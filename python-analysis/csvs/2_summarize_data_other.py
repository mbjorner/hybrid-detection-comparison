import numpy
import pandas
import sys

# Note: need to add number of replicates into plot because NA's

df_all = pandas.read_csv("data-other.csv")

nets = ["n4h1_0.1", "n4h1_0.2", "n4h1_0.3", "n4h1_0.4", "n4h1_0.5", "n4h1_0",
        "n4h1_introg", "n5h2", "n8h3",
        "n10h2", "n10h1shallow", "n10h1deep",
        "n15h1deep", "n15h3", "n15h1shallow", "n15h1intermediate",
        "n25h5"]
ngens = [30, 100, 300, 1000, 3000, 10000]
mthds = ["MSCquartets-true", "MSCquartets-estimated", "HyDe", "D", "Dp", "D3"]
mtrcs = ["precision", "precision_bon", 
         "recall", "recall_bon", 
         "fpr", "fpr_bon",
         "whr", "whr_bon"]

# Compute mean and standard dev + err across replicates
cols = ["NET", "NGEN", "MTHD",
        "precision_mean", "precision_sdev", "precision_serr", "precision_notna",
        "precision_bon_mean", "precision_bon_sdev", "precision_bon_serr", "precision_bon_notna",
        "recall_mean", "recall_sdev", "recall_serr", "recall_notna",
        "recall_bon_mean", "recall_bon_sdev", "recall_bon_serr", "recall_bon_notna",
        "fpr_mean", "fpr_sdev", "fpr_serr", "fpr_notna",
        "fpr_bon_mean", "fpr_bon_sdev", "fpr_bon_serr", "fpr_bon_notna",
        "whr_mean", "whr_sdev", "whr_serr", "whr_notna", 
        "whr_bon_mean", "whr_bon_sdev", "whr_bon_serr", "whr_bon_notna",]
rows = []

for net in nets:
    for ngen in ngens:
        for mthd in mthds:
            xdf_all = df_all[(df_all["NET"] == net) &
                             (df_all["NGEN"] == ngen) &
                             (df_all["MTHD"] == mthd)]

            row = {}
            row["NET"] = net
            row["NGEN"] = ngen
            row["MTHD"] = mthd

            for mtrc in mtrcs:
                data = xdf_all[mtrc].values
                data = data[~numpy.isnan(data)]

                notna = len(data)
                if notna == 0:
                    row[mtrc + "_mean"] = "NA"
                    row[mtrc + "_sdev"] = "NA"
                    row[mtrc + "_serr"] = "NA"
                else:
                    row[mtrc + "_mean"] = numpy.mean(data)
                    row[mtrc + "_sdev"] = numpy.std(data)
                    row[mtrc + "_serr"] = numpy.std(data) / numpy.sqrt(notna)
                row[mtrc + "_notna"] = notna

            rows.append(row)

df = pandas.DataFrame(rows, columns=cols)

# Save data frame
df.to_csv("data-other-summary.csv",
          sep=',', na_rep="NA",header=True, index=False)

