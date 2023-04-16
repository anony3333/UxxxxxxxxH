import os
import os.path
from change import gen_mlir_file
from maingen import GenMain, Kernel
from run import Evaluate

import shutil
from sys import argv


mesh_size_list = [512]
halo_width = 4
mlir_file_name = [x for x in os.listdir() if x.endswith(".mlir")][0]
# mlir_file_name = "fastwaves.mlir"
origin_mesh_width = 64
origin_halo_width = 4

# 自动生成不同大小的mlir以及cu源文件


def gen_mlir(mesh_size, halo_width):
    return gen_mlir_file(mlir_file_name, origin_mesh_width, origin_halo_width, mesh_size, halo_width)


def gen_folder(file_name):
    pwd = os.getcwd()
    path = os.path.join(pwd, file_name)
    if os.path.exists(path):
        shutil.rmtree(path)

    os.mkdir(path)
    return path


def get_folder_path(mesh_size):
    pwd = os.getcwd()
    new_file_name = mlir_file_name[0:-5] + str(mesh_size)
    path = os.path.join(pwd, new_file_name)
    return path


def gen_source_files():
    for mesh_size in mesh_size_list:
        content = gen_mlir(mesh_size, halo_width)
        new_file_name = mlir_file_name[0:-5] + str(mesh_size)
        folder_path = gen_folder(new_file_name)
        with open(os.path.join(folder_path, new_file_name + ".mlir"), "w") as f:
            print(content, file=f)


def copy_utils():
    for mesh_size in mesh_size_list:

        shutil.copy(os.path.join(os.getcwd(), 'util.h'),
                    get_folder_path(mesh_size))


kernel_variables = {'all_variables': {'arg0': 3, 'arg1': 3},
             'in_variables': set(['arg0']),
             'out_variables': set(['arg1']), 'useless_variables': set(), 'mid_variables': set()}

var_list = [f'arg{i}' for i in range(0, 2)]
stream_list = None

def gen_main():
    def gen_single_main(mesh_size, halo_width):
        new_file_name = mlir_file_name[0:-5] + str(mesh_size)
        Kernel_list = [Kernel(new_file_name, var_list)]
        tmp_list = [new_file_name]
        streamlist = [tmp_list]
        with open(os.path.join(get_folder_path(mesh_size), new_file_name + ".cu"), "w") as f:

            GenMain(mesh_size, halo_width, kernel_variables, Kernel_list, streamlist).gen(f)
    for mesh_size in mesh_size_list:
        gen_single_main(mesh_size, halo_width)

def evaluate(step, inline):
    pwd = os.getcwd()
    result_file = open(os.path.join(pwd, "result.txt"), 'w')
    def evaluate_single(mesh_size):
        new_file_name = mlir_file_name[0:-5] + str(mesh_size)
        print(new_file_name, file=result_file)
        main_name = os.path.join(get_folder_path(mesh_size), new_file_name + ".cu")
        e = Evaluate(get_folder_path(mesh_size), main_name, [new_file_name + ".mlir"], inline)

        for _ in range(step):
            r = e.evaluate()
            print(r, file=result_file)
        print("---------------", file=result_file)
        e.clean()
    for mesh_size in mesh_size_list:
        evaluate_single(mesh_size)
    result_file.close()

if __name__ == '__main__':
    inline = False
    assert len(argv) >= 3
    inline = int(argv[1])
    step = int(argv[2])
    gen_source_files()
    copy_utils()
    gen_main()
    evaluate(1, inline)