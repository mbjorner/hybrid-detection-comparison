# with HyDe, D-Stat (ABBA-BABA), TICR, MSCQuartets

library(gridExtra)

## method ## network ## network size ## gene_trees/seq_length ## trial ## time_taken (seconds)
setwd("~/GitHub/phylo-microbes/output/timing")
timingresults <- "time_comparison.csv"

time_data <- read.csv(timingresults)
time_grouped <- time_data %>% group_by(method, network, gene_trees)

# Calculate summary values of time taken for all functions

# For all methods, we calculate
# (by network size and the number of gene trees or sequence length)
# time taken (mean)
# time taken (standard deviation)

summary_times <- time_grouped %>% summarise(
  time = mean(time_taken),
  time_sd = stdev(time_taken)
)

network_names <- c("n10", "n10red", "n10orange", "n15",
                   "n15red", "n15orange", "n15blue")
network_sizes <- c(4, 5, 8, 10, 15, 25)
methods   <- c("HyDe", "D-statistic", "D3", "TICR", "MSCquartets")
time_plot <- list()

# Plots are arranged with number of taxa on the x axis,
# and number of gene trees forming separate lines on the plot,
# with the y-axis as time as measured in seconds.

for (i in seq_len(methods)) {
  #### Create HyDe plot
  subset_object <- subset(summary_times, method %in% c(methods[i]))

  time_plot_curr <- ggplot(subset_object, aes(x = network_size)) +
  geom_line(aes(y <- time), color = "darkred") +
  geom_point(aes(y = WHR), color = "darkred") +
  geom_errorbar(
    data = subset_object,
    aes(gene_trees, time, ymin = time - time_sd, ymax = time + time_sd),
    colour = 'darkred',
    width = 0.2) +
  theme_classic() + theme(axis.title = element_blank()) + ylim(0,1) + title(methods[i])

  time_plot[[i]] <- time_plot_curr
}

# plots are arranged with a single plot corresponding to the time for each method, 

# methods   <- c("HyDe", "D-statistic", "D3", "TICR", "MSCquartets")

grid.arrange(time_plot[1], time_plot[2], time_plot[3], time_plot[4], time_plot[5])

