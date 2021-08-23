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

treeCF = readTrees2CF(tree, CFfile="TempTreeCF.csv")

# ticr(treeCF, :maxCF, :onesided)

# ERROR: ArgumentError: reducing over an empty collection is not allowed
# why is it empty?

# use quartetmaxcut tree as network
QMCTree = joinpath("1_astral.QMC.tre")
net = readTopology(QMCTree);

ticrOut = ticr!(net, treeCF, true, quartetstat = :maxCF, test = :onesided)

io = open("n10_n30_1_ticr.txt", "w");
write(io, Base.string(ticrOut));

# ticrOut now stores the p-values in the second array{Float64,1} tuple column...
# typeof(ticrOut)
# Tuple{Float64,Float64,Dict{String,Int64},Array{Float64,1},Array{Float64,1},HybridNetwork}

# this is stored in ticr[5]

# how to concatenate the p-values with the treeCF that was found earlier?

# ensure rows of treeCF (not including header) and number of ticrOut is the same

# treeCF = DataFrame(CSV.File("tempTreeCF.csv"))
treeCF = writeTableCF(treeCF) # is way easier than writing then reading a file

if length(ticrOut[5]) != nrow(treeCF)
    println("These are not the same length, should end")
    println("length of ticrOut is ", length(ticrOut[5]))
    println("number of rows of CFtree is ", nrow(treeCF))
end

# pastes the p-values to dataframe
insertcols!(treeCF, 9, :pValTicr => ticrOut[5])

# to find if pValTicr is less than alpha of 0.05
# create a new column to indicate if the p-value is less than 0.05
hybrid = ticrOut[5].<0.05
insert!(treeCF, 10, hybrid, :isHybridTICR)

CSV.write(string("/Users/bjorner/GitHub/phylo-microbes/data/knownGT/n10_n30/", "1_TICR" ,".csv"), treeCF)
 

 