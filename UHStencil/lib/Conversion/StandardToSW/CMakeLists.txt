add_mlir_dialect_library(StandardToSW
    ConvertStandardToSW.cpp

    ADDITIONAL_HEADER_DIRS
    ${PROJECT_SOURCE_DIR}/include/Conversion/StandardToSW

    DEPENDS
    MLIRStandardToSWPassIncGen
)

target_link_libraries(StandardToSW PUBLIC MLIRIR)