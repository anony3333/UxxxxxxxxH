# ../../build/bin/stenCC \
# --convert-stencil-to-std --cse \
# --uh-tiling-affine-for='hardware=sw tile_sizes_l0=4,4,4' --cse \
# --uh-affine-inner-loop-tiling=tile_sizes=4,4,4 --cse \
# # --uh-generate-fast-mem-copies --cse \
# --uh-generate-fast-mem-copies=inner_tile=4,4 --cse \
# --uh-affine-parallelize \
# --lower-affine-debug --cse stencil_3d27pt_box.dsl >& 3d27pt_sw_scf_new.mlir

../../build/bin/stenCC --convert-stencil-to-std --cse --uh-tiling-affine-for='hardware=sw tile_sizes_l0=4,4,4' --cse --uh-affine-inner-loop-tiling=tile_sizes=4,4,4 --cse --uh-affine-parallelize --lower-affine-debug --cse stencil_3d27pt_box.dsl >& 3d27pt_sw_scf_new.mlir

# ../../build/bin/stenCC --convert-stencil-to-std --cse --uh-tiling-affine-for='hardware=sw tile_sizes_l0=4,4,4' --cse --uh-affine-inner-loop-tiling=tile_sizes=4,4,4 --cse --uh-generate-fast-mem-copies --cse --uh-affine-parallelize stencil_3d27pt_box.dsl >& 3d27pt_sw_affine_new.mlir