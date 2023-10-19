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
           r"\textbf{g)}"]

# Tableau 20 colors in RGB.    
tableau20 = [(31, 119, 180), (174, 199, 232),
             (255, 127, 14), (255, 187, 120)]

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

def make_figure(df, output):
    fig = plt.figure(figsize=(8.5, 3.5))
    gs = gridspec.GridSpec(2,4)
    ax00 = plt.subplot(gs[0,0])  # n5h2
    ax01 = plt.subplot(gs[0,1])  # n10h2
    ax02 = plt.subplot(gs[0,2])  # n10h1shallow
    ax03 = plt.subplot(gs[0,3])  # LEGEND
    ax10 = plt.subplot(gs[1,0])  # n15h1shallow
    ax11 = plt.subplot(gs[1,1])  # n15h1intermediate
    ax12 = plt.subplot(gs[1,2])  # n15h1deep
    ax13 = plt.subplot(gs[1,3])  # n15h3

    axs = [ax00, ax01, ax02,
           ax10, ax11, ax12, ax13]
    nets = ["n5h2", "n10h2", "n10h1shallow",
            "n15h1shallow", "n15h1intermediate", "n15h1deep", "n15h3"]
    gtres = ["True gene trees", "Estimated gene trees"]
    ngens = [30, 100, 300, 1000, 3000]

    for i, net in enumerate(nets):
        ax = axs[i]
    
        xdf = df[(df["NET"] == net)]

        bw = 0.25

        ys1 = xdf[(xdf["GTRE"] == "true")].PROP.values * 100 
        ys2 = xdf[(xdf["GTRE"] == "estimated")].PROP.values * 100
        xs1 = numpy.arange(len(ys1)) 
        xs2 = [x + 0.25 for x in xs1]

        ax.bar(xs1, ys1, color=tableau20[0], width=bw) 
        ax.bar(xs2, ys2, color=tableau20[2], width=0.25)  

        # Set labels
        ax.set_title(letters[i] + str(" %s" % net),
                    loc="left", x=0.0, y=1.0, fontsize=11)

        if (i == 0) or (i == 3):
            ax.set_ylabel(r"Percent reject", fontsize=10)  

        if i > 2:
            ax.set_xlabel("\# of Gene Trees", fontsize=10)

        xticks = [x + 0.125 for x in xs1]
        ax.set_xticks(xticks, [str(x) for x in ngens])

        yticks = [0, 20, 40, 60, 80, 100]
        ax.set_ylim(0, 100)
        ax.set_yticks(yticks)
        ax.tick_params(axis='x', labelsize=9)
        ax.tick_params(axis='y', labelsize=9)

        # Set plot axis parameters
        #ax.tick_params(axis=u'both', which=u'both',length=0) # removes tiny ticks
        #ax.get_xaxis().tick_bottom() 
        #ax.get_yaxis().tick_left()
        ax.spines["top"].set_visible(False)
        ax.spines["right"].set_visible(False)

    
    gs.tight_layout(fig, rect=[0, 0, 1, 0.925])

    # Add figure title
    fig.suptitle("Percent replicates TICR correctly rejects major tree", fontsize=12)

    # Add legend
    hs = []
    for k in range(len(gtres)):
        h, = ax.plot([1], [1],
                     '-',
                     color=tableau20[k*2],
                     lw=10)
        hs.append(h)

    ax03.legend(hs, gtres,
                frameon=False,
                ncol=1,
                fontsize=10.5,
                loc='center')

    # Remove other plot stuff    
    ax03.spines["top"].set_visible(False)
    ax03.spines["right"].set_visible(False)
    ax03.spines["left"].set_visible(False)
    ax03.spines["bottom"].set_visible(False)
    ax03.tick_params(axis=u'both', which=u'both',length=0)
    ax03.set_yticks([])
    ax03.set_xticks([])

    # Save plot
    plt.savefig(output, format='pdf', dpi=300)

# Read and plot data
df = pandas.read_csv("../csvs/data-ticr.csv")
make_figure(df, "figure-ticr-v2.pdf")
