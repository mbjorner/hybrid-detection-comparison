# Marianne Bjorner 15FEB2022
# input: hyDe summary table
# output: plots with false positive and negative rate plotted by network, 
# number of gene trees, and sequence length.



#setwd("~/GitHub/phylo-microbes/output/2022FEB15_output_alln10_n15")

#inputFile = "2022FEB15summarytable_withWrongClades_BonferroniCorrected_HyDe.csv";
#inputFile = "2022FEB15summarytable_withWrongClades_HyDe.csv";

# setwd("~/GitHub/phylo-microbes/output/long_mix_out")
# setwd("~/GitHub/phylo-microbes/output/20220511output")


setwd("~/GitHub/copyn15/")

inputFile = "20220517_HyDe_DStat_p05n10_n15.csv"
inputFile = "falseRates_HyDe_DStat_pbonferronin10n15bonbon.csv"

setwd("~/GitHub/phylo-microbes/data/HyDe_four_taxon/long_branches/")
inputFile = "long_mix052022_HyDe_DStat_pbonferronin4_long.csv"

setwd("~/GitHub/copyn15/")

inputFile = "falseRates_HyDe_DStat_pbonferronin10n15bonbon.csv"

# read input file as a dataframe for use with ggplot2;
# ggplot2 must be installed w accompanying packages.

library(dplyr)
library(ggplot2)

HyDe_Dstat_data = read.csv(inputFile);

# desire is to plot false positive and false negative rate over
# the number of gene trees and sequence length; we should do this for each of the trees
# that we have:

HyDe_Dstat_counts <- HyDe_Dstat_data %>% group_by(network_name, gene_trees, seq_length)
HyDe_Dstat_counts <- HyDe_Dstat_data %>% group_by(network_name, gene_trees)


summary_HyDe <- HyDe_Dstat_counts %>% summarise(
  hyde_false_negatives = mean(HyDe_fn),
  hyde_false_positives = mean(HyDe_fp),
  hyde_true_negatives = mean(HyDe_tn),
  hyde_true_positives = mean(HyDe_tp),
  hyde_wrongClade = mean(HyDe_wrongClade),
  true_pos_rate = mean(HyDe_tp) / (mean(HyDe_tp) + mean(HyDe_fn)),
  hyde_false_neg_rate = mean(HyDe_fn) / (mean(HyDe_fn) + mean(HyDe_tp)), 
  hyde_false_neg_wrongclade = (mean(HyDe_fn)) / (mean(HyDe_fn) + mean(HyDe_tp) + mean(HyDe_wrongClade)),
  hyde_false_pos_rate = mean(HyDe_fp) / (mean(HyDe_fp) + mean(HyDe_tn))
)

# add confidence interval as sqrt(p* (1-p) / 30)


summary_Dstat <- HyDe_Dstat_counts %>% summarise(
  d_false_negatives = mean(Dstat_fn),
  d_false_positives = mean(Dstat_fp),
  d_true_negatives = mean(Dstat_tn),
  d_true_positives = mean(Dstat_tp),
  d_wrongClade = mean(Dstat_wc),
  d_false_neg_rate = mean(Dstat_fn) / (mean(Dstat_fn) + mean(Dstat_tp)), 
  d_false_pos_rate = mean(Dstat_fp) / (mean(Dstat_fp) + mean(Dstat_tn))
)

# goal is now to plot the summary_Dstat and summary_HyDe by [n10, n10red, n10orange] and [n15, n15red, n15blue, n15orange]
trans = t(summary_HyDe)
trans %>% select(starts_with("n10", "hyde"))
#) = summary_HyDe[starts_with(summary_HyDe$network_name, "n10") , ]

n10summary_Dstat = summary_Dstat[summary_Dstat$network_name == "n10", ] 
n15summary_Dstat = summary_Dstat[summary_Dstat$network_name == "n15", ]

#-- plot only one network at a time
n6summary = summary_HyDe[summary_HyDe$network_name == "n6", ] 

n10summary = summary_HyDe[summary_HyDe$network_name == "n10", ] 
n10redsummary = summary_HyDe[summary_HyDe$network_name == "n10red", ] 
n10orangesummary = summary_HyDe[summary_HyDe$network_name == "n10orange", ] 

n15summary = summary_HyDe[summary_HyDe$network_name == "n15", ] 
n15redsummary = summary_HyDe[summary_HyDe$network_name == "n15red", ] 
n15orangesummary = summary_HyDe[summary_HyDe$network_name == "n15orange", ] 
n15bluesummary = summary_HyDe[summary_HyDe$network_name == "n15blue", ] 

######## n10 summary tables
ggplot(data = summary_HyDe, mapping = aes(x = gene_trees, y = hyde_false_neg_rate, color=factor(network_name))) +
  geom_line() +geom_point() + ylab("False Negative Rate") + xlab("Number of Gene Trees") + ggtitle("HyDe False Negative Rates (bonferroni corrected)") +
  theme_classic();

ggplot(data = summary_HyDe, mapping = aes(x = network_name, y = true_pos_rate, color=factor(gene_trees))) +
  geom_line() +geom_point() + ylab("Power") + xlab("Mixing Parameter") + ggtitle("HyDe performance on 4-taxon tree") +
  theme_classic();

ggplot(data = summary_HyDe, mapping = aes(x = gene_trees, y = hyde_false_neg_wrongclade, color=factor(network_name))) +
  geom_line() +geom_point() + ylab("Power") + xlab("Mixing Parameter") + ggtitle("N10H2 HyDe False Negative Rates") +
  theme_classic();

ggplot(data = summary_HyDe, mapping = aes(x = gene_trees, y = hyde_false_pos_rate, color=factor(network_name))) +
  geom_line() +geom_point() + ylab("False Positive Rate") + xlab("Number of Gene Trees") + ggtitle("HyDe False Positive Rates (bonferroni corrected)") +
  theme_classic();


ggplot(data = summary_Dstat, mapping = aes(x = gene_trees, y = d_false_neg_rate, color=factor(network_name))) +
  geom_line() +geom_point() + ylab("False Negative Rate") + xlab("Sequence Length (bp)") + ggtitle("D-Statistic False Negative Rates (bonferroni)") +
  theme_classic();

ggplot(data = summary_Dstat, mapping = aes(x = gene_trees, y = d_false_pos_rate, color=factor(network_name))) +
  geom_line() +geom_point() + ylab("False Positive Rate") + xlab("Sequence Length (bp)") + ggtitle("D-Statistic False Positive Rates (bonferroni)") +
  theme_classic();

ggplot(data = summary_Dstat, mapping = aes(x = gene_trees, y = hyde_false_pos_rate, color=factor(network_name))) +
  geom_line() +geom_point() + ylab("False Positive Rate") + xlab("Number of Gene Trees") + ggtitle("HyDe False Positive Rates") +
  theme_classic();


ggplot(data = n10summary, mapping = aes(x = gene_trees, y = hyde_false_pos_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Positive Rate") + xlab("Number of Gene Trees") + ggtitle("N10H2 HyDe False Positive Rates") + theme_classic();

ggplot(data = n10redsummary, mapping = aes(x = gene_trees, y = hyde_false_neg_rate)) +
  geom_line() +geom_point() + ylab("False Negative Rate") + xlab("Number of Gene Trees") + ggtitle("N10red HyDe False Negative Rates") + theme_classic();

ggplot(data = n10redsummary, mapping = aes(x = gene_trees, y = hyde_false_pos_rate)) +
  geom_line() +geom_point() + ylab("False Positive Rate") + xlab("Number of Gene Trees") + ggtitle("N10red HyDe False Positive Rates")+ theme_classic();

ggplot(data = n10orangesummary, mapping = aes(x = gene_trees, y = hyde_false_neg_rate)) +
  geom_line() +geom_point() + ylab("False Negative Rate") + xlab("Number of Gene Trees") + ggtitle("N10orange HyDe False Negative Rates")+theme_classic();

ggplot(data = n10orangesummary, mapping = aes(x = gene_trees, y = hyde_false_pos_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Positive Rate") + xlab("Number of Gene Trees") + ggtitle("N10orange HyDe False Positive Rates")+theme_classic();


######### n15 summary tables
ggplot(data = n15summary, mapping = aes(x = gene_trees, y = hyde_false_neg_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Negative Rate") + xlab("Number of Gene Trees") + ggtitle("N15H3 HyDe False Negative Rates")+theme_classic();

ggplot(data = n15summary, mapping = aes(x = gene_trees, y = hyde_false_pos_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Positive Rate") + xlab("Number of Gene Trees") + ggtitle("N15H3 HyDe False Positive Rates")+theme_classic();

ggplot(data = n15redsummary, mapping = aes(x = gene_trees, y = hyde_false_neg_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Negative Rate") + xlab("Number of Gene Trees") + ggtitle("N15red HyDe False Negative Rates")+theme_classic();

ggplot(data = n15redsummary, mapping = aes(x = gene_trees, y = hyde_false_pos_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Positive Rate") + xlab("Number of Gene Trees") + ggtitle("N15red HyDe False Positive Rates")+theme_classic();

ggplot(data = n15orangesummary, mapping = aes(x = gene_trees, y = hyde_false_neg_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Negative Rate") + xlab("Number of Gene Trees") + ggtitle("N15orange HyDe False Negative Rates")+theme_classic();

ggplot(data = n15orangesummary, mapping = aes(x = gene_trees, y = hyde_false_pos_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Positive Rate") + xlab("Number of Gene Trees") + ggtitle("N15orange HyDe False Positive Rates")+theme_classic();

ggplot(data = n15bluesummary, mapping = aes(x = gene_trees, y = hyde_false_neg_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Negative Rate") + xlab("Number of Gene Trees") + ggtitle("N15blue HyDe False Negative Rates")+theme_classic();

ggplot(data = n15bluesummary, mapping = aes(x = gene_trees, y = hyde_false_pos_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Positive Rate") + xlab("Number of Gene Trees") + ggtitle("N15blue HyDe False Positive Rates")+theme_classic();


n10summary_d = summary_Dstat[summary_Dstat$network_name == "n10", ] 
n10redsummary_d = summary_Dstat[summary_Dstat$network_name == "n10red", ] 
n10orangesummary_d = summary_Dstat[summary_Dstat$network_name == "n10orange", ]

n15summary_d = c(summary_Dstat[summary_Dstat$network_name == "n15", ], summary_Dstat[summary_Dstat$network_name == "n15red", ])
n15redsummary_d = summary_Dstat[summary_Dstat$network_name == "n15red", ] 
n15orangesummary_d = summary_Dstat[summary_Dstat$network_name == "n15orange", ]
n15bluesummary_d = summary_Dstat[summary_Dstat$network_name == "n15blue", ]


#### N10 summary
ggplot(data = summary_Dstat, mapping = aes(x = gene_trees, y = d_false_neg_rate)) +
  geom_line() +geom_point() + ylab("False Negaitve Rate") + xlab("Number of Gene Trees") + 
  ggtitle("D-Statistic Precision") + theme_classic();

ggplot(data = summary_Dstat, mapping = aes(x = gene_trees, y = d_false_neg_rate)) +
  geom_line() +geom_point() + ylab("False Negaitve Rate") + xlab("Number of Gene Trees") + 
  ggtitle("N10H2 D-Statistic False Negative Rates") + theme_classic();

ggplot(data = n10summary_d, mapping = aes(x = gene_trees, y = d_false_pos_rate)) +
  geom_line() +geom_point() + ylab("False Positive Rate") + xlab("Number of Gene Trees") + 
  ggtitle("N10H2 D-Statistic False Positive Rates")+ theme_classic();

ggplot(data = n10redsummary_d, mapping = aes(x = gene_trees, y = d_false_neg_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Negaitve Rate") + xlab("Number of Gene Trees") + 
  ggtitle("N10red D-Statistic False Negative Rates")+theme_classic();

ggplot(data = n10redsummary_d, mapping = aes(x = gene_trees, y = d_false_pos_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Positive Rate") + xlab("Number of Gene Trees") + 
  ggtitle("N10red D-Statistic False Positive Rates")+theme_classic();

ggplot(data = n10orangesummary_d, mapping = aes(x = gene_trees, y = d_false_neg_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Negaitve Rate") + xlab("Number of Gene Trees") +
  ggtitle("N10orange D-Statistic False Negative Rates")+theme_classic();

ggplot(data = n10orangesummary_d, mapping = aes(x = gene_trees, y = d_false_pos_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Positive Rate") + xlab("Number of Gene Trees") + 
  ggtitle("N10orange D-Statistic False Positive Rates")+theme_classic();



###### N15 summary
ggplot(data = n15summary_d, mapping = aes(x = gene_trees, y = d_false_neg_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Negaitve Rate") + xlab("Number of Gene Trees") + 
  ggtitle("N15H3 D-Statistic False Negative Rates")+theme_classic();

ggplot(data = n15summary_d, mapping = aes(x = gene_trees, y = d_false_pos_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Positive Rate") + xlab("Number of Gene Trees") + 
  ggtitle("N15H3 D-Statistic False Positive Rates")+theme_classic();

ggplot(data = n15redsummary_d, mapping = aes(x = gene_trees, y = d_false_neg_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Negaitve Rate") + xlab("Number of Gene Trees") +
  ggtitle("N15red D-Statistic False Negative Rates")+theme_classic();

ggplot(data = n15redsummary_d, mapping = aes(x = gene_trees, y = d_false_pos_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Positive Rate") + xlab("Number of Gene Trees") +
  ggtitle("N15red D-Statistic False Positive Rates")+theme_classic();

ggplot(data = n15orangesummary_d, mapping = aes(x = gene_trees, y = d_false_neg_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Negaitve Rate") + xlab("Number of Gene Trees") +
  ggtitle("N15orange D-Statistic False Negative Rates")+theme_classic();

ggplot(data = n15orangesummary_d, mapping = aes(x = gene_trees, y = d_false_pos_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Positive Rate") + xlab("Number of Gene Trees") +
  ggtitle("N15orange D-Statistic False Positive Rates")+theme_classic();

ggplot(data = n15bluesummary_d, mapping = aes(x = gene_trees, y = d_false_neg_rate)) +
  geom_line() +geom_point() + ylab("False Negaitve Rate") + xlab("Number of Gene Trees") +
  ggtitle("N15blue D-Statistic False Negative Rates")+theme_classic();

ggplot(data = n15bluesummary_d, mapping = aes(x = gene_trees, y = d_false_pos_rate, color=factor(seq_length))) +
  geom_line() +geom_point() + ylab("False Positive Rate") + xlab("Number of Gene Trees") +
  ggtitle("N15blue D-Statistic False Positive Rates")+theme_classic();


