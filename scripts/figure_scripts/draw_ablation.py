
import pandas as pd
import matplotlib.pyplot as plt

csfont = {'family': 'Times New Roman', 'size': 18}
plt.rc('font', **csfont)

Header = ["baseline", "+parallelism", "+memory"]

def plot_subfig(data, x, ax, x_offset):
    colors = ["#EEE8AA", "#778899", "#FFD700"]

    bar0 = ax[x].bar(x_offset, data[Header[0]], color=colors[0], label=Header[0],width = 0.3, linewidth=1, edgecolor="black")
    bar1 = ax[x].bar(x_offset * 2, data[Header[1]], color=colors[1], label=Header[1],width = 0.3, linewidth=1, edgecolor="black")
    bar2 = ax[x].bar(x_offset * 3, data[Header[2]], color=colors[2], label=Header[2],width = 0.3, linewidth=1, edgecolor="black")
    scale= 1e8 if x!=2 else 1e6
    ax[x].text(x_offset+0.05, data[Header[0]], '{:.2g}'.format(data[Header[0]]/scale), ha="center", va="bottom")
    if x==2:
        ax[x].text(x_offset * 2+0.05, data[Header[1]], '{:.2g}'.format(data[Header[1]]/scale), ha="center", va="bottom")
    # ax[x].text(x_offset * 3, data[Header[2]], '{:.2g}'.format(data[Header[2]]), ha="center", va="bottom")
    ax[x].set_ylim(0, 1.1 * max(data[Header[0]], data[Header[1]], data[Header[2]]))
    return [bar0, bar1, bar2]



if __name__ == "__main__":

    fig, ax = plt.subplots(1, 3, sharex="col", figsize=(16, 2.5))

    devices = ["V100", "A100","SW26010"]
    # Header = ["single core", "Parallel", "Fine-Tune"]
    data = \
    {
        "SW26010": 
        {
            Header[0]: 64006739.52148616,
            Header[1]: 1064592.776,
            Header[2]: 10437.854,
        },
        "V100":
        {
            Header[0]: 595834979226.0,
            Header[1]: 61114272.5,
            Header[2]: 32963085.8,
        },
        "A100":
        {
            Header[0]: 587013512585.8,
            Header[1]: 38960367.5,
            Header[2]: 21153388.5,
        }
    }
    data_sw = data["SW26010"]
    data_v100 = data["V100"]
    data_a100 = data["A100"]
    for k, v in data_sw.items():
        data_sw[k] = 256 * 256 * 256 / (v / 1000)
    for k, v in data_v100.items():
        data_v100[k] = 256 * 256 * 256 / (v / 1000 / 1000/ 1000)
    for k, v in data_a100.items():
        data_a100[k] = 256 * 256 * 256 / (v / 1000 / 1000/ 1000)

    for i, device in enumerate(devices):
        handles = plot_subfig(data[device], i, ax, 1)

        # ax[i].set_yscale("log")
        ax[i].set_title(device)
        ax[i].set_xticks([1, 2, 3], Header)

    ax[0].set_ylabel("updated points / s")
    plt.subplots_adjust(wspace=0.3)

    # ax[0].set_ylim(1e+2, 1e7)
    # ax[1].set_ylim(1e+3, 3e9)
    # ax[2].set_ylim(1e+3, 3e9)


    # fig.legend(handles, Header, loc="upper center", ncol=3, frameon=False,bbox_to_anchor=(0.5,1.05))
    # plt.show()
    plt.savefig(f"../../figure/ablation_3d3r.pdf", bbox_inches='tight')