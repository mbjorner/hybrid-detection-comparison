# Marianne Bjorner 15FEB2022
# input: TICR summary table
# output: plots with counts of TICR p value less than some alpha by network
# name and the number of gene trees



setwd("~/GitHub/phylo-microbes/output/2022FEB15_output_alln10_n15")

inputFile = "2022FEB15_TICR_results_withQMC.csv"

setwd("~/GitHub/phylo-microbes/data/foranal20220517/")
inputFile = "n10n15_TICR_results_majorTree20220518.csv"

inputFile = "/Users/bjorner/GitHub/phylo-microbes/scripts/CHTCFunctions/ms_outfiles_paper_ticr.csv"
# read input file as a dataframe for use with ggplot2;
# ggplot2 must be installed w accompanying packages.

library(dplyr)
library(ggplot2)

TICR_data = read.csv(inputFile);

# desire is to plot false positive and false negative rate over
# the number of gene trees; we should do this for each of the trees
# that we have:

TICR_counts <- TICR_data %>% group_by(network_name, seq_length)

alpha = 0.05;

summary_TICR <- TICR_counts %>% summarise(
  numSignificantAlpha = sum(TICR_pval < alpha, na.rm=TRUE),
  numSignificantBonferroni = sum(TICR_pval < alpha/30, na.rm=TRUE)
)

# goal is now to plot the summary_TICR that we have created 

subset

ggplot(data = summary_TICR, mapping = aes(x = network_name, y = numSignificantAlpha, fill=factor(seq_length))) +
  geom_bar(position="dodge",stat="identity") + ylab("number of trials (of 30) with significant results") + 
  xlab("Number of Gene Trees") + ggtitle("Number of tests rejecting true network");

# plot instead the proportion
net101525 = c("n10h2.net"    ,  
              "n10red.net"     ,   "n10orange.net"  ,  
              "n15h3.net" ,  "n15blue.net"     ,       "n15red.net" ,  "n15orange.net" , 
              "n25h5.net")
net458 = c("n4h1_0.1.net",     "n4h1_0.2.net"   ,    "n4h1_0.3.net" ,    "n4h1_0.4.net"  ,  "n4h1_0.4.net",
              "n4h1_0.5.net"    ,  "n4h1_0.net" ,  "n4h1_introg.net", "n5h2_overlap.net", "n8h3.net" )

summary_TICR_101525 = subset(summary_TICR, network_name %in% net101525)
summary_TICR_458 = subset(summary_TICR, network_name %in% net458)
library(stringr)
replace(summary_TICR_101525$network_name, grepl(".net",summary_TICR_101525$network_name), str_replace(summary_TICR_101525$network_name, ".net", "")) 
#summary_TICR_458<-replace(summary_TICR_101525$network_name, grepl(".net",summary_TICR_101525$network_name), str_replace(summary_TICR_101525$network_name, ".net", "")) 



ggplot(data = summary_TICR, mapping = aes(x = network_name, y = numSignificantBonferroni/30, fill = factor(seq_length))) +
  geom_bar(position="dodge",stat="identity") + ylab("Proportion Correctly Rejecting Major Tree") + 
  xlab("Input Network") + ggtitle("Proportion of TICR tests rejecting Major Tree as True Topology") + labs(fill = "Number of Gene Trees") + theme_classic();

ggplot(data = summary_TICR_101525, mapping = aes(x = network_name, y = numSignificantBonferroni/30, fill = factor(seq_length))) +
  geom_bar(position="dodge",stat="identity") + ylab("Proportion Correctly Rejecting Major Tree") + 
  xlab("Network") + ggtitle("Proportion of TICR tests rejecting Major Tree as True Topology") + labs(fill = "Number of Gene Trees") + theme_classic();

ggplot(data = summary_TICR_458, mapping = aes(x = network_name, y = numSignificantBonferroni/30, fill = factor(seq_length))) +
  geom_bar(position="dodge",stat="identity") + ylab("Proportion Correctly Rejecting Major Tree") + 
  xlab("Network") + ggtitle("Proportion of TICR tests rejecting Major Tree as True Topology") + labs(fill = "Number of Gene Trees") + theme_classic();



ggplot(data = summary_TICR, mapping = aes(x = network, y = numSignificantBonferroni, fill=factor(gene_trees))) +
  geom_bar(position="dodge",stat="identity")

