from ast import arg
import os
import os.path
import re
from re import A
import subprocess
import argparse
import time

# self.cwd = os.path.realpath(os.path.dirname(__file__))
class Evaluate:
    def __init__(self, cwd, main_name, mlir_list, inline):
        self.cwd = cwd
        self.object_paths = []
        self.main_name = main_name
        self.mlir_list = mlir_list
        self.clean_path = []
        self.inline = inline

    # self.cwd = os.path.dirname(os.path.realpath(__file__))
    # BENCH_NAME = os.path.basename(self.cwd)

    def compile_mlir(self, BENCH_NAME, inline=True):
        # global object_paths
        print("Compiling MLIR...")

        origin_mlir_path = os.path.join(self.cwd, BENCH_NAME + ".mlir")
        lowered_mlir_path = os.path.join(self.cwd, BENCH_NAME + "_lowered.mlir")
        bc_path = os.path.join(self.cwd, BENCH_NAME + ".bc")
        assembly_path = os.path.join(self.cwd, BENCH_NAME + ".s")
        object_path = os.path.join(self.cwd, BENCH_NAME + ".o")
        self.clean_path += [lowered_mlir_path, bc_path, assembly_path, object_path]
        self.object_paths.append(object_path)
        cmd_paras = "oec-opt --canonicalize --stencil-shape-inference --stencil-storage-materialization --stencil-shape-inference --stencil-combine-to-ifelse --cse \
            --canonicalize --convert-stencil-to-std --cse --parallel-loop-tiling=parallel-loop-tile-sizes=128,1,1 \
            --canonicalize --test-gpu-greedy-parallel-loop-mapping --convert-parallel-loops-to-gpu --lower-affine \
            --convert-scf-to-std --gpu-kernel-outlining --cse \
            --canonicalize --stencil-kernel-to-cubin --cse --canonicalize --mlir-disable-threading " + origin_mlir_path

        cmd1_paras = "oec-opt --canonicalize --stencil-inlining --cse --canonicalize --stencil-shape-inference --stencil-storage-materialization --stencil-shape-inference --stencil-combine-to-ifelse --cse \
            --canonicalize --convert-stencil-to-std --cse --parallel-loop-tiling=parallel-loop-tile-sizes=128,1,1 \
            --canonicalize --test-gpu-greedy-parallel-loop-mapping --convert-parallel-loops-to-gpu --lower-affine \
            --convert-scf-to-std --gpu-kernel-outlining --cse \
            --canonicalize --stencil-kernel-to-cubin --cse --canonicalize --mlir-disable-threading " + origin_mlir_path
        with open(lowered_mlir_path, "w") as f:
            if inline and self.inline:
                ret = subprocess.call(cmd1_paras.split(), cwd=self.cwd, stdout=f)
            else:
                ret = subprocess.call(cmd_paras.split(), cwd=self.cwd, stdout=f)

        if ret != 0:
            print("Error: compile_mlir failed in lowering")
            exit(1)
        cmd2 = "mlir-translate --mlir-to-llvmir " + lowered_mlir_path
        with open(bc_path, "w") as f:
            ret = subprocess.call(cmd2.split(), cwd=self.cwd, stdout=f)
        if ret != 0:
            print("Error: compile_mlir failed in translation")
            exit(1)
        cmd3 = "llc -O3 " + bc_path + " -o " + assembly_path
        ret = subprocess.call(cmd3.split(), cwd=self.cwd)
        if ret != 0:
            print("Error: compile_mlir failed in llc")
            exit(1)
        cmd4 = "clang -c " + assembly_path + " -fPIE -o " + object_path
        ret = subprocess.call(cmd4.split(), cwd=self.cwd)
        if ret != 0:
            print("Error: compile_mlir failed in clang")
            exit(1)
    
    def clean(self):
        for file in self.clean_path:
            if os.path.exists(file):
                os.remove(file)
        for mlir in self.mlir_list:
            file = os.path.join(self.cwd,mlir)
            if os.path.exists(file):
                os.remove(file)

    def link(self):
        print("Linking...")
        cmd = f"nvcc --default-stream per-thread  -allow-unsupported-compiler -ccbin clang {self.main_name} " + " ".join(self.object_paths) + " -L/root/new-open-earth/llvm-project/install/lib -lcuda-runtime-wrappers -lcudart -lcuda -o demo"
        ret = subprocess.call(cmd.split(), cwd=self.cwd)
        if ret != 0:
            print("Error: link failed")
            exit(1)

    def run(self):
        print("Running...")
        kernel_name = self.main_name[:-3].split('/')[-1] + "_kernel"
        cmd = f"CUDA_VISIBLE_DEVICES=1 nsys nvprof ./demo | grep {kernel_name} | awk '{{print $4}}' > duration.csv"
        stdout_file = open(os.path.join(self.cwd,"result.txt"),"w")
        stderr_file = open(os.path.join(self.cwd,"error.txt"),"w")
        print(["bash", "-c", cmd])
        ret = subprocess.call(["bash", "-c", cmd], cwd=self.cwd, stdout=stdout_file, stderr=stderr_file)
        stdout_file.close()
        stderr_file.close()
        if ret != 0:
            print("Error: run failed")
            exit(1)

    def get_score(self):
        min_t = 1000000.0
        max_t = 0.0
        sum_t = 0.0
        with open(os.path.join(self.cwd,"error.txt"),"r") as f_e:
            assert len(f_e.read()) == 0


        with open(os.path.join(self.cwd,"result.txt"),"r") as f:
            content = f.read()
            l = re.findall(r"time.*?(\d+\.\d+)", content)
            sum_t = 0.0
            for time in l:
                t = float(time)
                sum_t += t
                min_t = min(t, min_t)
                max_t = max(t, max_t)
            avg_t = sum_t / len(l)
        print((avg_t, max_t, min_t))
        return (avg_t, max_t, min_t)


    def evaluate(self) -> float:
        if os.path.exists(os.path.join(self.cwd, "demo")):
            time.sleep(3) # rest for 3 seconds
            self.run()
        else:
            for mlir in self.mlir_list:
                assert mlir.endswith(".mlir")
                self.compile_mlir(mlir[0:-5])
            self.link()
            self.run()
        r = self.get_score()[0]
        # self.clean()
        return r


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--clean', action='store_true')
    parser.add_argument('--run', action='store_true')
    parser.add_argument('--exec', action='store_true')
    parser.add_argument('--compile', action='store_true')
    args = parser.parse_args()
    if args.compile:
        compile_mlir('fastwaves512_merge2_1')
        compile_mlir('fastwaves512_merge2_2')

    # if args.clean:
    #     clean()
    if args.run:
    #     clean()
        bench_name = os.path.basename(self.cwd)
        compile_mlir('fastwaves512_merge2_1')
        compile_mlir('fastwaves512_merge2_2')
        # link("fastwaves512_merge2")
        link("fastwaves512_merge2")
        run()
        print("done!")
    # if args.exec:
    #     run()
