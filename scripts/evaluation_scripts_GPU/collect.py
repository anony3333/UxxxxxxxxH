import os
import pandas as pd
import json


device = ["A100", "V100"]

dimention = ["2d", "3d"]
shape = ["star", "box"]
radius = [1, 2, 3]

def gen_key(dimention, shape, radius):
    return f"{dimention}{radius}r_{shape}" 


def get_data(postfix=""):
    data = {"A100": {}, "V100": {}}
    for d in device:
        path = f"../../source/data/gpu/{d}"
        for dim in dimention:
            for s in shape:
                for r in radius:
                    df = pd.read_csv(f"{path}/{dim}{r}r_{s}_duration{postfix}.csv")
                    if postfix == "":
                        data[d][gen_key(dim, s, r)] = df
                    else:
                        data[d][gen_key(dim, s, r)] = df.dropna().sort_values(by=["duration(ns)"]).reset_index(drop=True)
    return data

def get_fastest_config(fastest_config, data, device, dimention, shape, radius):
    if dimention == "2d":
        # print(data[device][gen_key(dimention, shape, radius)].iloc[0])
        # 选取"gx","gy","bx","by","inx","iny","shm"
        fastest_config[device][gen_key(dimention, shape, radius)] = data[device][gen_key(dimention, shape, radius)].loc[0, ["gx","gy","bx","by","inx","iny","shm", "duration(ns)"]].to_dict()
    else:
        fastest_config[device][gen_key(dimention, shape, radius)] = data[device][gen_key(dimention, shape, radius)].loc[0, ["gx","gy","gz","bx","by","bz","inx","iny","inz","shm", "duration(ns)"]].to_dict()
    return fastest_config

if __name__ == '__main__':
    data_search = get_data()
    data_base_search = get_data("_specific")
    fastest_config_search = {"A100": {}, "V100": {}}
    fastest_config_base_search = {"A100": {}, "V100": {}}

    fastest = {"A100": {}, "V100": {}}
    for d in device:
        for dim in dimention:
            for s in shape:
                for r in radius:
                    fastest_config_search = get_fastest_config(fastest_config_search, data_search, d, dim, s, r)
                    fastest_config_base_search = get_fastest_config(fastest_config_base_search, data_base_search, d, dim, s, r)
    # print(fastest_config)
    print("=================GET FASTEST CONFIG====================")
    # import pdb; pdb.set_trace()
    for d in device:
        for dim in dimention:
            for s in shape:
                for r in radius:
                    time_search = ("search", fastest_config_search[d][gen_key(dim, s, r)], fastest_config_search[d][gen_key(dim, s, r)]["duration(ns)"])
                    time_base_search = ("base_search", fastest_config_base_search[d][gen_key(dim, s, r)], fastest_config_base_search[d][gen_key(dim, s, r)]["duration(ns)"])
                    fastest_time = min(time_search, time_base_search, key=lambda x: x[2])
                    fastest[d][gen_key(dim, s, r)] = fastest_time
    
    print(fastest)
    json.dump(fastest, open("../../source/data/fastest.json", "w"), indent=4)
    # fastest A100
    json.dump(fastest["A100"], open("../../source/data/fastest_A100.json", "w"), indent=4)
    # fastest V100
    json.dump(fastest["V100"], open("../../source/data/fastest_V100.json", "w"), indent=4)
    """
    for d in device:
        for dim in dimention:
            for s in shape:
                for r in radius:
                    if not exist_case(d, dim, s, r):
                        continue
                    if fastest_config[d][gen_key(dim, s, r)]["shm"] == 0:
                        print(f"{d} {dim} {s} {r}r: {fastest_config[d][gen_key(dim, s, r)]}")

    print("=================USED SHARE MEM====================")
    for d in device:
        for dim in dimention:
            for s in shape:
                for r in radius:
                    if not exist_case(d, dim, s, r):
                        continue
                    if fastest_config[d][gen_key(dim, s, r)]["shm"] == 1:
                        print(f"{d} {dim} {s} {r}r: {fastest_config[d][gen_key(dim, s, r)]}")
    """