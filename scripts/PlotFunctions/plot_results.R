# Creates plots of MSC quartets, HyDe, D-Statistic, and D3
# in terms of precision, FNR, FPR, (for all) and WHR (for HyDe)

### Load all necessary libraries 
library(tidyverse)
library(gridExtra)
library(ggplot2)
library(gtable)
library(grid)
library(dplyr)
library(lemon)

hyde_d_d3_dp="/Users/bjorner/GitHub/phylo-microbes/scripts/CHTCFunctions/0915out.csv"
ticr_msc = "/Users/bjorner/GitHub/phylo-microbes/scripts/CHTCFunctions/ms_outfiles_paper_ticr.csv"

error <- function(errRate) {
  return(sqrt((errRate * (1 - errRate)) / 30))
}

TICR_MSC_data = read.csv(ticr_msc)
hyde_d_d3_dp_data = read.csv(hyde_d_d3_dp)
TICR_MSC_counts <- TICR_MSC_data %>% group_by(network_name, seq_length)
HyDe_Dstat_counts <- hyde_d_d3_dp_data %>% group_by(network_name, seq_length)

# For HyDe, we calculate
# - FNR = FN/(FN+TP+WH)
# - FPR = FP/(FP+TN)
# - WHR = WH/(FP+TP+WH)
# - precision = TP/(TP+WH+FP)

summary_HyDe_bonferroni <- HyDe_Dstat_counts %>% summarise(
  hyde_false_negatives = mean(FN_bon),
  hyde_false_positives = mean(FP_bon),
  hyde_true_negatives = mean(TN_bon),
  hyde_true_positives = mean(TP_bon),
  hyde_wrongClade = mean(WC_bon),
  
  FNR = mean(FN_bon) / (mean(FN_bon) + mean(TP_bon) + mean(WC_bon)),
  FPR = mean(FP_bon) / (mean(FP_bon) + mean(TN_bon)),
  WHR = mean(WC_bon) / (mean(FP_bon) + mean(TP_bon) + mean(WC_bon)),
  precision = mean(TP_bon) / (mean(FP_bon) + mean(TP_bon) + mean(WC_bon)),
  recall = mean(TP_bon) / (mean(TP_bon) + mean(FN_bon)),
                               
  true_pos_rate = mean(TP_bon) / (mean(TP_bon) + mean(FN_bon)),
  hyde_false_neg_rate = mean(FN_bon) / (mean(FN_bon) + mean(TP_bon)), 
  hyde_false_neg_wrongclade = (mean(FN_bon)) / (mean(FN_bon) + mean(TP_bon) + mean(WC_bon)),
  hyde_false_pos_rate = mean(FP_bon) / (mean(FP_bon) + mean(TN_bon))
)

summary_HyDe <- HyDe_Dstat_counts %>% summarise(
  hyde_false_negatives = mean(FN),
  hyde_false_positives = mean(FP),
  hyde_true_negatives = mean(TN),
  hyde_true_positives = mean(TP),
  hyde_wrongClade = mean(WC),
  
  FNR = mean(FN) / (mean(FN) + mean(TP) + mean(WC)),
  FPR = mean(FP) / (mean(FP) + mean(TN)),
  WHR = mean(WC) / (mean(FP) + mean(TP) + mean(WC)),
  precision = mean(TP) / (mean(FP) + mean(TP) + mean(WC)),
  recall = mean(TP) / (mean(TP) + mean(FN)),
  
  true_pos_rate = mean(TP) / (mean(TP) + mean(FN)),
  hyde_false_neg_rate = mean(FN) / (mean(FN) + mean(TP)), 
  hyde_false_neg_wrongclade = (mean(FN)) / (mean(FN) + mean(TP) + mean(WC)),
  hyde_false_pos_rate = mean(FP) / (mean(FP) + mean(TN))
)

# FP_D,FN_D,TP_D,TN_D,FP_Dbon,FN_Dbon,TP_Dbon,TN_Dbon
summary_Dstat <- HyDe_Dstat_counts %>% summarise(
  d_false_negatives = mean(FN_D),
  d_false_positives = mean(FP_D),
  d_true_negatives = mean(TN_D),
  d_true_positives = mean(TP_D),
  
  FNR = mean(FN_D) / (mean(FN_D) + mean(TP_D)),
  FPR = mean(FP_D) / (mean(FP_D) + mean(TN_D)),
  precision = mean(TP_D) / (mean(FP_D) + mean(TP_D)),
  recall = mean(TP_D) / (mean(TP_D) + mean(FN_D)),
  
  d_false_neg_rate = mean(FN_D) / (mean(FN_D) + mean(TP_D)), 
  d_false_pos_rate = mean(FP_D) / (mean(FP_D) + mean(TP_D))
)

summary_Dstat_bonferroni <- HyDe_Dstat_counts %>% summarise(
  d_false_negatives = mean(FN_Dbon),
  d_false_positives = mean(FP_Dbon),
  d_true_negatives = mean(TN_Dbon),
  d_true_positives = mean(TP_Dbon),
  
  FNR = mean(FN_Dbon) / (mean(FN_Dbon) + mean(TP_Dbon)),
  FPR = mean(FP_Dbon) / (mean(FP_Dbon) + mean(TN_Dbon)),
  precision = mean(TP_Dbon) / (mean(FP_Dbon) + mean(TP_Dbon)),
  recall = mean(TP_Dbon) / (mean(TP_Dbon) + mean(FN_Dbon)),
  
  d_false_neg_rate = mean(FN_Dbon) / (mean(FN_Dbon) + mean(TP_Dbon)), 
  d_false_pos_rate = mean(FP_Dbon) / (mean(FP_Dbon) + mean(TP_Dbon))
)


summary_D3_bonferroni <- HyDe_Dstat_counts %>% summarise(
  d_false_negatives = mean(FN_D3bon),
  d_false_positives = mean(FP_D3bon),
  d_true_negatives = mean(TN_D3bon),
  d_true_positives = mean(TP_D3bon),
  
  FNR = mean(FN_D3bon) / (mean(FN_D3bon) + mean(TP_D3bon)),
  FPR = mean(FP_D3bon) / (mean(FP_D3bon) + mean(TN_D3bon)),
  precision = mean(TP_D3bon) / (mean(FP_D3bon) + mean(TP_D3bon)),
  recall = mean(TP_D3bon) / (mean(TP_D3bon) + mean(FN_D3bon)),
  
  d_false_neg_rate = mean(FN_D3bon) / (mean(FN_D3bon) + mean(TP_D3bon)), 
  d_false_pos_rate = mean(FP_D3bon) / (mean(FP_D3bon) + mean(TP_D3bon))
)


summary_D3 <- HyDe_Dstat_counts %>% summarise(
  d_false_negatives = mean(FN_D3),
  d_false_positives = mean(FP_D3),
  d_true_negatives = mean(TN_D3),
  d_true_positives = mean(TP_D3),
  
  FNR = mean(FN_D3) / (mean(FN_D3) + mean(TP_D3)),
  FPR = mean(FP_D3) / (mean(FP_D3) + mean(TN_D3)),
  precision = mean(TP_D3) / (mean(FP_D3) + mean(TP_D3)),
  recall = mean(TP_D3) / (mean(TP_D3) + mean(FN_D3)),
  
  d_false_neg_rate = mean(FN_D3) / (mean(FN_D3) + mean(TP_D3)), 
  d_false_pos_rate = mean(FP_D3) / (mean(FP_D3) + mean(TP_D3))
)


summary_Dp_bonferroni <- HyDe_Dstat_counts %>% summarise(
  d_false_negatives = mean(FN_Dpbon),
  d_false_positives = mean(FP_Dpbon),
  d_true_negatives = mean(TN_Dpbon),
  d_true_positives = mean(TP_Dpbon),
  
  FNR = mean(FN_Dpbon) / (mean(FN_Dpbon) + mean(TP_Dpbon)),
  FPR = mean(FP_Dpbon) / (mean(FP_Dpbon) + mean(TN_Dpbon)),
  precision = mean(TP_Dpbon) / (mean(FP_Dpbon) + mean(TP_Dpbon)),
  recall = mean(TP_Dpbon) / (mean(TP_Dpbon) + mean(FN_Dpbon)),
  
  d_false_neg_rate = mean(FN_Dpbon) / (mean(FN_Dpbon) + mean(TP_Dpbon)), 
  d_false_pos_rate = mean(FP_Dpbon) / (mean(FP_Dpbon) + mean(TP_Dpbon))
)


summary_Dp <- HyDe_Dstat_counts %>% summarise(
  d_false_negatives = mean(FN_Dp),
  d_false_positives = mean(FP_Dp),
  d_true_negatives = mean(TN_Dp),
  d_true_positives = mean(TP_Dp),
  
  FNR = mean(FN_Dp) / (mean(FN_Dp) + mean(TP_Dp)),
  FPR = mean(FP_Dp) / (mean(FP_Dp) + mean(TN_Dp)),
  precision = mean(TP_Dp) / (mean(FP_Dp) + mean(TP_Dp)),
  recall = mean(TP_Dp) / (mean(TP_Dp) + mean(FN_Dp)),
  
  d_false_neg_rate = mean(FN_Dp) / (mean(FN_Dp) + mean(TP_Dp)), 
  d_false_pos_rate = mean(FP_Dp) / (mean(FP_Dp) + mean(TP_Dp))
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
  
  recall = mean(TP) / (mean(TP) + mean(FN)),
  precision = mean(TP) / (mean(TP) + mean(FP))
)


summary_MSC <- TICR_MSC_counts %>% summarise(
  false_negatives = mean(FN),
  false_positives = mean(FP),
  true_negatives = mean(TN),
  true_positives = mean(TP),
  FNR = mean(FN) / (mean(TP) + mean(FN)), 
  FPR = mean(FP) / (mean(TN) + mean(FP)),
  precision = mean(TP) / (mean(TP) + mean(FP)),
  recall = mean(TP) / (mean(TP) + mean(FN))
)

summary_MSC_bonferroni <- TICR_MSC_counts %>% summarise(
  false_negatives = mean(FN_bon),
  false_positives = mean(FP_bon),
  true_negatives = mean(TN_bon),
  true_positives = mean(TP_bon),
  FNR = mean(FN_bon) / (mean(TP_bon) + mean(FN_bon)), 
  FPR = mean(FP_bon) / (mean(TN_bon) + mean(FP_bon)),
  precision = mean(TP_bon) / (mean(TP_bon) + mean(FP_bon)),
  recall = mean(TP_bon) / (mean(TP_bon) + mean(FN_bon))
)


## replace Nan values
summary_HyDe[is.na(summary_HyDe)] = 0
summary_MSC[is.na(summary_MSC)] = 0
summary_D3[is.na(summary_D3)] = 0
summary_Dstat[is.na(summary_Dstat)] = 0
summary_Dp[is.na(summary_Dp)] = 0

summary_HyDe_bonferroni[is.na(summary_HyDe_bonferroni)] = 0
summary_MSC_bonferroni[is.na(summary_MSC_bonferroni)] = 0
summary_D3_bonferroni[is.na(summary_D3_bonferroni)] = 0
summary_Dstat_bonferroni[is.na(summary_Dstat_bonferroni)] = 0
summary_Dp_bonferroni[is.na(summary_Dp_bonferroni)] = 0

## scale sequence length to be / 10 to reflect kbp (as sequences of 100 bp are 
## generated per gene tree)
summary_HyDe["seq_length"] = summary_HyDe["seq_length"]/10
summary_HyDe_bonferroni["seq_length"] = summary_HyDe_bonferroni["seq_length"]/10

summary_D3["seq_length"] = summary_D3["seq_length"]/10
summary_D3_bonferroni["seq_length"] = summary_D3_bonferroni["seq_length"]/10

summary_Dp["seq_length"] = summary_Dp["seq_length"]/10
summary_Dp_bonferroni["seq_length"] = summary_Dp_bonferroni["seq_length"]/10

summary_Dstat["seq_length"] = summary_Dstat["seq_length"]/10
summary_Dstat_bonferroni["seq_length"] = summary_Dstat_bonferroni["seq_length"]/10

## function allows us to extract the legend to arrange legend for plotting as
## a grob later
get_only_legend <- function(plot) {
  plot_table <- ggplot_gtable(ggplot_build(plot))
  legend_plot <- which(sapply(plot_table$grobs, function(x) x$name) == "guide-box")
  legend <- plot_table$grobs[[legend_plot]]
  return(legend)
}

network_names = c("n4h1_0.1.net",
                  "n4h1_0.2.net",
                  "n4h1_0.3.net",
                  "n4h1_0.4.net",
                  "n4h1_0.5.net", #5
                  "n4h1_0.net",
                  "n4h1_introg.net",
                  "n5h2.net",
                  "n6h1.net",
                  "n8h3.net", #10
                  "n10h2.net",
                  "n10major.net",
                  "n10orange.net",
                  "n10red.net", #14
                  "n15blue.net",
                  "n15h3.net",
                  "n15major.net",
                  "n15orange.net", #18
                  "n15red.net", #19
                  "n25h5.net",#20
                  "n50h10.net",
                  "n5h2_overlap.net")

for (significance in c("alpha05", "bonferroni")) {
  hyde_plot_list = list()  
  d_stat_plot_list = list()
  ticr_plot_list = list()
  msc_plot_list = list()
  d3_plot_list = list()
  dp_plot_list = list()
for (method_name in c("MSCquartets", "D-statistic", "D3", "Dp", "HyDe")) {
  for (i in 1:length(network_names)) {
  if (significance == "alpha05") {
  if (method_name == "TICR") {
    subset_object = subset(summary_TICR, network_name %in% c(network_names[i]))
  } else if (method_name == "MSCquartets") {
    subset_object = subset(summary_MSC, network_name %in% c(network_names[i]) )
  } else if (method_name == "D-statistic") {
    subset_object = subset(summary_Dstat, network_name %in% c(network_names[i]))
  } else if (method_name == "D3") {
    subset_object = subset(summary_D3, network_name %in% c(network_names[i]))
  } else if (method_name == "Dp") {
    subset_object = subset(summary_Dp, network_name %in% c(network_names[i]))
  } else if (method_name == "HyDe") {
    subset_object = subset(summary_HyDe, network_name %in% c(network_names[i]))
  }
  }
    
  if (significance == "bonferroni") {
    if (method_name == "TICR") {
      subset_object = subset(summary_TICR_bonferroni, network_name %in% c(network_names[i]))
    } else if (method_name == "MSCquartets") {
      subset_object = subset(summary_MSC_bonferroni, network_name %in% c(network_names[i]) )
    } else if (method_name == "D-statistic") {
      subset_object = subset(summary_Dstat_bonferroni, network_name %in% c(network_names[i]))
    } else if (method_name == "D3") {
      subset_object = subset(summary_D3_bonferroni, network_name %in% c(network_names[i]))
    } else if (method_name == "Dp") {
      subset_object = subset(summary_Dp_bonferroni, network_name %in% c(network_names[i]))
    } else if (method_name == "HyDe") {
      subset_object = subset(summary_HyDe_bonferroni, network_name %in% c(network_names[i]))
    }
  }
    
  new_plot = ggplot(subset_object, aes(x = seq_length)) +
    geom_line(aes(y = precision, color = 'Precision')) + geom_point(aes(y = precision, color = 'Precision')) +
    geom_errorbar(
      data = subset_object,
      aes(seq_length, precision, ymin = precision - error(precision), ymax = precision + error(precision), color = 'Precision'),
      position=position_dodge(.9),
      width = 0.2
    ) + 
    geom_line(aes(y = FNR, color = 'False Negative Rate')) + geom_point(aes(y = FNR, color = 'False Negative Rate')) +
    geom_errorbar(
      data = subset_object,
      aes(seq_length, FNR, ymin = FNR - error(FNR), ymax = FNR + error(FNR), color = 'False Negative Rate'),
      width = 0.2
    ) +
    geom_line(aes(y = FPR, color = 'False Positive Rate')) + geom_point(aes(y = FPR, color = 'False Positive Rate')) +
    geom_errorbar(
      data = subset_object,
      aes(seq_length, FPR, ymin = FPR - error(FPR), ymax = FPR + error(FPR), color = 'False Positive Rate'),
      width = 0.2
    ) + theme_classic() +
    scale_color_manual(name='', breaks=c("Precision", "False Positive Rate", "False Negative Rate", "Wrong Hybrid Rate"),
                                             values=c("Precision"="#003f5c", "False Positive Rate"="#ffa600", "False Negative Rate"="#ef5675", "Wrong Hybrid Rate" = "#7a5195")) +
    theme(axis.title = element_blank()) + theme(legend.position = "none") +  ylim(0,1)   # + theme(legend.position="right") # 
  
    if (i %in% c(5,10,14,19,20)) {
   # Do nothing new_plot = new_plot +
    } else {
       new_plot = new_plot + theme(axis.text.x=element_blank())
    }
  
 if (method_name == "MSCquartets") {
    msc_plot_list[[i]] = new_plot
  } else if (method_name == "D-statistic") {
    d_stat_plot_list[[i]] = new_plot + theme(axis.text.y=element_blank())
  } else if (method_name == "D3") {
    d3_plot_list[[i]] = new_plot + theme(axis.text.y=element_blank())
  } else if (method_name == "Dp") {
    dp_plot_list[[i]] = new_plot + theme(axis.text.y=element_blank())
  } else if (method_name == "HyDe") {
    hyde_plot_list[[i]] = new_plot + theme(axis.text.y=element_blank()) +
      geom_line(aes(y = WHR, color = 'Wrong Hybrid Rate')) + geom_point(aes(y = WHR, color = 'Wrong Hybrid Rate')) + 
      geom_errorbar(
        data = subset_object,
        aes(seq_length, WHR, ymin = WHR - error(WHR), ymax = WHR + error(WHR), color = 'Hybridization assigned to incorrect taxon'),
        width = 0.2
      ) + scale_color_manual(name='', breaks=c("Precision", "False Positive Rate", "False Negative Rate", "Wrong Hybrid Rate"),
                                              values=c("Precision"="#003f5c", "False Positive Rate"="#ffa600", "False Negative Rate"="#ef5675", "Wrong Hybrid Rate" = "#7a5195")) 
  }
  
  }
}
  
  lg = get_only_legend(hyde_plot_list[[1]] + theme(legend.position = "bottom"))  
  
  plotN4H1 <- grid.arrange(arrangeGrob(arrangeGrob(msc_plot_list[[6]], left = "0"), 
                                       arrangeGrob(msc_plot_list[[1]], left="0.1"),
                                       arrangeGrob(msc_plot_list[[2]], left="0.2"),
                                       arrangeGrob(msc_plot_list[[3]], left="0.3"),
                                       arrangeGrob(msc_plot_list[[4]], left="0.4"),
                                       arrangeGrob(msc_plot_list[[5]], left="0.5"), 
                                       top = grid::textGrob("MSCquartets", hjust = 0.2), 
                                       bottom = grid::textGrob("  Number of\n Gene Trees", hjust = 0.2),heights = c(1,1,1,1,1,1.2), 
                                       ncol = 1), 
                           arrangeGrob(hyde_plot_list[[6]], hyde_plot_list[[1]], hyde_plot_list[[2]], 
                                       hyde_plot_list[[3]], hyde_plot_list[[4]], hyde_plot_list[[5]], 
                                       heights = c(1,1,1,1,1,1.2), top="HyDe", 
                                       bottom = "Sequence Length\n (kbp)", ncol = 1),
                           arrangeGrob(d_stat_plot_list[[6]], d_stat_plot_list[[1]], d_stat_plot_list[[2]], 
                                       d_stat_plot_list[[3]], d_stat_plot_list[[4]], d_stat_plot_list[[5]], 
                                       ncol = 1, heights = c(1,1,1,1,1,1.2), bottom = "Sequence Length\n (kbp)", 
                                       top="Patterson's D-Statistic"),
                           #arrangeGrob(dp_plot_list[[6]],dp_plot_list[[1]],dp_plot_list[[2]],dp_plot_list[[3]],dp_plot_list[[4]],dp_plot_list[[5]], bottom = "Sequence Length (kbp)", top="Dp", ncol = 1),
                           arrangeGrob(d3_plot_list[[6]],d3_plot_list[[1]],d3_plot_list[[2]],
                                       d3_plot_list[[3]],d3_plot_list[[4]],d3_plot_list[[5]], 
                                       bottom = "Sequence Length\n (kbp)", top="D3", ncol = 1, 
                                       heights = c(1,1,1,1,1,1.2)),  left="Mixing Parameter (γ)",
                           ncol = 4, widths = c(1.2,1,1,1))
  
  plotN4H1N5H2N8H3 <- grid.arrange( arrangeGrob(heights = c(1,1,1.2), arrangeGrob(msc_plot_list[[7]], left="n4h1 introgression"), arrangeGrob(msc_plot_list[[22]], left="n5h2"), arrangeGrob(msc_plot_list[[10]], left="n8h3"), top = grid::textGrob("MSCquartets", hjust = 0.2), bottom = grid::textGrob("  Number of\n Gene Trees", hjust = 0.2), ncol = 1), 
                                    arrangeGrob(heights = c(1,1,1.2), hyde_plot_list[[7]],  hyde_plot_list[[8]], hyde_plot_list[[10]], top="HyDe", bottom="Sequence Length\n (kbp)", ncol = 1),
                                    arrangeGrob(heights = c(1,1,1.2), d_stat_plot_list[[7]],  d_stat_plot_list[[8]], d_stat_plot_list[[10]], ncol = 1, bottom="Sequence Length\n (kbp)", top="Patterson's D-Statistic"),
                                    #arrangeGrob(dp_plot_list[[7]],dp_plot_list[[8]],dp_plot_list[[10]], top="Dp",bottom="Sequence Length\n (kbp)", ncol = 1),
                                    arrangeGrob(heights = c(1,1,1.2), d3_plot_list[[7]],d3_plot_list[[8]],d3_plot_list[[10]], top="D3",bottom="Sequence Length\n (kbp)", ncol = 1),  ncol=4,  widths = c(1.2,1,1,1))
  
  plotN10 <- grid.arrange( arrangeGrob(heights = c(1,1,1.2), arrangeGrob(msc_plot_list[[11]], left = "n10h2"), arrangeGrob(msc_plot_list[[13]], left = "n10h1 shallow"), arrangeGrob(msc_plot_list[[14]], left = "n10h1 deep"), top = grid::textGrob("MSCquartets", hjust = 0.2), bottom = grid::textGrob("  Number of\n Gene Trees", hjust = 0.2), ncol = 1), 
                           arrangeGrob(heights = c(1,1,1.2), hyde_plot_list[[11]], hyde_plot_list[[13]], hyde_plot_list[[14]], top="HyDe", bottom="Sequence Length\n (kbp)", ncol = 1),
                           arrangeGrob(heights = c(1,1,1.2), d_stat_plot_list[[11]], d_stat_plot_list[[13]], d_stat_plot_list[[14]], ncol = 1,  bottom="Sequence Length\n (kbp)",top="Patterson's D-Statistic"),
                           #arrangeGrob(dp_plot_list[[11]],dp_plot_list[[13]],dp_plot_list[[14]], bottom="Sequence Length (kbp)", top="Dp", ncol = 1),
                           arrangeGrob(heights = c(1,1,1.2), d3_plot_list[[11]],d3_plot_list[[13]],d3_plot_list[[14]],  bottom="Sequence Length\n (kbp)",top="D3", ncol = 1), ncol=4,  widths = c(1.2,1,1,1))
  
  plotN15 <- grid.arrange(arrangeGrob(heights = c(1,1,1,1.2), arrangeGrob(msc_plot_list[[16]], left = "n15h3"), arrangeGrob(msc_plot_list[[15]], left = "n15h1 deep"),arrangeGrob(msc_plot_list[[18]],left="n15h1 shallow"), arrangeGrob(msc_plot_list[[19]],left="n15h1 intermediate"),  top = grid::textGrob("MSCquartets", hjust = 0.2), bottom = grid::textGrob("  Number of\n Gene Trees", hjust = 0.2), ncol = 1), 
                          arrangeGrob(heights = c(1,1,1,1.2), hyde_plot_list[[16]], hyde_plot_list[[15]], hyde_plot_list[[18]], hyde_plot_list[[19]], bottom="Sequence Length\n (kbp)", top="HyDe", ncol = 1),
                          arrangeGrob(heights = c(1,1,1,1.2), d_stat_plot_list[[16]], d_stat_plot_list[[15]], d_stat_plot_list[[18]], d_stat_plot_list[[19]], ncol = 1,  bottom="Sequence Length\n (kbp)",top="Patterson's D-Statistic"),
                          #arrangeGrob(dp_plot_list[[16]],dp_plot_list[[15]],dp_plot_list[[18]],dp_plot_list[[19]],  bottom="Sequence Length (kbp)",top="Dp", ncol = 1),
                          arrangeGrob(heights = c(1,1,1,1.2),d3_plot_list[[16]],d3_plot_list[[15]],d3_plot_list[[18]],d3_plot_list[[19]],  bottom="Sequence Length\n (kbp)",top="D3", ncol = 1), ncol=4,  widths = c(1.2,1,1,1))
  
  plotN25 <- grid.arrange( arrangeGrob(heights = c(1.2),msc_plot_list[[20]],  top = grid::textGrob("MSCquartets", hjust = 0.3), bottom = grid::textGrob("  Number of\n Gene Trees", hjust = 0.3), ncol = 1), 
                           arrangeGrob( heights = c(1.2),hyde_plot_list[[20]], top="HyDe", bottom="Sequence Length\n (kbp)", ncol = 1),
                           arrangeGrob(heights = c(1.2), d_stat_plot_list[[20]], ncol = 1, bottom="Sequence Length\n (kbp)", top="Patterson's D-Statistic"),
                           #arrangeGrob(dp_plot_list[[20]], top="Dp", bottom="Sequence Length (kbp)", ncol = 1),
                           arrangeGrob(heights = c(1.2),d3_plot_list[[20]], top="D3",  bottom="Sequence Length\n (kbp)",ncol = 1), left = "n25h5", ncol=4, widths = c(1.2,1,1,1))
  
  plotN4H1_legend <- grid.arrange(plotN4H1, lg, nrow=2, heights=c(10,1))
  plotN4H1N5H2N8H3_legend <- grid.arrange(plotN4H1N5H2N8H3, lg, nrow=2, heights=c(8,1))
  plotN10_legend <- grid.arrange(plotN10, lg, nrow=2, heights=c(8,1))
  plotN15_legend <- grid.arrange(plotN15, lg, nrow=2, heights=c(9,1))
  plotN25_legend <- grid.arrange(plotN25, lg, nrow=2, heights=c(5,1))
  
  setwd("/Users/bjorner/GitHub/phylo-microbes")
  if (significance == "alpha05") {
  ggsave(filename = "plotN4H1_05.png", plot = plotN4H1_legend, width = 8, height = 8)
  ggsave(filename = "plotN4H1N5H2N8H3_05.png", plot = plotN4H1N5H2N8H3_legend, width = 8, height = 6)
  ggsave(filename = "plotN10_05.png", plot = plotN10_legend, width = 8, height = 6)
  ggsave(filename = "plotN15_05.png", plot = plotN15_legend, width = 8, height = 8)
  ggsave(filename = "plotN25_05.png", plot = plotN25_legend, width = 8, height = 3)
  } else if (significance == "bonferroni") {
    ggsave(filename = "plotN4H1_bonferroni.png", plot = plotN4H1_legend, width = 8, height = 8)
    ggsave(filename = "plotN4H1N5H2N8H3_bonferroni.png", plot = plotN4H1N5H2N8H3_legend, width = 8, height = 6)
    ggsave(filename = "plotN10_bonferroni.png", plot = plotN10_legend, width = 8, height = 6)
    ggsave(filename = "plotN15_bonferroni.png", plot = plotN15_legend, width = 8, height = 8)
    ggsave(filename = "plotN25_bonferroni.png", plot = plotN25_legend, width = 8, height = 3)
  } else {
    # print error message if necessary
  }
}