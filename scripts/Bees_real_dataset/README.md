#### Analyzing sequences and gene tree files from Bossert et. al. 2021

Dataset as used in the manuscript [Bossert et. al. 2021](https://academic.oup.com/sysbio/article-abstract/70/4/803/6050959?login=false) is found in [dryad](https://datadryad.org/stash/dataset/doi:10.5061/dryad.z08kprrb6).

Input data used:
 - Concatenated gene sequences stored in ./alignments/concatenated_matrix/80p_completeness.phylip
	- consists of 32 alignments of 576041bp length
 - Gene trees created from the gene sequences: 852 gene trees (one for each UCE) were reconstructed in the original manuscript using 6 different methods, and found in folders labeled accordingly:
Iq2_GTRG
Iq2_MFP
MrBayes_GTRG
MrBayes_rj
PhyloBayes
RAxML
 
Modifications: 

- Per initial published species tree (figure 2 in Bossert et al 2021), file `phylobayes_consensus_80p_867loci.newick` was rooted at outgroups Dufourea_novaeangliae and Lasioglossum_albipes. Durfourea_novaeangliae was removed from each gene tree, as well as from the sequence file to simplify analysis as HyDe uses only one outgroup.

Gene Trees:

- For each folder, gene trees were concatenated into a single file for use in methods TICR and MSCquartets. `gene_tree_files.txt` is a file that lists paths to all gene tree files to be concatenated.

```
julia concatenate_files.jl Iq2_GTRG_gene_tree_files.txt Iq2_GTRG_concatenated_gene_tree_files.tre 
julia concatenate_files.jl Iq2_MFP_gene_tree_files.txt Iq2_MFP_concatenated_gene_tree_files.tre 
julia concatenate_files.jl MrBayes_GTRG_gene_tree_files.txt MrBayes_GTRG_concatenated_gene_tree_files.tre 
julia concatenate_files.jl MrBayes_rj_gene_tree_files.txt MrBayes_rj_concatenated_gene_tree_files.tre 
julia concatenate_files.jl PhyloBayes_gene_tree_files.txt PhyloBayes_concatenated_gene_tree_files.tre 
julia concatenate_files.jl RAxML_gene_tree_files.txt RAxML_concatenated_gene_tree_files.tre 
```

Species trees used as comparison were derived from resulting species trees
from file.
/Users/bjorner/DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/gene_trees/Iq2_GTRG/Iq2_GTRG_concatenated_gene_tree_files.tre_MSCresults.csv


#### running MSCquartets:
```
# where datafile is the concatenated gene tree file
datafile=/phylo-microbes/scripts/Bees_real_dataset/input_data/Iq2_GTRG_concatenated_gene_tree_files.tre
output_name=${datafile}_MSCresults.csv
RScript /phylo-microbes/scripts/HybridDetection/MSCquartets.R ${datafile} ${output_name}
```

#### tunning TICR:
```
# where output from IQ-Tree 2 (GTR+G model) is used to compare to the rerooted consensus tree
method_species_tree=Iq2_GTRG
gene_trees=Iq2_GTRG_concatenated_gene_tree_files.tre
species_tree
outfile=${method_species_tree}_TICR.csv
julia /Users/bjorner/GitHub/phylo-microbes/scripts/HybridDetection/TICR.jl ${gene_trees} ${species_tree} ${outfile}

```
#### running HyDe

```
hyde_input=/phylo-microbes/scripts/Bees_real_dataset/80p_completeness_without_Dufourea.phylip
map=/phylo-microbes/scripts/Bees_real_dataset/bee_map_without_Dufourea.txt
num_taxa=31
outgroup=Lasioglossum_albipes
length=576041
run_hyde.py -i ${hyde_input} -m ${map} -o ${outgroup} -n ${num_taxa} -t ${num_taxa} -s ${length} --prefix bees_HyDe_outgroup_without_Dufourea_${outgroup}
```

#### running Dp, D3, Patterson's D-Statistic

```
# from the previous output of HyDe (output_HyDe), run following as contained in /phylo-microbes/scripts/SummaryTables/analyzeMethodOutputFile.jl/

output_HyDe=/phylo-microbes/scripts/Bees_real_dataset/results/bees_HyDe_outgroup_without_Dufourea_Lasioglossum_albipes-out.txt
rerooted_tree=/phylo-microbes/scripts/Bees_real_dataset/input_data/rerooted_iqtree.tre

analyzeHyDe_DStat(output_HyDe, "bees_outgroup_Lasioglossum_analyzed.csv", rerooted_tree, "/phylo-microbes/scripts/Bees_real_dataset/", "Lasioglossum_albipes") 
```