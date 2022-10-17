
netfile=long_mix04
map=~/GitHub/long_branch05map.txt
outgroup=O
num_taxa=4

for length in 50000 100000 250000 500000
do

for files in {1..30}
do
gene_trees=${netfile}-gt${length}-${files}-1.tre

seqgen_out=${gene_trees}_seqgen.out

~/GitHub/Seq-Gen-1.3.4/source/seq-gen -mGTR -s 0.01 -l 1 -r 1.0 0.2 10.0 0.75 3.2 1.6 \
        -f 0.15 0.35 0.15 0.35 -i 0.2 -a 5.0 -g 3 -q < ${gene_trees} > ${gene_trees}_seq.out 2> ${gene_trees}_seqgen.log

concat_target=${gene_trees}_seq.out
mapfile=${map}
outfile=${gene_trees}_concat.out

python ~/github/phylo-microbes/scripts/CHTCFunctions/seqgen2hyde.py ${concat_target} ${outfile} ${mapfile} 

hyde_input=${outfile}
python ~/github/HyDe/scripts/run_hyde.py -i ${hyde_input} -m ${mapfile} -o ${outgroup} -n ${num_taxa} -t ${num_taxa} -s ${length} --prefix ${gene_trees}_HyDe

HyDeOut=${gene_trees}_HyDe-out.txt
HyDeOutName=${gene_trees}_HyDe_Dstat.csv
true_network=${netfile}.net
significance=0.05

julia ~/github/phylo-microbes/scripts/CHTCFunctions/chtc_HyDe_Dstat_table.jl ${HyDeOut} ${true_network} ${significance} ${HyDeOutName}

done
done