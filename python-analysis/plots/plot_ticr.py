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
           r"\textbf{f)}"]

upperletters = [r"\textbf{A}", 
                r"\textbf{B}", 
                r"\textbf{C}", 
                r"\textbf{D}", 
                r"\textbf{E}", 
                r"\textbf{F}"]

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
    fig = plt.figure(figsize=(5.5, 3.5))
    gs = gridspec.GridSpec(2,2)
    ax00 = plt.subplot(gs[0,0])  # n10h2
    ax01 = plt.subplot(gs[0,1])  # n10orange
    ax10 = plt.subplot(gs[1,0])  # n15blue
    ax11 = plt.subplot(gs[1,1])  # n15orange

    axs = [ax00, ax01, ax10, ax11]
    nets = ["n10h2", "n10orange", "n15orange", "n15blue"]
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

        if (i == 0) or (i == 2):
            ax.set_ylabel(r"Percent reject", fontsize=10)  

        if i > 1:
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

    # Add legend at bottom
    gs.tight_layout(fig, rect=[0, 0.1, 1, 0.925])
    fig.suptitle("Percent replicates TICR correctly rejects major tree", fontsize=12)

    gtres = ["True gene trees", "Estimated gene trees"]
    hs = []
    for k in range(len(gtres)):
        h, = ax.plot([1], [1],
                     '-',
                     color=tableau20[k*2],
                     lw=10)
        hs.append(h)

    ax.legend(hs, gtres,
              frameon=False,
              ncol=2,
              fontsize=10.5,
              loc='lower center',
              bbox_to_anchor=(-0.2125, -1.125, 0, 1))

    ## Save plot
    ##gs.tight_layout(fig, rect=[0, 0, 1, 1])
    plt.savefig(output, format='pdf', dpi=300)

# Read and plot data
df = pandas.read_csv("../csvs/data-ticr.csv")
make_figure(df, "figure-ticr.pdf")
