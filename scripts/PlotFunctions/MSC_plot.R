# Marianne Bjorner 15FEB2022
# input: MSC summary table
# output: plots with false positives and false negative rates plotted by network



setwd("~/GitHub/phylo-microbes/output/2022FEB15_output_alln10_n15")

inputFile = "2022FEB15_MSCQuartets_results_alpha05.csv";
inputFile = "2022FEB15_MSCQuartets_results_alphaBonferroni.csv";

# read input file as a dataframe for use with ggplot2;
# ggplot2 must be installed w accompanying packages.

library(dplyr)
library(ggplot2)

MSC_data = read.csv(inputFile);

# desire is to plot false positive and false negative rate over
# the number of gene trees; we should do this for each of the trees
# that we have:

MSC_counts <- MSC_data %>% group_by(network, gene_trees)

summary_MSC <- MSC_counts %>% summarise(
  false_negatives = mean(FN),
  false_positives = mean(FP),
  true_negatives = mean(TN),
  true_positives = mean(TP),
  false_neg_rate = mean(FN) / (mean(TP)), 
  false_pos_rate = mean(FP) / (mean(TN))
)

# goal is now to plot the summary_MSC that we have created with false positive 
# and false negative rates
toString(summary_MSC$gene_trees)

ggplot(data = summary_MSC, mapping = aes(x = network, y = false_neg_rate, fill=factor(gene_trees))) +
  geom_bar(position="dodge",stat="identity") + ggtitle("MSC False Negative Rate") + ylab("False Negative Rate") + xlab("Networks")

ggplot(data = summary_MSC, mapping = aes(x = network, y = false_pos_rate, fill=factor(gene_trees))) +
  geom_bar(position="dodge",stat="identity") + ggtitle("MSC False Positive Rate") + ylab("False Positive Rate") + xlab("Networks")
