from test_driver import order, output_csv
import os

default_config_2d = []
default_config_3d = []

def get_info_from_name(test_case_name):
    # test_case_name example: "2d3r_box"
    # return dimention and order
    # 2d3r_box -> 2, 3
    # 3d7r_box -> 3, 7
    dim = int(test_case_name[0])
    order = int(test_case_name[2])
    return dim, order

def get_dsl_name(test_case_name):
    # return the dsl file name in test_case_name folder, dsl name ends with ".dsl"
    for file in os.listdir(test_case_name):
        if file.endswith(".dsl"):
            return file

if __name__ == "__main__":
    output_csv = "duration_specific.csv"
    cwd = os.getcwd()
    for test_case in os.listdir():
        if not os.path.isdir(test_case):
            continue
        case_dim, case_order = get_info_from_name(test_case)
        dsl_name = get_dsl_name(test_case)
        os.chdir(test_case)
        order = case_order

        if case_dim == 2:
            run_2d(default_config_2d, dsl_name, 1)
        elif case_dim == 3:
            run_3d(default_config_3d, dsl_name, 1)

        