# Marianne Bjorner
# 09APR2021
# 
# Input: true network
# Output: Concordance Factor table theoretical CFs 
# and whether those quartets denote a hybrid or tree structure


import Pkg; Pkg.add("QuartetNetworkGoodnessFit")
import Pkg; Pkg.add("DataFrames")
import Pkg; Pkg.add("CSV")
import Pkg; Pkg.add("PhyloNetworks")

using QuartetNetworkGoodnessFit, DataFrames, CSV, PhyloNetworks

cd("/Users/bjorner/GitHub/phylo-microbes/data/")

# knownGT - n10.net, n15.net
# n25h5 rooted.net OR n25h5.net
# n50h10 rooted.net OR n50h10.net
# n100h10

netFile = joinpath("knownGT/n10.net");
trueNetwork = readTopology(netFile);

# http://crsl4.github.io/PhyloNetworks.jl/v0.9/man/expectedCFs/

# read trees to a CF

cd("/Users/bjorner/GitHub/phylo-microbes/data/knownGT/n10_n30/")
tree = joinpath("1_astral.in")

genetrees = readMultiTopology(tree)
treesCF = readTrees2CF(genetrees)

topologyMaxQPseudolik!(trueNetwork, treesCF);


expectedCFTable = fittedQuartetCF(treesCF);
df_long = fittedQuartetCF(treesCF, :long)

# df_long now stores the expected CFs
# where there is a difference in minor CFs and expected CFs, 
# there *is* a hybrid structure

# write dataframe to CSV

CSV.write(string("/Users/bjorner/GitHub/phylo-microbes/data/knownGT/n10_n30/trueNet10_1.csv"), df_long)

# translate this table into the format of another here -

