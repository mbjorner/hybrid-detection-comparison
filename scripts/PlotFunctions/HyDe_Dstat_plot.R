# Marianne Bjorner 15FEB2022
# input: MSC summary table
# output: plots with false positive and negative rate plotted by network, 
# number of gene trees, and sequence length.



setwd("~/GitHub/phylo-microbes/output/2022FEB15_output_alln10_n15")

inputFile = "2022FEB15summarytable_withWrongClades_BonferroniCorrected_HyDe.csv";
inputFile = "2022FEB15summarytable_withWrongClades_HyDe.csv";

# read input file as a dataframe for use with ggplot2;
# ggplot2 must be installed w accompanying packages.

library(dplyr)
library(ggplot2)

HyDe_Dstat_data = read.csv(inputFile);

# desire is to plot false positive and false negative rate over
# the number of gene trees and sequence length; we should do this for each of the trees
# that we have:

HyDe_Dstat_counts <- HyDe_Dstat_data %>% group_by(network_name, gene_trees, seq_length)

summary_HyDe <- HyDe_Dstat_counts %>% summarise(
  hyde_false_negatives = mean(HyDe_fn),
  hyde_false_positives = mean(HyDe_fp),
  hyde_true_negatives = mean(HyDe_tn),
  hyde_true_positives = mean(HyDe_tp),
  hyde_wrongClade = mean(HyDe_wrongClade),
  hyde_false_neg_rate = mean(HyDe_fn) / (mean(HyDe_fn) + mean(HyDe_tp)), 
  hyde_false_pos_rate = mean(HyDe_fp) / (mean(HyDe_fp) + mean(HyDe_tn))
)

summary_Dstat <- HyDe_Dstat_counts %>% summarise(
  d_false_negatives = mean(Dstat_fn),
  d_false_positives = mean(Dstat_fp),
  d_true_negatives = mean(Dstat_tn),
  d_true_positives = mean(Dstat_tp),
  d_wrongClade = mean(Dstat_wc),
  d_false_neg_rate = mean(Dstat_fn) / (mean(Dstat_fn) + mean(Dstat_tp)), 
  d_false_pos_rate = mean(Dstat_fp) / (mean(Dstat_fp) + mean(Dstat_tn))
)

# goal is now to plot the summary_Dstat and summary_HyDe

#-- plot only one network at a time
n10summary = summary_HyDe[summary_HyDe$network_name == "n10", ] 
n10redsummary = summary_HyDe[summary_HyDe$network_name == "n10red", ] 
n10orangesummary = summary_HyDe[summary_HyDe$network_name == "n10orange", ] 


ggplot(data = n10summary, mapping = aes(x = gene_trees, y = hyde_false_neg_rate, color=factor(seq_length))) +
  geom_line() +geom_point();

ggplot(data = n10summary, mapping = aes(x = gene_trees, y = hyde_false_pos_rate, color=factor(seq_length))) +
  geom_line() +geom_point();

n10summary_d = summary_Dstat[summary_Dstat$network_name == "n10", ] 
n10redsummary_d = summary_Dstat[summary_Dstat$network_name == "n10red", ] 
n10orangesummary_d = summary_Dstat[summary_Dstat$network_name == "n10orange", ]

ggplot(data = n10summary_d, mapping = aes(x = gene_trees, y = d_false_neg_rate, color=factor(seq_length))) +
  geom_line() +geom_point();

ggplot(data = n10summary_d, mapping = aes(x = gene_trees, y = d_false_pos_rate, color=factor(seq_length))) +
  geom_line() + geom_point();
