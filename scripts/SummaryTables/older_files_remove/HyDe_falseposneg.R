
library(ggplot2)
install.packages("devtools")
library(devtools)
install_github("kassambara/easyGgplot2")
library(dplyr)
library(easyGgplot2)

setwd("~/GitHub/phylo-microbes/output/output_HyDe_seqvariants")

# files:

# n10summarytable_HyDe.csv
# n15summarytable_HyDe.csv

Number_of_Gene_Trees = c(n30,n100,n300,n1000,n3000)

file_used = "n10summarytable_HyDe.csv"

summary_table = read.table(file_used, header =TRUE, sep = ",")


mean_data <- group_by(summary_table, gene_trees, seq_length) %>%
  summarise(HyDe_fpr = (mean(HyDe_fp, na.rm = TRUE) / (mean(HyDe_fp, na.rm = TRUE) + mean(HyDe_tn, na.rm = TRUE))),
            HyDe_fnr = (mean(HyDe_fn, na.rm = TRUE) / ((mean(HyDe_tp, na.rm = TRUE) + mean(HyDe_fn, na.rm = TRUE)))))

# add false positive graph
p = ggplot(data = mean_data, aes(x=gene_trees, y=HyDe_fpr)) + geom_line(aes(colour=as.factor(seq_length)))

# add false negative graph

Measure = rep(c("False Positives", "False Negatives"), 4)
p = ggplot(data = mean_data, aes(x=gene_trees, y=c(HyDe_fpr, HyDe_fnr))) + geom_line(aes(colour=Measure))


p  + ggtitle("Performance of TICR on N15H3 Network") +
  ylab("Mean p-values") + xlab("Number of Gene Trees")


df <- data.frame(x=rep(1:5, 9), val=sample(1:100, 45), 
                 variable=rep(paste0("category", 1:9), each=5))
