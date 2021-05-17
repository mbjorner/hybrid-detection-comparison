# Marianne Bjorner
# 14MAY2021
# 
# Input:
#    Hyde output
#    Known network structure
#    significance level
# Output:
#    Table comparing HyDe output to expected results

import Pkg; Pkg.add("QuartetNetworkGoodnessFit")
import Pkg; Pkg.add("DataFrames")
import Pkg; Pkg.add("CSV")
import Pkg; Pkg.add("PhyloNetworks")

using QuartetNetworkGoodnessFit, DataFrames, CSV, PhyloNetworks


cd("/Users/bjorner/GitHub/phylo-microbes/data/")

netFile = joinpath("knownGT/n10.net");
trueNetwork = readTopology(netFile);

