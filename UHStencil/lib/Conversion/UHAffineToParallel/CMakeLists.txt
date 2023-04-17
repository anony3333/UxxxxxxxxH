add_mlir_dialect_library(UHAffineToParallel
    UHAffineToParallel.cpp

    ADDITIONAL_HEADER_DIRS
    ${PROJECT_SOURCE_DIR}/include/Conversion/UHAffineToParallel

    DEPENDS
    MLIRUHAffineToParallelPassIncGen
)

target_link_libraries(UHAffineToParallel PUBLIC MLIRIR)