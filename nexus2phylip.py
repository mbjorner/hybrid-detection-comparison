#!/usr/bin/env python

'''
general instructions on how to convert from nexus to phylip format
acquired from 
http://sequenceconversion.bugaco.com/converter/biology/sequences/nexus_to_phylip.php

should probably look into another method, as this does not currently work :/
'''

from Bio import SeqIO
import os

input_path = "./GitHub/phylo-microbes/data/sequences/"

# get partial paths of every nexus input file in paths (these end in seqgen.out)
nexus_paths = []
numTrees = ["knownGT/n10/seqgen/", "knownGT/n15/seqgen/", "n25h5/", "n50h10/", "n100h25/"]

for tree_nums in numTrees:
    for subfolder in os.listdir(input_path + tree_nums):
        try:  
            for f in os.listdir(input_path + tree_nums + subfolder):
                if "_seqgen.out" in f:
                    nexus_paths.append(tree_nums + subfolder + "/" + f)
        except OSError:
            print("") # do nothing

# print(nexus_paths)
# print(len(nexus_paths))

# Current state: throws ValueError: ERROR: TAXLABELS must be identical with MATRIC. Please Report this as a bug, and send in data file.
for file in nexus_paths:
    records = SeqIO.parse(input_path + file, "nexus")
    count = SeqIO.write(records, input_path + file + ".phylip", "phylip")
    print("Converted %i records" % count)
