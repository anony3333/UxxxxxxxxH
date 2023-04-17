../../build/bin/stenCC --convert-stencil-to-std --cse \
            --uh-tiling-affine-for="hardware=sw tile_sizes_l0=8,8" --cse \
            --uh-affine-inner-loop-tiling=tile_sizes=64,64 --cse \
            --uh-generate-fast-mem-copies=inner_tile=4,4 -cse \
            --uh-affine-parallelize \
            --lower-affine -cse stencil_2d5pt_star.dsl >& stencil_2d5pt_star.mlir
