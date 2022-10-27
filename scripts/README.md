## Guide to running scripts

The following folders contain any necessary scripts for rerunning data analyses and recreating plots for hybrid detection methods MSCquartets, HyDe, ABBA-BABA (Patterson's D-Statistic), D3, and Dp. 

1. Running HyDe, TICR, and MSCquartets from simulated gene trees/sequences using their extended newick format is found in `network-simulation-details.jl.ipynb`. 
    - Methods TICR (julia) and MSCquartets (R) are available as packages, and their individual scripts for use in the notebook are located in the `HybridDetection` folder. However, HyDe requires an additional download (https://github.com/pblischak/HyDe).
    - This script depends on the additional download of programs `ms` (https://home.uchicago.edu/rhudson1/source/mksamples.html) and `seq-gen` (https://github.com/rambaut/Seq-Gen) for generation of gene trees and sequences.
    - For post-processing of sequences, `goalign` (https://github.com/evolbioinfo/goalign) and `snp-sites` are used (https://github.com/sanger-pathogens/snp-sites).

2. Analyzing HyDe output to compute D3, Dp, and Patterson's D-Statistic is found in the script `/SummaryTables/analyzeMethodOutputFile.jl`, contained in the functions `calcD3fromHyDe`, `calcDpsd_concatenated`, and `calcDsd_concatenated` respectively.

3. Analyzing all method output files to compute true positives and negatives when provided a ground truth extended newick format of the network is also found in `/SummaryTables/analyzeMethodOutputFile.jl`, with `analyzeHyDe_DStat` and `analyzeTICR_MSC`. 

4. Analysis on a real dataset of bees (Pseudapis spp.) is contained in the folder Bees_real_dataset.

#### CHTCFunctions

contains scripts for running methods on grid computing system CHTC

#### HelperFunctions

contains helper functions that are used in construction of other methods and/or creation of simulated data.

#### SummaryTables

contains methods to summarize timing, analyze for false positives/negatives, and otherwise compile results

- analyzeMethodOutputFile.jl contains a number of functions helpful in:
    - computing Patterson's D-Statistic from HyDe output files
    - computing D3 from HyDe output files
    - computing Dp from HyDe output files
    - calculating the accuracy of HyDe, D, D3, Dp, TICR, and MSCquartets in the form of true and false positives and negatives
- time_summary.jl contains functions to compile timing data for each of the methods TICR, MSCquartets, and HyDe

#### HybridDetection

contains functions MSCquartets and TICR to detect hybridization from gene trees. 

- MSCquartets.R: runs MSCquartets
- TICR.jl: runs TICR
- TICRMSC_compilation_table.jl: creates table of MSCquartets and TICR results

#### PlotFunctions

contains functions for plotting all results


