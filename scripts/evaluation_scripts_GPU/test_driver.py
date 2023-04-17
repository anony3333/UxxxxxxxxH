import sys
import os
import itertools
import random
import subprocess
import time

option_set = set()
output_csv = "duration.csv"
# 获取环境变量，如果没有则返回1000
TEST_NUM = int(os.getenv("TEST_NUM", 1000))
print("TEST_NUM: ", TEST_NUM)

order = 4
MM2d = NN2d = 8192
MM3d = NN3d = QQ3d = 512

def CALL(cmd):
    ret = subprocess.call(["bash", "-c", cmd])
    if ret != 0:
        print("error: ", cmd)


def repeat(gridSize, blockSize, innerTile):
    global option_set
    str_vec = []
    for x, y, z in zip(gridSize, blockSize, innerTile):
        str_vec.append(f"{x, y, z}")
    final_str = "/".join(sorted(str_vec))
    if final_str in option_set:
        return False
    else:
        option_set.add(final_str)
        return True

def FilterParams2d(configVector):
    innerTile, gridSize, blockSize, useShm = configVector

    if useShm and gridSize[0] * blockSize[0] * innerTile[0] > MM2d:
        return False
    if useShm and gridSize[1] * blockSize[1] * innerTile[1] > NN2d:
        return False

    if not useShm and gridSize[0] * blockSize[0] > MM2d:
        return False
    if not useShm and gridSize[1] * blockSize[1] > NN2d:
        return False

    if gridSize[0] * gridSize[1] <= 128:
        return False

    ## block size 
    if blockSize[0] * blockSize[1] > 1024 or blockSize[0] * blockSize[1] < 128:
        return False
    ## shared memory
    if useShm and (2*order + innerTile[0]*blockSize[0]) * (2*order+innerTile[1] * blockSize[1]) * 8 * 2 > 2 ** 15:
        return False
    if not useShm and innerTile[0] * innerTile[1] != 1:
        return False
    return repeat(gridSize, blockSize, innerTile)

def FilterParams3d(configVector):
    innerTile, gridSize, blockSize, useShm = configVector

    if gridSize[0] * blockSize[0] * innerTile[0] > MM3d:
        return False
    if gridSize[1] * blockSize[1] * innerTile[1] > NN3d:
        return False
    if gridSize[2] * blockSize[2] * innerTile[2] > QQ3d:
        return False
    
    if gridSize[0] * gridSize[1] * gridSize[2] <= 128:
        return False

    ## block size 
    if blockSize[0] * blockSize[1] * blockSize[2] > 1024 or blockSize[0] * blockSize[1] * blockSize[2] < 128:
        return False
    if blockSize[2] > 64:
        return False
    if blockSize[0] * blockSize[1] * blockSize[2] < 128:
        return False

    if blockSize[0] * innerTile[0] > 32:
        return False
    if blockSize[1] * innerTile[2] > 32:
        return False
    if blockSize[1] * innerTile[2] > 32:
        return False

    ## shared memory
    input_shm = (innerTile[0] * blockSize[0] + order * 2) * \
                (innerTile[1] * blockSize[1] + order * 2) * \
                (innerTile[2] * blockSize[2] + order * 2) * 8
    output_shm = (innerTile[0] * blockSize[0]) * \
                (innerTile[1] * blockSize[1]) * \
                (innerTile[2] * blockSize[2]) * 8
    if useShm and innerTile[0]*innerTile[1]*innerTile[2] == 1 or useShm and input_shm + output_shm > 2 ** 15:
        return False
    return repeat(gridSize, blockSize, innerTile)

def run_2d(configVector, dsl, cnt):
    innerTile, gridSize, blockSize, useShm = configVector

    ## write paras
    with open(f"{output_csv}.csv", 'a') as csv:
        csv.write(f"{gridSize[0]},{gridSize[1]},")
        csv.write(f"{blockSize[0]},{blockSize[1]},")
        csv.write(f"{innerTile[0]},{innerTile[1]},")
        csv.write(f"{int(useShm)},")
    
    stenCC = "../../build/bin/stenCC "
    options = ["--convert-stencil-to-std"]

    ## uh parallel
    ## tile_sizes_l0=gy,gx
    ## tile_sizes_l1=by,bx
    options.append(f"--uh-tiling-affine-for=\'hardware=gpu tile_sizes_l0={gridSize[1]},{gridSize[0]} tile_sizes_l1={blockSize[1]},{blockSize[0]}\'")
    
    ## uh mem mapping
    ## inner_tile=tile_y,tile_x
    if useShm:
        options.append(f"--uh-mem-mapping=\'inner_tile={innerTile[1]},{innerTile[0]}\'")
    options.append("--cse")

    ## lowering
    options += ["--uh-affine-parallelize", "--lower-affine", "--cse", "--uh-gpu-parallel-loop-mapping", \
        "--convert-parallel-loops-to-gpu", "--gpu-kernel-outlining", "--cse", \
        "--pass-pipeline=\'gpu.module(gpu.func(uh-promote-workgroup-memory))\'", \
        "--lower-affine", "--convert-scf-to-std", \
        "--pass-pipeline=\'gpu.module(strip-debuginfo,convert-gpu-to-nvvm,gpu-to-cubin)\'", \
        "--gpu-to-llvm", "--cse"]
    
    try:
        ## generate code
        cmd = stenCC + " ".join(options + [dsl, "> tmp.mlir 2>&1"])
        print(cmd)
        CALL(cmd)
        cmd = "mlir-translate --mlir-to-llvmir tmp.mlir | llc -o tmp.s"
        print(cmd)
        CALL(cmd)
        cmd = "clang -c -O3 -o tmp.o tmp.s"
        print(cmd)
        CALL(cmd)
        cmd = f"nvcc -g -ccbin clang {dsl.split('_')[1]}_main.cpp tmp.o  \
            -lmlir_cuda_runtime -lcudart -lcuda"
        print(cmd)
        CALL(cmd)
        
        ## profile
        # --launch-skip=3   跳过前三个kernel
        # grep -P avg       看gpu__time_duration.avg这一行
        # cut -d\" -f 24    切下按"分隔的第24段，即duration
        # sed 's/,//g'      去除duration字段的逗号
        # cmd = f"CUDA_VISIBLE_DEVICES={cnt%2} ncu --csv --launch-skip=3 --metrics duration ./a.out | \
        #     grep -P avg | cut -d\\\" -f 24 | sed 's/,//g' >> {output_csv}.csv"
        kernel_name = dsl[:dsl.rindex("_")] + "_kernel" 
        cmd = f"CUDA_VISIBLE_DEVICES=1 nsys nvprof ./a.out | grep {kernel_name} | awk '{{print $4}}' | sed 's/,//g' >> {output_csv}.csv"
        print(cmd)
        CALL(cmd)
    except KeyboardInterrupt as e:
        raise e
    except Exception as e:
        print("running error: %s" % e)
        CALL(f"echo \"n/a\" >> {output_csv}.csv")




def searchSpace_2d(dsl):
    with open(f"{output_csv}.csv", 'w') as csv:
        csv.write("SearchTime(s),gx,gy,bx,by,inx,iny,shm,duration(ns)\n")
    
    innerTiles = itertools.product([2**i for i in range(0, 4)], repeat=2)
    gridSizes = itertools.product([2**i for i in range(0, 10)], repeat=2)
    blockSizes = itertools.product([2**i for i in range(0, 8)], repeat=2)

    configs = filter(FilterParams2d, itertools.product(
        innerTiles,
        gridSizes,
        blockSizes,
        [True, False] ## use shared memory
    ))
    configs = list(configs)
    random.shuffle(configs)
    maxTestCount = min(TEST_NUM, len(configs))
    print(f"number of total configurations: {len(configs)}")
    print(f"number of configurations to test: {maxTestCount}")
    start_time = time.time()
    for cnt, configVector in enumerate(configs):
        if cnt < maxTestCount:
            print(f"\n-------------------------- test {cnt} / {maxTestCount}")
            with open(f"{output_csv}.csv", 'a') as csv:
                csv.write(f"{round(time.time() - start_time,2)},")
            run_2d(configVector, dsl, cnt)
            os.system("rm report*")
        cnt += 1

def run_3d(configVector, dsl, cnt):
    innerTile, gridSize, blockSize, useShm = configVector

    ## write paras
    with open(f"{output_csv}.csv", 'a') as csv:
        csv.write(f"{gridSize[0]},{gridSize[1]},{gridSize[2]},")
        csv.write(f"{blockSize[0]},{blockSize[1]},{blockSize[2]},")
        csv.write(f"{innerTile[0]},{innerTile[1]},{innerTile[2]},")
        csv.write(f"{int(useShm)},")
    
    stenCC = "../../build/bin/stenCC "
    options = ["--convert-stencil-to-std"]

    ## uh parallel
    ## tile_sizes_l0=gz,gy,gx
    ## tile_sizes_l1=bz,by,bx
    options.append(f"--uh-tiling-affine-for=\'hardware=gpu \
        tile_sizes_l0={gridSize[2]},{gridSize[1]},{gridSize[0]} \
        tile_sizes_l1={blockSize[2]},{blockSize[1]},{blockSize[0]} \'")
    
    ## uh mem mapping
    # inner_tile=tile_z,tile_y,tile_x
    if useShm:
        options.append(f"--uh-mem-mapping=\'inner_tile={innerTile[2]},{innerTile[1]},{innerTile[0]}\'")
    options.append("--cse")

    ## lowering
    options += ["--uh-affine-parallelize", "--lower-affine", "--cse", "--uh-gpu-parallel-loop-mapping", \
        "--convert-parallel-loops-to-gpu", "--gpu-kernel-outlining", "--cse", \
        "--pass-pipeline=\'gpu.module(gpu.func(uh-promote-workgroup-memory))\'", \
        "--lower-affine", "--convert-scf-to-std", \
        "--pass-pipeline=\'gpu.module(strip-debuginfo,convert-gpu-to-nvvm,gpu-to-cubin)\'", \
        "--gpu-to-llvm", "--cse"]
    
    try:
        ## generate code
        cmd = stenCC + " ".join(options + [dsl, "> tmp.mlir 2>&1"])
        print(cmd)
        CALL(cmd)
        cmd = "mlir-translate --mlir-to-llvmir tmp.mlir | llc -o tmp.s"
        print(cmd)
        CALL(cmd)
        cmd = "clang -c -O3 -o tmp.o tmp.s"
        print(cmd)
        CALL(cmd)
        cmd = f"nvcc -g -ccbin clang {dsl.split('_')[1]}_main.cpp tmp.o  \
            -lmlir_cuda_runtime -lcudart -lcuda"
        print(cmd)
        CALL(cmd)
        
        kernel_name = dsl[:dsl.rindex("_")] + "_kernel" 
        cmd = f"CUDA_VISIBLE_DEVICES=0 nsys nvprof ./a.out | grep {kernel_name} | awk '{{print $4}}' | sed 's/,//g' >> {output_csv}.csv"
        print(cmd)
        CALL(cmd)
    except KeyboardInterrupt as e:
        raise e
    except Exception as e:
        print("running error: %s" % e)
        CALL(f"echo \"n/a\" >> {output_csv}.csv")

def searchSpace_3d(dsl):
    with open(f"{output_csv}.csv", 'w') as csv:
        csv.write("SearchTime(s),gx,gy,gz,bx,by,bz,inx,iny,inz,shm,duration(ns)\n")
    
    innerTiles = itertools.product([2**i for i in range(0, 3)], repeat=3)
    gridSizes = itertools.product([2**i for i in range(0, 8)], repeat=3)
    blockSizes = itertools.product([2**i for i in range(0, 8)], repeat=3)

    configs = filter(FilterParams3d, itertools.product(
        innerTiles,
        gridSizes,
        blockSizes,
        [True, False]
    ))
    configs = list(configs)
    random.shuffle(configs)
    maxTestCount = min(TEST_NUM, len(configs))
    print(f"number of total configurations: {len(configs)}")
    print(f"number of configurations to test: {maxTestCount}")
    start_time = time.time()
    for cnt, configVector in enumerate(configs):
        if cnt < maxTestCount:
            print(f"\n-------------------------- test {cnt} / {maxTestCount}")
            with open(f"{output_csv}.csv", 'a') as csv:
                csv.write(f"{round(time.time() - start_time,2)},")
            run_3d(configVector, dsl, cnt)
            os.system("rm report*")
        cnt += 1