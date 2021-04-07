nums=(n10 n15)
trees=(30 100 300 1000 3000)
outgroups=()

folder=./GitHub/phylo-microbes/data/knownGT/n10_n30/

# outgroup is dependent on what 

for i in {1..30}
do
    # run ticr pipeline from the csv CFs
    # requires quartet max cut [find-cut-Mac] in working directory
    ./TICR/scripts/get-pop-tree.pl ${folder}${i}_astral.CFs.csv
    # creates .txt and .tre file

    #rename csv files

    cp ${folder}${i}_astral.CFs

    # requires some copy pasting of CFs 
    Rscript --vanilla ./TICR/scripts/getTreeBranchLengths.r ${folder}/${i}_astral

done