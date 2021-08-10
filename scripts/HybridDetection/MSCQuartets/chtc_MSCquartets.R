#!/usr/bin/env Rscript

# Marianne Bjorner
# May 30, 2021
#
# MSCQuartets as performed on a single input file, taken as a command line argument

library(MSCquartets)
library(ape)

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  stop("Missing argument for gene trees in MSCQuartets file", call.=FALSE)
}

fileName = args[1]
gene_trees = read.tree(fileName)
QT = quartetTable(gene_trees, taxonnames = NULL, epsilon = 0, random = 0)
QTR = quartetTableResolved(QT, omit = F)

MSC = quartetTreeTestInd(QTR, model = "T3")
Star = quartetStarTestInd(QTR)

CFpVals = cbind(MSC, Star[, "p_star"])

write.csv(CFpVals, paste(fileName, "MSC_table_output.csv", sep = "")) 

