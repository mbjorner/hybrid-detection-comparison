## Julia script to read a single file with a gene tree, 
## create a CF from argument input

import Pkg; Pkg.add("PhyloNetworks")

using PhyloNetworks

file = string(ARGS[1])

## CF table filename matching the replicate:
cftable = string(file,".CFs.csv")

## this commands saves the CF table with the name given by cftable
datCF = readTrees2CF(file, writeTab=true, CFfile = cftable, writeSummary=false)