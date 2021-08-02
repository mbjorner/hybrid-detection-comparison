#!/bin/bash
# give executable permissions with 'chmod +x run_MSCquartets.sh'

# input = GeneTreeFile

# untar R installation and packages
tar -xzf R402.tar.gz
tar -xzf packages.tar.gz

# make sure the script will use your R installation, 
# and the working directory as its home location
export PATH=$PWD/R/bin:$PATH
export RHOME=$PWD/R
export R_LIBS=$PWD/packages

# run MSC quartets analysis on input file (R)
Rscript chtc_MSCquartets.R $1

