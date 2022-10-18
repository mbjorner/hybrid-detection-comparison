## CHTCFunctions

contains scripts for running on CHTC

Currently supported:

- MSCquartets (R)
- TICR (julia)
- HyDe (python)
- ABBA-BABA (as included in HyDe)

## HelperFunctions

contains (primarily julia) helper functions that are used in construction of other methods and/or creation of simulated data.

- extractSubnets.jl: extracts subnetworks in triplet form
- fromTrees2CF.jl: creates concordance factor table from gene tree input
- functions.jl: simulates gene trees from a network
- simulating-gene-trees.jl: simulates gene trees from a network

## SummaryTables

contains summary tables for HyDe, MSCQuartets, and TICR functions, given their output. compares these to expected networks.

- expectedCFtable.jl: creates expected table from given network
- HyDe_table.jl: creates HyDe table summary, incl. comparison to expected network
- makeTICRMSCTable.jl: creates TICR and MSC quartets table, incl. comparison to expected network

## HybridDetection

contains functions to detect hybridization from gene trees or sequences, as well as simulating sequences.

- ticr_julia.jl: TICR using the quartet-networks-goodness of fit julia package
- seq-gen.sh: generates sequences
- test_hyde.sh: runs HyDe
- MSCQuartets folder: runs R-based MSCQuartets analysis
