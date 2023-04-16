import os
import time

import json

result_map = {}

def check_file(file_name, file_path):
    if file_name in os.listdir(file_path):
        return True
    else:
        return False

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
    if not check_file("output", "."):
        return {}
    with open("output", "r") as f:
        try:
            lines = f.readlines()
        except:
            lines = []
        for line in lines:
            if "SPE" in line:
                add_element_to_dict_list(time_dict, "SPE", float(line.split()[3]))
            elif "MPE" in line:
                add_element_to_dict_list(time_dict, "MPE", float(line.split()[3]))
            elif "Failed" in line:
                return {}
    return time_dict

def main():
    global result_map
    cwd = os.getcwd()
    all_test_case = [os.path.join(cwd, x) for x in os.listdir() if os.path.isdir(x)]
    min_time = 100000000
    min_time_folder = ""
    all_case_num = len(all_test_case)
    fail_num = 0
    for case in all_test_case:
        os.chdir(case)
        if check_file("output", case):
            time_dict = get_time()
            if not time_dict:
                fail_num += 1
                os.chdir(cwd)
                continue
            avg_time = sum(time_dict["SPE"]) / len(time_dict["SPE"])
            result_map[os.path.basename(case)] = avg_time
            if avg_time < min_time:
                min_time = avg_time
                min_time_folder = os.path.basename(case)
        else:
            fail_num += 1
        os.chdir(cwd)
    print("min time: ", min_time)
    print("min time folder: ", min_time_folder)
    print("all case num: ", all_case_num)
    print("fail num: ", fail_num)

if __name__ == '__main__':
    all_test_case = ["2d13pt_star","2d49pt_box","2d9pt_box", "3d125pt_box","3d19pt_star","3d343pt_box", "2d25pt_box", "2d5pt_star","2d9pt_star","3d13pt_star","3d27pt_box", "3d7pt_star"]
    top_cwd = os.getcwd()
    for test_case in all_test_case:
        os.chdir(test_case)
        main()
        os.chdir(top_cwd)
    with open("result.json", "w") as f:
        json.dump(result_map, f)
