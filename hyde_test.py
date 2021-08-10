#!/usr/bin/env python

import phyde as hd
import os

input_path = "./GitHub/phylo-microbes/data/sequences/"

# get partial paths of every phylip input file in paths (these end in seqgen.out)
phylip_paths = []
numTrees = ["knownGT/n10/seqgen/", "knownGT/n15/seqgen/", "n25h5/", "n50h10/", "n100h25/"]

for tree_nums in numTrees:
    for subfolder in os.listdir(input_path + tree_nums):
        try:  
            for f in os.listdir(input_path + tree_nums + subfolder):
                if ".phylip" in f:
                    phylip_paths.append(tree_nums + subfolder + "/" + f)
        except OSError:
            print("") # do nothing

# the top of the phylip files should have the number of taxa and number of sites:
# note that hyde documentation says that "it is typically difficult to detect hybridization
# using less than 10,000 sites"
print("hello")

for file in phylip_paths:
    # create mapfile?
    


    num_taxa =
    num_sites = 
    num_individuals = num_taxa # ?

    print("dat1")
    dat = hd.HydeData(file, file, "10", 10, 10, 500)
    print("dat")
