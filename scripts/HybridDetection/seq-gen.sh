#!/bin/bash

# Marianne Bjorner 04MAR2021

# this depends on seq-gen, available from https://github.com/rambaut/Seq-Gen
# takes gene trees as input and produces sequences as output



input_file=./GitHub/phylo-microbes/data/n25h5/n25h5
output_dir=./GitHub/phylo-microbes/data/sequences/n25h5/n25h5

choices=(-gt50- -gt100- -gt500- -gt1000-)
choices=()
# there are 6 copies of each gt1000 tree for some reason... ?

for j in ${choices[@]}    
do
    for i in {1..30}
    do
       ./Seq-Gen/seq-gen -mHKY -t2.0 -f0.300414,0.191363,0.196748,0.311475 -l500 -s0.018 -n1 < ${input_file}${j}${i}-1.tre > ${output_dir}${j}${i}-1_seqgen.out 2> ${output_dir}${j}${i}-1_seqgen.log
    done
done