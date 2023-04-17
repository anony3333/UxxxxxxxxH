#include <mlir/Dialect/Affine/IR/AffineOps.h>
#include <mlir/Dialect/GPU/GPUDialect.h>
#include <mlir/Dialect/SCF/SCF.h>
#include <mlir/Dialect/StandardOps/IR/Ops.h>
#include <mlir/Dialect/MemRef/IR/MemRef.h>
#include <mlir/IR/BlockAndValueMapping.h>
#include <mlir/IR/Builders.h>
#include <mlir/IR/BuiltinOps.h>
#include <mlir/IR/MLIRContext.h>
#include <mlir/IR/PatternMatch.h>
#include <mlir/IR/TypeRange.h>
#include <mlir/IR/UseDefLists.h>
#include <mlir/IR/Value.h>
#include <mlir/IR/Visitors.h>
#include <mlir/Pass/Pass.h>
#include <mlir/Support/LLVM.h>
#include <mlir/Support/LogicalResult.h>
#include <mlir/Transforms/DialectConversion.h>
#include <llvm/ADT/ArrayRef.h>
#include <llvm/ADT/None.h>
#include <llvm/ADT/STLExtras.h>
#include <llvm/ADT/iterator_range.h>
#include <llvm/Support/ErrorHandling.h>
#include <llvm/Support/raw_ostream.h>
#include <cstdint>
#include <functional>
#include <iterator>
#include <tuple>
#include <map>

#include "Conversion/StencilToStandard/ConvertStencilToStandard.h"
#include "Conversion/StencilToStandard/Passes.h"
#include "Dialect/Stencil/StencilDialect.h"
#include "Dialect/Stencil/StencilOps.h"
#include "Dialect/Stencil/StencilTypes.h"
#include "PassDetail.h"

using namespace mlir;
using namespace stencil;
using namespace scf;

namespace {
int64_t domain_size = 0;
//std::map<StringRef, memref::AllocOp> allocMap;
memref::AllocOp alloc;
AffineStoreOp store;

//===----------------------------------------------------------------------===//
// Rewriting Pattern
//===----------------------------------------------------------------------===//
class FuncOpLowering : public StencilOpToStdPattern<FuncOp> {
public:
    using StencilOpToStdPattern<FuncOp>::StencilOpToStdPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        auto loc = operation->getLoc();
        auto funcOp = cast<FuncOp>(operation);

        // 转化原始func操作的参数
        TypeConverter::SignatureConversion result(funcOp.getNumArguments());
        for (auto &en : llvm::enumerate(funcOp.getType().getInputs())) {
            result.addInputs(en.index(), typeConverter.convertType(en.value()));
        }

        // 创建新函数类型
        auto funcType =
            FunctionType::get(funcOp.getContext(),result.getConvertedTypes(),
                            funcOp.getType().getResults());

        // Replace the function by a function with an updated signature
        auto newFuncOp =
            rewriter.create<FuncOp>(loc, funcOp.getName(), funcType, llvm::None);
        if (StencilDialect::isStencilProgram(funcOp)) {
            newFuncOp->setAttr(StencilDialect::getStdStencilProgarmAttrName(), UnitAttr::get(operation->getContext()));
        } else if (StencilDialect::isStencilIteration(funcOp)) {
            newFuncOp->setAttr(StencilDialect::getStdStencilIterationAttrName(), UnitAttr::get(operation->getContext()));
        }
        newFuncOp->setAttr("llvm.emit_c_interface", UnitAttr::get(operation->getContext()));
        rewriter.inlineRegionBefore(funcOp.getBody(), newFuncOp.getBody(),
                                    newFuncOp.end());

        // Convert the signature and delete the original operation
        rewriter.applySignatureConversion(&newFuncOp.getBody(), result);
        rewriter.eraseOp(funcOp);
        return success();
    }
};

class ApplyOpLowering : public StencilOpToStdPattern<stencil::ApplyOp> {
public:
    using StencilOpToStdPattern<stencil::ApplyOp>::StencilOpToStdPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands, 
                    ConversionPatternRewriter &rewriter) const override {
        auto loc = operation->getLoc();
        auto applyOp = cast<stencil::ApplyOp>(operation);
        auto shapeOp = cast<ShapeOp>(operation);

        SmallVector<Value, 10> newResults;
        for (unsigned i = 0; i < applyOp.getNumResults(); i++) {
            auto allocType = typeConverter.convertType(applyOp.getResult(i).getType()).cast<MemRefType>();
            auto allocOp = rewriter.create<memref::AllocOp>(loc, allocType);
            newResults.push_back(allocOp.getResult());
            alloc = allocOp;
        }
        //auto returnOp = cast<stencil::ReturnOp>(applyOp.getBody()->getTerminator());

        SmallVector<int64_t, 3> lbs, ubs, steps;
        for (int64_t i = 0; i < shapeOp.getRank(); i++) {
          int64_t lb = shapeOp.getLB()[i];
          int64_t ub = shapeOp.getUB()[i];
          int64_t step = 1;
          lbs.push_back(lb);
          ubs.push_back(ub);
          steps.push_back(step);
        }

        SmallVector<Value, 3> inductionVars; ///< 记录嵌套循环的迭代变量
        SmallVector<Value, 3> innerLoopBasePos; ///< 记录每层循环初始位置，初始位置 + 各层迭代变量 = 最终迭代变量
        AffineForOp forOp;
        domain_size = shapeOp.getRank();
        for (int64_t i = 0; i < shapeOp.getRank(); i++) {
          forOp = rewriter.create<AffineForOp>(loc, lbs[i], ubs[i], steps[i]);
          forOp->setAttr("stencil_main_loop", UnitAttr::get(operation->getContext()));
          rewriter.setInsertionPointToStart(forOp.getBody());
        }

        // 转化apply操作签名
        TypeConverter::SignatureConversion result(applyOp.getNumOperands());
        for (auto &en : llvm::enumerate(applyOp.getOperands())) {
            result.remapInput(en.index(), operands[en.index()]);
        }
        rewriter.applySignatureConversion(&applyOp.region(), result);
        // 复制域
        rewriter.mergeBlockBefore(
            applyOp.getBody(),
            forOp.getBody()->getTerminator());
        
        // /************************ 释放之前申请的临时空间? **************************/
        // //TODO

        // // 替换applyOp?
        rewriter.replaceOp(applyOp, newResults);
        return success();
    }
};

class ReturnOpLowering : public StencilOpToStdPattern<stencil::ReturnOp> {
public:
  using StencilOpToStdPattern<stencil::ReturnOp>::StencilOpToStdPattern;

  LogicalResult
  matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                  ConversionPatternRewriter &rewriter) const override {
    //直接删除
    rewriter.eraseOp(operation);
    return success();
  }
};

class YieldOpLowering : public StencilOpToStdPattern<scf::YieldOp> {
public:
  using StencilOpToStdPattern<scf::YieldOp>::StencilOpToStdPattern;

  LogicalResult
  matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                  ConversionPatternRewriter &rewriter) const override {
    auto yieldOp = cast<scf::YieldOp>(operation);

    // Remove all result types from the operand list
    SmallVector<Value, 4> newOperands;
    llvm::copy_if(
        yieldOp.getOperands(), std::back_inserter(newOperands),
        [](Value value) { return !value.getType().isa<ResultType>(); });
    assert(newOperands.size() < yieldOp.getNumOperands() &&
           "expected if op to return results");

    rewriter.replaceOpWithNewOp<scf::YieldOp>(yieldOp, newOperands);
    return success();
  }
};

class IfOpLowering : public StencilOpToStdPattern<scf::IfOp> {
public:
  using StencilOpToStdPattern<scf::IfOp>::StencilOpToStdPattern;

  LogicalResult
  matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                  ConversionPatternRewriter &rewriter) const override {
    auto ifOp = cast<scf::IfOp>(operation);

    // Remove all result types from the result list
    SmallVector<Type, 4> newTypes;
    llvm::copy_if(ifOp.getResultTypes(), std::back_inserter(newTypes),
                  [](Type type) { return !type.isa<ResultType>(); });
    assert(newTypes.size() < ifOp.getNumResults() &&
           "expected if op to return results");

    // Create a new if op and move the bodies
    auto newOp = rewriter.create<scf::IfOp>(ifOp.getLoc(), newTypes,
                                            ifOp.condition(), true);
    newOp.walk([&](scf::YieldOp yieldOp) { rewriter.eraseOp(yieldOp); });
    rewriter.mergeBlocks(ifOp.getBody(0), newOp.getBody(0), llvm::None);
    rewriter.mergeBlocks(ifOp.getBody(1), newOp.getBody(1), llvm::None);

    // Erase the if op if there are no results to replace
    if (newOp.getNumResults() == 0) {
      rewriter.eraseOp(ifOp);
      return success();
    }

    // Replace the if op by the results of the new op
    SmallVector<Value, 4> newResults(ifOp.getNumResults(),
                                     newOp.getResults().front());
    auto it = newOp.getResults().begin();
    for (auto en : llvm::enumerate(ifOp.getResultTypes())) {
      if (!en.value().isa<ResultType>())
        newResults[en.index()] = *it++;
    }
    rewriter.replaceOp(ifOp, newResults);
    return success();
  }
};

class AccessOpLowering : public StencilOpToStdPattern<stencil::AccessOp> {
public:
    using StencilOpToStdPattern<stencil::AccessOp>::StencilOpToStdPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        // printf("// ####### AccessOpLowering #######\n");
        auto loc = operation->getLoc();
        auto accessOp = cast<stencil::AccessOp>(operation);
        auto offsetOp = cast<OffsetOp>(accessOp.getOperation());

        SmallVector<Value, 3> basePos;
        auto forOp = operation->getParentOfType<AffineForOp>();
        for(int64_t i = 0; i < domain_size-1; i++){
            basePos.push_back(forOp.getInductionVar());
            forOp = forOp->getParentOfType<AffineForOp>();
        }
        basePos.push_back(forOp.getInductionVar());
        SmallVector<Value, 3> reversePos(llvm::reverse(ValueRange(basePos)));

        SmallVector<Value, 3> loadOffset;
        auto offset = offsetOp.getOffset();
        AffineExpr d0, d1, d2;
        AffineMap offsetMap;
        if (domain_size==1){
            bindDims(operation->getContext(), d0);
            d0 = d0 + rewriter.getAffineConstantExpr(offset[0]);
            offsetMap = AffineMap::get(1, 0, {d0}, operation->getContext());
        }else if(domain_size==2){
            bindDims(operation->getContext(), d0, d1);
            d0 = d0 + rewriter.getAffineConstantExpr(offset[0]);
            d1 = d1 + rewriter.getAffineConstantExpr(offset[1]);
            offsetMap = AffineMap::get(2, 0, {d0,d1}, operation->getContext());
        }else{
            bindDims(operation->getContext(), d0, d1, d2);
            d0 = d0 + rewriter.getAffineConstantExpr(offset[0]);
            d1 = d1 + rewriter.getAffineConstantExpr(offset[1]);
            d2 = d2 + rewriter.getAffineConstantExpr(offset[2]);
            offsetMap = AffineMap::get(3, 0, {d0,d1,d2}, operation->getContext());
        }
        rewriter.replaceOpWithNewOp<mlir::AffineLoadOp>(operation, operands[0], offsetMap, reversePos);
        return success();
  }
};

class LoadOpLowering : public StencilOpToStdPattern<stencil::LoadOp> {
public:
    using StencilOpToStdPattern<stencil::LoadOp>::StencilOpToStdPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        // printf("// ####### LoadOpLowering #######\n");
        auto loc = operation->getLoc();
        auto offsetOp = cast<OffsetOp>(operation);
        // 计算位置
        SmallVector<Value, 3> loadOffset;
        for (auto elem : offsetOp.getOffset()) {
            Value offset_index = 
                rewriter.create<ConstantIndexOp>(loc, elem);
            loadOffset.push_back(offset_index);
        }

        // 替换Op
        rewriter.replaceOpWithNewOp<mlir::AffineLoadOp>(operation, operands[0], loadOffset);
        return success();
  }
};

class IterationOpLowering : public StencilOpToStdPattern<IterationOp> {
public:
    using StencilOpToStdPattern<IterationOp>::StencilOpToStdPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        auto loc = operation->getLoc();
        auto iterationOp = cast<stencil::IterationOp>(operation);
        
        auto bindParamNum = iterationOp.getBindParamNum();
        auto iterNum = iterationOp.getIterNum();
        auto funcName = iterationOp.getStencilFuncName();

        SmallVector<Value, 8> operands1, operands2;
        for (unsigned i = 0; i < bindParamNum; i++) {
            operands1.push_back(operands[i]);
            operands2.push_back(operands[i+bindParamNum]);
        }

        // 创建for循环
        auto lb = rewriter.create<ConstantIndexOp>(loc, 0);
        auto ub = rewriter.create<ConstantIndexOp>(loc, iterNum);
        auto step = rewriter.create<ConstantIndexOp>(loc, 1);
        auto forOp = rewriter.create<scf::ForOp>(loc, lb, ub, step);
        // 在嵌套循环中创建call
        rewriter.setInsertionPointToStart(forOp.getBody());

        // 计算两次
        rewriter.create<CallOp>(loc, funcName, TypeRange(), operands1);
        rewriter.create<CallOp>(loc, funcName, TypeRange(), operands2);

        // 插入forOp终结符号
        //rewriter.create<scf::YieldOp>(loc);

        // 删除iteration操作
        rewriter.eraseOp(operation);
        return success();
    }
};

class StoreOpLowering : public StencilOpToStdPattern<stencil::StoreOp> {
public:
    using StencilOpToStdPattern<stencil::StoreOp>::StencilOpToStdPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands, 
                    ConversionPatternRewriter &rewriter) const override {
        // printf("// ####### StoreOpLowering #######\n");
        //rewriter.eraseOp(operation);
        auto loc = operation->getLoc();
        auto storeOp = cast<stencil::StoreOp>(operation);
        SmallVector<Value, 3> storePos;
        auto forOp = operation->getParentOfType<AffineForOp>();
        for(int64_t i = 0; i < domain_size-1; i++){
            storePos.push_back(forOp.getInductionVar());
            forOp = forOp->getParentOfType<AffineForOp>();
        }
        storePos.push_back(forOp.getInductionVar());
        SmallVector<Value, 3> reversePos(llvm::reverse(ValueRange(storePos)));
        store = rewriter.create<AffineStoreOp>(loc, operands[0], alloc, reversePos);
        rewriter.eraseOp(operation);
        return success();
    }
};

class CopyOpLowering : public StencilOpToStdPattern<stencil::CopyOp> {
public:
    using StencilOpToStdPattern<stencil::CopyOp>::StencilOpToStdPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        //获取参数
        auto result = operands[0];
        auto output = operands[1];

        store.setOperand(1, output);

        // 删除copy操作
        rewriter.eraseOp(operation);
        return success();
    }
};

//============================================================================//
// 转换目标
//============================================================================//
class StencilToStdTarget : public ConversionTarget {
public:
    explicit StencilToStdTarget(MLIRContext &context)
        : ConversionTarget(context) {}

    bool isDynamicallyLegal(Operation *op) const override {
        if (auto funcOp = dyn_cast<FuncOp>(op)) {
            return !StencilDialect::isStencilProgram(funcOp) && !StencilDialect::isStencilIteration(funcOp);
        }
        return true;
    }
};

//============================================================================//
// Rewriting pass
//============================================================================//
struct StencilToStdPass : public StencilToStdPassBase<StencilToStdPass> {
    void getDependentDialects(DialectRegistry &registry) const override {
        registry.insert<AffineDialect>();
    }
    void runOnOperation() override;
};

void StencilToStdPass::runOnOperation() {
    OwningRewritePatternList patterns(&getContext());
    auto module = getOperation();
    
   //todo

    StencilTypeConverter_std typeConverter(module.getContext());
    populateStencilToStdConversionPatterns(typeConverter, patterns);

    StencilToStdTarget target(*(module.getContext()));
    target.addLegalDialect<AffineDialect>();
    target.addLegalDialect<SCFDialect>();
    target.addLegalDialect<memref::MemRefDialect>();
    target.addLegalDialect<StandardOpsDialect>();
    target.addDynamicallyLegalOp<FuncOp>();
    // target.addLegalOp<FuncOp>();
    target.addLegalOp<mlir::stencil::CastToMemRefOp>();
    target.addLegalOp<mlir::memref::AllocOp>();
    target.addLegalOp<ModuleOp>();

    if (failed(applyFullConversion(module, target, std::move(patterns)))) {
        signalPassFailure();
    }
    
}
} // namespace

namespace mlir {
namespace stencil {

// 填充转换模式列表
void populateStencilToStdConversionPatterns(
    StencilTypeConverter_std &typeConverter, mlir::OwningRewritePatternList &patterns) {
    patterns.insert<FuncOpLowering, ApplyOpLowering, ReturnOpLowering, YieldOpLowering,
                    IfOpLowering ,IterationOpLowering,StoreOpLowering, AccessOpLowering,
                    LoadOpLowering, CopyOpLowering>(typeConverter);
}

//============================================================================//
// Stencil类型转换器
//============================================================================//

StencilTypeConverter_std::StencilTypeConverter_std(MLIRContext *context_)
    : context(context_) {
  // 给field类型添加类型转换
  addConversion([&](stencil::GridType type) {
    return MemRefType::get(type.getShape(), type.getElementType());
    //type.getShape()???不确定
  });
  addConversion([&](Type type) -> Optional<Type> {
    if (auto gridType = type.dyn_cast<stencil::GridType>())
      return llvm::None;
    return type;
  });
}

//============================================================================//
// Stencil模式基类
//============================================================================//
StencilToStdPattern::StencilToStdPattern(
    StringRef rootOpName, StencilTypeConverter_std &typeConverter,
    PatternBenefit benefit)
    : ConversionPattern(rootOpName, benefit, typeConverter.getContext()),
    typeConverter(typeConverter) {}


} // namespace stencil
} // namespace mlir

std::unique_ptr<Pass> mlir::createConvertStencilToStdPass() {
    return std::make_unique<StencilToStdPass>();
}
