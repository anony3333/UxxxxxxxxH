#ifndef _CONVERSION_STANDARDTOSW_PASS_TD_
#define _CONVERSION_STANDARDTOSW_PASS_TD_

include "mlir/Pass/PassBase.td"

def StandardToSWPass : Pass<"convert-std-to-sw", "ModuleOp"> {
    let summary = "Convert standard dialect to sw dialect";
    let constructor = "mlir::createConvertStandardToSWPass()";
}


#endif // _CONVERSION_STANDARDTOSW_PASS_TD_