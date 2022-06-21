# plots the summary tables of MSC quartets and TICR FP/FN
library(ggplot2)

setwd("~/GitHub/phylo-microbes/output/summary/output")

# n10summarytable.csv
# n15summarytable.csv
# n10orange summary table?

file_used = "n15summarytable_3.csv"

summary_table = read.table("n15summarytable_3.csv", header =TRUE, sep = ",")

Number_of_Gene_Trees = c(30,100,300,1000,3000)
#Number_of_Gene_Trees = c(50,100,500,1000)

if (length(Number_of_Gene_Trees) == 5) {
  #avg_ticr_fp = c(sum(summary_table$ticr_fp[1:30])/sum(summary_table$true_neg[1:30]), 
  #                sum(summary_table$ticr_fp[31:60])/sum(summary_table$true_neg[31:60]), 
  #                sum(summary_table$ticr_fp[61:90])/sum(summary_table$true_neg[61:90]), 
  #                sum(summary_table$ticr_fp[91:120])/sum(summary_table$true_neg[91:120]), 
  #                sum(summary_table$ticr_fp[121:150])/sum(summary_table$true_neg[121:150]))
  # avg_ticr_fn = c(sum(summary_table$ticr_fn[1:30])/sum(summary_table$true_pos[1:30]), 
  #               sum(summary_table$ticr_fn[31:60])/sum(summary_table$true_pos[31:60]), 
  #               sum(summary_table$ticr_fn[61:90])/sum(summary_table$true_pos[61:90]), 
  #               sum(summary_table$ticr_fn[91:120])/sum(summary_table$true_pos[91:120]), 
  #               sum(summary_table$ticr_fn[121:150])/sum(summary_table$true_pos[121:150]))
  avg_msc_fp = c(sum(summary_table$msc_fp[1:30])/sum(summary_table$true_neg[1:30]), 
                 sum(summary_table$msc_fp[31:60])/sum(summary_table$true_neg[31:60]), 
                 sum(summary_table$msc_fp[61:90])/sum(summary_table$true_neg[61:90]), 
                 sum(summary_table$msc_fp[91:120])/sum(summary_table$true_neg[91:120]), 
                 sum(summary_table$msc_fp[121:150])/sum(summary_table$true_neg[121:150]))
  avg_msc_fn = c(sum(summary_table$msc_fn[1:30])/sum(summary_table$true_pos[1:30]), 
                 sum(summary_table$msc_fn[31:60])/sum(summary_table$true_pos[31:60]), 
                 sum(summary_table$msc_fn[61:90])/sum(summary_table$true_pos[61:90]), 
                 sum(summary_table$msc_fn[91:120])/sum(summary_table$true_pos[91:120]), 
                 sum(summary_table$msc_fn[121:150])/sum(summary_table$true_pos[121:150]))
} else {
  #avg_ticr_fp = c(sum(summary_table$ticr_fp[1:30])/sum(summary_table$true_neg[1:30]), 
  #                    sum(summary_table$ticr_fp[31:60])/sum(summary_table$true_neg[31:60]), 
  #                    sum(summary_table$ticr_fp[61:90])/sum(summary_table$true_neg[61:90]), 
  #                    sum(summary_table$ticr_fp[91:120])/sum(summary_table$true_neg[91:120]))
  # avg_ticr_fn = c(sum(summary_table$ticr_fn[1:30])/sum(summary_table$true_pos[1:30]), 
  #                    sum(summary_table$ticr_fn[31:60])/sum(summary_table$true_pos[31:60]), 
  #                    sum(summary_table$ticr_fn[61:90])/sum(summary_table$true_pos[61:90]), 
  #                   sum(summary_table$ticr_fn[91:120])/sum(summary_table$true_pos[91:120]))
  avg_msc_fp = c(sum(summary_table$msc_fp[1:30])/sum(summary_table$true_neg[1:30]), 
                 sum(summary_table$msc_fp[31:60])/sum(summary_table$true_neg[31:60]), 
                 sum(summary_table$msc_fp[61:90])/sum(summary_table$true_neg[61:90]), 
                 sum(summary_table$msc_fp[91:120])/sum(summary_table$true_neg[91:120]))
  avg_msc_fn = c(sum(summary_table$msc_fn[1:30])/sum(summary_table$true_pos[1:30]), 
                 sum(summary_table$msc_fn[31:60])/sum(summary_table$true_pos[31:60]), 
                 sum(summary_table$msc_fn[61:90])/sum(summary_table$true_pos[61:90]), 
                 sum(summary_table$msc_fn[91:120])/sum(summary_table$true_pos[91:120]))
}


df2 <- data.frame(method=rep(c("ticr_fp", "ticr_fn", "msc_fp", "msc_fn"), each=5),
                  trees=rep(Number_of_Gene_Trees,4),
                  False_Discovery_Rate=c(avg_ticr_fp, avg_ticr_fn, avg_msc_fp, avg_msc_fn))

ggplot(data = df2, aes(x=trees, y=num_false)) + geom_line(aes(colour=method))

df3 <- data.frame(Measure=rep(c("False Positives", "False Negatives"), each=5),
                  Number_Gene_Trees=rep(Number_of_Gene_Trees,4),
                  False_Discovery_Rate=c(avg_msc_fp, avg_msc_fn))

p = ggplot(data = df3, aes(x=Number_Gene_Trees, y=False_Discovery_Rate)) + geom_line(aes(colour=Measure))

p + ggtitle("Performance of MSCQuartets on N15H3 Network") +
  ylab("False Discovery Rate") + xlab("Number of Gene Trees")

