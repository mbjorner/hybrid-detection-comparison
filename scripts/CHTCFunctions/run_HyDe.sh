#!/bin/bash
# give executable permissions with 'chmod +x run_HyDe.sh'

# have job exit if any command returns with non-zero exit status (aka failure)
set -e

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
input=$1
map=$2
num_taxa=$3
outgroup=10
# for n10, out = 10; n15 =15, n25=25, n50=50, n100=53

# input = 

# modify this line to run your desired Python script and any other work you need to do
run_hyde.py -i ${input} -m ${map} -o ${outgroup} -n ${num_taxa} -t ${num_taxa} -s 500 --prefix n10trial


