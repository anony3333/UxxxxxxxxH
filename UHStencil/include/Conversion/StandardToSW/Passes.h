/**
 * @file Passes.h
 * @author Bangduo Chen (chenbangduo@buaa.edu.cn)
 * @brief Standard to SW Pass
 * @version 0.1
 * @date 2021-03-22
 * 
 * @copyright Copyright (c) HiPO Beihang University 2021
 * 
 */
#ifndef _CONVERSION_STANDARDTOSW_PASSES_H_
#define _CONVERSION_STANDARDTOSW_PASSES_H_

#include "mlir/Pass/Pass.h"

namespace mlir {

class Pass;

std::unique_ptr<Pass> createConvertStandardToSWPass();

//============================================================================//
// 注册
//============================================================================//
#define GEN_PASS_REGISTRATION
#include "Conversion/StandardToSW/Passes.h.inc"


} // end of mlir

#endif // _CONVERSION_STANDARDTOSW_PASSES_H_