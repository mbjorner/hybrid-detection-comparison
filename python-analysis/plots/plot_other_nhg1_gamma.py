import numpy
import pandas
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
from matplotlib import rc
import sys

plt.rc('text', usetex=True)
plt.rc('text.latex', preamble=r'\usepackage{helvet} \usepackage{sfmath}')

letters = [r"\textbf{a)}", 
           r"\textbf{b)}", 
           r"\textbf{c)}", 
           r"\textbf{d)}", 
           r"\textbf{e)}", 
           r"\textbf{f)}",
           r"\textbf{g)}",
           r"\textbf{h)}",
           r"\textbf{i)}",
           r"\textbf{j)}",
           r"\textbf{k)}",
           r"\textbf{l)}",
           r"\textbf{m)}",
           r"\textbf{n)}",
           r"\textbf{o)}"]

# Tableau 20 colors in RGB.    
tableau20 = [(31, 119, 180), (174, 199, 232),
             (255, 127, 14), (255, 187, 120),
             (44, 160, 44), (152, 223, 138),
             (214, 39, 40), (255, 152, 150), 
             (148, 103, 189), (197, 176, 213),
             (140, 86, 75), (196, 156, 148), 
             (227, 119, 194), (247, 182, 210),
             (127, 127, 127), (199, 199, 199), 
             (188, 189, 34), (219, 219, 141),
             (23, 190, 207), (158, 218, 229)]

# Dark blue - (31, 119, 180), (174, 199, 232),
# Orange - (255, 127, 14), (255, 187, 120),
# Green - (44, 160, 44), (152, 223, 138),
# Red - (214, 39, 40), (255, 152, 150), 
# Purple - (148, 103, 189), (197, 176, 213),
# Brown - (140, 86, 75), (196, 156, 148), 
# Pink - (227, 119, 194), (247, 182, 210),
# Gray - (127, 127, 127), (199, 199, 199), 
# Yellow - (188, 189, 34), (219, 219, 141),
# Light blue - (23, 190, 207), (158, 218, 229)

# Map RGB values to the [0, 1]
for i in range(len(tableau20)):
    r, g, b = tableau20[i]
    tableau20[i] = (r / 255., g / 255., b / 255.)

def make_figure(df, output, bon=False):
    fig = plt.figure(figsize=(12, 6))
    gs = gridspec.GridSpec(4,6)
    ax00 = plt.subplot(gs[0,0])
    ax01 = plt.subplot(gs[0,1])
    ax02 = plt.subplot(gs[0,2])
    ax03 = plt.subplot(gs[0,3])
    ax04 = plt.subplot(gs[0,4])
    ax05 = plt.subplot(gs[0,5])

    ax10 = plt.subplot(gs[1,0])
    ax11 = plt.subplot(gs[1,1])
    ax12 = plt.subplot(gs[1,2])
    ax13 = plt.subplot(gs[1,3])
    ax14 = plt.subplot(gs[1,4])
    ax15 = plt.subplot(gs[1,5])

    ax20 = plt.subplot(gs[2,0])
    ax21 = plt.subplot(gs[2,1])
    ax22 = plt.subplot(gs[2,2])
    ax23 = plt.subplot(gs[2,3])
    ax24 = plt.subplot(gs[2,4])
    ax25 = plt.subplot(gs[2,5])

    ax30 = plt.subplot(gs[3,0])
    ax31 = plt.subplot(gs[3,1])
    ax32 = plt.subplot(gs[3,2])
    ax33 = plt.subplot(gs[3,3])
    ax34 = plt.subplot(gs[3,4])
    ax35 = plt.subplot(gs[3,5])

    axs = [[ax00, ax01, ax02, ax03, ax04, ax05], 
           [ax10, ax11, ax12, ax13, ax14, ax15],
           [ax20, ax21, ax22, ax23, ax24, ax25],
           [ax30, ax31, ax32, ax33, ax34, ax35]]
    nets = ["n4h1_0", "n4h1_0.1", "n4h1_0.2", "n4h1_0.3", "n4h1_0.4", "n4h1_0.5"]
    nams = [r"n4h1 $\gamma=0.0$",
            r"n4h1 $\gamma=0.1$",
            r"n4h1 $\gamma=0.2$",
            r"n4h1 $\gamma=0.3$",
            r"n4h1 $\gamma=0.4$",
            r"n4h1 $\gamma=0.5$"]
    if bon:
        mets = ["precision_bon", "recall_bon", "fpr_bon", "whr_bon"]
        output = output + "_bon.pdf"
    else:
        mets = ["precision", "recall", "fpr", "whr"]
        output = output + ".pdf"
    ngens = numpy.array([30, 100, 300, 1000, 3000, 10000])
    # ngens = ngens[:-1]
    mthds = ["MSCquartets-true", "MSCquartets-estimated", "HyDe", "D", "Dp", "D3"]
    names = ["MSCquartets (true gene trees)", "MSCquartets (estimated gene trees)", "HyDe", "D", "Dp", "D3"]

    for i, met in enumerate(mets):
        for j, net in enumerate(nets):
            ax = axs[i][j]
            for k, mthd in enumerate(mthds):
                xdf = df[(df["NET"] == net) & (df["MTHD"] == mthd)]

                ys = xdf[met + "_mean"].values #[:-1]
                es = xdf[met + "_sdev"].values #[:-1]
                # es = xdf[met + "_serr"].values #[:-1]

                keep = ~numpy.isnan(ys)
                xs = ngens[keep]
                ys = ys[keep]
                es = es[keep]

                ax.plot(xs, ys, '.-', color=tableau20[k*2])
                ax.errorbar(xs, ys, yerr=es,
                            color=tableau20[k*2])
                #ax.fill_between(xs, ys - es, ys + es, 
                #                color=tableau20[2*k], alpha=0.25)

            # Set labels
            if i == 0:
                ax.set_title(nams[j],
                             loc="center", x=0.5, y=1.25,
                             fontsize=13)

            ax.text(0.05, 1.125, letters[i*3 + j], fontsize=10, 
                    horizontalalignment='center',
                    verticalalignment='center',
                    transform=ax.transAxes)

            if (i == 0) and (j == 0):
                ax.set_ylabel(r"Precision", fontsize=11)
            elif (i == 1) and (j == 0):
                ax.set_ylabel(r"Recall", fontsize=11)
            elif (i == 2) and (j == 0):
                ax.set_ylabel(r"FP Rate", fontsize=11)
            elif (i == 3) and (j == 0):
                ax.set_ylabel(r"Wrong Hybrid Rate", fontsize=11)

            if i > 2:
                ax.set_xlabel("\# of Loci", fontsize=11)

            if bon:
                if i == 0:
                    ytick_min = 0.0
                    ytick_max = 1.0
                    diff = ytick_max - ytick_min
                    ymin = ytick_min - diff * 0.05
                    ymax = ytick_max + diff * 0.05
                    yticks = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
                elif i == 1:
                    ytick_min = 0.0
                    ytick_max = 1.0
                    diff = ytick_max - ytick_min
                    ymin = ytick_min - diff * 0.05
                    ymax = ytick_max + diff * 0.05
                    yticks = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
                elif i == 2:
                    ytick_min = 0.0
                    ytick_max = 0.5
                    diff = ytick_max - ytick_min
                    ymin = ytick_min - diff * 0.05
                    ymax = ytick_max + diff * 0.05
                    yticks = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5]
                elif i == 3:
                    ytick_min = 0.0
                    ytick_max = 0.2
                    diff = ytick_max - ytick_min
                    ymin = ytick_min - diff * 0.05
                    ymax = ytick_max + diff * 0.05
                    yticks = [0.0, 0.1, 0.2]

                ax.set_ylim(ymin, ymax)
                ax.set_yticks(yticks)
                ax.set_xticks([0, 3000, 10000])
                ax.tick_params(axis='x', labelsize=9)
                ax.tick_params(axis='y', labelsize=9)

            # Set plot axis parameters
            ax.tick_params(axis=u'both', which=u'both',length=0) # removes tiny ticks
            ax.get_xaxis().tick_bottom() 
            ax.get_yaxis().tick_left()
            ax.spines["top"].set_visible(False)
            ax.spines["right"].set_visible(False)

    # Add legend at bottom
    gs.tight_layout(fig, rect=[0, 0.1, 1, 1])

    hs = []
    for k in range(len(mthds)):
        h, = ax32.plot([1], [1], '-',
                       color=tableau20[k*2],
                       lw=10)
        hs.append(h)

    ax32.legend(hs, names,
                frameon=False,
                ncol=6,
                fontsize=10.5,
                loc='lower center',
                bbox_to_anchor=(1.1, -1.5, 0, 1))

    ## Save plot
    ##gs.tight_layout(fig, rect=[0, 0, 1, 1])
    plt.savefig(output, format='pdf', dpi=300)

# Read and plot data
df = pandas.read_csv("../csvs/data-other-summary.csv")
make_figure(df, "figure-other-n4h1-gamma", bon=False)
make_figure(df, "figure-other-n4h1-gamma", bon=True)

