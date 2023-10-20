import numpy
import pandas
import sys

# Note: need to add number of replicates into plot because NA's

df_true = pandas.read_csv("MSC.csv")
df_esti = pandas.read_csv("MSC_iqtree.csv")
df_site = pandas.read_csv("HyDe_D_Dp_D3.csv")

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
ngens = [30, 100, 300, 1000, 3000, 10000]
gtres = ["true", "estimated"]
mthds = ["MSCquartets-true", "MSCquartets-estimated", "HyDe", "D", "Dp", "D3"]

# Check and combine data
cols = ["NET", "NGEN", "REPL", "MTHD",
        "precision", "precision_bon",
        "recall", "recall_bon",
        "fpr", "fpr_bon",
        "whr", "whr_bon"]
rows = []

# MSCquartets
for net1, net2 in zip(nets1, nets2):
    for gtre in gtres:
        if gtre == "true":
            df = df_true
        else:
            df = df_esti
        for ngen in ngens:
            repls = [rep for rep in range(1, 31)]
            if (net1 == "n4h1_0.5") and (ngen == 30):
                repls.remove(26)
            elif (net1 == "n15h3") and (ngen == 30):
                # Present in this data frame but removing to restrict all methods to same replicates
                repls.remove(13)

            for repl in repls:
                row = {}
                row["NET"] = net2
                row["NGEN"] = ngen
                row["REPL"] = repl
                row["MTHD"] = "MSCquartets-" + gtre
                row["precision"] = numpy.nan
                row["precision_bon"] = numpy.nan
                row["recall"] = numpy.nan
                row["recall_bon"] = numpy.nan
                row["fpr"] = numpy.nan
                row["fpr_bon"] = numpy.nan
                row["whr"] = numpy.nan
                row["wrh_bon"] = numpy.nan

                if ngen == 10000:
                    rows.append(row)
                    continue

                xdf = df[(df["network_name"] == net1 + ".net") &
                         (df["gene_trees"] == ngen) &
                         (df["trial_num"] == repl)]

                if xdf.shape[0] != 1:
                    print(xdf)
                    sys.exit("Double check MSCquartets - %s %s %d %d " % (net1, gtre, ngen, repl))
                
                TP = xdf.TP.values[0]
                TN = xdf.TN.values[0]
                FP = xdf.FP.values[0]
                FN = xdf.FN.values[0]
                TP_bon = xdf.TP_bon.values[0]
                TN_bon = xdf.TN_bon.values[0]
                FP_bon = xdf.FP_bon.values[0]
                FN_bon = xdf.FN_bon.values[0]

                if TP + FP > 0:
                    row["precision"] =  TP / (TP + FP)
                if TP_bon + FP_bon > 0:
                    row["precision_bon"] =  TP_bon / (TP_bon + FP_bon)
                if TP + FN > 0:
                    row["recall"] = TP / (TP + FN)
                if TP_bon + FN_bon > 0:
                    row["recall_bon"] = TP_bon / (TP_bon + FN_bon)
                if FP + TN > 0:
                    row["fpr"] = FP / (FP + TN)
                if FP_bon + TN_bon > 0:
                    row["fpr_bon"] = FP_bon / (FP_bon + TN_bon)

                rows.append(row)

# Site-based methods data
for net1, net2 in zip(nets1, nets2):
    for ngen in ngens:
        repls = [rep for rep in range(1, 31)]
        if (net1 == "n4h1_0.5") and (ngen == 30):
            # Present in this data frame but removing to restrict all methods to same replicates
            repls.remove(26)
        elif (net1 == "n15h3") and (ngen == 30):
            repls.remove(13)

        for repl in repls:
                xdf = df_site[(df_site["network_name"] == net1 + ".net") &
                              (df_site["gene_trees"] == ngen) &
                              (df_site["trial_num"] == repl)]

                if xdf.shape[0] != 1:
                    print(xdf)
                    sys.exit("Double check site methods - %s %d %d" % (net1, ngen, repl))

                for mthd in mthds[2:]:
                    row = {}
                    row["NET"] = net2
                    row["NGEN"] = ngen
                    row["REPL"] = repl
                    row["MTHD"] = mthd
                    row["precision"] = numpy.nan
                    row["precision_bon"] = numpy.nan
                    row["recall"] = numpy.nan
                    row["recall_bon"] = numpy.nan
                    row["fpr"] = numpy.nan
                    row["fpr_bon"] = numpy.nan
                    row["wrong_hybrid"] = numpy.nan
                    row["wrong_hybrid_bon"] = numpy.nan

                    TP = xdf["TP_" + mthd].values[0]
                    TN = xdf["TN_" + mthd].values[0]
                    FP = xdf["FP_" + mthd].values[0]
                    FN = xdf["FN_" + mthd].values[0]
                    TP_bon = xdf["TP_" + mthd + "bon"].values[0]
                    TN_bon = xdf["TN_" + mthd + "bon"].values[0]
                    FP_bon = xdf["FP_" + mthd + "bon"].values[0]
                    FN_bon = xdf["FN_" + mthd + "bon"].values[0]

                    if TP + FP > 0:
                        row["precision"] =  TP / (TP + FP)
                    if TP_bon + FP_bon > 0:
                        row["precision_bon"] =  TP_bon / (TP_bon + FP_bon)
                    if TP + FN > 0:
                        row["recall"] = TP / (TP + FN)
                    if TP_bon + FN_bon > 0:
                        row["recall_bon"] = TP_bon / (TP_bon + FN_bon)
                    if FP + TN > 0:
                        row["fpr"] = FP / (FP + TN)
                    if FP_bon + TN_bon > 0:
                        row["fpr_bon"] = FP_bon / (FP_bon + TN_bon)

                    if mthd == "HyDe":
                        WH = xdf["WC_" + mthd].values[0]
                        WH_bon = xdf["WC_" + mthd + "bon"].values[0]

                        if (WH + TP + FP) > 0:
                            row["whr"] = WH / (WH + TP + FP)
                        if (WH_bon + TP_bon + FP_bon) > 0:
                            row["whr_bon"] = WH_bon / (WH_bon + TP_bon + FP_bon)

                    rows.append(row)

df = pandas.DataFrame(rows, columns=cols)

# Save data frame
df.to_csv("data-other.csv",
          sep=',', na_rep="NA",header=True, index=False)
