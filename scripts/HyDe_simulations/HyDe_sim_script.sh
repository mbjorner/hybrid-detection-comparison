#!/bin/bash

# script for running the entirety of a job, where one job is
# defined as one set of gene trees as input.

#inputs:
# gene_trees: used for TICR, HyDe, and MSCquartets
# map: used for HyDe
# network: identifier used for file naming/organization
# num_gene_trees: identifier used for file naming/organization

#inputs:
gene_trees=$1
network=$3
num_gene_trees=$4
true_network=$5
num_trial=$6

significance=0.05

## HYDE

#variables: 
# seqgen 
seed=275890


## seqgen: 
# output - .log and .out files.
# .out is used for HyDe

# unpack tarred files
export WORKDIR=$PWD
tar -xzf Seq-Gen-1.3.4.tar.gz

# creates makefile
#cd Seq-Gen-1.3.4 
#cd source
#make

cd $WORKDIR

#cd Seq-Gen-1.3.4 
#cd source
#ls

#chmod +x ./Seq-Gen-1.3.4/source/seq-gen

for j in 50000 100000 250000 500000
do
   seqgen_out=${j}_${gene_trees}_${network}_seqgen.out
   ./Seq-Gen-1.3.4/source/seq-gen -mGTR -r 1.0 0.2 10.0 0.75 3.2 1.6 -f 0.15 0.35 0.15 0.35 -i 0.2 -a 5.0 -g 3 -s0.018 -n1  -l${j} -z${seed} < ${gene_trees} > ${seqgen_out} 2> ${gene_trees}_${network}_seqgen.log
   
   # OLD PARAMS
   # -mHKY -t2.0 -f0.300414,0.191363,0.196748,0.311475 -l${j} -s0.018 -n1 -z${seed} < ${gene_trees} > ${seqgen_out} 2> ${gene_trees}_${network}_${num_gene_trees}_seqgen.log
   echo "${seqgen_out}"
done
# have job exit if any command returns with non-zero exit status (aka failure)
# set -e

# replace env-name on the right hand side of this line with the name of your conda environment
ENVNAME=HyDe
# if you need the environment directory to be named something other than the environment name, change this line
ENVDIR=$ENVNAME

# these lines handle setting up the environment; you shouldn't have to modify them
   export PATH
   mkdir $ENVDIR
   tar -xzf $ENVNAME.tar.gz -C $ENVDIR
   . $ENVDIR/bin/activate

 # run HyDe script using inputs
   input=${gene_trees}_${network}_seqgen.out
   map=$2
   num_taxa=$3

# for n10, out = 10; n15=15, n25=25, n50=50, n100=53
   outgroup=$3
   case "$3" in
      100) outgroup=t53
      ;;
      25) outgroup=t25
      ;;
      50) outgroup=t50
      ;;
      5) outgroup=E
      ;;
      4) outgroup=O
      ;;
   esac

# modify this line to run your desired Python script and any other work you need to do

for i in 50000 100000 250000 500000
do
   echo "$i"
   seqgen_output=${i}_${gene_trees}_${network}_seqgen.out
   run_hyde.py -i ${seqgen_output} -m ${map} -o ${outgroup} -n ${num_taxa} -t ${num_taxa} -s ${i} --prefix $1_$3_${i}_HyDe

   HyDeOut=$1_$3_${i}_HyDe-out.txt
done

 #exit environment

rm *seqgen*

# extract Julia binaries tarball
   tar -xzf julia-1.6.1-linux-x86_64.tar.gz
   tar -xzf my-project-julia.tar.gz

# add Julia binary to path
export PATH=$_CONDOR_SCRATCH_DIR/julia-1.6.1/bin:$PATH
# add Julia packages to DEPOT variable
export JULIA_DEPOT_PATH=$_CONDOR_SCRATCH_DIR/my-project-julia

# HyDe table

for i in 50000 100000 250000 500000
do
    HyDeOut=$1_$3_${i}_HyDe-out.txt 
    HyDeOutName=$1_$3_${i}_HyDe.csv
    julia --project=my-project-julia chtc_HyDe_table.jl ${HyDeOut} ${true_network} ${significance} ${HyDeOutName}
done

rm *HyDe-out*
rm *_expected.csv
rm *astral*



