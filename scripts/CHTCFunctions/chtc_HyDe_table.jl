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
if (length(ARGS) > 0)
    alpha = ARGS[3] # significance level

# inputs

    HyDeFile = ARGS[1] #"/Users/bjorner/GitHub/HyDe/n10trial-out.txt"
    netFile = ARGS[2] #"/Users/bjorner/GitHub/phylo-microbes/data/knownGT/n10.net"

# output file destination
    outFile = ARGS[4]
else
    alpha = "0.05"
    HyDeFile = "/Users/bjorner/GitHub/HyDe/n10trial-out.txt"
    netFile = "/Users/bjorner/GitHub/phylo-microbes/data/knownGT/n10.net"
    outFile = "output_test.csv"
end

HyDeOut = DataFrame(CSV.File(HyDeFile))
net = readTopologyLevel1(netFile);

# create new column called "HyDeHybrid" 1 / 0 (default is 0)
insertcols!(HyDeOut, 6, :HyDeHybrid => 0)
for row in 1:size(HyDeOut,1)
    if (HyDeOut[row, :Pvalue] .< parse(Float64,alpha))
        HyDeOut[row, :HyDeHybrid]=1
    end
end

# create new column "Hybrid triplet" 1 / 0
insertcols!(HyDeOut, 7, :HybridTripletExpected => 0)
insertcols!(HyDeOut, 8, :HybridCorrectID => 0)

setsOfTriplets = size(HyDeOut,1)

for row in 1:setsOfTriplets
    # extract the triplet that it tells you

    net = readTopologyLevel1(netFile);
    P1 = string(HyDeOut[row, :P1]);
    Hybrid = string(HyDeOut[row, :Hybrid]);
    P2 = string(HyDeOut[row, :P2]);
    triplet = [P1,Hybrid,P2];

    for l in tipLabels(net)
        if l ∉ triplet
            PhyloNetworks.deleteleaf!(net,l, keeporiginalroot=true);
            #@show net
        end 
    end 

    #plot(net,:R)

    print("The number of hybrids leftover in the net is ", string(net.numHybrids), "\n")

    if net.numHybrids > 0 # then the triplets contain a hybrid relationship
        HyDeOut[row, :HybridTripletExpected] = 1;
    
        hybridclade = hardwiredCluster(net.hybrid[1].edge[1],tipLabels(net));
        print("the hybrid clade is ", hybridclade)
        trueHybrid = tipLabels(net)[hybridclade];

        print("the hybrid clade is \n", hybridclade )

        print("the true hybrid is ", string(trueHybrid), "\n")
        print("the hybrid is ", Hybrid)
        
        if (cmp((string(trueHybrid)),string("[\"", Hybrid, "\"]")) == 1)
            print(HyDeOut[row, :HyDeHybrid])
            HyDeOut[row, :HybridCorrectID] = 2
            if (HyDeOut[row, :HyDeHybrid] .== 1)
                print("they match")
                HyDeOut[row, :HybridCorrectID] = 1
            end
        else
            HyDeOut[row, :HybridCorrectID] = 0
        end
    end
end

# HyDeOut
CSV.write(string(outFile), HyDeOut)

# False positives / False Negatives rate
# false positives are when hyde detects a hybrid relationship where there isn't one

# count all positives where it should be a negative / count all negatives
#falsePositives = 0
#allNegatives = 0
#for row in 1:setsOfTriplets
#    if string(HyDeOut[row, :HybridTripletExpected]) == string(0)
#        allNegatives = allNegatives + 1
#        if string(HyDeOut[row, :HyDeHybrid]) == string(1)
#            falsePositives = falsePositives + 1
#        end
#    end
# end

