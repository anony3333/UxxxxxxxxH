3d27pt:
	../../build/bin/stenCC --convert-stencil-to-std --uh-tiling-to-parallel='tile_sizes_l0=4,4,4 tile_sizes_l1=4,4,4' --uh-affine-inner-loop-tiling --lower-affine --uh-gpu-parallel-loop-mapping -cse stencil_3d27pt_box.dsl >& 3d27pt_scf.mlir
	../../build/bin/stenCC -x=mlir --convert-parallel-loops-to-gpu --lower-affine --convert-scf-to-std --gpu-kernel-outlining 3d27pt_scf.mlir >& 3d27pt_gpu.mlir
	../../build/bin/stenCC -x=mlir --pass-pipeline="gpu.module(strip-debuginfo,convert-gpu-to-nvvm,gpu-to-cubin)" --gpu-to-llvm 3d27pt_gpu.mlir >& 3d27pt_llvm.mlir
	mlir-translate --mlir-to-llvmir 3d27pt_llvm.mlir > 3d27pt_gpu.ll
	llc 3d27pt_gpu.ll -o 3d27pt_gpu.s
	clang -c 3d27pt_gpu.s -o 3d27pt_gpu.o
	nvcc -g -ccbin clang 3d27pt_main.cpp 3d27pt_gpu.o -L/home/jzh/mlir_stencil/llvm-project/build/lib  -lmlir_cuda_runtime -lcudart -lcuda
