# Marianne Bjorner
# 07SEP2022
# Visualization using ggtree for annotating phylogenetic trees
# with accompanying data related to hybridizations

# Idea: heatmap describing the number of hybridizations attached to each
# taxa

if(!require(installr)) {
  install.packages("installr"); 
  require(installr)
} #load / install+load installr

updateR()

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("ggtree")

library(ggtree)
library(ggplot2)
install.packages("ggnewscale")
library(ggnewscale)

browseVignettes("ggtree")


bee_tree <- "/Users/bjorner/DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/species_trees/concatenation_trees/iqtree2_consensus_80p_867loci.newick"
tree <- read.tree(bee_tree)
circ <- ggtree(tree)

p1 <- ggtree(tree) + geom_tiplab() + hexpand(.4)
p1

p <- ggtree(tree, branch.length = "none") + 
  geom_tiplab() + theme(legend.position='none')
p


# TODO: plot HyDe, MSC, TICR results side-by-side, maybe as a heat map?

# Step 1: create dataframe for heatmap based on results of MSC, TICR, etc.

# import MSC, HyDe results
TICR_results <- 
HyDe_results <- 


p1 <- gheatmap(circ, df, offset=.8, width=.2,
               colnames_angle=95, colnames_offset_y = .25) +
  scale_fill_viridis_d(option="D", name="discrete\nvalue")

nwk <- system.file("extdata", "sample.nwk", package="treeio")

tree <- read.tree(nwk)
circ <- ggtree(tree, layout = "circular")

df <- data.frame(first=c("a", "b", "a", "c", "d", "d", "a", 
                         "b", "e", "e", "f", "c", "f"),
                 second= c("z", "z", "z", "z", "y", "y", 
                           "y", "y", "x", "x", "x", "a", "a"))
rownames(df) <- tree$tip.label

df2 <- as.data.frame(matrix(rnorm(39), ncol=3))
rownames(df2) <- tree$tip.label
colnames(df2) <- LETTERS[1:3]


p1 <- gheatmap(circ, df, offset=.8, width=.2,
               colnames_angle=95, colnames_offset_y = .25) +
  scale_fill_viridis_d(option="D", name="discrete\nvalue")


p2 <- p1 + new_scale_fill()
gheatmap(p2, df2, offset=15, width=.3,
         colnames_angle=90, colnames_offset_y = .25) +
  scale_fill_viridis_c(option="A", name="continuous\nvalue")

