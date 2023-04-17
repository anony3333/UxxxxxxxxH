/**
 * @file PassDetail.h
 * @author 
 * @brief 
 * @version 0.1
 * @date 
 * 
 * @copyright Copyright (c) HiPO Beihang University 2022
 * 
 */
#ifndef CONVERSION_UHAFFINETOPARALLEL_PASSDETAIL_H_
#define CONVERSION_UHAFFINETOPARALLEL_PASSDETAIL_H_

#include "mlir/Pass/Pass.h"

namespace mlir {

#define GEN_PASS_CLASSES
#include "Conversion/UHAffineToParallel/Passes.h.inc"

} // end namespace mlir

#endif // CONVERSION_UHAFFINETOPARALLEL_PASSDETAIL_H_
