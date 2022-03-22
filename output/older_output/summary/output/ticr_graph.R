# goal is to plot side by side violin plots or box plots or just averages idk

library(ggplot2)
install.packages("devtools")
library(devtools)
install_github("kassambara/easyGgplot2")
library(dplyr)
library(easyGgplot2)

setwd("~/GitHub/phylo-microbes/output/output_ticr")

# files:

# n10_TICR_results_withQMC.csv
# n15_TICR_results_withQMC.csv

Number_of_Gene_Trees = c(n30,n100,n300,n1000,n3000)

file_used = "n15_TICR_results_withQMC.csv"

summary_table = read.table(file_used, header =TRUE, sep = ",")


mean_data <- group_by(summary_table, gene_trees) %>%
  summarise(ticr_pVal = mean(ticr_pVal, na.rm = TRUE))

p = ggplot2.lineplot(data=mean_data,
                     xName="gene_trees",
                     yName="ticr_pVal")

plot(mean_data, log="y")


p  + ggtitle("Performance of TICR on N15H3 Network") +
  ylab("Mean p-values") + xlab("Number of Gene Trees") + scale_y_continuous(trans='log2')

boxplot(summary_table$ticr_pVal ~ summary_table$gene_trees)

p = ggplot2.lineplot(data=summary_table,
                xName="gene_trees",
                yName="ticr_pVal", log = "y")

p  + ggtitle("Performance of TICR on N15H3 Network") +
  ylab("p-values") + xlab("Number of Gene Trees")

a_n30 = summary_table$ticr_pVal[1:30]
b_n100 = summary_table$ticr_pVal[31:60]
c_n300 = summary_table$ticr_pVal[61:90]
d_n1000 = summary_table$ticr_pVal[91:120]
e_n3000 = summary_table$ticr_pVal[121:150]

data1 = data.frame(a_n30, b_n100, c_n300, d_n1000, e_n3000)


x=gene_trees
y=ticr_pVal

average_nTrees30 = mean(summary_table$ticr_pVal[1:30])
average_nTrees100 =  mean(summary_table$ticr_pVal[31:60])
average_nTrees300 =  mean(summary_table$ticr_pVal[61:90])
average_nTrees1000 = mean( summary_table$ticr_pVal[91:120])
average_nTrees3000 = mean( summary_table$ticr_pVal[121:150])


p = ggplot(data = data1, aes(x=c("a_n30", "b_n100", "c_n300", "d_n1000", "e_n3000"),y=pvalues)) + geom_violin()

p + ggtitle("Performance of TICR on N10H2 Network") +
  ylab("P value") + xlab("Number of Gene Trees")




