add_mlir_dialect(StencilOps stencil)

set(LLVM_TARGET_DEFINITIONS StencilInterfaces.td)
mlir_tablegen(StencilInterfaces.h.inc -gen-op-interface-decls)
mlir_tablegen(StencilInterfaces.cpp.inc -gen-op-interface-defs)
add_public_tablegen_target(MLIRStencilInterfacesIncGen)
add_dependencies(mlir-headers MLIRStencilInterfacesIncGen)

set(LLVM_TARGET_DEFINITIONS Passes.td)
mlir_tablegen(Passes.h.inc -gen-pass-decls -name Stencil)
add_public_tablegen_target(MLIRStencilPassIncGen)