/**
 * @file Passes.h
 * @author Siqi Wang (18373181@buaa.edu.cn)
 * @brief Stencil to Standard Pass
 * @version 0.1
 * @date 2021-12-06
 * 
 * @copyright Copyright (c) HiPO Beihang University 2021
 * 
 */
#ifndef _CONVERSION_STENCILTOSTANDARD_PASSES_H_
#define _CONVERSION_STENCILTOSTANDARD_PASSES_H_

#include "mlir/Pass/Pass.h"

namespace mlir {

class Pass;

std::unique_ptr<Pass> createConvertStencilToStdPass();
std::unique_ptr<Pass> createLowerAffinePartiallyPass();
std::unique_ptr<Pass> createLowerAffineParallelToSCFPass();

//===----------------------------------------------------------------------===//
// 注册
//===----------------------------------------------------------------------===//
#define GEN_PASS_REGISTRATION
#include "Conversion/StencilToStandard/Passes.h.inc"

} // end of mlir

#endif // _CONVERSION_STENCILTOSTANDARD_PASSES_H_
