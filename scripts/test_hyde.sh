#!/bin/bash

# Marianne Bjorner 18MAR2021

num_taxa=10
input=./GitHub/phylo-microbes/data/sequences/n10h2/1_astral_seqgen.out
map=./GitHub/n10h2map.txt

# requires the input and map files inside of the HyDe folder

cd ./GitHub/HyDe
./GitHub/HyDe/run_hyde.py -i ${input} -m ${map} -o out -n ${num_taxa} -t ${num_taxa} -s 500 --prefix n10trial