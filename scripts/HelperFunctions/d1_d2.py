"""
Marianne Bjorner
July 5 2022

Follows D1 and D2 script as given by https://github.com/mhibbins/D1_D2_scripts/blob/master/newickDstats.py
Each newick representation as given by ms output is read in


Initially tested on :

python d1_d2.py /Users/bjorner/GitHub/hybrid-detection-comparison/data/knownGT/multiNet/n6_n1000/1_astral.in /Users/bjorner/GitHub/hybrid-detection-comparison/maps/n6h1.txt

"""

import sys

import pandas as pd
from Bio import Phylo as phy
import csv
import itertools

### This script takes a file containing newick-formatted genealogies as input, and uses the branch lengths in order to estimate the D1 and D2 statistics. 
# Taxon IDs passed to tree.distance() should be edited so they correspond to the relevant taxa for the system of interest. ###

only_ingroup_permutations_csv_name = ''.join([sys.argv[1], "_D1_D2.csv"])

names = []

f = open(sys.argv[2], "r")
for line in f: 
    name = line.split(" ")
    names.append(str(name[0]))
    
outgroup = names.pop() # we will not be using the outgroup, though D1, D2 depend on it being present to root the tree
    
three_taxon_permutations = list(itertools.permutations(names, 3))
column_names = ["t1", "t2", "t3", "d1", "d2"]
data = []

for triple in three_taxon_permutations:
    tax2 = triple[0]
    tax3 = triple[1]
    tax4 = triple[2]

    DistanceABAB=[]
    DistanceBCBC=[]
    DistanceACAB=[]
    DistanceACBC=[]
    trees = phy.parse(sys.argv[1],'newick') # needs to be read anew prior to each traversal of the tree collection
    for tree in trees: #for each genealogy
        if tree.distance(tax3,tax4) < tree.distance(tax2,tax3) and tree.distance(tax2,tax4): #if the topology is AB
            DistanceABABi = tree.distance(tax3,tax4) #AB given AB
            DistanceACABi = tree.distance(tax2,tax4) #AC given AB
            DistanceABAB.append(DistanceABABi)
            DistanceACAB.append(DistanceACABi)
        if tree.distance(tax2,tax3) < tree.distance(tax3,tax4) and tree.distance(tax2,tax4): #if the topology is BC
            DistanceBCBCi = tree.distance(tax2,tax3) #BC given BC
            DistanceACBCi = tree.distance(tax2,tax4) #AC given BC
            DistanceBCBC.append(DistanceBCBCi)
            DistanceACBC.append(DistanceACBCi)
            
    # alleviate division by zero errors
    divisor_abab = max(1, len(DistanceABAB))
    divisor_acab = max(1, len(DistanceACAB))
    divisor_bcbc = max(1, len(DistanceBCBC))
    divisor_acbc = max(1, len(DistanceACBC))
   
    D1 = (sum(DistanceABAB)/divisor_abab)-(sum(DistanceBCBC)/divisor_bcbc) #Estimate D1
    D2 = (sum(DistanceACAB)/divisor_acab)-(sum(DistanceACBC)/divisor_acbc) #Estimate D2
    data.append([tax2, tax3, tax4, D1, D2])

df_only_ingroups = pd.DataFrame(data, columns=column_names)
df_only_ingroups.to_csv(only_ingroup_permutations_csv_name)