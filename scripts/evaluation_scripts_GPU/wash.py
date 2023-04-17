import csv
import os

def repair(csv_name):
    if "2d" in csv_name:
        num_columns = 9
    elif "3d" in csv_name:
        num_columns = 12
    with open(csv_name, "r") as f:
        lines = f.read()
    need_repair = False
    for line in lines.split("\n"):
        columns = line.split(",")
        if len(columns) > num_columns:
            need_repair = True
            break
    if need_repair:
        os.rename(csv_name, csv_name + ".bak")
        with open(csv_name, "w") as f:
            for line in lines.split("\n"):
                columns = line.split(",")
                if len(columns) <= num_columns:
                    f.write(line + "\n")
                else:
                    f.write(",".join(columns[:num_columns - 1]) + "\n")
                    f.write(",".join(columns[num_columns - 1:]) + "\n")


if __name__ == "__main__":
    for csv in os.listdir("."):
        if csv.endswith(".csv"):
            repair(csv)