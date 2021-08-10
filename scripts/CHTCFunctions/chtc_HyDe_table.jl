# Marianne Bjorner
# 14MAY2021
# 
# Input:
#    Hyde output
#    Known network structure
#    significance level
# Output:
#    Table comparing HyDe output to expected results

# exec '/Applications/Julia-1.5.app/Contents/Resources/julia/bin/julia'

import Pkg; Pkg.add("QuartetNetworkGoodnessFit")
import Pkg; Pkg.add("DataFrames")
import Pkg; Pkg.add("CSV")
import Pkg; Pkg.add("PhyloNetworks")

using QuartetNetworkGoodnessFit, DataFrames, CSV, PhyloNetworks

# constants
alpha = ARGS[3] # significance level

# inputs

HyDeFile = ARGS[1] #"/Users/bjorner/GitHub/HyDe/n10trial-out.txt"
netFile = ARGS[2] #"/Users/bjorner/GitHub/phylo-microbes/data/knownGT/n10.net"

# output file destination
outFile = "HyDeComparison_n10_1"

HyDeOut = DataFrame(CSV.File(HyDeFile))
net = readTopologyLevel1(netFile);

# create new column called "HyDeHybrid" 1 / 0 (default is 0)
insert!(HyDeOut, 6, 0, :HyDeHybrid)
HyDeOut[(HyDeOut[:Pvalue] .< alpha), :HyDeHybrid]=1

# create new column "Hybrid triplet" 1 / 0
insert!(HyDeOut, 7, 0, :HybridTripletExpected)
insert!(HyDeOut, 8, 0, :HybridCorrectID)

setsOfTriplets = size(HyDeOut)[1]

for row in 1:setsOfTriplets
    # extract the triplet that it tells you

    net = readTopologyLevel1(netFile);
    P1 = string(HyDeOut[row, :P1])
    Hybrid = string(HyDeOut[row, :Hybrid])
    P2 = string(HyDeOut[row, :P2])
    triplet = [P1,Hybrid,P2]

    for l in tipLabels(net)
        if l ∉ triplet
            PhyloNetworks.deleteLeaf!(net,l)
        end 
    end 

    print(string(net.numHybrids))

    if net.numHybrids > 0 # then the triplets contain a hybrid relationship
        HyDeOut[row, :HybridTripletExpected] = 1
    
        hybridclade = hardwiredCluster(net.hybrid[1].edge[1],tipLabels(net))
        trueHybrid = tipLabels(net)[hybridclade]
        if Hybrid == trueHybrid
            HyDeOut[row, :HybridCorrectID] = 1
        end
    end
end

# HyDeOut
CSV.write(string(outfile ,".csv"), HyDeOut)

# False positives / False Negatives rate
# false positives are when hyde detects a hybrid relationship where there isn't one

# count all positives where it should be a negative / count all negatives
falsePositives = 0
allNegatives = 0
for row in 1:setsOfTriplets
    if string(HyDeOut[row, :HybridTripletExpected]) == string(0)
        allNegatives = allNegatives + 1
        if string(HyDeOut[row, :HyDeHybrid]) == string(1)
            falsePositives = falsePositives + 1
        end
    end
end

