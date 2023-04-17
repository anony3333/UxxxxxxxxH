#ifndef _CONVERSION_LOOPSTOGPU_PASS_TD
#define _CONVERSION_LOOPSTOGPU_PASS_TD

include "mlir/Pass/PassBase.td"

def GPUParallelLoopMappingPass : FunctionPass<"uh-gpu-parallel-loop-mapping"> {
    let summary = "UH gpu parallel loop mapping";
    let constructor = "mlir::createGPUParallelLoopMappingPass()";
}

def UHPromoteWorkgroupMemoryPass : FunctionPass<"uh-promote-workgroup-memory"> {
    let summary = "promote workgroup memref alloc to gpu.func workgroup attribute";
    let constructor = "mlir::createUHPromoteWorkgroupMemoryPass()";
}

#endif // _CONVERSION_LOOPSTOGPU_PASS_TD
