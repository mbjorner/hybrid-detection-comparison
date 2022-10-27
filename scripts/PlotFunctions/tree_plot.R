# Marianne Bjorner
# 07SEP2022
# Visualization using ggtree for annotating phylogenetic trees
# with accompanying data related to detected hybridizations by test type

#if (!require("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
# if version of R is less than required, updateR()
# BiocManager::install("ggtree")

library(ggtree)
library(dplyr)
library(ggplot2)
library(gtable)
library(treeio)
library(ggnewscale)

# to view ggtree data visualizations, browseVignettes("ggtree")

#bee_tree <- "/Users/bjorner/DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/species_trees/concatenation_trees/iqtree2_consensus_80p_867loci.newick"
bee_tree <- "/Users/bjorner/GitHub/hybrid-detection-comparison/scripts/Bees_real_dataset/rerooted_iqtree.tre"
#phylo_bayes_consensus <- "(Acunomia_melanderi:0.025556,Hoplonomia_elliotii:0.043639,(Curvinomia_chalybeata:0.037426,(Austronomia_australica:0.031856,((Lipotriches_justiciae:0.016152,Lipotriches_collaris:0.021476)1:0.040895,((((Ruginomia_rugiventris:0.049361,((Stictonomia_sangaensis:0.011898,(Stictonomia_schubotzi:0.019337,Stictonomia_aliceae:0.006284)1:0.005089[&&NHX:D=C])1:0.007211[&&NHX:D=C],(Pachynomia_flavicarpa:0.01274,(Pachynomia_tshibindica:0.004246,Pachynomia_amoenula:0.005038)1:0.003883)1:0.01832)1:0.011332)1:0.001251[&&NHX:D=B],((Steganomus_junodi:0.02161,Steganomus_ennediensis:0.014725)1:0.032654,((Pseudapis_cinerea:0.0111,(((Pseudapis_riftensis:0.002575,Pseudapis_pandeana:0.002174)1:0.000999,Pseudapis_kenyensis:0.003554)1:0.010063,((Pseudapis_siamensis:0.004509,Pseudapis_oxybeloides:0.003867)1:0.00401,(Pseudapis_interstitinervis:0.006527,(Pseudapis_flavolobata:0.00425,Pseudapis_nilotica:0.00673)1:0.002561)1:0.002334)1:0.004485)1:0.004583)1:0.009684,(Nomiapis_bispinosa:0.009934,Nomiapis_diversipes:0.006366)1:0.008488)1:0.015318)1:0.005259)1:0.031128,((Lasioglossum_albipes:0.395776,Dufourea_novaeangliae:0.432467)1:0.09907,(Dieunomia_triangulifera:0.005012,Dieunomia_heteropoda:0.007919)1:0.082612)1:0.01373)1:0.001512[&&NHX:D=B],(Macronomia_clavisetis:0.060172,Afronomia_circumnitens:0.044105)1:0.003409)1:0.001131[&&NHX:D=A])1:0.021026)1:0.003319)1:0.003139);"
#rerooted_tree <- "((Dufourea_novaeangliae:0.3283715714,Lasioglossum_albipes:0.30386322)100:0.04366393925,((Dieunomia_heteropoda:0.0076910555,Dieunomia_triangulifera:0.0051386997)100:0.0724310222,(((((Nomiapis_diversipes:0.0062672973,Nomiapis_bispinosa:0.0098182024)100:0.0083095333,(((((Pseudapis_flavolobata:0.0041930065,Pseudapis_nilotica:0.0066414241)100:0.0025068106,Pseudapis_interstitinervis:0.006456856)100:0.0023093309,(Pseudapis_oxybeloides:0.0038106611,Pseudapis_siamensis:0.0044619926)100:0.0039590854)100:0.0043929177,(Pseudapis_kenyensis:0.0035267461,(Pseudapis_pandeana:0.0021542374,Pseudapis_riftensis:0.0025190795)100:0.0009973197)100:0.0099039704)100:0.0045145952,Pseudapis_cinerea:0.0110034005)100:0.0094434408)100:0.014587841,(Steganomus_junodi:0.0206332551,Steganomus_ennediensis:0.0146395137)100:0.0307092457)100:0.0051359568,((((Pachynomia_amoenula:0.0049805902,Pachynomia_tshibindica:0.0042030544)100:0.0038497808,Pachynomia_flavicarpa:0.0123664618)100:0.0175816651,((Stictonomia_aliceae:0.0064317418,Stictonomia_schubotzi:0.0185468615)100:0.0047644916[&&NHX:D=C],Stictonomia_sangaensis:0.0115996862)100:0.0071397815[&&NHX:D=C])100:0.0106176884,Ruginomia_rugiventris:0.0468046685)100:0.0014864908[&&NHX:D=B])100:0.0282867098,((Afronomia_circumnitens:0.0413271988,Macronomia_clavisetis:0.0567920798)100:0.0038641687,((Lipotriches_collaris:0.0208948171,Lipotriches_justiciae:0.0162409274)100:0.038424918,(Austronomia_australica:0.0307471261,(Curvinomia_chalybeata:0.036090395,(Acunomia_melanderi:0.0246844118,Hoplonomia_elliotii:0.0420533865):0.0031975809)100:0.0033972094)100:0.0192760758)100:0.0013979556[&&NHX:D=A])93:0.0019831738[&&NHX:D=A])100:0.0158097997)100:0.04366393925);"
rerooted_tree <- "((Lasioglossum_albipes:0.30386322)100:0.04366393925,((Dieunomia_heteropoda:0.0076910555,Dieunomia_triangulifera:0.0051386997)100:0.0724310222,(((((Nomiapis_diversipes:0.0062672973,Nomiapis_bispinosa:0.0098182024)100:0.0083095333,(((((Pseudapis_flavolobata:0.0041930065,Pseudapis_nilotica:0.0066414241)100:0.0025068106,Pseudapis_interstitinervis:0.006456856)100:0.0023093309,(Pseudapis_oxybeloides:0.0038106611,Pseudapis_siamensis:0.0044619926)100:0.0039590854)100:0.0043929177,(Pseudapis_kenyensis:0.0035267461,(Pseudapis_pandeana:0.0021542374,Pseudapis_riftensis:0.0025190795)100:0.0009973197)100:0.0099039704)100:0.0045145952,Pseudapis_cinerea:0.0110034005)100:0.0094434408)100:0.014587841,(Steganomus_junodi:0.0206332551,Steganomus_ennediensis:0.0146395137)100:0.0307092457)100:0.0051359568,((((Pachynomia_amoenula:0.0049805902,Pachynomia_tshibindica:0.0042030544)100:0.0038497808,Pachynomia_flavicarpa:0.0123664618)100:0.0175816651,((Stictonomia_aliceae:0.0064317418,Stictonomia_schubotzi:0.0185468615)100:0.0047644916[&&NHX:D=C],Stictonomia_sangaensis:0.0115996862)100:0.0071397815[&&NHX:D=C])100:0.0106176884,Ruginomia_rugiventris:0.0468046685)100:0.0014864908[&&NHX:D=B])100:0.0282867098,((Afronomia_circumnitens:0.0413271988,Macronomia_clavisetis:0.0567920798)100:0.0038641687,((Lipotriches_collaris:0.0208948171,Lipotriches_justiciae:0.0162409274)100:0.038424918,(Austronomia_australica:0.0307471261,(Curvinomia_chalybeata:0.036090395,(Acunomia_melanderi:0.0246844118,Hoplonomia_elliotii:0.0420533865):0.0031975809)100:0.0033972094)100:0.0192760758)100:0.0013979556[&&NHX:D=A])93:0.0019831738[&&NHX:D=A])100:0.0158097997)100:0.04366393925);"

tree <- read.nhx(textConnection(rerooted_tree))
bee_tree <- read.tree(bee_tree)

# look at tree as-is with species labels
tree_visual <- ggtree(tree) + geom_tiplab()  + 
  geom_label(aes(label=D), fill='steelblue') 
tree_visual

# import MSC, HyDe results
#MSC_results <- "/Users/bjorner/GitHub/hybrid-detection-comparison/scripts/Bees_real_dataset/Iq2_GTRG_concatenated_gene_tree_files.tre_MSCresults.csv"
MSC_results <- "/Users/bjorner/GitHub/hybrid-detection-comparison/scripts/Bees_real_dataset/Iq2_GTRG_concatenated_gene_tree_files.tre_remove_Dufourea_novaeangliae.txt_MSCresults.csv"
HyDe_results <- "/Users/bjorner/GitHub/hybrid-detection-comparison/scripts/Bees_real_dataset/bees_without_Dufourea_outgroup_Lasioglossum_albipes_analyzed.csv"
#HyDe_results <- "/Users/bjorner/GitHub/hybrid-detection-comparison/scripts/Bees_real_dataset/bees_outgroup_Lasioglossum_analyzed.csv"
#HyDe_results <- "/Users/bjorner/GitHub/hybrid-detection-comparison/scripts/Bees_real_dataset/bees_HyDe_0921_analyzed.csv"
MSC_results <- read.csv(MSC_results)
HyDe_results <- read.csv(HyDe_results)

#MSC_results <- subset(MSC_results, Dufourea_novaeangliae != 1)
#HyDe_results <- subset(HyDe_results, P1 != "Dufourea_novaeangliae" & Hybrid != "Dufourea_novaeangliae" & P2 != "Dufourea_novaeangliae")

tiplabels <- bee_tree$tip.label

##### MSC
alpha <- 0.05
numTests <- nrow(MSC_results)

numTestswithDuofera <- sum(MSC_results[,"Dufourea_novaeangliae"] == 1)

numTests_corrected = numTests - numTestswithDuofera;
summary_MSC <- MSC_results %>% summarize(
  numSignificantAlpha = sum(p_T3 < alpha, na.rm=TRUE),
  numSignificantBonferroni = sum(p_T3 < alpha/numTests, na.rm=TRUE)
)

# count number of occurrences where tip == 1, bonferroni level or p-val level reached
numlabels <- length(tiplabels)
num_alpha05 <- c()
num_bonferroni <- c()

column_names <- colnames(MSC_results)
#column_names = column_names[column_names != "Dufourea_novaeangliae"]
columnnameslength = length(column_names)

for (a in 1:columnnameslength) {
  num_alpha05[a] <- sum(MSC_results[ , a] == 1 & MSC_results$p_T3 < alpha & MSC_results[,"Dufourea_novaeangliae"] == 0)
  num_bonferroni[a] <- sum(MSC_results[ , a] == 1 & MSC_results$p_T3 < alpha/numTests & MSC_results[,"Dufourea_novaeangliae"] == 0)
  if (column_names[a] %in% tiplabels) {
  } else {
    num_alpha05[a] <- 0
    num_bonferroni[a] <- 0
  }
}

for (a in 1:columnnameslength) {
  num_alpha05[a] <- sum(MSC_results[ , a] == 1 & MSC_results$p_T3 < alpha )
  num_bonferroni[a] <- sum(MSC_results[ , a] == 1  & MSC_results$p_T3 < alpha/numTests)
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
  
  numHyDe_alpha05[a] <- sum((HyDe_results$P1 == tiplabels[a] | (HyDe_results$P2 == tiplabels[a]))  & HyDe_results$HyDe_pvalue < alpha)
  numHyDe_bonferroni[a] <- sum((HyDe_results$P1 == tiplabels[a] | (HyDe_results$P2 == tiplabels[a]))  & HyDe_results$HyDe_pvalue < alpha/numTests)
  

  numD_alpha05[a] <- sum((HyDe_results$P1 == tiplabels[a]) & (HyDe_results$isDtestTopology == 1) & (HyDe_results$D_pvalue < alpha)) +
                     sum((HyDe_results$Hybrid == tiplabels[a]) & (HyDe_results$isDtestTopology == 2) & (HyDe_results$D_pvalue < alpha)) +
                     sum((HyDe_results$P2 == tiplabels[a]) & (HyDe_results$isDtestTopology == 3) & (HyDe_results$D_pvalue < alpha)) +
                     sum((HyDe_results$P1 == tiplabels[a]) & (HyDe_results$isDtestTopology == 2) & (HyDe_results$D_pvalue < alpha) & (HyDe_results$D < 0))  +
                     sum((HyDe_results$P1 == tiplabels[a]) & (HyDe_results$isDtestTopology == 3) & (HyDe_results$D_pvalue < alpha) & (HyDe_results$D < 0)) +
                     sum((HyDe_results$Hybrid == tiplabels[a]) & (HyDe_results$isDtestTopology == 1) & (HyDe_results$D_pvalue < alpha) & (HyDe_results$D > 0))  +
                     sum((HyDe_results$Hybrid == tiplabels[a]) & (HyDe_results$isDtestTopology == 3) & (HyDe_results$D_pvalue < alpha) & (HyDe_results$D > 0)) +
                     sum((HyDe_results$P2 == tiplabels[a]) & (HyDe_results$isDtestTopology == 1) & (HyDe_results$D_pvalue < alpha) & (HyDe_results$D < 0))  +
                     sum((HyDe_results$P2 == tiplabels[a]) & (HyDe_results$isDtestTopology == 2) & (HyDe_results$D_pvalue < alpha) & (HyDe_results$D > 0))
    
  numD_bonferroni[a] <- sum((HyDe_results$P1 == tiplabels[a]) & (HyDe_results$isDtestTopology == 1) & (HyDe_results$D_pvalue < alpha/numTests)) +
    sum((HyDe_results$Hybrid == tiplabels[a]) & (HyDe_results$isDtestTopology == 2) & (HyDe_results$D_pvalue < alpha/numTests)) +
    sum((HyDe_results$P2 == tiplabels[a]) & (HyDe_results$isDtestTopology == 3) & (HyDe_results$D_pvalue < alpha/numTests)) +
    sum((HyDe_results$P1 == tiplabels[a]) & (HyDe_results$isDtestTopology == 2) & (HyDe_results$D_pvalue < alpha/numTests) & (HyDe_results$D < 0))  +
    sum((HyDe_results$P1 == tiplabels[a]) & (HyDe_results$isDtestTopology == 3) & (HyDe_results$D_pvalue < alpha/numTests) & (HyDe_results$D < 0)) +
    sum((HyDe_results$Hybrid == tiplabels[a]) & (HyDe_results$isDtestTopology == 1) & (HyDe_results$D_pvalue < alpha/numTests) & (HyDe_results$D > 0))  +
    sum((HyDe_results$Hybrid == tiplabels[a]) & (HyDe_results$isDtestTopology == 3) & (HyDe_results$D_pvalue < alpha/numTests) & (HyDe_results$D > 0)) +
    sum((HyDe_results$P2 == tiplabels[a]) & (HyDe_results$isDtestTopology == 1) & (HyDe_results$D_pvalue < alpha/numTests) & (HyDe_results$D < 0))  +
    sum((HyDe_results$P2 == tiplabels[a]) & (HyDe_results$isDtestTopology == 2) & (HyDe_results$D_pvalue < alpha/numTests) & (HyDe_results$D > 0))
  
  #numD_bonferroni[a] <- sum((HyDe_results$Hybrid == tiplabels[a] | (HyDe_results$P1 == tiplabels[a]) | (HyDe_results$P2 == tiplabels[a])) & HyDe_results$D_pvalue < alpha/numTests)
  
  #numD3_alpha05[a] <- sum((HyDe_results$Hybrid == tiplabels[a] | (HyDe_results$P1 == tiplabels[a]) | (HyDe_results$P2 == tiplabels[a])) & HyDe_results$D3_pvalue < alpha)
  #numD3_bonferroni[a] <- sum((HyDe_results$Hybrid == tiplabels[a] | (HyDe_results$P1 == tiplabels[a]) | (HyDe_results$P2 == tiplabels[a])) & HyDe_results$D3_pvalue < alpha/numTests)
  
  numD3_alpha05[a] <- sum((HyDe_results$P1 == tiplabels[a]) & (HyDe_results$isDtestTopology == 1) & (HyDe_results$D3_pvalue < alpha)) +
    sum((HyDe_results$Hybrid == tiplabels[a]) & (HyDe_results$isDtestTopology == 2) & (HyDe_results$D3_pvalue < alpha)) +
    sum((HyDe_results$P2 == tiplabels[a]) & (HyDe_results$isDtestTopology == 3) & (HyDe_results$D3_pvalue < alpha)) +
    
    sum((HyDe_results$P1 == tiplabels[a]) & (HyDe_results$isDtestTopology == 2) & (HyDe_results$D3_pvalue < alpha) & (HyDe_results$D3 > 0))  +
    sum((HyDe_results$P1 == tiplabels[a]) & (HyDe_results$isDtestTopology == 3) & (HyDe_results$D3_pvalue < alpha) & (HyDe_results$D3 > 0)) +
    
    sum((HyDe_results$Hybrid == tiplabels[a]) & (HyDe_results$isDtestTopology == 1) & (HyDe_results$D3_pvalue < alpha) & (HyDe_results$D3 < 0))  +
    sum((HyDe_results$Hybrid == tiplabels[a]) & (HyDe_results$isDtestTopology == 3) & (HyDe_results$D3_pvalue < alpha) & (HyDe_results$D3 < 0)) +
    
    sum((HyDe_results$P2 == tiplabels[a]) & (HyDe_results$isDtestTopology == 1) & (HyDe_results$D3_pvalue < alpha) & (HyDe_results$D3 > 0))  +
    sum((HyDe_results$P2 == tiplabels[a]) & (HyDe_results$isDtestTopology == 2) & (HyDe_results$D3_pvalue < alpha) & (HyDe_results$D3 < 0))
  
  
  numD3_bonferroni[a] <-  sum((HyDe_results$P1 == tiplabels[a]) & (HyDe_results$isDtestTopology == 1) & (HyDe_results$D3_pvalue < alpha/numTests)) +
    sum((HyDe_results$Hybrid == tiplabels[a]) & (HyDe_results$isDtestTopology == 2) & (HyDe_results$D3_pvalue < alpha/numTests)) +
    sum((HyDe_results$P2 == tiplabels[a]) & (HyDe_results$isDtestTopology == 3) & (HyDe_results$D3_pvalue < alpha/numTests)) +
    sum((HyDe_results$P1 == tiplabels[a]) & (HyDe_results$isDtestTopology == 2) & (HyDe_results$D3_pvalue < alpha/numTests) & (HyDe_results$D3 > 0))  +
    sum((HyDe_results$P1 == tiplabels[a]) & (HyDe_results$isDtestTopology == 3) & (HyDe_results$D3_pvalue < alpha/numTests) & (HyDe_results$D3 > 0)) +
    sum((HyDe_results$Hybrid == tiplabels[a]) & (HyDe_results$isDtestTopology == 1) & (HyDe_results$D3_pvalue < alpha/numTests) & (HyDe_results$D3 < 0))  +
    sum((HyDe_results$Hybrid == tiplabels[a]) & (HyDe_results$isDtestTopology == 3) & (HyDe_results$D3_pvalue < alpha/numTests) & (HyDe_results$D3 < 0)) +
    sum((HyDe_results$P2 == tiplabels[a]) & (HyDe_results$isDtestTopology == 1) & (HyDe_results$D3_pvalue < alpha/numTests) & (HyDe_results$D3 > 0))  +
    sum((HyDe_results$P2 == tiplabels[a]) & (HyDe_results$isDtestTopology == 2) & (HyDe_results$D3_pvalue < alpha/numTests) & (HyDe_results$D3 < 0))
  
  
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


df_alpha = data.frame(MSC= a05/summary_MSC$numSignificantAlpha, 
                HyDe_H = numHyDeHyb_alpha05/summary_HyDe$numHyDe_siga,
                HyDe_P= numHyDe_alpha05/summary_HyDe$numHyDe_siga,
                D = numD_alpha05/summary_HyDe$numD_siga,
                D3 = numD3_alpha05/summary_HyDe$numD3_siga
)

df_bonferroni = data.frame(MSC = ab/summary_MSC$numSignificantBonferroni,
                           HyDe_H = numHyDeHyb_bonferroni/summary_HyDe$numHyDe_sigb,
                           HyDe_P = numHyDe_bonferroni/summary_HyDe$numHyDe_sigb,
                           D = numD_bonferroni/summary_HyDe$numD_sigb,
                           D3 = numD3_bonferroni/summary_HyDe$numD3_sigb
)

# Replace NA values with 0
df_alpha[is.na(df_alpha)] <- 0
df_bonferroni[is.na(df_bonferroni)] <- 0

# Scale values from 0 to 1 based on the maximum value of that test
columns = c( "MSC", "HyDe_H","HyDe_P", "D", "D3")
for (column in columns) {
  df_alpha[column] = df_alpha[column] / max(df_alpha[column])
  df_bonferroni[column] = df_bonferroni[column] / max(df_bonferroni[column])
}

# Assign row names of dataframes to be aligned with the species labels of the tree
rownames(df_alpha) <- bee_tree$tip.label
rownames(df_bonferroni) <- bee_tree$tip.label

# Create plot of proposed species tree, with aligned labels
p <- ggtree(tree, layout = "rectangular") + geom_tiplab(size=4, align=TRUE, linesize=.5) + 
     geom_label(aes(label=D), size=3.5, fill="thistle") + theme(legend.position = 'none')# + theme_tree2() 
p

# Create heatmaps for all tests next to tree visualization
alpha_plot <- gheatmap(p, df_alpha, offset=.2, width=1.2, colnames=TRUE, font.size = 3.5, colnames_angle = -0, legend_title="", low="white", high="#4a1486") +
  theme(legend.position = 'top') + scale_x_ggtree()
bonferroni_plot <- gheatmap(p, df_bonferroni, offset=.2, width=1.2, colnames=TRUE, font.size = 3.5, legend_title="", colnames_angle = -0, low="white", high="#4a1486") +
  theme(legend.position = 'top') + scale_x_ggtree()

# Display completed plots, and save
alpha_plot
bonferroni_plot
setwd("/Users/bjorner/GitHub/hybrid-detection-comparison/")
ggsave(filename = "alpha_bees_no_dufourea_ingt_ortree.png", plot = alpha_plot, width = 10, height = 8)
ggsave(filename = "bonferroni_bees_no_dufourea_ingt_ortree.png", plot = bonferroni_plot, width = 10, height = 8)
