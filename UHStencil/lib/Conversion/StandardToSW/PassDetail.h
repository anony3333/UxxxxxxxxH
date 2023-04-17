/**
 * @file PassDetail.h
 * @author 
 * @brief 自定义pass生成文件包装
 * @version 0.1
 * @date 2022-09-14
 * 
 * @copyright Copyright (c) HiPO Beihang University 2022
 * 
 */

#ifndef _CONVERSION_STANDARDTOSW_PASSDETAIL_H_
#define _CONVERSION_STANDARDTOSW_PASSDETAIL_H_

#include <mlir/Pass/Pass.h>

namespace mlir {

#define GEN_PASS_CLASSES
#include "Conversion/StandardToSW/Passes.h.inc"

} // end of namespace mlir

#endif // _CONVERSION_STANDARDTOSW_PASSDETAIL_H_
