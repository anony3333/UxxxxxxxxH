#ifndef _CONVERSION_STENCILTOSTANDARD_PASS_TD_
#define _CONVERSION_STENCILTOSTANDARD_PASS_TD_

include "mlir/Pass/PassBase.td"

def StencilToStdPass : Pass<"convert-stencil-to-std", "ModuleOp"> {
    let summary = "Convert stencil dialect to standard operations";
    let constructor = "mlir::createConvertStencilToStdPass()";
}

def LowerAffinePartiallyPass : Pass<"lower-affine-partially", "ModuleOp"> {
    let summary = "Lower affine dialect partially";
    let constructor = "mlir::createLowerAffinePartiallyPass()";
}

def LowerAffineParallelToSCFPass : Pass<"lower-affine-parallel-to-scf", "ModuleOp"> {
    let summary = "Lower affine parallel to scf";
    let constructor = "mlir::createLowerAffineParallelToSCFPass()";
}

#endif // _CONVERSION_STENCILTOSTANDARD_PASS_TD_
