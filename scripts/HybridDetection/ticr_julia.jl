# Marianne Bjorner
# 01APR2021
# 
# Input: tree files, QuartetMaxCut Tree
# Output: txt file of ticr output

import Pkg; Pkg.add("QuartetNetworkGoodnessFit")
import Pkg; Pkg.add("DataFrames")
import Pkg; Pkg.add("CSV")
import Pkg; Pkg.add("PhyloNetworks")

using QuartetNetworkGoodnessFit, DataFrames, CSV, PhyloNetworks

cd("/Users/bjorner/GitHub/phylo-microbes/data/knownGT/n10_n30/")

tree = joinpath("1_astral.in")

treeCF = readTrees2CF(tree)
treeCF = DataFrame(CSV.File("tableCF.txt"));
# ticr(treeCF, :maxCF, :onesided)

# ERROR: ArgumentError: reducing over an empty collection is not allowed
# why is it empty?

# use quartetmaxcut tree as network
QMCTree = joinpath("1_astral.QMC.tre")
net = readTopology(QMCTree);

ticrOut = ticr!(net, treeCF, true, quartetstat = :maxCF, test = :onesided)

CSV.write("ticrTree.csv",treeCF)

io = open("n10_n30_1_ticr.txt", "w");
write(io, Base.string(ticrOut));


 

 