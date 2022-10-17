# Creates a plot comparing the timing of HyDe, MSCquartets, and TICR

library(gridExtra)
library(dplyr)
library(ggplot2)
library(RColorBrewer)


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

summary_times_to25 = subset(summary_times, netsize < 50)
methods   <- c("HyDe", "TICR", "MSC")
time_plot <- list()

# Plots are arranged with number of taxa on the x axis,
# and number of gene trees forming separate lines on the plot,
# with the y-axis as time as measured in seconds.
for (i in 1:length(methods)) {
  subset_object <- subset(summary_times_to25, method %in% c(methods[i]))
  
  myColors <- brewer.pal(6,"Purples")
  names(myColors) <- levels(subset_object$gt_number)
  colScale = 0
  if (i==1) { # HyDe; change colors to reflect sequence lengths, not #gt
    myColors <- brewer.pal(6,"Greens")
    names(myColors) <- levels(subset_object$gt_number)
    colScale <- scale_colour_manual(name = "Sequence Length",values = myColors)
  } else {
    colScale <- scale_colour_manual(name = "Number of Gene Trees",values = myColors)
  }
  
  time_plot_curr <- ggplot(data = subset_object, mapping = aes(x = netsize, y = time_in_s, color=factor(gt_number))) +
  geom_line() + geom_point() + ylab("CPU time (s)") + xlab("Network Size (number of taxa)") + ggtitle("") +  
  geom_errorbar(
    data = subset_object,
    aes(netsize, time_in_s, ymin = time_in_s - time_sd, ymax = time_in_s + time_sd),
    width = 0.2) +
  theme_classic();

  if (i==1) { # HyDe
    time_plot[[i]] <- time_plot_curr + colScale  + theme(legend.position = "none") + ggtitle("HyDe")
  } else if (i==2) {
    time_plot[[i]] <- time_plot_curr + colScale+ theme(axis.title.y = element_blank()) + theme(legend.position = "none") + ylim(0,6200) + ggtitle("TICR")
  } else {
    time_plot[[i]] <- time_plot_curr + colScale+ theme(axis.title.y = element_blank())  + theme(legend.position = "none") + ylim(0,6200) + ggtitle("MSCquartets")
  }
}

get_only_legend <- function(plot) {
  plot_table <- ggplot_gtable(ggplot_build(plot))
  legend_plot <- which(sapply(plot_table$grobs, function(x) x$name) == "guide-box")
  legend <- plot_table$grobs[[legend_plot]]
  return(legend)
}

lg_hyde = get_only_legend(time_plot[[1]] + theme(legend.position = "bottom")  + 
                            theme(legend.text=element_text(size=rel(0.6)))  + 
                            theme(legend.title=element_text(size=rel(0.6))))
lg_mscticr = get_only_legend(time_plot[[3]] + theme(legend.position = "bottom")  +  
                               theme(legend.text=element_text(size=rel(0.6))) + 
                               theme(legend.title=element_text(size=rel(0.6))))

plot_times <- grid.arrange(time_plot[[1]], time_plot[[3]], time_plot[[2]], 
                           heights = c(1.2), widths=c(1,1,1), nrow=1)
# create for spacing's sake
dummyplot <- plot.new()
plot_times_legend <- grid.arrange(plot_times, arrangeGrob(lg_hyde, dummyplot, 
                                              lg_mscticr, nrow=1, widths=c(1,0.25,1.75)), 
                                  nrow=2, heights=c(5,1))

plot_times_legend
setwd("~/GitHub/phylo-microbes/")
ggsave(filename = "plot_times_with_legend_test.png", plot = plot_times_legend, 
       width = 8, height = 3)
