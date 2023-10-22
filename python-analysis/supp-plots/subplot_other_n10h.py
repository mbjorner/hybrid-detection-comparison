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

tableau20 = [(227, 119, 194), (247, 182, 210),
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
    counter = 0

    fig = plt.figure(figsize=(8, 5))
    gs = gridspec.GridSpec(3,4)
    ax00 = plt.subplot(gs[0,0])
    ax01 = plt.subplot(gs[0,1])
    ax02 = plt.subplot(gs[0,2])
    ax03 = plt.subplot(gs[0,3])

    ax10 = plt.subplot(gs[1,0])
    ax11 = plt.subplot(gs[1,1])
    ax12 = plt.subplot(gs[1,2])
    ax13 = plt.subplot(gs[1,3])

    ax20 = plt.subplot(gs[2,0])
    ax21 = plt.subplot(gs[2,1])
    ax22 = plt.subplot(gs[2,2])
    ax23 = plt.subplot(gs[2,3])

    # MSCquartets (true vs estimated)
    # HyDe
    # D and Dp (because one is adding BBAA to denominator)
    # D3

    axs = [[ax00, ax00, ax01, ax02, ax02, ax03],
           [ax10, ax10, ax11, ax12, ax12, ax13],
           [ax20, ax20, ax21, ax22, ax22, ax23]]
    nets = ["n10h2", "n10h1shallow", "n10h1deep"]
    if bon:
        mets = ["precision_bon", "recall_bon", "fpr_bon", "whr_bon"]
        output = output + "_bon.pdf"
    else:
        mets = ["precision", "recall", "fpr", "whr"]
        output = output + ".pdf"
    vmets = ["Precision", "Recall", "FP Rate", "Wrong Hybrid Rate"]
    ngens = numpy.array([30, 100, 300, 1000, 3000, 10000])
    names = ["MSCquartets", "MSCquartets", "HyDe", "D and Dp", "D and Dp", "D3"]
    mthds = ["MSCquartets-true", "MSCquartets-estimated", "HyDe", "D", "Dp", "D3"]

    for i, net in enumerate(nets):
        for j, mthd in enumerate(mthds):
            ax = axs[i][j]
            xdf = df[(df["NET"] == net) & (df["MTHD"] == mthd)]
            
            

            for k, met in enumerate(mets):
                ys = xdf[met + "_mean"].values #[:-1]
                es = xdf[met + "_sdev"].values #[:-1]
                # es = xdf[met + "_serr"].values #[:-1]

                keep = ~numpy.isnan(ys)
                xs = ngens[keep]
                ys = ys[keep]
                es = es[keep]

                if (j == 0) or (j == 3):
                    ax.plot(xs, ys, '.--', color=tableau20[k*2], lw=1)
                    #ax.errorbar(xs, ys, yerr=es,
                    #            color=tableau20[k*2])

                    if j == 0:
                        labels = ["true", "estimated"]
                    else:
                        labels = ["D", "Dp"]

                    if i == 0:
                        h1, = ax.plot([1], [1], '--', color='k', lw=1)
                        h2, = ax.plot([1], [1], '-', color='k', lw=1)

                        ax.legend([h1, h2],
                                  labels, 
                                  frameon=False,
                                  ncol=1,
                                  fontsize=8,
                                  loc='upper right')

                else:
                    ax.plot(xs, ys, '.-', color=tableau20[k*2], lw=1)
                    #ax.errorbar(xs, ys, yerr=es,
                    #            color=tableau20[k*2])

            # Add letters
            if (j != 0) and (j != 3):
                ax.text(0.05, 1.125, letters[counter], fontsize=10, 
                        horizontalalignment='center',
                        verticalalignment='center',
                        transform=ax.transAxes)
                counter += 1

            # Set labels
            if i == 0:
                ax.set_title(names[j],
                             loc="center", x=0.5, y=1.25,
                             fontsize=13)            

            if j == 0:
                ax.set_ylabel(str("%s" % net), fontsize=11)

            if i > 1:
                ax.set_xlabel("\# of Loci", fontsize=11)

            ytick_min = 0.0
            ytick_max = 1.0
            diff = ytick_max - ytick_min
            ymin = ytick_min - diff * 0.05
            ymax = ytick_max + diff * 0.05
            yticks = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
            ax.set_ylim(ymin, ymax)
            ax.set_yticks(yticks)

            if j < 2:
                ax.set_xticks([0, 1000, 3000])
            else:
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
    for k in range(len(vmets)):
        h, = ax21.plot([1], [1],
                     '-',
                     color=tableau20[k*2],
                     lw=10)
        hs.append(h)

    ax21.legend(hs, vmets,
              frameon=False,
              ncol=4,
              fontsize=10.5,
              loc='lower center',
              bbox_to_anchor=(1.75, -1.25, 0, 1))

    if bon:
        ax20.text(-0.125, -0.85, r"Threshold:", fontsize=10, 
                  horizontalalignment='left',
                  verticalalignment='center',
                  transform=ax20.transAxes)
        ax20.text(-0.125, -1.05, r"$\alpha < 0.05$ / \# of tests", fontsize=10, 
                  horizontalalignment='left',
                  verticalalignment='center',
                  transform=ax20.transAxes)
    else:
        ax20.text(-0.125, -0.85, r"Threshold:", fontsize=10, 
                  horizontalalignment='left',
                  verticalalignment='center',
                  transform=ax20.transAxes)
        ax20.text(-0.125, -1.05, r"$\alpha < 0.05$", fontsize=10, 
                  horizontalalignment='left',
                  verticalalignment='center',
                  transform=ax20.transAxes)

    ## Save plot
    ##gs.tight_layout(fig, rect=[0, 0, 1, 1])
    plt.savefig(output, format='pdf', dpi=300)

# Read and plot data
df = pandas.read_csv("../csvs/data-other-summary.csv")
make_figure(df, "supp-figure-other-n10h", bon=False)
make_figure(df, "supp-figure-other-n10h", bon=True)

