# Marianne Bjorner
# Nov 29 2021

# for testing how well hybrid-lambda is simulating trees under MSCsimtester
# inputs: simulated gene tree files

# MSCsimtester builds on the packages ape and kSamples.
# Required input is a collection of gene trees, stored as a multiPhylo object by the ape package,
# and a specification of a rooted species tree with edge lengths in generations, together with constant
# population sizes for each edge.

# load packages
library(MSCsimtester)
library(ape)
library(kSamples)

# load gene, species tree file (these must be rooted, look into if this has any impact)

setwd("~/GitHub/phylo-microbes/data/knownGT/")
geneTreeFile = "n10_n1000/10_astral.in"
speciesTreeFile = "n10.net"

gts = read.tree(file=system.file(geneTreeFile,package="MSCsimtester"));
sp_tree = read.tree(speciesTreeFile);
taxon1 = "1"
taxon2 = "2"
taxon3 = "3"
popSizes=c(100,100,100,100,100,100,100,100,100,100)

distDensities = pairwiseDist(sp_tree, popSizes, gts, taxon1, taxon2, numSteps = 1000,
             tailProb = 0.01)

ad_ouput = ADtest(distDensities, subsampleSize = FALSE)

rootedTriple(stree, popSizes, gtSample, taxon1, taxon2, taxon3,
             subsampleSize = FALSE)









