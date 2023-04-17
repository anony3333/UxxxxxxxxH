../../build/bin/stenCC --convert-stencil-to-std --cse \
           --uh-tiling-affine-for="hardware=gpu tile_sizes_l0=8,8,8 tile_sizes_l1=2,8,8" \
           --uh-mem-mapping="inner_tile=2,2,2"  \
           --cse --uh-affine-parallelize \
           stencil_3d27pt_box.dsl >& 3d27pt_affine.mlir
           #--uh-mem-mapping="inner_tile=4,4,2"  \
../../build/bin/stenCC -x=mlir --lower-affine  --cse --uh-gpu-parallel-loop-mapping --convert-parallel-loops-to-gpu --canonicalize --gpu-kernel-outlining --cse --pass-pipeline="gpu.module(gpu.func(uh-promote-workgroup-memory))" 3d27pt_affine.mlir >& 3d27pt_gpu.mlir
../../build/bin/stenCC -x=mlir --lower-affine --convert-scf-to-std --pass-pipeline="gpu.module(strip-debuginfo,convert-gpu-to-nvvm,gpu-to-cubin)" --gpu-to-llvm --cse 3d27pt_gpu.mlir >& 3d27pt_llvm.mlir
mlir-translate --mlir-to-llvmir 3d27pt_llvm.mlir > 3d27pt_gpu.ll
llc 3d27pt_gpu.ll -o 3d27pt_gpu.s
clang -c 3d27pt_gpu.s -o 3d27pt_gpu.o
nvcc -g -ccbin clang 3d27pt_main.cpp 3d27pt_gpu.o -L/home/jzh/mlir_stencil/llvm-project/build/lib  -lmlir_cuda_runtime -lcudart -lcuda
./a.out
