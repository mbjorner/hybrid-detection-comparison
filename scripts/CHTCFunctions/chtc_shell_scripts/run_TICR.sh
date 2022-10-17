#!/bin/bash
# give executable permissions with 'chmod +x run_TICR.sh'

# TICR with Julia
# extract Julia binaries tarball
tar -xzf julia-1.6.1-linux-x86_64.tar.gz
tar -xzf my-project-julia.tar.gz

# add Julia binary to path
export PATH=$_CONDOR_SCRATCH_DIR/julia-1.6.1/bin:$PATH
# add Julia packages to DEPOT variable
export JULIA_DEPOT_PATH=$_CONDOR_SCRATCH_DIR/my-project-julia

 # run Julia script
gene_trees_file=$1
input_network=$2
outfile=$3
julia --project=my-project-julia chtc_TICR.jl ${gene_trees_file} ${input_network} ${outfile}