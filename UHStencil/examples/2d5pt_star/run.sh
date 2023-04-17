../../build/bin/stenCC --convert-stencil-to-std --cse \
           --uh-tiling-affine-for="hardware=gpu tile_sizes_l0=32,32 tile_sizes_l1=16,16" \
           --uh-mem-mapping="inner_tile=2,4"  \
           --cse --uh-affine-parallelize \
           stencil_2d5pt_star.dsl >& 2d5pt_affine.mlir
           #--uh-mem-mapping="inner_tile=2,2"  \
../../build/bin/stenCC -x=mlir --lower-affine  --cse --uh-gpu-parallel-loop-mapping --convert-parallel-loops-to-gpu --canonicalize --gpu-kernel-outlining --cse --pass-pipeline="gpu.module(gpu.func(uh-promote-workgroup-memory))" 2d5pt_affine.mlir >& 2d5pt_gpu.mlir
../../build/bin/stenCC -x=mlir --lower-affine --convert-scf-to-std --pass-pipeline="gpu.module(strip-debuginfo,convert-gpu-to-nvvm,gpu-to-cubin)" --gpu-to-llvm --cse 2d5pt_gpu.mlir >& 2d5pt_llvm.mlir
mlir-translate --mlir-to-llvmir 2d5pt_llvm.mlir > 2d5pt_gpu.ll
llc 2d5pt_gpu.ll -o 2d5pt_gpu.s
clang -c -O3 2d5pt_gpu.s -o 2d5pt_gpu.o
nvcc -g -ccbin clang 2d5pt_main.cpp 2d5pt_gpu.o -L/home/jzh/mlir_stencil/llvm-project/build/lib  -lmlir_cuda_runtime -lcudart -lcuda
./a.out
