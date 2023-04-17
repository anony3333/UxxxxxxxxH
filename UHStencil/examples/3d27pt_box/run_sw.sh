../../build/bin/stenCC --convert-stencil-to-std --cse \
            --uh-tiling-affine-for="hardware=sw tile_sizes_l0=2,4,8" -cse \
            --uh-mem-mapping="inner_tile=16,16,16" -cse \
            --uh-affine-parallelize \
            --lower-affine-debug -cse stencil_3d27pt_box.dsl > 3d27pt_sw_scf_new.mlir
