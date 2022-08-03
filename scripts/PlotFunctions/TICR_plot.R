# Marianne Bjorner 15FEB2022
# input: TICR summary table
# output: plots with counts of TICR p value less than some alpha by network
# name and the number of gene trees



setwd("~/GitHub/phylo-microbes/output/2022FEB15_output_alln10_n15")

inputFile = "2022FEB15_TICR_results_withQMC.csv"

setwd("~/GitHub/phylo-microbes/data/foranal20220517/")
inputFile = "n10n15_TICR_results_majorTree20220518.csv"
# read input file as a dataframe for use with ggplot2;
# ggplot2 must be installed w accompanying packages.

library(dplyr)
library(ggplot2)

TICR_data = read.csv(inputFile);

# desire is to plot false positive and false negative rate over
# the number of gene trees; we should do this for each of the trees
# that we have:

TICR_counts <- TICR_data %>% group_by(net_name, gene_trees)

alpha = 0.05;

summary_TICR <- TICR_counts %>% summarise(
  numSignificantAlpha = sum(ticr_pVal < alpha, na.rm=TRUE),
  numSignificantBonferroni = sum(ticr_pVal < alpha/30, na.rm=TRUE)
)

# goal is now to plot the summary_TICR that we have created 

ggplot(data = summary_TICR, mapping = aes(x = net_name, y = numSignificantAlpha, fill=factor(gene_trees))) +
  geom_bar(position="dodge",stat="identity") + ylab("number of trials (of 30) with significant results") + 
  xlab("Number of Gene Trees") + ggtitle("Number of tests rejecting true network");

# plot instead the proportion
ggplot(data = summary_TICR, mapping = aes(x = net_name, y = numSignificantAlpha/30, fill = factor(gene_trees))) +
  geom_bar(position="dodge",stat="identity") + ylab("Proportion Correctly Rejecting Major Tree") + 
  xlab("Input Network") + ggtitle("Proportion of TICR tests rejecting Major Tree as True Topology") + labs(fill = "Number of Gene Trees") + theme_classic();


ggplot(data = summary_TICR, mapping = aes(x = network, y = numSignificantBonferroni, fill=factor(gene_trees))) +
  geom_bar(position="dodge",stat="identity")

