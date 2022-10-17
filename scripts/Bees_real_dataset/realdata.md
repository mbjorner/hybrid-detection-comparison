# Documentation for real datasets

Datasets tried:
- Pseudapis Bees: https://academic.oup.com/sysbio/article-abstract/70/4/803/6050959?login=false
    - Dataset: https://datadryad.org/stash/dataset/doi:10.5061/dryad.z08kprrb6

/Users/bjorner/DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4

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
 
Modifications: Per initial published species tree (figure 2 in Pseudapis bees paper), phylobayes_consensus_80p_867loci.newick was rooted at outgroups Dufourea_novaeangliae and Lasioglossum_albipes. Durfourea_novaeangliae was removed from each gene tree, as well as from the sequence file to simplify analysis.

Gene Trees:

For each folder, gene trees were concatenated into a single file for use in methods TICR and MSCquartets.

```
julia concatenate_files.jl Iq2_GTRG gene_tree_files.txt Iq2_GTRG_concatenated_gene_tree_files.tre 
julia concatenate_files.jl Iq2_MFP gene_tree_files.txt Iq2_MFP_concatenated_gene_tree_files.tre 
julia concatenate_files.jl MrBayes_GTRG gene_tree_files.txt MrBayes_GTRG_concatenated_gene_tree_files.tre 
julia concatenate_files.jl MrBayes_rj gene_tree_files.txt MrBayes_rj_concatenated_gene_tree_files.tre 
julia concatenate_files.jl PhyloBayes gene_tree_files.txt PhyloBayes_concatenated_gene_tree_files.tre 
julia concatenate_files.jl RAxML gene_tree_files.txt RAxML_concatenated_gene_tree_files.tre 

```

Species trees used as comparison were derived from resulting species trees
from file.
/Users/bjorner/DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/gene_trees/Iq2_GTRG/Iq2_GTRG_concatenated_gene_tree_files.tre_MSCresults.csv

```
# running MSCquartets:

output_name=${datafile}_MSCresults.csv
RScript chtc_MSCquartets.R ${datafile} ${output_name}

gene_trees=$1
network=$3
num_gene_trees=$4
true_network=$5
num_trial=$6

# running HyDe
# /Users/bjorner/DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/alignments/concatenated_matrix/80p_completeness.phylip
hyde_input=/Users/bjorner/DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/alignments/concatenated_matrix/80p_completeness.phylip
map=phylo-microbes/scripts/Bees_real_dataset/bee_map.txt
num_taxa=32
#outgroup=Dufourea_novaeangliae
outgroup=Lasioglossum_albipes
length=576041
run_hyde.py -i ${hyde_input} -m ${map} -o ${outgroup} -n ${num_taxa} -t ${num_taxa} -s ${length} --prefix bees_HyDe_outgroup_${outgroup}

hyde_input=/Users/bjorner/GitHub/phylo-microbes/scripts/Bees_real_dataset/bee_map_without_Dufourea.txt
map=/Users/bjorner/GitHub/phylo-microbes/scripts/Bees_real_dataset/bee_map_without_Dufourea.txt
num_taxa=31
outgroup=Lasioglossum_albipes
length=576041
run_hyde.py -i ${hyde_input} -m ${map} -o ${outgroup} -n ${num_taxa} -t ${num_taxa} -s ${length} --prefix bees_HyDe_outgroup_without_Dufourea_${outgroup}



# running ABBA-BABA using HyDe output:
input=bees_HyDe-out.txt 
output=bees_HyDe_ABBABABA-out.csv
julia ABBA-BABA_from_hyde.jl ${input} {output}

input="/Users/bjorner/DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/alignments/concatenated_matrix/80p_completeness.phylip"
rerooted_tree="/Users/bjorner/GitHub/phylo-microbes/scripts/Bees_real_dataset/rerooted_iqtree.tre"
output_HyDe="/Users/bjorner/GitHub/phylo-microbes/scripts/Bees_real_dataset/bees_HyDe_outgroup_Lasioglossum_albipes-out.txt"
analyzeHyDe_DStat(output_HyDe, "bees_outgroup_Lasioglossum_analyzed.csv", rerooted_tree, "/User/bjorner/GitHub/phylo-microbes/scripts/Bees_real_dataset/", "Lasioglossum_albipes") 


```

# TICR on species trees:
three concatenation trees were published by the authors of original Pseudapis bees study, located in the following directories. These are topologically equivalent according to fig 2.
DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/species_trees/concatenation_trees/iqtree2_consensus_80p_867loci.newick
DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/species_trees/concatenation_trees/PhyloBayes_consensus_80p_867loci.newick
DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/species_trees/concatenation_trees/RAxML_bipartitions_80p_867loci.newick

ASTRAL trees were also created from gene trees
DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/species_trees/ASTRAL_trees/30_collapsed_no_loci_removed/ez_astral.tre
DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/species_trees/ASTRAL_trees/30_collapsed_no_loci_removed/iq_GTRG_astral.tre
DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/species_trees/ASTRAL_trees/30_collapsed_no_loci_removed/iq_MFP_astral.tre
DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/species_trees/ASTRAL_trees/30_collapsed_no_loci_removed/MB_GTRG_astral.tre
DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/species_trees/ASTRAL_trees/30_collapsed_no_loci_removed/MB_rj_astral.tre
DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/species_trees/ASTRAL_trees/30_collapsed_no_loci_removed/RAxML_astral.tre

to run these with TICR, we use the gene trees obtained from IQ-Tree 2 (GTR+G) to compare.

```
method_species_tree=RAxML_bipartitions
species_tree=/Users/bjorner/DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/species_trees/concatenation_trees/${method_species_tree}_80p_867loci.newick
gene_trees=/Users/bjorner/DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/gene_trees/Iq2_GTRG/Iq2_GTRG_concatenated_gene_tree_files.tre
outfile=${method_species_tree}_TICR.csv
julia /Users/bjorner/GitHub/phylo-microbes/scripts/CHTCFunctions/individual_methods/chtc_TICR.jl ${gene_trees} ${species_tree} ${outfile}
```
### TICR results:

- no support for proposed tree from IQ-tree_consenses with IQ-tree2 gene trees: GitHub/phylo-microbes/scripts/Bees_real_dataset/iqtree2_consensus_TICR.csv
- no support for proposed tree from PhyloBayes_consensus with IQ-tree2 gene trees: GitHub/phylo-microbes/scripts/Bees_real_dataset/PhyloBayes_consensus_TICR.csv
- no support for proposed tree from RAxML bipartitions with IQ-tree2 gene trees: GitHub/phylo-microbes/scripts/Bees_real_dataset/RAxML_bipartitions_TICR.csv
