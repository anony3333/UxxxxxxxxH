from os import system as cmd
import os
import time
import multiprocessing


# here is the code that MSC can run
#stencils_2d = ["2d9pt_star", "2d9pt_box", "2d121pt_box", "2d169pt_box"]
stencils_2d = []
stencils_3d = ["3d7pt_star", "3d13pt_star", "3d25pt_star", "3d31pt_star"]
#stencils_3d = ["3d25pt_star", "3d31pt_star"]
stencils_3d = ["3d13pt_star"]
stencils = stencils_3d + stencils_2d

tile_size_dict = {"2d9pt_star":[32,64], "2d9pt_box":[32,64], 
                  "2d121pt_box":[16,32], "2d169pt_box":[16,32],
                  "3d7pt_star":[2,8,64], "3d13pt_star":[2,8,64], 
                  "3d25pt_star":[2,4,32], "3d31pt_star":[2,4,32] }

UTIL_PATH = "/home/export/online3/cess/jzh/UHStencil/utils"
MAKEFILE_PATH = "/home/export/online3/cess/jzh/UHStencil/Makefile"
DRIVER_PATH = ""

def check_file(file_name, file_path):
    if file_name in os.listdir(file_path):
        return True
    else:
        return False

def link_for_makefile_and_util():
    assert DRIVER_PATH
    driver_name = os.path.basename(DRIVER_PATH)
    if not check_file(driver_name, "."):
        cmd("ln -s %s %s" % (DRIVER_PATH, driver_name))
    if not check_file("utils", "."):
        cmd("ln -s %s %s" % (UTIL_PATH, "utils"))
    if not check_file("Makefile", "."):
        cmd("ln -s %s %s" % (MAKEFILE_PATH, "Makefile"))

# return a dict, key is SPE or MPE, value is the time list
def test_single_uh_stencil(test_time = 1): # single test case, now cwd is in the stencil dir
    def add_element_to_dict_list(dict_list, key, value):
        if key in dict_list:
            dict_list[key].append(value)
        else:
            dict_list[key] = [value]

    def get_time():
        # the time is in file 'output' and format is like this:
        # SPE elapsed Time: 518.351000 (ms) 
        # MPE elapsed Time: 10917.267000 (ms)
        time_dict = {}
        with open("output", "r") as f:
            lines = f.readlines()
            for line in lines:
                if "SPE" in line:
                    add_element_to_dict_list(time_dict, "SPE", float(line.split()[3]))
                elif "MPE" in line:
                    add_element_to_dict_list(time_dict, "MPE", float(line.split()[3]))
        return time_dict
    cmd("make clean")
    #  bsub -I -b -q q_sw_share -n 1 -cgsp 64 -share_size 2048 -o output ./stencilExe
    for _ in range(test_time):
        cmd("make run")

def test(bench_kind, target, num_threads, cases, config, path_out, num_mpi, out_file):
    pass

def parallel_main():
    # 创建线程池
    # 将test_single_uh_stencil函数放入线程池
    pool = Pool(4)
    # 定义callback函数
    min_time = 100000
    min_time_folder = ""
    def callback_func(time_dict):
        # 对min_time和min_time_folder上进程锁
        avg_time = sum(time_dict["SPE"]) / len(time_dict["SPE"])
        if avg_time < min_time:
            min_time = avg_time
            min_time_folder = dir

    # 将test_single_uh_stencil函数放入进程池
    for stencil in stencils:
        pool.apply_async(test_single_uh_stencil, (stencil,))

def test_one(case_folder):
    os.chdir(case_folder)
    link_for_makefile_and_util() # link Makefile and utils
    test_single_uh_stencil()

def main():
    global DRIVER_PATH
    cwd = os.getcwd()
    stencil_min_time_dict = {}
    stencil_shape = os.path.basename(cwd)
    DRIVER_PATH = [os.path.join(cwd, x) for x in os.listdir() if ".c" in x][0]
    # define a min time and its folder name
    
    # min_time = 100000
    # min_time_folder = ""
    pool = multiprocessing.Pool(32)
    all_test_case = [os.path.join(cwd, x) for x in os.listdir() if os.path.isdir(x)]
    pool.map(test_one, all_test_case)
    pool.close()
    # for dir in os.listdir(): # top level dir
    #     if os.path.isdir(dir):
    #         os.chdir(dir)
    #         link_for_makefile_and_util() # link Makefile and utils
    #         time_dict = test_single_uh_stencil()
    #         # assert len(time_dict["SPE"]) == len(time_dict["MPE"])
    #         avg_time = sum(time_dict["SPE"]) / len(time_dict["SPE"])
    #         if avg_time < min_time:
    #             min_time = avg_time
    #             min_time_folder = dir
    #         os.chdir(cwd)
    # stencil_min_time_dict[stencil_shape] = (min_time, min_time_folder)

if __name__ == "__main__":
    main()