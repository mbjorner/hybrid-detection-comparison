import numpy
import pandas
import sys

df_true = pandas.read_csv("MSC.csv")
df_esti = pandas.read_csv("MSC_iqtree.csv")

nets1 = ["n4h1_0.1", "n4h1_0.2", "n4h1_0.3", "n4h1_0.4", "n4h1_0.5", "n4h1_0",
         "n4h1_introg", "n5h2", "n8h3",
         "n10h2", "n10orange", "n10red",
         "n15blue", "n15h3", "n15orange", "n15red",
         "n25h5"]

nets2 = ["n4h1_0.1", "n4h1_0.2", "n4h1_0.3", "n4h1_0.4", "n4h1_0.5", "n4h1_0",
         "n4h1_introg", "n5h2", "n8h3",
         "n10h2", "n10h1shallow", "n10h1deep",
         "n15h1deep", "n15h3", "n15h1shallow", "n15h1intermediate",
         "n25h5"]

ngens = [30, 100, 300, 1000, 3000]
gtres = ["true", "estimated"]


cols = ["NET", "NGEN", "REPL", "GTRE", "PVAL", "RNUL"]
rows = []


# Check data
for net1, net2 in zip(nets1, nets2):
    for gtre in gtres:
        if gtre == "true":
            df = df_true
        else:
            df = df_esti
        for ngen in ngens:
            repls = [ rep for rep in range(1, 31)]
            if (net1 == "n4h1_0.5") and (ngen == 30):
                repls.remove(26)
            for repl in repls:
                xdf = df[(df["network_name"] == net1 + ".net") &
                         (df["gene_trees"] == ngen) &
                         (df["trial_num"] == repl)]
                
                if xdf.shape[0] != 1:
                    print(xdf)
                    sys.exit("Double check %s %s %d %d" % (net1, gtre, ngen, repl))
                else:
                    pval = xdf.TICR_pval.values[0]
                    row = {}
                    row["NET"] = net2
                    row["GTRE"] = gtre
                    row["NGEN"] = ngen
                    row["REPL"] = repl
                    row["PVAL"] = pval
                    if pval < 0.05:
                        row["RNUL"] = 1
                    else:
                        row["RNUL"] = 0
                    rows.append(row)

df = pandas.DataFrame(rows, columns=cols)

# Remove networks with nothing in true and estimated gene trees
remove = []
for net in nets2:
    print("Processing network %s" % net)
    xdf = df[(df["NET"] == net) & (df["NGEN"] == ngen)]
    if numpy.sum(xdf.RNUL.values) == 0:
        sys.stdout.write("Removing network %s\n" % net)
        df = df[(df["NET"] != net)]

# Convert to proportions
cols = ["NET", "NGEN", "GTRE", "PROP"]
rows = []

nets = list(set(df.NET.values))
for net in nets:
    for ngen in ngens:
        for gtre in gtres:
            xdf = df[(df["NET"] == net) &
                     (df["NGEN"] == ngen) &
                     (df["GTRE"] == gtre)]

            n_rnul = numpy.sum(xdf.RNUL.values)
            n_totl = numpy.size(xdf.RNUL.values)

            row = {}
            row["NET"] = net
            row["NGEN"] = ngen
            row["GTRE"] = gtre
            row["PROP"] = float(n_rnul) / n_totl
            rows.append(row)

df = pandas.DataFrame(rows, columns=cols)
df.to_csv("data-ticr.csv",
          sep=',', na_rep="NA",header=True, index=False)
