3d7pt:
	../../build/bin/stenCC  --emit=gpu stencil_3d7pt_arbitrary_shape.dsl > gpu0.mlir  2>&1
	mlir-opt gpu0.mlir  -gpu-kernel-outlining  -pass-pipeline="gpu.module(strip-debuginfo,convert-gpu-to-nvvm,gpu-to-cubin)" --gpu-to-llvm  > 3d7pt_gpu0.mlir 2>&1
	mlir-translate --mlir-to-llvmir 3d7pt_gpu0.mlir > 3d7pt_gpu0.ll
	llc 3d7pt_gpu0.ll -o 3d7pt_gpu0.s
	clang -c 3d7pt_gpu0.s -o 3d7pt_gpu0.o
	nvcc -ccbin clang 3d7pt_main.cpp 3d7pt_gpu0.o -L/home/jzh/mlir_stencil/llvm-project/build/lib  -lmlir_cuda_runtime -lcudart -lcuda
