MSCsimtester, an R package from Allman et. al. [documentation](https://jarhodesuaf.github.io/software/MSCsimtester_1.0.0.pdf), allows users to determine whether the simulated gene trees match the multi-species coalesent model. 

This relies on the functions ADtest, pairwiseDist, and rootedTriple.

The output of the ADtest function is a histogram of counts comparing 3 input taxa and their pairwise distances versus their expected pairwise distances. The expected pairwise distances are calculated using an input (rooted) species tree with parameters population sizes and edge lengths. The input must be a rooted, bifurcating tree. 

Rooted 0-hybrid network files are found in RootedTrees folder. These have the internal nodes labeled, which makes counting the number of total nodes easier (necessary for setting population sized), and were originally created by removing a hybridization from the output of hybridlambda's rooted tree file. These are written in Newick tree format.


This test was completed on:
- X_astral.in files (use **ms** for simulation) where X is the replicate, on N10, N15 networks with 2, 3 hybridizations respectively.
    - N10
    - N15


- **hybridlambda** files on N10 and N15 single hybridization networks (N10red, N10orange, N15blue, N15red, N15orange)
    - N10
    - N15

- **hybridlambda** files on gene trees with four taxa.
    - HyDe four taxon trees

Results from astral files:
- 

Results from hybridlambda files:
- 

Results from HyDe sim

Expected results from different phylogenetic tree simulators are located in the article [Testing Multispecies Coalescent Models using Summary Statistics](https://arxiv.org/pdf/1908.01424.pdf), written by Allman, Banos, and Rhodes. 

Acknowledgements given to Hector Banos for assistance with understanding population trees edge lengths and sizes to use as input for MSCsimtester's ADtest and pairwiseDist functions.