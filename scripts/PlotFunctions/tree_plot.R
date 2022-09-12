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
library(dplyr)
library(ggplot2)
library(gtable)
install.packages("ggnewscale")
library(ggnewscale)

#browseVignettes("ggtree")


bee_tree <- "/Users/bjorner/DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/species_trees/concatenation_trees/iqtree2_consensus_80p_867loci.newick"
tree <- read.tree(bee_tree)
tree_visual <- ggtree(tree)

p1 <- ggtree(tree) + geom_tiplab() + hexpand(.4)
p1

p <- ggtree(tree, branch.length = "none") + 
  geom_tiplab() + theme(legend.position='none')
p


# TODO: plot HyDe, MSC, TICR results side-by-side, maybe as a heat map?

# Step 1: create dataframe for heatmap based on results of MSC, TICR, etc.

# import MSC, HyDe results
MSC_results <- "/Users/bjorner/GitHub/phylo-microbes/scripts/Bees_real_dataset/Iq2_GTRG_concatenated_gene_tree_files.tre_MSCresults.csv"
HyDe_results <- "/Users/bjorner/GitHub/phylo-microbes/scripts/Bees_real_dataset/bees_HyDe-out.txt_analyzed.csv"

MSC_results <- read.csv(MSC_results)
HyDe_results <- read.csv(HyDe_results)
tiplabels <- tree$tip.label

# sum of times p value is less than 0.05
##### MSC
alpha <- 0.05
numTests <- nrow(MSC_results)
summary_MSC <- MSC_results %>% summarize(
  numSignificantAlpha = sum(p_T3 < alpha, na.rm=TRUE),
  numSignificantBonferroni = sum(p_T3 < alpha/numTests, na.rm=TRUE)
)

# count number of occurrences where tip == 1, bonferroni level or p-val level reached
numlabels <- length(tiplabels)
num_alpha05 <- c()
num_bonferroni <- c()

column_names <- colnames(MSC_results)
columnnameslength = length(column_names)

for (a in 1:columnnameslength) {
  num_alpha05[a] <- sum(MSC_results[ , a] == 1 & MSC_results$p_T3 < alpha)
  num_bonferroni[a] <- sum(MSC_results[ , a] == 1 & MSC_results$p_T3 < alpha/numTests)
  if (column_names[a] %in% tiplabels) {
  } else {
    num_alpha05[a] <- 0
    num_bonferroni[a] <- 0
  }
}

alpha05 = data.frame(taxa = column_names, frequency = num_alpha05)
alphabon = data.frame(taxa = column_names, frequency = num_bonferroni)

a05 = c()
ab = c()

for (a in 1:numlabels) {
  for (b in 1:columnnameslength) {
    if (column_names[b] %in% tiplabels[a]) {
      a05[a] = num_alpha05[b]
      ab[a] = num_bonferroni[b]
    }
  }
}


### HYDE
numHyDeHyb_alpha05 = c()
numHyDeHyb_bonferroni = c()

numHyDe_alpha05 = c()
numHyDe_bonferroni = c()

numD_alpha05 = c()
numD_bonferroni = c()

numD3_alpha05 = c()
numD3_bonferroni = c()

numDp_alpha05 = c()
numDp_bonferroni = c()

for (a in 1:numlabels) {
  numHyDeHyb_alpha05[a] <- sum(HyDe_results$Hybrid == tiplabels[a] & HyDe_results$HyDe_pvalue < alpha)
  numHyDeHyb_bonferroni[a] <- sum(HyDe_results$Hybrid == tiplabels[a] & HyDe_results$HyDe_pvalue < alpha/numTests)
  
  numHyDe_alpha05[a] <- sum((HyDe_results$Hybrid == tiplabels[a] | (HyDe_results$P1 == tiplabels[a]) | (HyDe_results$P2 == tiplabels[a]))  & HyDe_results$HyDe_pvalue < alpha)
  numHyDe_bonferroni[a] <- sum((HyDe_results$Hybrid == tiplabels[a] | (HyDe_results$P1 == tiplabels[a]) | (HyDe_results$P2 == tiplabels[a]))  & HyDe_results$HyDe_pvalue < alpha/numTests)
  
  numD_alpha05[a] <- sum((HyDe_results$Hybrid == tiplabels[a] | (HyDe_results$P1 == tiplabels[a]) | (HyDe_results$P2 == tiplabels[a]))  & HyDe_results$D_pvalue < alpha)
  numD_bonferroni[a] <- sum((HyDe_results$Hybrid == tiplabels[a] | (HyDe_results$P1 == tiplabels[a]) | (HyDe_results$P2 == tiplabels[a])) & HyDe_results$D_pvalue < alpha/numTests)
  
  numD3_alpha05[a] <- sum((HyDe_results$Hybrid == tiplabels[a] | (HyDe_results$P1 == tiplabels[a]) | (HyDe_results$P2 == tiplabels[a])) & HyDe_results$D3_pvalue < alpha)
  numD3_bonferroni[a] <- sum((HyDe_results$Hybrid == tiplabels[a] | (HyDe_results$P1 == tiplabels[a]) | (HyDe_results$P2 == tiplabels[a])) & HyDe_results$D3_pvalue < alpha/numTests)
  
  numDp_alpha05[a] <- sum((HyDe_results$Hybrid == tiplabels[a] | (HyDe_results$P1 == tiplabels[a]) | (HyDe_results$P2 == tiplabels[a])) & HyDe_results$Dp_pvalue < alpha)
  numDp_bonferroni[a] <- sum((HyDe_results$Hybrid == tiplabels[a] | (HyDe_results$P1 == tiplabels[a]) | (HyDe_results$P2 == tiplabels[a])) & HyDe_results$Dp_pvalue < alpha/numTests)
  
}

HyDe_resCounts <- HyDe_results %>% group_by()
summary_HyDe <- HyDe_results %>% summarise(
  numHyDe_siga = sum(HyDe_results$HyDe_pvalue < alpha),
  numHyDe_sigb = sum(HyDe_results$HyDe_pvalue < alpha/numTests),
  
  numD_siga = sum(HyDe_results$HyDe_pvalue < alpha),
  numD_sigb = sum(HyDe_results$HyDe_pvalue < alpha/numTests),
  
  numD3_siga = sum(HyDe_results$HyDe_pvalue < alpha),
  numD3_sigb = sum(HyDe_results$HyDe_pvalue < alpha/numTests)
)


df = data.frame(#MSCa = a05/summary_MSC$numSignificantAlpha, MSCb = ab/summary_MSC$numSignificantBonferroni, 
                HyDea = numHyDeHyb_alpha05/summary_HyDe$numHyDe_siga,
                HyDeb = numHyDeHyb_bonferroni/summary_HyDe$numHyDe_sigb,
                
                HyDea_all = numHyDe_alpha05/summary_HyDe$numHyDe_siga,
                HyDeb_all = numHyDe_bonferroni/summary_HyDe$numHyDe_sigb
                
                #Da = numD_alpha05/summary_HyDe$numD_siga,
                #Db = numD_bonferroni/summary_HyDe$numD_sigb,
                
                #D3a = numD3_alpha05/summary_HyDe$numD3_siga,
                #D3b = numD3_bonferroni/summary_HyDe$numD3_sigb,
                
                #Dpa = numDp_alpha05/summary_HyDe$numD_siga,
                #Dpb = numDp_bonferroni/summary_HyDe$numD_sigb)
)

df[is.na(df)] <- 0
rownames(df) <- tree$tip.label

# create dataframe for each, listing by species impacted when
# p-value is less than bonferroni OR 0.05
p <- gheatmap(tree_visual, df)
p
gheatmap(tree, df, offset=.8, width=.2,
               colnames_angle=95, colnames_offset_y = .25) +
  scale_fill_viridis_d(option="D", name="discrete\nvalue")

gheatmap(tree, df, offset=8, width=0.6, 
         colnames=FALSE, legend_title="genotype")))



p1 <- gheatmap(circ, df, offset=.8, width=.2,
               colnames_angle=95, colnames_offset_y = .25) +
  scale_fill_viridis_d(option="D", name="discrete\nvalue")

nwk <- system.file("extdata", "sample.nwk", package="treeio")

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

