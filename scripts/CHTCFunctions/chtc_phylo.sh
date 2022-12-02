#!/bin/bash

# script for running the entirety of a job, where one job is
# defined as one set of gene trees as input.

#inputs:
# gene_trees: used for TICR, HyDe, and MSCquartets
# map: used for HyDe
# network: identifier used for file naming/organization

#inputs:
gene_trees=$1
map=$2
num_taxa=$3
true_network=$4

significance=0.05

###### HYDE / D-Statistic ######


# replace env-name on the right hand side of this line with the name of your conda environment
ENVNAME=HyDe
# if you need the environment directory to be named something other than the environment name, change this line
ENVDIR=$ENVNAME

# these lines handle setting up the environment; you shouldn't have to modify them
   export PATH
   mkdir $ENVDIR
   tar -xzf $ENVNAME.tar.gz -C $ENVDIR
   . $ENVDIR/bin/activate

# for n10, out = 10; n15=15, n25=25, n50=50, n100=53
   outgroup=$3
   case "$outgroup" in
      100) outgroup=53
      ;;
      25) outgroup=25
      ;;
      50) outgroup=50
      ;;
      5) outgroup=5
      ;;
      4) outgroup=4
      ;;
   esac

#  seqgen_output=$1 --- toggle line to run hyde
seqgen_output=$2



# where $3 is the number of taxa in the network OR the map file if the taxa names are non-integers
boolHyde=0
timefile=${seqgen_output}_HyDe_time.txt
for i in 3000 10000 50000 100000 250000 500000
do
   j="$i"
   if [ "${seqgen_output}" == *"-gt${j}-"*"out" ] 
   then
      echo "running HyDe on ${seqgen_output}"
      # python seqgen2hyde.py ${seqgen_output} ${hyde_input} ${map_file} # no longer needed
      { time run_hyde.py -i ${seqgen_output} -m ${map} -o ${outgroup} -n ${num_taxa} -t ${num_taxa} -s ${i} --prefix ${gene_trees}_HyDe ; } 2> ${timefile}
      HyDeOut=${gene_trees}_HyDe-out.txt
      # timefile=${seqgen_output}_D3_D_time.txt
      # { time python D3_D_combinations.py ${seqgen_output} ${map} ; } 2> ${timefile}

      boolHyde=1
   fi
done

# unpack tarred files
export WORKDIR=$PWD
tar -xzf Seq-Gen-1.3.4.tar.gz
cd $WORKDIR

## create PHYLIP alignment
./Seq-Gen-1.3.4/source/seq-gen -mHKY -s0.036 -f0.300414,0.191363,0.196748,0.311475 -n1 -l100 <  ${gene_trees} > alignment.sg.phy 2> seqgen_seed.log

## save seed for recreation
# grep "" seedms >> ${gt_filename}_seeds.txt
cat ${gene_trees} | sed -n '2p' >> ${gene_trees}_seeds.txt
grep "seed: " seqgen_seed.log >> ${gene_trees}_seeds.txt

## create iqtree gene trees for comparison
# unpack tarred files
export WORKDIR=$PWD
tar -xzf iqtree-1.6.12-Linux.tar.gz
cd $WORKDIR

# extract
numtaxa=$3
line_split=$((${numtaxa} + 1))
split -d -l ${line_split} alignment.sg.phy physplit
treename=${gene_trees}_iqtree.tre
for i in physplit?*
do
   ./iqtree-1.6.12-Linux/bin/iqtree -m HKY85 -s $i
   cat ${i}.treefile >> ${treename}
done

# extract Julia binaries tarball
tar -xzf julia-1.6.1-linux-x86_64.tar.gz
tar -xzf my-project-julia.tar.gz

# add Julia binary to path
export PATH=$_CONDOR_SCRATCH_DIR/julia-1.6.1/bin:$PATH
# add Julia packages to DEPOT variable
export JULIA_DEPOT_PATH=$_CONDOR_SCRATCH_DIR/my-project-julia

tar -xzf TICR.tar.gz

## run TICR using gene tree output and compare to major tree
timefile=${gene_trees}_TICR_time.txt
TICROut=${gene_trees}_ticr.csv
{ time julia --project=my-project-julia chtc_TICR.jl ${gene_trees} ${true_network} ${TICROut} ; } 2> ${timefile}

## run TICR using iqtree gene tree output and compare to major tree
TICROut_iq=${treename}_ticr.csv
{ time julia --project=my-project-julia chtc_TICR.jl ${treename} ${true_network} ${TICROut_iq} ; } >> ${timefile}
    
## MSCquartets
tar -xzf R413.tar.gz
tar -xzf packages.tar.gz

# make sure the script will use your R installation, 
# and the working directory as its home location
export PATH=$PWD/R/bin:$PATH
export RHOME=$PWD/R
export R_LIBS=$PWD/packages

# run MSCquartets using gene tree output
timefile=${gene_trees}_MSC_time.txt
MSCOut=${gene_trees}_MSC.csv
{ time Rscript chtc_MSCquartets.R ${gene_trees} ${MSCOut} ; } 2> ${timefile}

# run MSCquartets using iqtree gene tree output
MSCOut_iq=${treename}_MSC.csv
{ time Rscript chtc_MSCquartets.R ${treename} ${MSCOut_iq} ;} >> ${timefile}

export PATH=$_CONDOR_SCRATCH_DIR/julia-1.6.1/bin:$PATH
export JULIA_DEPOT_PATH=$_CONDOR_SCRATCH_DIR/my-project-julia

#expected_quartets_file=${gene_trees}_expected.csv
#julia --project=my-project-julia chtc_expected_cfTable.jl ${true_network} ${gene_trees} ${expected_quartets_file}

TICRMSCSummaryOut=${gene_trees}_TICR_MSC_summary.csv
julia --project=my-project-julia chtc_TICRMSC_table.jl ${TICROut} ${MSCOut} ${significance} ${true_network} ${TICRMSCSummaryOut}

TICRMSCSummaryOut_iq=${treename}_TICR_MSC_summary.csv
julia --project=my-project-julia chtc_TICRMSC_table.jl ${TICROut_iq} ${MSCOut_iq} ${significance} ${true_network} ${TICRMSCSummaryOut_iq}




# HyDe table
if [[ $boolHyde == 1 ]] 
then
echo "HyDe should run on ${seqgen_output}"
HyDeOut=${gene_trees}_HyDe-out.txt
HyDeOutName=${gene_trees}_HyDe_Dstat.csv
julia --project=my-project-julia chtc_HyDe_Dstat_table.jl ${HyDeOut} ${true_network} ${significance} ${HyDeOutName}
fi



# removal of excess files
rm *_MSC.csv
rm *_ticr.csv
rm physplit*
rm *.CFs.csv
rm *_expected.csv
rm *astral*
rm summaryTreesQuartets.txt
rm tableCF.txt