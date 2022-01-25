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

gts = read.tree(geneTreeFile);
sp_tree = read.tree(speciesTreeFile);
sp_tree = read.tree(text="(10:9.6,(1:7.2,(2:7.2,((9:0.4)H2#0.8:5.0,(3:4.4,(4:3.5,((5:0.2,6:0.2)I1:2.1,(7:1.4,(8:0.4,H2#0.8:0.0)I2:1.0)I3:0.9)I4:1.2)I5:0.9)I6:1.0)I7:0.6)I8:1.2)I9:2.4)I10;")

taxon1 = "1"
taxon2 = "2"
taxon3 = "3"

# per email: treat all populations as the same

popSizes=c(100,100,100,100,100,100,100,100,100,100)

distDensities = pairwiseDist(sp_tree, popSizes, gts, taxon1, taxon2, numSteps = 1000,
             tailProb = 0.01)
# Warning message: Tip labels on species tree and gene tree 1 do not match.  Exiting.
# will try with species trees with zero hybridizations


ad_ouput = ADtest(distDensities, subsampleSize = FALSE)
# Warning message:
# In ADtest(distDensities, subsampleSize = FALSE) :
#  Test size for AD test must be positive and less than the number of gene trees.  Exiting.


rootedTriple(stree, popSizes, gtSample, taxon1, taxon2, taxon3,
             subsampleSize = FALSE)









