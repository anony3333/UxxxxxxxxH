#ifndef _CONVERSION_UHAFFINETOPARALLEL_PASS_TD_
#define _CONVERSION_UHAFFINETOPARALLEL_PASS_TD_

include "mlir/Pass/PassBase.td"

def UHTilingAffineForPass : FunctionPass<"uh-tiling-affine-for"> {
    let summary = "add UH tiling affine for operations";
    let constructor = "mlir::createUHTilingAffineForPass()";
    let options = [
        Option<"hardware", "hardware", "std::string",
                /*default*/"\"gpu\"",
                "Select target hardware, now only gpu and sw are supported">,
        Option<"num_level", "number_of_levels", "unsigned",
                /*default=*/"1",
                "Set the number of unified-hardware levels">,
        ListOption<"tile_sizes_l0", "tile_sizes_l0", "unsigned",
                "List of tile sizes for uh level 0",
                "llvm::cl::MiscFlags::CommaSeparated">,
        ListOption<"tile_sizes_l1", "tile_sizes_l1", "unsigned",
                "List of tile sizes for uh level 1",
                "llvm::cl::MiscFlags::CommaSeparated">,
        ListOption<"tile_sizes_l2", "tile_sizes_l2", "unsigned",
                "List of tile sizes for uh level 2",
                "llvm::cl::MiscFlags::CommaSeparated">,
    ];
}

def UHTilingToParallelPass : FunctionPass<"uh-tiling-to-parallel"> {
    let summary = "Tiling UH affine for to parallel operations";
    let constructor = "mlir::createUHTilingToParallelPass()";
    let options = [
        Option<"hardware", "hardware", "std::string",
                /*default*/"\"gpu\"",
                "Select target hardware, now only gpu and sw are supported">,
        Option<"num_level", "number_of_levels", "unsigned",
                /*default=*/"1",
                "Set the number of unified-hardware levels">,
        ListOption<"tile_sizes_l0", "tile_sizes_l0", "unsigned",
                "List of tile sizes for uh level 0",
                "llvm::cl::MiscFlags::CommaSeparated">,
        ListOption<"tile_sizes_l1", "tile_sizes_l1", "unsigned",
                "List of tile sizes for uh level 1",
                "llvm::cl::MiscFlags::CommaSeparated">,
        ListOption<"tile_sizes_l2", "tile_sizes_l2", "unsigned",
                "List of tile sizes for uh level 2",
                "llvm::cl::MiscFlags::CommaSeparated">,
  ];
}

def UHAffineParallelizePass : FunctionPass<"uh-affine-parallelize"> {
    let summary = "parallelize tagged affine.for and then collapse the parallel loops";
    let constructor = "mlir::createUHAffineParallelizePass()";
}

def AffineInnerTilingPass : FunctionPass<"uh-affine-inner-loop-tiling"> {
    let summary = "tling affine inner loops";
    let constructor = "mlir::createAffineInnerTilingPass()";
    let options = [
        ListOption<"tile_sizes", "tile_sizes", "unsigned",
                "List of inner tile sizes",
                "llvm::cl::MiscFlags::CommaSeparated">,
    ];
}

def FastMemCopyPass : FunctionPass<"uh-generate-fast-mem-copies"> {
    let summary = "generate fast memory copy loops";
    let constructor = "mlir::createFastMemCopyPass()";
    let dependentDialects = ["memref::MemRefDialect"];
    let options = [
        Option<"fastMemoryCapacity", "fast-mem-capacity", "uint64_t",
            /*default=*/"std::numeric_limits<uint64_t>::max()",
            "Set fast memory space capacity in KiB (default: unlimited)">,
        Option<"fastMemorySpace", "fast-mem-space", "unsigned",
            /*default=*/"3",
            "Fast memory space identifier for copy generation (default: 1)">,
        Option<"slowMemorySpace", "slow-mem-space", "unsigned",
            /*default=*/"0",
            "Slow memory space identifier for copy generation (default: 0)">,
        ListOption<"inner_tile", "inner_tile", "unsigned",
                "List of inner tile sizes",
                "llvm::cl::MiscFlags::CommaSeparated">,
    ];
}

def UHMemMappingPass : FunctionPass<"uh-mem-mapping"> {
    let summary = "map uh memory";
    let constructor = "mlir::createUHMemMappingPass()";
    let options = [
        ListOption<"inner_tile", "inner_tile", "unsigned",
                "List of inner tile sizes",
                "llvm::cl::MiscFlags::CommaSeparated">,
        Option<"input_only", "input_only", "bool",
                /*default=*/"false",
                "mapping input memref to fast memory only">,
        ListOption<"tile_by_cache", "tile_by_cache", "unsigned",
                "List of tile sizes for caching",
                "llvm::cl::MiscFlags::CommaSeparated">,
    ];
}

#endif // _CONVERSION_UHAFFINETOPARALLEL_PASS_TD_
