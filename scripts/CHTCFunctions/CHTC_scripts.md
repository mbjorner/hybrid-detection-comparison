# CHTC scripts

1. login to campus VPN 

2. ssh into CHTC

'''bash
ssh submit-1.chtc.wisc.edu

'''

3. transfer (secure copy) all scripts from home computer to chtc
- command-t to open new tab in terminal
'''bash
(base) % cd github/phylo-microbes/scripts/CHTCFunctions
(base) % scp chtc* bjorner@submit-1.chtc.wisc.edu:/home/bjorner
'''
- it will ask again for the password to login to CHTC 

## TICR

TICR depends on a quartet maxcut tree, and an input file. This runs in julia.

1. Download julia onto CHTC following https://chtc.cs.wisc.edu/julia-jobs
- using julia-#.#.#-linux-x86_64.tar.gz.

2. Download packages QuartetNetworkGoodnessFit, DataFrames, CSV, and PhyloNetworks

### QuartetMaxCut

## MSCQuartets

MSCQuartets depends only on an input file. This runs in R.

1. Download R onto CHTC following https://chtc.cs.wisc.edu/r-jobs

2. Download packages ape and MSCQuartets
'''bash

'''

## HyDe

HyDe depends on an input file that had sequences generated. This runs in python.

1. Download python onto CHTC following https://chtc.cs.wisc.edu/python-jobs

2. 

### seqgen

