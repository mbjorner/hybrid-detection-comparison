## Julia script to read a file with gene trees and 
## create a table of CFs

using PhyloNetworks

## Data folder:
folder = "../data/knownGT/n10_n30/"

## Replicate:
file = "1_astral.in"

## CF table filename matching the replicate:
cftable = string(split(file,'.')[1],".csv")

## this commands saves the CF table with the name given by cftable
datCF = readTrees2CF(string(folder,file), writeTab=true, CFfile = cftable, writeSummary=false)