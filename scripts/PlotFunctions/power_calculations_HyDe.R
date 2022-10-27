# Marianne Bjorner
# HyDe power calculations

# using initial hybridlambda output 
# simulated from the long internal branched 4-taxon tree
# of the original HyDe paper, reproduces the power calculations

### Load all necessary libraries 
library(tidyverse)
library(gridExtra)
library(ggplot2)
library(gtable)
library(grid)
library(dplyr)
library(lemon)

hyde_long_mix="/Users/bjorner/GitHub/hybrid-detection-comparison/data/HyDe_four_taxon/long_branches/long_mix052022_HyDe_DStat_pbonferronin4_long.csv"

hyde_data = read.csv(hyde_long_mix)
HyDe_counts <- hyde_data %>% group_by(network_name, gene_trees)

summary_HyDe <- HyDe_counts %>% summarise(
  hyde_false_negatives = mean(HyDe_fn),
  hyde_false_positives = mean(HyDe_fp),
  hyde_true_negatives = mean(HyDe_tn),
  hyde_true_positives = mean(HyDe_tp),
  hyde_wrongClade = mean(HyDe_wrongClade),
  
  power = 1 - (mean(HyDe_fn) / (mean(HyDe_fn) + mean(HyDe_tp)))
)

# replace network names with their numbers
currnames = c("long_mix0", "long_mix01", "long_mix02", "long_mix03", "long_mix04", "long_mix05")
replacement_names = c("0", "0.1", "0.2", "0.3", "0.4", "0.5")

for (row in 1:nrow(summary_HyDe)) {
  netname = summary_HyDe[row, "network_name"]
  index = match(netname, currnames)
  summary_HyDe[row, "network_name"] = replacement_names[index]
}

summary_HyDe["gene_trees"] = summary_HyDe["gene_trees"]/1000

# Plots are arranged with mixing parameter on the x axis,
# and sequence length forming separate lines on the plot,
# with the y-axis as power (1-FNR).

  # HyDe; change colors to reflect sequence lengths, not #gt
  myColors <- brewer.pal(4,"Greens")
  names(myColors) <- levels( summary_HyDe$gene_trees)
  colScale <- scale_colour_manual(name = "Sequence Length (kbp)",values = myColors)
  
  power_plot <- ggplot(data = summary_HyDe, mapping = aes(x = network_name, y = power, group=factor(gene_trees), color=factor(gene_trees))) +
    geom_line(aes(y = power, color=factor(gene_trees)) , size = 1) + geom_point(aes(y = power), size = 3) +
    ylab("Power") + xlab("Mixing Parameter (γ)") + ggtitle("") + theme_classic() + colScale + theme(legend.position = "bottom");
  power_plot

  
setwd("/Users/bjorner/GitHub/hybrid-detection-comparison/")
ggsave(filename = "power_calculations_hybridlambda_bonferroni.png", plot = power_plot, 
       width = 5, height = 5)
