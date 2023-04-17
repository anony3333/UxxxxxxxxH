add_mlir_dialect_library(LoopsToGPU
    GPUParallelLoopMapping.cpp

    ADDITIONAL_HEADER_DIRS
    ${PROJECT_SOURCE_DIR}/include/Conversion/LoopsToGPU

    DEPENDS
    MLIRLoopsToGPUPassIncGen
)

target_link_libraries(LoopsToGPU PUBLIC MLIRIR)