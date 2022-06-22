# with HyDe, D-Stat (ABBA-BABA), TICR, MSCQuartets

library(gridExtra)


setwd("~/GitHub/phylo-microbes/analysis051422")
TICR05 = "06212022_ticr05_results.csv"
TICR_bonferroni = "06212022_ticrbonferroni_results.csv"
MSC05 = "06212022_msc05_results.csv"
MSC_bonferroni = "06212022_mscbonferroni_results.csv"

TICR_data = read.csv(TICR05)
TICR_counts <- TICR_data %>% group_by(network, gene_trees)
MSC_data = read.csv(MSC05)
MSC_counts <- MSC_data %>% group_by(network, gene_trees)

setwd("~/GitHub/copyn15/")
inputFile = "falseRates_HyDe_DStat_pbonferronin10n15bonbon.csv"
inputFile = "20220517_HyDe_DStat_p05n10_n15.csv"
HyDe_Dstat_data = read.csv(inputFile)

HyDe_Dstat_counts <- HyDe_Dstat_data %>% group_by(network_name, gene_trees)


# Calculate summary values for all functions

# For HyDe, we calculate
# - FNR = FN/(FN+TP+WH)
# - FPR = FP/(FP+TN)
# - WHR = WH/(FP+TP+WH)
# - precision = TP/(TP+WH+FP)

summary_HyDe <- HyDe_Dstat_counts %>% summarise(
  hyde_false_negatives = mean(HyDe_fn),
  hyde_false_positives = mean(HyDe_fp),
  hyde_true_negatives = mean(HyDe_tn),
  hyde_true_positives = mean(HyDe_tp),
  hyde_wrongClade = mean(HyDe_wrongClade),
  
  FNR = mean(HyDe_fn) / (mean(HyDe_fn) + mean(HyDe_tp) + mean(HyDe_wrongClade)),
  FPR = mean(HyDe_fp) / (mean(HyDe_fp) + mean(HyDe_tn)),
  WHR = mean(HyDe_wrongClade) / (mean(HyDe_fp) + mean(HyDe_tp) + mean(HyDe_wrongClade)),
  precision = mean(HyDe_tp) / (mean(HyDe_fp) + mean(HyDe_tp) + mean(HyDe_wrongClade)),
                               
  true_pos_rate = mean(HyDe_tp) / (mean(HyDe_tp) + mean(HyDe_fn)),
  hyde_false_neg_rate = mean(HyDe_fn) / (mean(HyDe_fn) + mean(HyDe_tp)), 
  hyde_false_neg_wrongclade = (mean(HyDe_fn)) / (mean(HyDe_fn) + mean(HyDe_tp) + mean(HyDe_wrongClade)),
  hyde_false_pos_rate = mean(HyDe_fp) / (mean(HyDe_fp) + mean(HyDe_tn))
)


summary_Dstat <- HyDe_Dstat_counts %>% summarise(
  d_false_negatives = mean(Dstat_fn),
  d_false_positives = mean(Dstat_fp),
  d_true_negatives = mean(Dstat_tn),
  d_true_positives = mean(Dstat_tp),
  
  FNR = mean(Dstat_fn) / (mean(Dstat_fn) + mean(Dstat_tp)),
  FPR = mean(Dstat_fp) / (mean(Dstat_fp) + mean(Dstat_tn)),
  precision = mean(Dstat_tp) / (mean(Dstat_fp) + mean(Dstat_tp)),
  
  d_false_neg_rate = mean(Dstat_fn) / (mean(Dstat_fn) + mean(Dstat_tp)), 
  d_false_pos_rate = mean(Dstat_fp) / (mean(Dstat_fp) + mean(Dstat_tn))
)

# For MSC and TICR, we calculate
# - FNR = FN / (FN+TP)
# - FPR = FP / (FP+TN)
# - precision = TP / (TP+FP)


summary_TICR <- TICR_counts %>% summarise(
  false_negatives = mean(FN),
  false_positives = mean(FP),
  true_negatives = mean(TN),
  true_positives = mean(TP),
  FNR = mean(FN) / (mean(TP) + mean(FN)), 
  FPR = mean(FP) / (mean(TN) + mean(FP)),
  precision = mean(TP) / (mean(TP) + mean(FP))
)


summary_MSC <- MSC_counts %>% summarise(
  false_negatives = mean(FN),
  false_positives = mean(FP),
  true_negatives = mean(TN),
  true_positives = mean(TP),
  FNR = mean(FN) / (mean(TP) + mean(FN)), 
  FPR = mean(FP) / (mean(TN) + mean(FP)),
  precision = mean(TP) / (mean(TP) + mean(FP))
)


# N10H2 decomposes into N10Red and N10Orange: We create a 4x3 grid to display 
# results across these 3 network types with 4 methods

# TICR     MSCQuartets      HyDe      ABBA-BABA

network_names = c("n10", "n10red", "n10orange", "n15", "n15red", "n15orange", "n15blue")
hyde_plot_list = list()

for (i in 1:length(network_names)) {
  #### Create HyDe plot
  subset_object = subset(summary_HyDe, network_name %in% c(network_names[i]))

  hyde_plot = ggplot(subset_object, aes(x = gene_trees)) +
  geom_line(aes(y = WHR), color = "darkred") + geom_point(aes(y = WHR), color = "darkred") + 
  geom_errorbar(
    data = subset_object,
    aes(gene_trees, WHR, ymin = WHR - error(WHR), ymax = WHR + error(WHR)),
    colour = 'darkred',
    width = 0.2
  ) + 
  geom_line(aes(y = precision), color = "blue") + geom_point(aes(y = precision), color = "blue") +
  geom_errorbar(
    data = subset_object,
    aes(gene_trees, precision, ymin = precision - error(precision), ymax = precision + error(precision)),
    colour = 'blue',
    position=position_dodge(.9),
    width = 0.2
  ) + 
  geom_line(aes(y = FNR), color = "black") + geom_point(aes(y = FNR), color = "black") +
  geom_errorbar(
    data = subset_object,
    aes(gene_trees, FNR, ymin = FNR - error(FNR), ymax = FNR + error(FNR)),
    colour = 'black',
    width = 0.2
  ) +
  geom_line(aes(y = FPR), color = "orange") + geom_point(aes(y = FPR), color = "orange") +
  geom_errorbar(
    data = subset_object,
    aes(gene_trees, FPR, ymin = FPR - error(FPR), ymax = FPR + error(FPR)),
    colour = 'orange',
    width = 0.2
  ) + theme_classic() + theme(axis.title = element_blank()) + ylim(0,1)
  hyde_plot_list[[i]] = hyde_plot
}
  
d_stat_plot_list = list()
ticr_plot_list = list()
msc_plot_list = list()

for (method_name in c("TICR", "MSCquartets", "D-statistic")) {
  
  for (i in 1:length(network_names)) {
  ### Create ABBA-BABA plot (D-statistic)
  if (method_name == "TICR") {
    subset_object = subset(summary_TICR, network %in% c(network_names[i]))
  } else if (method_name == "MSCquartets") {
    subset_object = subset(summary_MSC, network %in% c(network_names[i]) )
  } else if (method_name == "D-statistic") {
    subset_object = subset(summary_Dstat, network_name %in% c(network_names[i]))
  }
    
  new_plot = ggplot(subset_object, aes(x = gene_trees)) +
    geom_line(aes(y = precision), color = "blue") + geom_point(aes(y = precision), color = "blue") +
    geom_errorbar(
      data = subset_object,
      aes(gene_trees, precision, ymin = precision - error(precision), ymax = precision + error(precision)),
      colour = 'blue',
      position=position_dodge(.9),
      width = 0.2
    ) + 
    geom_line(aes(y = FNR), color = "black") + geom_point(aes(y = FNR), color = "black") +
    geom_errorbar(
      data = subset_object,
      aes(gene_trees, FNR, ymin = FNR - error(FNR), ymax = FNR + error(FNR)),
      colour = 'black',
      width = 0.2
    ) +
    geom_line(aes(y = FPR), color = "orange") + geom_point(aes(y = FPR), color = "orange") +
    geom_errorbar(
      data = subset_object,
      aes(gene_trees, FPR, ymin = FPR - error(FPR), ymax = FPR + error(FPR)),
      colour = 'orange',
      width = 0.2
    ) + theme_classic() + theme(axis.title = element_blank()) + ylim(0,1)
  if (method_name == "TICR") {
    ticr_plot_list[[i]] = new_plot
  } else if (method_name == "MSCquartets") {
    msc_plot_list[[i]] = new_plot  
  } else if (method_name == "D-statistic") {
    d_stat_plot_list[[i]] = new_plot
  }
  
}}

# plots are arranged n10 as first row, TICR, MSC, 

# n10 plot
n10_ticr = ticr_plot_list[[1]]
n10_msc = msc_plot_list[[1]]
n10_hyde = hyde_plot_list[[1]]
n10_d_stat = d_stat_plot_list[[1]]

n10red_ticr = ticr_plot_list[[2]]
n10red_msc = msc_plot_list[[2]]
n10red_hyde = hyde_plot_list[[2]]
n10red_d_stat = d_stat_plot_list[[2]]

n10orange_ticr = ticr_plot_list[[3]]
n10orange_msc = msc_plot_list[[3]]
n10orange_hyde = hyde_plot_list[[3]] 
n10orange_d_stat = d_stat_plot_list[[3]]

# n15 plot
n15_ticr = ticr_plot_list[[4]]
n15_msc = msc_plot_list[[4]]
n15_hyde = hyde_plot_list[[4]]
n15_d_stat = d_stat_plot_list[[4]]

n15red_ticr = ticr_plot_list[[5]]
n15red_msc = msc_plot_list[[5]]
n15red_hyde = hyde_plot_list[[5]]
n15red_d_stat = d_stat_plot_list[[5]]

n15orange_ticr = ticr_plot_list[[6]]
n15orange_msc = msc_plot_list[[6]]
n15orange_hyde = hyde_plot_list[[6]] 
n15orange_d_stat = d_stat_plot_list[[6]]

n15blue_ticr = ticr_plot_list[[7]]
n15blue_msc = msc_plot_list[[7]]
n15blue_hyde = hyde_plot_list[[7]] 
n15blue_d_stat = d_stat_plot_list[[7]]


#top=   "TICR  ----------- MSCQuartets  ---------  HyDe --------   D-Statistic",
#bottom="gene trees        gene trees        sequence length     sequence length"

grid.arrange(n10_ticr, n10_msc, n10_hyde, n10_d_stat, 
             n10red_ticr, n10red_msc, n10red_hyde, n10red_d_stat,
             n10orange_ticr, n10orange_msc, n10orange_hyde, n10orange_d_stat,
             ncol=4)

# n15 plot
grid.arrange(n15_ticr, n15_msc, n15_hyde, n15_d_stat, 
             n15red_ticr, n15red_msc, n15red_hyde, n15red_d_stat,
             n15orange_ticr, n15orange_msc, n15orange_hyde, n15orange_d_stat,
             n15blue_ticr, n15blue_msc, n15blue_hyde, n15blue_d_stat,
             ncol=4)

error <- function(errRate) {
  return(sqrt((errRate * (1 - errRate)) / 30))
}

