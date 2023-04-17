# UHStencil

A stencil domain specific compiler with unified-hardware abstraction.

## Build Instructions

UHStencil depends on a build of llvm  including MLIR. So you need to build and install llvm first. The repository is developed based on LLVM project commit d7b669b.

### Requirement
| Dependency | Version |
| :----: | :----: |
| cmake | 3.19.7 |
| ninja | 1.10.2 |
| gcc | 10.2.0 |
| python | 3.9.6 |

we also have tested on `Ubuntu 20.04.1 LTS`

### Build LLVM project

We assume that you build LLVM and MLIR in `build` directory and install them to `<INSTALL_DIR>`. 

```bash
git clone https://github.com/llvm/llvm-project.git
cd llvm-project
git checkout d7b669b
mkdir build && cd build
cmake -G Ninja ../llvm -DLLVM_BUILD_EXAMPLES=OFF -DLLVM_TARGETS_TO_BUILD="host;NVPTX" -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> -DLLVM_ENABLE_PROJECTS=mlir -DLLVM_OPTIMIZED_TABLEGEN=ON -DLLVM_ENABLE_OCAMLDOC=OFF -DLLVM_ENABLE_BINDINGS=OFF -DLLVM_INSTALL_UTILS=ON -DMLIR_ENABLE_CUDA_RUNNER=ON #-DLLVM_PARALLEL_LINK_JOBS=2
cmake --build . --target install
```

### Build UHStencil project

```bash
git clone https://github.com/buaa-hipo/UHStencil.git
cd UHStencil
export LLVM_INSTALL=<path_to_llvm_install>
export LLVM_BUILD=<path_to_llvm_build_directory>
mkdir build && cd build
cmake -G Ninja .. -DMLIR_DIR=$LLVM_INSTALL/lib/cmake/mlir -DLLVM_EXTERNAL_LIT=$LLVM_BUILD/bin/llvm-lit
cmake --build . --target stenCC
```
The execuatable binary will be generated in path `UHStencil/build/bin`, named `stenCC`.


## How To Use

### simple run on CUDA gpu

After building all project, You can run the example program provided by UHStencil. There is a sample command.

```bash
cd UHStencil/examples/3d27pt_box/
../../build/bin/stenCC --convert-stencil-to-std --cse \
           --uh-tiling-affine-for="hardware=gpu tile_sizes_l0=4,4,4 tile_sizes_l1=4,4,4" \
           --uh-mem-mapping="inner_tile=2,2,2"  \
           --cse --uh-affine-parallelize \
           --lower-affine  --cse --uh-gpu-parallel-loop-mapping  \
           stencil_3d27pt_box.dsl >& 3d27pt_scf.mlir
../../build/bin/stenCC -x=mlir --convert-parallel-loops-to-gpu --canonicalize --gpu-kernel-outlining --cse --pass-pipeline="gpu.module(gpu.func(uh-promote-workgroup-memory))" 3d27pt_scf.mlir >& 3d27pt_gpu.mlir
../../build/bin/stenCC -x=mlir --lower-affine --convert-scf-to-std --pass-pipeline="gpu.module(strip-debuginfo,convert-gpu-to-nvvm,gpu-to-cubin)" --gpu-to-llvm --cse 3d27pt_gpu.mlir >& 3d27pt_llvm.mlir
mlir-translate --mlir-to-llvmir 3d27pt_llvm.mlir > 3d27pt_gpu.ll
llc 3d27pt_gpu.ll -o 3d27pt_gpu.s
clang -c 3d27pt_gpu.s -o 3d27pt_gpu.o
nvcc -g -ccbin clang 3d27pt_main.cpp 3d27pt_gpu.o -L/home/jzh/mlir_stencil/llvm-project/build/lib  -lmlir_cuda_runtime -lcudart -lcuda
./a.out

```

### simple run on Sunway

```bash
cd UHStencil/examples/3d27pt_box/
../../build/bin/stenCC --convert-stencil-to-sw stencil_3d27pt_box.dsl >& 3d27pt.sw
python3 ../../tool/translate.py 3d27pt.sw >& 3d27pt.c
```
