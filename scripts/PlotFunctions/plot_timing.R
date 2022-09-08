# with HyDe, D-Stat (ABBA-BABA), TICR, MSCQuartets

library(gridExtra)
library(dplyr)
library(ggplot2)

## method ## network ## network size ## gene_trees/seq_length ## trial ## time_taken (seconds)
setwd("~/GitHub/phylo-microbes/output/ms_out/output08022022/")

# GitHub/phylo-microbes/output/ms_out/output08022022/time_summary.csv

timingresults <- "time_summary.csv"
timingresults <- "/Users/bjorner/GitHub/phylo-microbes/output/ms_out/time_summary_ms_paper.csv"

time_data <- read.csv(timingresults)
time_grouped <- time_data %>% group_by(method, netsize, gt_number)

# Calculate summary values of time taken for all functions

# For all methods, we calculate
# (by network size and the number of gene trees or sequence length)
# time taken (mean)
# time taken (standard deviation)

summary_times <- time_grouped %>% summarise(
  time_in_s = mean(cpu_time),
  time_sd = sd(cpu_time)
  
)

# network_names <- c("n10", "n10red", "n10orange", "n15",
#                   "n15red", "n15orange", "n15blue")
# network_sizes <- c(4, 5, 8, 10, 15, 25)
methods   <- c("HyDe", "TICR", "MSC")
time_plot <- list()

# Plots are arranged with number of taxa on the x axis,
# and number of gene trees forming separate lines on the plot,
# with the y-axis as time as measured in seconds.
for (i in 1:length(methods)) {
  
  subset_object <- subset(subset_24_and_below, method %in% c(methods[i]))
  
  time_plot_curr <- ggplot(data = subset_object, mapping = aes(x = netsize, y = time_in_s, color=factor(gt_number))) +
  geom_line() +geom_point() + ylab("CPU time (s)") + xlab("Network Size (number of taxa)") + ggtitle("") +  geom_errorbar(
    data = subset_object,
    aes(netsize, time_in_s, ymin = time_in_s - time_sd, ymax = time_in_s + time_sd),
    width = 0.2) + ggtitle(methods[i]) + labs(colour = "Number of Gene Trees") +
  theme_classic();
  
  time_plot[[i]] <- time_plot_curr
}
#HYDE PLOT
subset_object <- subset(summary_times, "HyDe" %in% c(methods[i]))

HyDe_plot <- ggplot(data = subset_object, mapping = aes(x = netsize, y = time_in_s, color=factor(gt_number))) +
  geom_line() +geom_point() + ylab("CPU time (s)") + xlab("Network Size (number of taxa)") + ggtitle("") +  geom_errorbar(
    data = subset_object,
    aes(netsize, time_in_s, ymin = time_in_s - time_sd, ymax = time_in_s + time_sd),
    width = 0.2) + ggtitle("HyDe") + labs(colour = "Sequence Length (bp)") +
  theme_classic();

# TICR PLOT
subset_object <- subset(summary_times, "TICR" %in% c(methods[i]))

TICR_plot <- ggplot(data = subset_object, mapping = aes(x = netsize, y = time_in_s, color=factor(gt_number))) +
  geom_line() +geom_point() + ylab("CPU time (s)") + xlab("Network Size (number of taxa)") + ggtitle("") +  geom_errorbar(
    data = subset_object,
    aes(netsize, time_in_s, ymin = time_in_s - time_sd, ymax = time_in_s + time_sd),
    width = 0.2) + ggtitle("TICR") + labs(colour = "Number of Gene Trees") +
  theme_classic();

#MSC PLOT
subset_object <- subset(summary_times, "MSC" %in% c(methods[i]))

MSC_plot <- ggplot(data = subset_object, mapping = aes(x = netsize, y = time_in_s, color=factor(gt_number))) +
  geom_line() +geom_point() + ylab("CPU time (s)") + xlab("Network Size (number of taxa)") + ggtitle("") +  geom_errorbar(
    data = subset_object,
    aes(netsize, time_in_s, ymin = time_in_s - time_sd, ymax = time_in_s + time_sd),
    width = 0.2) + ggtitle("MSCquartets") + labs(colour = "Number of Gene Trees") +
  theme_classic();




# plots are arranged with a single plot corresponding to the time for each method, 

# methods   <- c("HyDe", "TICR", "MSCquartets")

grid.arrange(time_plot[[1]], time_plot[[2]], time_plot[[3]], common.legend = TRUE, legend ="right")

grid.arrange(HyDe_plot, TICR_plot, MSC_plot)
