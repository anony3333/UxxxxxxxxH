/**
 * @file PassDetail.h
 * @author 
 * @brief 
 * @version 0.1
 * @date 2021-12-06
 * 
 * @copyright Copyright (c) HiPO Beihang University 2021
 * 
 */
#ifndef CONVERSION_LOOPSTOGPU_PASSDETAIL_H_
#define CONVERSION_LOOPSTOGPU_PASSDETAIL_H_

#include "mlir/Pass/Pass.h"

namespace mlir {

#define GEN_PASS_CLASSES
#include "Conversion/LoopsToGPU/Passes.h.inc"

} // end namespace mlir

#endif // CONVERSION_LOOPSTOGPU_PASSDETAIL_H_
