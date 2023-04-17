#ifndef _CONVERSION_STENCILTOSTANDARD_CONVERTSTENCILTOSTANDARD_H_
#define _CONVERSION_STENCILTOSTANDARD_CONVERTSTENCILTOSTANDARD_H_

#include <mlir/IR/MLIRContext.h>
#include <mlir/Support/LLVM.h>
#include <mlir/Transforms/DialectConversion.h>
#include <cstdint>
#include <tuple>
#include "Dialect/Stencil/StencilOps.h"

namespace mlir {
namespace stencil {

//============================================================================//
// 将stencil类型转化为standard类型
//============================================================================//
struct StencilTypeConverter_std : public TypeConverter {
    using TypeConverter::TypeConverter;

    StencilTypeConverter_std(MLIRContext *context);

    // 返回上下文
    MLIRContext *getContext() { return context; }

private:
    MLIRContext *context;
};
//============================================================================//
// 将stencil操作转化为std操作的基类
//============================================================================//
class StencilToStdPattern : public ConversionPattern {
public:
  StencilToStdPattern(
      StringRef rootOpName, StencilTypeConverter_std &typeConverter,
      PatternBenefit benefit = 1);

  // 返回父循环嵌套的归纳变量
  SmallVector<Value, 3> getInductionVars(Operation *operation) const;

  /// 计算操作的形状
  Index computeShape(ShapeOp shapeOp) const;

  /// 计算子视图的偏移、形状和步长
  std::tuple<Index, Index, Index> computeSubViewShape(FieldType fieldType,
                                                      ShapeOp accessOp,
                                                      Index assertLB) const;

  /// 计算给定常量偏移的索引值
  SmallVector<Value, 3>
  computeIndexValues(ValueRange inductionVars, Index offset,
                     ArrayRef<bool> allocation,
                     ConversionPatternRewriter &rewriter) const;

  /// 使用给定值的特定类型的返回操作
  template <typename OpTy>
  OpTy getUserOp(Value value) const {
    for (auto user : value.getUsers())
      if (OpTy op = dyn_cast<OpTy>(user))
        return op;
    return nullptr;
  }

protected:
  // 类型转换器的引用
  StencilTypeConverter_std &typeConverter;
};

//============================================================================//
// 实现匹配每一个操作的模式的辅助类
//============================================================================//
template <typename OpTy>
class StencilOpToStdPattern : public StencilToStdPattern {
public:
  StencilOpToStdPattern(
      StencilTypeConverter_std &typeConverter, PatternBenefit benefit = 1)
      : StencilToStdPattern(OpTy::getOperationName(), typeConverter, benefit) {}
};

// 填充conversion模式列表的辅助函数
void populateStencilToStdConversionPatterns(
    StencilTypeConverter_std &typeConveter, OwningRewritePatternList &patterns);

} // end of namespace stencil

void populateAffineToStdPartiallyConversionPatterns(RewritePatternSet &patterns);
std::unique_ptr<Pass> createLowerAffinePartiallyPass();

void populateAffineParallelToSCFConversionPatterns(RewritePatternSet &patterns);
std::unique_ptr<Pass> createLowerAffineParallelToSCFPass();
} // end of namespace mlir

#endif // _CONVERSION_STENCILTOSTANDARD_CONVERTSTENCILTOSTANDARD_H_
