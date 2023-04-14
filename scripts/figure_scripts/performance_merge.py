import pandas as pd
import matplotlib.pyplot as plt

import numpy as np

csfont = {'family': 'Times New Roman', 'size': 18}
plt.rc('font', **csfont)

DRAW_TYPE = "SW"  # SW or GPU

HEADER = ["MSC", "UHStencil"] if DRAW_TYPE == "SW" else ["OpenEarth", "UHStencil"]


def plot_subfig(data, x, y, ax, x_offset, dimention):
    def get_point_per_second(time, total_point):
        if DRAW_TYPE == "SW":
            return total_point / (time / 1000)
        elif DRAW_TYPE == "GPU":
            return total_point / (time / 1000 / 1000 / 1000)

    colors = [["#6B8E23", "#FF8C00", ],["#6B8E23", "#FF8C00", ], ["#2976bb", "#FF8C00", ]]
    bar0 = ax[x][y].bar(x_offset + 0, get_point_per_second(data[HEADER[0]], get_points_of_case(dimention)), color=colors[x][0], label=HEADER[0], linewidth=1, edgecolor="black")
    bar1 = ax[x][y].bar(x_offset + 1, get_point_per_second(data[HEADER[1]], get_points_of_case(dimention)), color=colors[x][1], label=HEADER[1], linewidth=1, edgecolor="black")
    return [bar0, bar1]


def get_points_of_case(case_name):
    if case_name.startswith("2D"):
        return 4096 * 4096
    elif case_name.startswith("3D"):
        return 256 * 256 * 256


def get_data(df, case, radius):
    case_list = case.split(" ")
    case_list.append("r=" + str(radius))
    key = ",".join(case_list)
    df = df[df["shape"] == key]
    return df


def plot_single_device(device_name, fig, ax, row_num):
    global DRAW_TYPE, HEADER
    if device_name == "SW":
        DRAW_TYPE = "SW"
        HEADER = ["MSC", "UHStencil"]
    elif device_name == "A100" or device_name == "V100":
        DRAW_TYPE = "GPU"
        HEADER = [f"OpenEarth {device_name}", f"UHStencil {device_name}"]
    filename = "../data/UHStencil论文实验数据.xlsx"
    outname = ""
    df = pd.read_excel(filename, sheet_name=DRAW_TYPE)
    cases = ["2D star", "2D box", "3D star", "3D box"]
    radius_list = [1, 2, 3]

    for j, case in enumerate(cases):
        
        for offset, radius in enumerate(radius_list):
            handles = plot_subfig(get_data(df, case, radius), row_num, j, ax, offset * 4, dimention=case.split()[0])
        # titie位置, 修改了整个图的大小之后需要修改
        ax[row_num][j].set_title(case, y=-0.4)
        # xticks 需要调一下
        # x * 4 + 0.5
        ax[row_num][j].set_xticks([0.5, 4.5, 8.5], list(map(lambda x: "r=" + str(x), radius_list)))
        # yticks 需要设置一下
    if device_name == "SW":
        ax[row_num][0].set_ylabel(f"(c) SW26010 \n updated points / s")
    if device_name == "V100":
        ax[row_num][0].set_ylabel(f"(a) V100 \n updated points / s")
    if device_name == "A100":
        ax[row_num][0].set_ylabel(f"(b) A100 \n updated points / s")
    # label位置对齐
    ax[row_num][0].yaxis.set_label_coords(-0.15, 0.5)
    return handles, HEADER

if __name__ == '__main__':
    # 图的大小需要调整一下
    fig, ax = plt.subplots(3, 4, sharey="row", figsize=(19, 3 * 3.5))
    # plt.show()
    all_handles = []
    all_headers = []
    for row_num, device_name in enumerate(["V100", "A100", "SW"]):
        # import pdb; pdb.set_trace()
        handles, headers = plot_single_device(device_name, fig, ax, row_num)
        # 将所有的handles里面的内容都放到all_handles里面
        all_handles.extend(handles)
        all_headers.extend(headers)
    new_handles = []
    new_headers = []
    all_ready_openearth = False
    all_ready_UHStencil = False
    for handle, header in zip(all_handles, all_headers):
        if "OpenEarth" in header and not all_ready_openearth:
            all_ready_openearth = True
            new_handles.append(handle)
            new_headers.append("OpenEarth")
        elif "UHStencil" in header and not all_ready_UHStencil:
            all_ready_UHStencil = True
            new_handles.append(handle)
            new_headers.append("UHStencil")
        elif "MSC" in header:
            new_handles.append(handle)
            new_headers.append("MSC")
        # handle[0].set_label(header)
    # 交换new_handles[0]和new_handles[1]的位置
    new_handles[0], new_handles[1] = new_handles[1], new_handles[0]
    new_headers[0], new_headers[1] = new_headers[1], new_headers[0]
    fig.legend(new_handles, new_headers, loc="upper center", ncol=3, frameon=False,bbox_to_anchor=(0.5, 0.9))
    plt.subplots_adjust(hspace=0.5, top=0.8, bottom=0.2)
    # plt.show()
    plt.savefig("../../figure/performance_merge.pdf", bbox_inches='tight')
