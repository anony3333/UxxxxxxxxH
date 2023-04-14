import sys
import os
import itertools
import random
import subprocess
import time
from functools import reduce

stencil="3d7pt_star"
stenCC="../../../build/bin/stenCC"
NN=256

def CALL(cmd):
    ret = subprocess.call(["bash", "-c", cmd])
    if ret != 0:
        print("error ", cmd)

def FilterParams(configVector):
    tile, mtile = configVector

    # MPE: 64
    if reduce(lambda x, y : x * y, tile) != 64:
        return False
    
    # LDM capability: 64 KB
    ldm_usage = reduce(lambda x, y : x * y, mtile) + \
        reduce(lambda x, y : (x+2) * (y+2), mtile)
    if  ldm_usage * 8 > 64 * 1024:
        return False

    if tile[0] * mtile[0] > NN:
        return False
    if tile[1] * mtile[1] > NN:
        return False
    if tile[2] * mtile[2] > NN:
        return False

    return True


def run(configVector):
    tile, mtile = configVector
    case_name = f"{stencil}_{tile[0]}_{tile[1]}_{tile[2]}_m_{mtile[0]}_{mtile[1]}_{mtile[2]}"
    CALL(f"mkdir {case_name}")

    cmd = stenCC
    cmd += f" --convert-stencil-to-std --cse \
            --uh-tiling-affine-for=\"hardware=sw tile_sizes_l0={tile[0]},{tile[1]},{tile[2]}\" --cse \
            --uh-mem-mapping=\"inner_tile={mtile[0]},{mtile[1]},{mtile[2]}\" --cse \
            --uh-affine-parallelize \
            --lower-affine -cse \
            --convert-std-to-sw \
            --sw-outlining  ./stencil_{stencil}.dsl >& {case_name}/stencil_{stencil}.sw"
    CALL(cmd)
    CALL(f"cd {case_name} && python ../../../../tool/translate.py stencil_{stencil}.sw")
    CALL("cd ../")


def search():
    tile = itertools.product([2**i for i in range(0, 5)], repeat=3)
    mtile = itertools.product([2**i for i in range(2, 8)], repeat=3)

    configs = filter(FilterParams, itertools.product(
        tile, mtile
    ))
    configs = list(configs)
    random.shuffle(configs)
    maxTestCount = min(1000, len(configs))
    print(f"number of total configurations: {len(configs)}")
    print(f"number of configurations to test: {maxTestCount}")
    
    for cnt, configVector in enumerate(configs):
        if cnt < maxTestCount:
            run(configVector)
        cnt += 1


if __name__ == '__main__':
    search()
    CALL("tar cvf 3d7pt_star.tar 3d7pt_star_* stencil_*driver.serial.c && rm -rf 3d7pt_star_*")