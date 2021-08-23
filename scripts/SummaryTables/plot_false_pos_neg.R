# plots the summary tables of MSC quartets and TICR FP/FN
library(ggplot2)

setwd("GitHub/phylo-microbes/output/summary/output")

# n10summarytable.csv
# n15summarytable.csv

summary_table = read.table("n15summarytable.csv", header =TRUE, sep = ",")

num_trees = c(30,100,300,1000,3000)


avg_ticr_fp = c(sum(summary_table$ticr_fp[1:30]), sum(summary_table$ticr_fp[31:60]), 
                sum(summary_table$ticr_fp[61:90]), sum(summary_table$ticr_fp[91:120]), 
                sum(summary_table$ticr_fp[121:150]))
avg_ticr_fn = c(sum(summary_table$ticr_fn[1:30]), sum(summary_table$ticr_fn[31:60]), 
                sum(summary_table$ticr_fn[61:90]), sum(summary_table$ticr_fn[91:120]), 
                sum(summary_table$ticr_fn[121:150]))
avg_msc_fp = c(sum(summary_table$msc_fp[1:30]), sum(summary_table$msc_fp[31:60]), 
               sum(summary_table$msc_fp[61:90]), sum(summary_table$msc_fp[91:120]), 
               sum(summary_table$msc_fp[121:150]))
avg_msc_fn = c(sum(summary_table$msc_fn[1:30]), sum(summary_table$msc_fn[31:60]), 
               sum(summary_table$msc_fn[61:90]), sum(summary_table$msc_fn[91:120]), 
               sum(summary_table$msc_fn[121:150]))

df2 <- data.frame(method=rep(c("ticr_fp", "ticr_fn", "msc_fp", "msc_fn"), each=5),
                  trees=rep(num_trees,4),
                  num_false=c(avg_ticr_fp, avg_ticr_fn, avg_msc_fp, avg_msc_fn))

ggplot(data = df2, aes(x=trees, y=num_false)) + geom_line(aes(colour=method))
