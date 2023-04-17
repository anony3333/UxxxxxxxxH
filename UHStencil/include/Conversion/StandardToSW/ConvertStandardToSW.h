/**
 * @file ConvertStandardToSW.h
 * @author 
 * @brief 将standard方言转化为sw方言
 * @version 0.1
 * @date 
 * 
 * @copyright Copyright (c) HiPO Beihang University 2022
 * 
 */

#ifndef _CONVERSION_STANDARDTOSW_CONVERTSTANDARDTOSW_H_
#define _CONVERSION_STANDARDTOSW_CONVERTSTANDARDTOSW_H_

#include <mlir/IR/MLIRContext.h>
#include <mlir/Support/LLVM.h>
#include <mlir/Transforms/DialectConversion.h>
#include <cstdint>
#include <tuple>


namespace mlir {
//============================================================================//
// 将standard类型转化为sw类型
//============================================================================//
struct StandardTypeConverter : public TypeConverter {
    using TypeConverter::TypeConverter;

    StandardTypeConverter(MLIRContext *context);

    // 返回上下文
    MLIRContext *getContext() { return context; }

private:
    MLIRContext *context;
};

//============================================================================//
// 将standard操作转化为sw操作的基类
//============================================================================//
class StandardToSWPattern : public ConversionPattern {
public:
    StandardToSWPattern(StringRef rootOpName, StandardTypeConverter &typeConverter,
                        PatternBenefit benefit = 1);
    
    // 返回嵌套循环的循环变量
    SmallVector<Value, 6> getInductionVars(Operation *operation) const;

protected:
    // 类型转换器的引用
    StandardTypeConverter &typeConverter;
};

//============================================================================//
// 实现匹配每一个操作的模式的辅助类
//============================================================================//
template <typename OpTy>
class StandardOpToSWPattern : public StandardToSWPattern {
public:
    StandardOpToSWPattern(StandardTypeConverter &typeConverter,
                          PatternBenefit benefit = 1)
        : StandardToSWPattern(OpTy::getOperationName(), typeConverter, benefit) {}
};

// 填充conversion模式列表的辅助函数
void populateStandardToSWConversionPatterns(StandardTypeConverter &typeConverter, 
                                            OwningRewritePatternList &patterns);
} // end of namespace mlir

#endif // _CONVERSION_STANDARDTOSW_CONVERTSTANDARDTOSW_H_