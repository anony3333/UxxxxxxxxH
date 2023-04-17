/**
 * @file PassDetail.h
 * @author Siqi Wang (18373181@buaa.edu.cn)
 * @brief 自定义pass生成文件包装
 * @version 0.1
 * @date 2021-12-06
 * 
 * @copyright Copyright (c) HiPO Beihang University 2021
 * 
 */
#ifndef CONVERSION_STENCILTOSTANDARD_PASSDETAIL_H_
#define CONVERSION_STENCILTOSTANDARD_PASSDETAIL_H_

#include "mlir/Pass/Pass.h"

namespace mlir {

#define GEN_PASS_CLASSES
#include "Conversion/StencilToStandard/Passes.h.inc"
#include <mlir/Conversion/Passes.h.inc>

} // end namespace mlir

#endif // CONVERSION_STENCILTOSTANDARD_PASSDETAIL_H_
