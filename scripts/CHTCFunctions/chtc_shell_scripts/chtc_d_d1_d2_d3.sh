sequences=$1
map=$2
num_taxa=$3
outgroup=$3
true_network=$4

ENVNAME=HyDe
# if you need the environment directory to be named something other than the environment name, change this line
ENVDIR=$ENVNAME

# these lines handle setting up the environment; you shouldn't have to modify them
export PATH
mkdir $ENVDIR
tar -xzf $ENVNAME.tar.gz -C $ENVDIR
. $ENVDIR/bin/activate

python D3_D_combinations.py ${sequences} ${map}

hyde_input=${gene_trees}_concatenated.txt

python seqgen2hyde.py ${sequences} ${hyde_input} ${map}
run_hyde.py -i ${hyde_input} -m ${map} -o ${outgroup} -n ${num_taxa} -t ${num_taxa} -s ${i} --prefix ${gene_trees}_HyDe

rm *_concatenated.txt
