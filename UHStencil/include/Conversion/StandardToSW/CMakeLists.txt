set(LLVM_TARGET_DEFINITIONS Passes.td)
mlir_tablegen(Passes.h.inc -gen-pass-decls -name StandardToSWConversion)
add_public_tablegen_target(MLIRStandardToSWPassIncGen)