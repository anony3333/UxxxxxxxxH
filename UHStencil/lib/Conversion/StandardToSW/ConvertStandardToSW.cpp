/**
 * @file ConvertStandardToSW.cpp
 * @author 
 * @brief 转化pass实现
 * @version 0.1
 * @date 2022-09-14
 * 
 * @copyright Copyright (c) HiPO Beihang University 2022
 * 
 */
#include <mlir/Dialect/MemRef/IR/MemRef.h>
#include <mlir/Dialect/Affine/IR/AffineOps.h>
#include <mlir/Dialect/Vector/VectorOps.h>
#include <mlir/Dialect/SCF/SCF.h>
#include <mlir/Dialect/StandardOps/IR/Ops.h>
#include <mlir/Dialect/GPU/GPUDialect.h>
#include <mlir/IR/AffineMap.h>
#include <mlir/IR/BlockAndValueMapping.h>
#include <mlir/IR/Builders.h>
#include <mlir/IR/BuiltinOps.h>
#include <mlir/IR/MLIRContext.h>
#include <mlir/IR/PatternMatch.h>
#include <mlir/IR/BuiltinTypes.h>
#include <mlir/IR/UseDefLists.h>
#include <mlir/IR/Value.h>
#include <mlir/Pass/Pass.h>
#include <mlir/Support/LLVM.h>
#include <mlir/Support/LogicalResult.h>
#include <mlir/Transforms/DialectConversion.h>
#include <llvm/ADT/ArrayRef.h>
#include <llvm/ADT/None.h>
#include <llvm/ADT/STLExtras.h>
#include <llvm/ADT/iterator_range.h>
#include <llvm/Support/raw_ostream.h>
#include <cstdint>
#include <functional>
#include <iterator>
#include <tuple>

#include "Conversion/StandardToSW/ConvertStandardToSW.h"
#include "Conversion/StandardToSW/Passes.h"
#include "Dialect/Stencil/StencilDialect.h"
#include "Dialect/SW/SWDialect.h"
#include "Dialect/SW/SWOps.h"
#include "Dialect/SW/SWTypes.h"
#include "PassDetail.h"

using namespace mlir;
using namespace mlir::gpu;
using namespace stencil;
using namespace scf;
using OpListType = llvm::iplist<Operation>;

namespace {
//============================================================================//
// Rewriting模式
//============================================================================//


/// to be done
/// 1. ParallelOp Lowering --> convert scf::parallel to sw.launch √
/// 2. scf::for lowering --> convert to sw.for √
/// 3. AddIOp Lowering --> similar to addf √
/// 4. MulIOp lowering --> similar to mulf √
/// 4. complete the following pattern

class CallOpLowering : public StandardOpToSWPattern<CallOp> {
public:
    using StandardOpToSWPattern<CallOp>::StandardOpToSWPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        CallOp callOp = cast<CallOp>(operation);

        rewriter.replaceOpWithNewOp<sw::LaunchMainFuncOp>(operation, rewriter.getSymbolRefAttr(callOp.getCallee()), operands);

        return success();
    }
};

class FuncOpLowering : public StandardOpToSWPattern<FuncOp> {
public:
    using StandardOpToSWPattern<FuncOp>::StandardOpToSWPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        auto loc = operation->getLoc();
        auto funcOp = cast<FuncOp>(operation);

        // 转化原始func操作的参数
        TypeConverter::SignatureConversion result(funcOp.getNumArguments());
        for (auto &en : llvm::enumerate(funcOp.getType().getInputs())) {
            result.addInputs(en.index(), typeConverter.convertType(en.value()));
            // result.addInputs(en.index(), en.value());
        }

        // 创建新函数类型
        auto funcType = FunctionType::get(funcOp.getContext(), result.getConvertedTypes(),
                                          funcOp.getType().getResults());
        
        // 对于描述stencil计算的func部分
        if (StencilDialect::isStdStencilProgram(funcOp)) {
            auto newFuncOp = rewriter.create<sw::MainFuncOp>(loc, funcOp.getName(), funcType);
            // 删除自己创建的block
            rewriter.eraseBlock(&newFuncOp.getBody().getBlocks().back());
            // 复制域
            rewriter.inlineRegionBefore(funcOp.getBody(), newFuncOp.getBody(),
                                        newFuncOp.end());        
            // 删除原有std终结符并在函数域中插入终结符
            auto stdReturnOp = newFuncOp.getBody().front().getTerminator();
            rewriter.eraseOp(stdReturnOp);
            rewriter.setInsertionPointToEnd(&newFuncOp.getBody().front());
            rewriter.create<sw::MainReturnOp>(loc);
            // 转换签名
            rewriter.applySignatureConversion(&newFuncOp.getBody(), result);
        } else if (StencilDialect::isStdStencilIteration(funcOp)) {
            // 对于迭代定义的func部分
            auto newFuncOp = rewriter.create<sw::MainIterationFuncOp>(loc, funcOp.getName(), funcType);
            // 删除自己创建的block
            rewriter.eraseBlock(&newFuncOp.getBody().getBlocks().back());
            // 复制域
            rewriter.inlineRegionBefore(funcOp.getBody(), newFuncOp.getBody(),
                                        newFuncOp.end());        
            // 删除原有std终结符并在函数域中插入终结符
            auto stdReturnOp = newFuncOp.getBody().front().getTerminator();
            rewriter.eraseOp(stdReturnOp);
            rewriter.setInsertionPointToEnd(&newFuncOp.getBody().front());
            rewriter.create<sw::MainIterationReturnOp>(loc);
            // 转换签名
            rewriter.applySignatureConversion(&newFuncOp.getBody(), result);
        }
        // 删除原操作
        rewriter.eraseOp(funcOp);

        return success();
    }
};

class ParallelOpLowering : public StandardOpToSWPattern<scf::ParallelOp> {
public:
    using StandardOpToSWPattern<scf::ParallelOp>::StandardOpToSWPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        auto loc = operation->getLoc();
        scf::ParallelOp parallelOp = cast<scf::ParallelOp>(operation);

        // scf.parallel(x, y, z)

        // 只考虑1个cacheRead和1个cacheWrite的情况
        SmallVector<Type, 1> cacheReadAttrType;
        SmallVector<Type, 1> cacheWriteAttrType;
        parallelOp.walk([&](memref::AllocOp allocOp) {
            auto readOrWrite = allocOp->getAttr("readOrWrite").cast<StringAttr>().getValue();
            if (readOrWrite == "read") {
                cacheReadAttrType.push_back(typeConverter.convertType(allocOp.getType()));
                // cacheReadAttrType.push_back(allocOp.getType());
            } else if (readOrWrite == "write") {
                cacheWriteAttrType.push_back(typeConverter.convertType(allocOp.getType()));
                // cacheWriteAttrType.push_back(allocOp.getType());
            }
        });

        auto mainFuncOp = operation->getParentOfType<sw::MainFuncOp>();
        SmallVector<Value, 2> mainFuncArgs;
        for (Value v : mainFuncOp.getArguments()) {
            mainFuncArgs.push_back(v);
        }

        SmallVector<Value, 3> iterArgs = llvm::to_vector<3>(parallelOp.getInductionVars());
        SmallVector<Value, 3> l0_tileNums = llvm::to_vector<3>(parallelOp.upperBound());

        // rewriter.replaceOpWithNewOp<sw::LaunchOp>(operation, mainFuncOperands, cacheReadAttrType, cacheWriteAttrType);
        auto launchOp = rewriter.create<sw::LaunchOp>(loc, mainFuncArgs, cacheReadAttrType, cacheWriteAttrType);
        
        rewriter.eraseBlock(launchOp.getBody());
        // auto scfYield = parallelOp.getBody()->getTerminator();
        // scfYield->erase();
        rewriter.inlineRegionBefore(parallelOp.region(), launchOp.region(), launchOp.region().end());

        // rewriter.setInsertionPointToEnd(&launchOp.region().front());
        // rewriter.create<sw::TerminatorOp>(loc);

        // 插入从核id
        // 根据从核id算出x_tile_id,y_tile_id,z_tile_id，即arg2,arg3,arg4, 而且确保后面的计算能正确引用
        // l0_tileNums没有创建出常量op，会有问题吗？scf.parallel前面已经有这些常量op

        rewriter.setInsertionPointToStart(launchOp.getBody());

        // 将l0_tileNums放到 sw.launch 内部
        SmallVector<Value, 3> const_l0_tileNums;
        for (auto tileNum : l0_tileNums) {
            auto defOp = tileNum.getDefiningOp<ConstantIndexOp>();
            assert(defOp && "parallelOp upper bound should be constant");
            int val = defOp.getValue();
            const_l0_tileNums.push_back(rewriter.create<sw::ConstantOp>(loc, 
                rewriter.getIndexType(), rewriter.getIndexAttr(val)));
        }
        DenseSet<Operation*> valuesDefinedOutside;
        // 将scf.parallel 的 step 放到 sw.launch 内部
        for (auto step : parallelOp.step()) {
            auto defOp = step.getDefiningOp<ConstantIndexOp>();
            assert(defOp && "parallelOp step should be constant");
            valuesDefinedOutside.insert(defOp.getOperation());
        }
        // 将scf.parallel 的 lower bound 放到 sw.launch 内部
        for (auto lb : parallelOp.lowerBound()) {
            auto defOp = lb.getDefiningOp<ConstantIndexOp>();
            assert(defOp && "parallelOp lower bound should be constant");
            valuesDefinedOutside.insert(defOp.getOperation());
        }
        Block::OpListType& ops = mainFuncOp.region().front().getOperations();
        for (auto iter = ops.begin(); iter != ops.end() && &*iter != operation; iter++) {
            if (isa<ConstantIndexOp>(&*iter)) {
                valuesDefinedOutside.insert(&*iter);
            }
        }
        // 用内部定义的常量替换外部的常量
        for (auto cstOp : valuesDefinedOutside) {
            auto val_outside = dyn_cast<ConstantIndexOp>(cstOp);
            Value val_inside = rewriter.create<sw::ConstantOp>(loc, rewriter.getIndexType(), 
                rewriter.getIndexAttr(val_outside.getValue()));
            val_outside.getResult().replaceAllUsesWith(val_inside);
            // rewriter.eraseOp(val_outside);
        }
        rewriter.eraseOp(parallelOp);

        Value id = rewriter.create<sw::GetIDOp>(loc, rewriter.getIndexType());
        Value total_tile_num = rewriter.create<sw::ConstantOp>(loc, rewriter.getIndexType(), rewriter.getIndexAttr(64));

        // x_id = id % 8 
        // y_id = id / 8 % 4
        // z_id = id / 8 / 4 % 2
        
        // x_div = id / 8
        // x_id = id - x_div * 8

        Value x_tile_div = rewriter.create<sw::DiviOp>(loc, rewriter.getIndexType(), id, const_l0_tileNums[0]);
        Value x_tile_mul = rewriter.create<sw::MuliOp>(loc, rewriter.getIndexType(), x_tile_div, const_l0_tileNums[0]);
        Value x_tile_id = rewriter.create<sw::SubiOp>(loc, rewriter.getIndexType(), id, x_tile_mul); 

        // y_div = id / 8 / 4 = x_div / 4
        // y_id = id / 8 - id / 8 / 4 * 4 = x_div - y_div * 4
        
        Value y_tile_div = rewriter.create<sw::DiviOp>(loc, rewriter.getIndexType(), x_tile_div, const_l0_tileNums[1]);
        Value y_tile_mul = rewriter.create<sw::MuliOp>(loc, rewriter.getIndexType(), y_tile_div, const_l0_tileNums[1]);
        Value y_tile_id = rewriter.create<sw::SubiOp>(loc, rewriter.getIndexType(), x_tile_div, y_tile_mul);

        // z_div = id / 8 / 4 / 2 = y_div / 2
        // z_id = id / 8 / 4 - id / 8 / 4 / 2 * 2 = y_div - z_div * 2
        
        Value z_tile_div = rewriter.create<sw::DiviOp>(loc, rewriter.getIndexType(), y_tile_div, const_l0_tileNums[2]);
        Value z_tile_mul = rewriter.create<sw::MuliOp>(loc, rewriter.getIndexType(), z_tile_div, const_l0_tileNums[2]);
        Value z_tile_id = rewriter.create<sw::SubiOp>(loc, rewriter.getIndexType(), y_tile_div, z_tile_mul);

        iterArgs[0].replaceAllUsesWith(x_tile_id);
        iterArgs[1].replaceAllUsesWith(y_tile_id);
        iterArgs[2].replaceAllUsesWith(z_tile_id);

        int num_arguments = launchOp.region().front().getNumArguments();
        for (int i = 0; i < num_arguments; i++)
            launchOp.region().front().eraseArgument(0);
        for (auto mainFuncArg : mainFuncArgs)
            launchOp.region().front().addArgument(mainFuncArg.getType());
        launchOp.region().front().addArguments(cacheReadAttrType);
        launchOp.region().front().addArguments(cacheWriteAttrType);

        return success();
    };
};

class AllocOpLowering : public StandardOpToSWPattern<memref::AllocOp> {
public:
    using StandardOpToSWPattern<memref::AllocOp>::StandardOpToSWPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        auto loc = operation->getLoc();
        memref::AllocOp allocOp = cast<memref::AllocOp>(operation);

        auto readOrWrite = allocOp->getAttr("readOrWrite").cast<StringAttr>().getValue();
        auto zDimAttr = allocOp->getAttr("swdma_zDim").cast<IntegerAttr>();
        auto cntAttr = allocOp->getAttr("swdma_cnt").cast<IntegerAttr>();
        auto strideAttr = allocOp->getAttr("swdma_stride").cast<IntegerAttr>();
        auto bsizeAttr = allocOp->getAttr("swdma_bsize").cast<IntegerAttr>();

        auto elemShape = allocOp.getType().getShape();

        SmallVector<Value, 6> inductionVars;
        auto launchOp = operation->getParentOfType<sw::LaunchOp>();

        // 好像只进来3次
        launchOp.walk([&](sw::ForOp forOp) {
            inductionVars.push_back(forOp.getInductionVar());
        });

        // 假定读和写各只有1个全局内存地址
        ValueRange launchOpArgs = launchOp.getBody()->getArguments();

        if (readOrWrite == "read") {
            auto forOp = operation->getParentOfType<sw::ForOp>();
            unsigned int cnt = 0;
            // 默认是后序遍历，这样的访问顺序对吗。。
            forOp.walk([&](gpu::BarrierOp barrierOp) {
                if (cnt == 0) {
                    SmallVector<Value, 3> indexArray;
                    Value halo = rewriter.create<sw::ConstantOp>(loc, rewriter.getIndexType(), allocOp->getAttr("halo"));      
                    for (int iter = (int)elemShape.size() - 1; iter >= 0; iter--) {
                        Value index = rewriter.create<sw::SubiOp>(loc, rewriter.getIndexType(), inductionVars[iter], halo);
                        indexArray.push_back(index);
                    }
                    auto launchOpCacheRead = launchOp.getCacheReadAttributions();
                    rewriter.setInsertionPointAfter(barrierOp);
                    // src, dst
                    rewriter.create<sw::MemcpyToLDMOp>(loc, launchOpArgs[0], launchOpCacheRead[0], indexArray, zDimAttr, cntAttr, strideAttr, bsizeAttr);
                }
                cnt += 1;
            });
        } else {
            auto forOp = operation->getParentOfType<sw::ForOp>();
            unsigned int cnt = 0;
            forOp.walk([&](gpu::BarrierOp barrierOp) {
                if (cnt == 1) {
                    SmallVector<Value, 3> indexArray;
                    for (int iter = (int)elemShape.size() - 1; iter >= 0; iter--) {
                        indexArray.push_back(inductionVars[iter]);
                    }
                    auto launchOpCacheWrite = launchOp.getCacheWriteAttributions();
                    rewriter.setInsertionPointAfter(barrierOp);
                    rewriter.create<sw::MemcpyToMEMOp>(loc, launchOpCacheWrite[0], launchOpArgs[1], indexArray, zDimAttr, cntAttr, strideAttr, bsizeAttr);
                }
                cnt += 1;
            });
        }

        rewriter.eraseOp(allocOp);

        return success();
    }
};

class ScfForOpLowering : public StandardOpToSWPattern<scf::ForOp> {
public:
    using StandardOpToSWPattern<scf::ForOp>::StandardOpToSWPattern;

    LogicalResult 
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        Location loc = operation->getLoc();
        scf::ForOp scfForOp = cast<scf::ForOp>(operation);

        Value lowerBound = scfForOp.lowerBound();
        Value upperBound = scfForOp.upperBound();
        Value step = scfForOp.step();
        sw::ForOp swForOp = rewriter.create<sw::ForOp>(loc, lowerBound, upperBound, step);
        
        rewriter.eraseBlock(swForOp.getBody());
        rewriter.inlineRegionBefore(scfForOp.region(), swForOp.region(), swForOp.region().end());
        rewriter.eraseOp(scfForOp);

        return success();
    }
};

class ScfYieldOpLowering : public StandardOpToSWPattern<scf::YieldOp> {
    using StandardOpToSWPattern<scf::YieldOp>::StandardOpToSWPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        scf::YieldOp scfYieldOp = cast<scf::YieldOp>(operation);

        if (/*isa<scf::ParallelOp>(operation->getParentOp()) ||*/
            isa<sw::LaunchOp>(operation->getParentOp())) {
            rewriter.replaceOpWithNewOp<sw::TerminatorOp>(scfYieldOp);
        }
        else {
            rewriter.replaceOpWithNewOp<sw::YieldOp>(scfYieldOp);
        }

        return success();
    }
};

class LoadOpLowering : public StandardOpToSWPattern<memref::LoadOp> {
public:
    using StandardOpToSWPattern<memref::LoadOp>::StandardOpToSWPattern;
    
    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        memref::LoadOpAdaptor loadOperands(operands);
        // rewriter.replaceOpWithNewOp<sw::LoadOp>(operation, loadOperands.memref(), loadOperands.indices());

        // auto loc = operation->getLoc();
        // auto loadOp = cast<stencil::LoadOp>(operation);
        // auto offsetOp = cast<OffsetOp>(operation);
        // // 计算位置
        // SmallVector<Value, 3> loadOffset;
        // for (auto elem : offsetOp.getOffset()) {
        //     auto offset_index = 
        //         rewriter.create<sw::ConstantOp>(loc, rewriter.getI64IntegerAttr(elem), rewriter.getI64Type());
        //     loadOffset.push_back(offset_index);
        // }
        // 找到对应的cacheRead数组
        auto launchOp = operation->getParentOfType<sw::LaunchOp>();
        // auto launchOpOperands = launchOp.getOperands();
        auto launchOpCacheRead = launchOp.getCacheReadAttributions();
        // int cacheReadIndex;
        // for (auto elem : llvm::enumerate(launchOp.getOperands())) {
        //     if (elem.value() == operands[0]) {
        //         cacheReadIndex = elem.index();
        //         break;
        //     }
        // }

        // 替换Op
        // rewriter.replaceOpWithNewOp<sw::LoadOp>(operation, launchOpCacheRead[cacheReadIndex], loadOffset);

        rewriter.replaceOpWithNewOp<sw::LoadOp>(operation, launchOpCacheRead[0], loadOperands.indices());

        return success();
    }
};

class StoreOpLowering : public StandardOpToSWPattern<memref::StoreOp> {
public:
    using StandardOpToSWPattern<memref::StoreOp>::StandardOpToSWPattern;
    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {  
        memref::StoreOpAdaptor storeOperands(operands);

        auto launchOp = operation->getParentOfType<sw::LaunchOp>();
        auto launchOpCacheWrite = launchOp.getCacheWriteAttributions();
                
        // rewriter.replaceOpWithNewOp<sw::StoreOp>(operation, storeOperands.value(), storeOperands.memref(), storeOperands.indices());
        rewriter.replaceOpWithNewOp<sw::StoreOp>(operation, operands[0], launchOpCacheWrite[0], storeOperands.indices());

        return success();
    }
};

// 可能不需要，但没有下降会：loc("3d27pt_sw_scf_test.mlir":161:5): error: failed to legalize operation 'std.return'
// class ReturnOpLowering : public StandardOpToSWPattern<ReturnOp> {
// public:
//     using StandardOpToSWPattern<ReturnOp>::StandardOpToSWPattern;

//     LogicalResult
//     matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
//                     ConversionPatternRewriter &rewriter) const override {
//         // 直接删除？（待确认）
//         // 参考StencilToSW，可能是在FuncOpLowering去重新加入sw类型的ReturnOp
//         rewriter.eraseOp(operation);
//         return success();
//     }
// };

class BarrierOpLowering : public StandardOpToSWPattern<gpu::BarrierOp> {
public:
    using StandardOpToSWPattern<gpu::BarrierOp>::StandardOpToSWPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        // error: failed to legalize operation 'gpu.barrier'
        rewriter.eraseOp(operation);
        return success();
    }
};

class ConstantOpLowering : public StandardOpToSWPattern<ConstantOp> {
public:
    using StandardOpToSWPattern<ConstantOp>::StandardOpToSWPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        auto loc = operation->getLoc();
        auto constantOp = cast<ConstantOp>(operation);
        auto value = constantOp.value();
        
        // 直接替换
        Value constantValue = rewriter.create<sw::ConstantOp>(loc, value, value.getType());
        rewriter.replaceOp(constantOp, constantValue);

        return success();
    }
};

class AddFOpLowering : public StandardOpToSWPattern<AddFOp> {
public:
    using StandardOpToSWPattern<AddFOp>::StandardOpToSWPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        auto loc = operation->getLoc();
        auto addfOp = cast<AddFOp>(operation);

        // 直接替换
        auto result = addfOp.getResult();
        Value addfValue = rewriter.create<sw::AddfOp>(loc, result.getType(), operands[0], operands[1]);
        rewriter.replaceOp(addfOp, addfValue);

        return success();
    }
};

class SubFOpLowering : public StandardOpToSWPattern<SubFOp> {
public:
    using StandardOpToSWPattern<SubFOp>::StandardOpToSWPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        auto loc = operation->getLoc();
        auto subfOp = cast<SubFOp>(operation);

        // 直接替换
        auto result = subfOp.getResult();
        Value subfValue = rewriter.create<sw::SubfOp>(loc, result.getType(), operands[0], operands[1]);
        rewriter.replaceOp(subfOp, subfValue);

        return success();
    }
};

class MulFOpLowering : public StandardOpToSWPattern<MulFOp> {
public:
    using StandardOpToSWPattern<MulFOp>::StandardOpToSWPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        auto loc = operation->getLoc();
        auto mulfOp = cast<MulFOp>(operation);

        // 直接替换
        auto result = mulfOp.getResult();
        Value mulfValue = rewriter.create<sw::MulfOp>(loc, result.getType(), operands[0], operands[1]);
        rewriter.replaceOp(mulfOp, mulfValue);

        return success();
    }
};

class DivFOpLowering : public StandardOpToSWPattern<DivFOp> {
public:
    using StandardOpToSWPattern<DivFOp>::StandardOpToSWPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        auto loc = operation->getLoc();
        auto divfOp = cast<DivFOp>(operation);

        // 直接替换
        auto result = divfOp.getResult();
        Value divfValue = rewriter.create<sw::DivfOp>(loc, result.getType(), operands[0], operands[1]);
        rewriter.replaceOp(divfOp, divfValue);

        return success();
    }
};

class AddIOpLowering : public StandardOpToSWPattern<AddIOp> {
public:
    using StandardOpToSWPattern<AddIOp>::StandardOpToSWPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        auto loc = operation->getLoc();
        auto addiOp = cast<AddIOp>(operation);

        // 直接替换
        auto result = addiOp.getResult();
        Value addiValue = rewriter.create<sw::AddiOp>(loc, result.getType(), operands[0], operands[1]);
        rewriter.replaceOp(addiOp, addiValue);

        return success();
    }
};

class SubIOpLowering : public StandardOpToSWPattern<SubIOp> {
public:
    using StandardOpToSWPattern<SubIOp>::StandardOpToSWPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        auto loc = operation->getLoc();
        auto subiOp = cast<SubIOp>(operation);

        // 直接替换
        auto result = subiOp.getResult();
        Value subiValue = rewriter.create<sw::SubiOp>(loc, result.getType(), operands[0], operands[1]);
        rewriter.replaceOp(subiOp, subiValue);

        return success();
    }
};

class MulIOpLowering : public StandardOpToSWPattern<MulIOp> {
public:
    using StandardOpToSWPattern<MulIOp>::StandardOpToSWPattern;

    LogicalResult
    matchAndRewrite(Operation *operation, ArrayRef<Value> operands,
                    ConversionPatternRewriter &rewriter) const override {
        auto loc = operation->getLoc();
        auto muliOp = cast<MulIOp>(operation);

        // 直接替换
        auto result = muliOp.getResult();
        Value muliValue = rewriter.create<sw::MuliOp>(loc, result.getType(), operands[0], operands[1]);
        rewriter.replaceOp(muliOp, muliValue);

        return success();
    }
};

//============================================================================//
// 转换目标
//============================================================================//
class StandardToSWTarget : public ConversionTarget {
public:
    explicit StandardToSWTarget(MLIRContext &context)
        : ConversionTarget(context) {}

    bool isDynamicallyLegal(Operation *op) const override {
        if (auto funcOp = dyn_cast<FuncOp>(op)) {
            // to be done
        }
        return true;
    }
};

//============================================================================//
// Rewriting pass
//============================================================================//
// StandardToSWPassBase是由StandardToSWPass的ODS文件生成
struct StandardToSWPass : public StandardToSWPassBase<StandardToSWPass> {
    void getDependentDialects(DialectRegistry &registry) const override {
        // Q 为什么所有pass都只注册了affine？似乎只是对外返回的一个接口，不影响实际运行
        registry.insert<AffineDialect>();
        registry.insert<SCFDialect>();
        registry.insert<memref::MemRefDialect>();
        registry.insert<StandardOpsDialect>();
        registry.insert<mlir::sw::SWDialect>();
    }
    void runOnOperation() override;
};

void StandardToSWPass::runOnOperation() {
    OwningRewritePatternList patterns(&getContext());
    auto module = getOperation();

    // stencil dialect的applyOp下降到std dialect时是什么？
    // 粗略地看是被替换成AffineForOp和allocOp，而且affine会进一步被下降成scf,memref
    // 怎么提取valueToLB和valueToApplyOpIndex信息？

    // stencil dialect的storeOp下降到std dialect时是什么？
    // AffineStoreOp，下降的过程是把stopOp外嵌套for的pos取出来，再创建新的AffineStoreOp
    // 怎么提取valueToOperand信息？

    // 需要建立TypeConverter类吗？大概率不需要，因为已经不是stenciltype这种自定义类型，而是std等类型

    // jzh留的注释的意思好像是valueToLB不用，但valueToApplyOpIndex，valueToOperand需要
    
    /*
    // 记录每个apply操作的下界, apply每个输入以及其中的store操作的参数与下界的绑定, 这样在变换相关操作时可以
    // 直接使用这个绑定关系
    DenseMap<Value, Index> valueToLB;
    DenseMap<Value, unsigned int> valueToApplyOpIndex;
    module.walk([&](stencil::ApplyOp applyOp) {
        auto lb = cast<ShapeOp>(applyOp.getOperation()).getLB();
        // 建立参数和下界的绑定关系
        for (auto en : llvm::enumerate(applyOp.getOperands())) {
            valueToLB[applyOp.getBody()->getArgument(en.index())] = lb;
            valueToApplyOpIndex[applyOp.getBody()->getArgument(en.index())] = en.index();
        }
        // 建立return操作的参数与下界的绑定关系
        for (auto value : applyOp.getBody()->getTerminator()->getOperands()) {
            valueToLB[value] = lb;
        }
    });

    DenseMap<Value, OpOperand *> valueToOperand;
    module.walk([&](stencil::StoreOp storeOp) {
        valueToOperand[storeOp.res()] = storeOp.getReturnOpOperand();
    });

    StencilTypeConverter typeConverter(module.getContext());
    populateStencilToSWConversionPatterns(typeConverter, valueToLB, 
        valueToOperand, valueToApplyOpIndex, patterns);
    */


   StandardTypeConverter typeConverter(module.getContext());
   populateStandardToSWConversionPatterns(typeConverter, patterns);
    
    StandardToSWTarget target(*(module.getContext()));
    target.addLegalDialect<mlir::sw::SWDialect>();
    // target.addDynamicallyLegalOp<FuncOp>(); // Aborted (core dumped)
    target.addLegalOp<ModuleOp>();
    // target.addLegalOp<memref::AllocOp>();

    if (failed(applyFullConversion(module, target, std::move(patterns)))) {
        signalPassFailure();
    }
}

} // end of anonymous namespace

namespace mlir {

// 填充转换模式列表
void populateStandardToSWConversionPatterns(
    StandardTypeConverter &typeConverter, mlir::OwningRewritePatternList &patterns) {
    patterns.insert<CallOpLowering, FuncOpLowering, ParallelOpLowering, // ReturnOpLowering,
                    ScfForOpLowering, ScfYieldOpLowering,
                    ConstantOpLowering, 
                    AddFOpLowering, SubFOpLowering, MulFOpLowering, DivFOpLowering,
                    AddIOpLowering, SubIOpLowering, MulIOpLowering,
                    LoadOpLowering, StoreOpLowering, AllocOpLowering, BarrierOpLowering>(typeConverter); 
}

//============================================================================//
// Standard类型转换器
//============================================================================//
StandardTypeConverter::StandardTypeConverter(MLIRContext *context_)
    : context(context_) {
    addConversion([&](mlir::MemRefType type) {
        return mlir::sw::MemRefType::get(type.getElementType(), type.getShape());
    });
}

//============================================================================//
// 转换模式基类
//============================================================================//

StandardToSWPattern::StandardToSWPattern(
    StringRef rootOpName, StandardTypeConverter &typeConverter, PatternBenefit benefit)
    : ConversionPattern(rootOpName, benefit, typeConverter.getContext()),
      typeConverter(typeConverter)
     {}

} // end of namespace mlir

std::unique_ptr<Pass> mlir::createConvertStandardToSWPass() {
    return std::make_unique<StandardToSWPass>();
}
