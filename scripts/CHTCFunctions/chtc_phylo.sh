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

for j in 15000 30000 60000 105000 255000 510000
do
   length=$(($INT($j)/$INT($4)))
   seqgen_out=${j}_${gene_trees}_${network}_${num_gene_trees}_seqgen.out
   ./Seq-Gen-1.3.4/source/seq-gen -mGTR -r 1.0 0.2 10.0 0.75 3.2 1.6 -f 0.15 0.35 0.15 0.35 -i 0.2 -a 5.0 -g 3 -l${length} -z${seed} < ${gene_trees} > ${seqgen_out} 2> ${gene_trees}_${network}_${num_gene_trees}_seqgen.log
   
   #echo $length
   #echo "is length specified"

   # OLD PARAMS
   # -mHKY -t2.0 -f0.300414,0.191363,0.196748,0.311475 -l${j} -s0.018 -n1 -z${seed} < ${gene_trees} > ${seqgen_out} 2> ${gene_trees}_${network}_${num_gene_trees}_seqgen.log
   echo "${seqgen_out}"
done

for j in 50 100 150 200 500 1000 2000 5000 10000 50000 100000
do
   seqgen_out=${j}_${gene_trees}_${network}_${num_gene_trees}_seqgen.out
   ./Seq-Gen-1.3.4/source/seq-gen -mGTR -r 1.0 0.2 10.0 0.75 3.2 1.6 -f 0.15 0.35 0.15 0.35 -i 0.2 -a 5.0 -g 3 -l${j} -z${seed} < ${gene_trees} > ${seqgen_out} 2> ${gene_trees}_${network}_${num_gene_trees}_seqgen.log

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
   input=${gene_trees}_${network}_${num_gene_trees}_seqgen.out
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

for i in 15000 30000 60000 105000 255000 510000
do
   echo "$i"
   seqgen_output=${i}_${gene_trees}_${network}_${num_gene_trees}_seqgen.out
   hyde_input=${i}_${gene_trees}_${network}_${num_gene_trees}_seqgen_concatenated.out
   
   python seqgen2hyde.py ${seqgen_output} ${hyde_input} $3
   
   run_hyde.py -i ${hyde_input} -m ${map} -o ${outgroup} -n ${num_taxa} -t ${num_taxa} -s ${i} --prefix $1_$3_$4_${i}_HyDe

   HyDeOut=$1_$3_$4_${i}_HyDe-out.txt #verify thisdone
done

for i in 50 100 150 200 500 1000 2000 5000 10000 50000 100000
do
   echo "$i"
   seqgen_output=${i}_${gene_trees}_${network}_${num_gene_trees}_seqgen.out
   hyde_input=${i}_${gene_trees}_${network}_${num_gene_trees}_seqgen_concatenated.out
   
   python seqgen2hyde.py ${seqgen_output} ${hyde_input} $3
   
   size=$(($INT($i)*$INT($4)))

   run_hyde.py -i ${hyde_input} -m ${map} -o ${outgroup} -n ${num_taxa} -t ${num_taxa} -s ${size} --prefix $1_$3_$4_${i}_HyDe

   HyDeOut=$1_$3_$4_${i}_HyDe-out.txt #verify thisdone
done

 #exit environment

# maybe we want to look at it to see if seqgen concatenated is performing correctly
#rm *seqgen.out

##TICR

#quartet max cut is usually used in TICR for creating a most likely tree from a table of concordance factor values.
#and then this is used as a backbone to create a network. 

# TICR with Julia
# extract Julia binaries tarball
   tar -xzf julia-1.6.1-linux-x86_64.tar.gz
   tar -xzf my-project-julia.tar.gz
   tar -xzf TICR.tar.gz

# add Julia binary to path
export PATH=$_CONDOR_SCRATCH_DIR/julia-1.6.1/bin:$PATH
# add Julia packages to DEPOT variable
export JULIA_DEPOT_PATH=$_CONDOR_SCRATCH_DIR/my-project-julia

# HyDe table

for i in 15000 30000 60000 105000 255000 510000
do
HyDeOut=$1_$3_$4_${i}_HyDe-out.txt 
HyDeOutName=$5_n$3_$4_${num_trial}_${i}_HyDe_Dstat_totlen.csv
julia --project=my-project-julia chtc_HyDe_Dstat_table.jl ${HyDeOut} ${true_network} ${significance} ${HyDeOutName}
done

for i in 50 100 150 200 500 1000 2000 5000 10000 50000 100000
do
HyDeOut=$1_$3_$4_${i}_HyDe-out.txt 
HyDeOutName=$5_n$3_$4_${num_trial}_${i}_HyDe_Dstat_lenpertree.csv
julia --project=my-project-julia chtc_HyDe_Dstat_table.jl ${HyDeOut} ${true_network} ${significance} ${HyDeOutName}
done

rm *HyDe-out*txt

# in order to use quartet max cut, it needs an input that is produced by the script
   julia --project=my-project-julia chtc_cfTable.jl $1

# requires quartet max cut [find-cut-Linux-64] in working directory; 
#   ./TICR/scripts/get-pop-tree.pl $1.CFs.csv
# this creates a file named $1.QMC.tre

# we run this with our true network, which will be converted to its major tree
TICROut=$5_n$3_$4_${num_trial}_ticr.csv
julia --project=my-project-julia chtc_TICR.jl $1 $5 ${TICROut}

# compares to the true network   
# julia --project=my-project-julia chtc_TICR.jl $1 $5 ${TICROut}

#outputs: table of obsCF printed to file tableCF.txt, desciptive stat of input data printed to file summaryTreesQuartets.txt

## MSCquartets

tar -xzf R402.tar.gz
tar -xzf packages.tar.gz

# make sure the script will use your R installation, 
# and the working directory as its home location
export PATH=$PWD/R/bin:$PATH
export RHOME=$PWD/R
export R_LIBS=$PWD/packages

MSCOut=$5_n$3_$4_${num_trial}_MSC.csv
 #run MSC quartets analysis on input file (R)
 Rscript chtc_MSCquartets.R $1 ${MSCOut}

# TICR, HyDe, and MSCQuartets produce three different output files, 
# which can then be used to build a comparison table, and compared to a true network file

# expectedCFtable.jl

   export PATH=$_CONDOR_SCRATCH_DIR/julia-1.6.1/bin:$PATH
# add Julia packages to DEPOT variable
   export JULIA_DEPOT_PATH=$_CONDOR_SCRATCH_DIR/my-project-julia

   expected_quartets_file=n$3_$4_${num_trial}_expected.csv
   julia --project=my-project-julia chtc_expected_cfTable.jl ${true_network} ${gene_trees} ${expected_quartets_file}

 TICRMSCSummaryOut=$5_n$3_$4_${num_trial}_TICR_MSC_summary.csv
 julia --project=my-project-julia chtc_TICRMSC_table.jl ${expected_quartets_file} ${TICROut} ${MSCOut} ${significance} ${true_network} ${TICRMSCSummaryOut}
# output = ??

rm *_MSC.csv
rm *_ticr.csv

# TICR table
# MSCquartets table

rm *_expected.csv
rm *-gt*
rm *astral*



