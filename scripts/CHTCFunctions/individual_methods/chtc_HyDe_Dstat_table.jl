# Marianne Bjorner
# 14MAY2021
# 
# Input:
#    Hyde output
#    Known network structure
#    significance level
# Output:
#    Table comparing HyDe output to expected results
#    Calculates D-statistic, p-value, z-score for D-statistic using HyDe ABBA / ABAB output

# exec '/Applications/Julia-1.5.app/Contents/Resources/julia/bin/julia'
#=
import Pkg; Pkg.add("QuartetNetworkGoodnessFit")
import Pkg; Pkg.add("DataFrames")
import Pkg; Pkg.add("CSV")
import Pkg; Pkg.add("PhyloNetworks")
import Pkg; Pkg.add("Distributions")
import Pkg; Pkg.add("Statistics")
=#
using QuartetNetworkGoodnessFit, DataFrames, CSV, PhyloNetworks, Statistics, Distributions

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
net = readTopology(netFile);

# create new column called "HyDeHybrid" 1 / 0 (default is 0)
insertcols!(HyDeOut, 6, :HyDeHybrid => 0)
for row in 1:size(HyDeOut,1)
    if (HyDeOut[row, :Pvalue] .< parse(Float64,alpha))
        HyDeOut[row, :HyDeHybrid]=1
    end
end

# create new column "Hybrid triplet" 1 / 0
if ("HybridTripletExpected" in names(HyDeOut))
else
    insertcols!(HyDeOut, 7, :HybridTripletExpected => 0)
end 
if ("HybridCorrectID" in names(HyDeOut))
else
    insertcols!(HyDeOut, 8, :HybridCorrectID => 0)
end
insertcols!(HyDeOut, 9, :D_statistic => 0.0)
insertcols!(HyDeOut, 10, :D_stat_Zscore => 0.0)
insertcols!(HyDeOut, 11, :D_stat_pval => 0.0)

setsOfTriplets = size(HyDeOut,1)

for row in 1:setsOfTriplets
    # extract the triplet that it tells you

    net = readTopology(netFile);
    P1 = string(HyDeOut[row, :P1]);
    Hybrid = string(HyDeOut[row, :Hybrid]);
    P2 = string(HyDeOut[row, :P2]);
    triplet = [P1,Hybrid,P2];

    for l in tipLabels(net)
        if l ∉ triplet
            PhyloNetworks.deleteleaf!(net,l, keeporiginalroot=true, simplify=true);
            #@show net
        end 
    end 

    #plot(net,:R)

    #print("The number of hybrids leftover in the net is ", string(net.numHybrids), "\n")

    if net.numHybrids > 0 # then the triplets contain a hybrid relationship
        HyDeOut[row, :HybridTripletExpected] = 1;
        # this is not entirely correct: if there are multiple hybrids in the network then we need to see those as well
        hybridclade = hardwiredCluster(net.hybrid[1].edge[1],tipLabels(net));
        #print("the hybrid clade is ", hybridclade)
        trueHybrid = tipLabels(net)[hybridclade]; # string vector

        #print("the hybrid clade is \n", hybridclade )

        #print("the true hybrid is ", string(trueHybrid), "\n")
        #print("the hybrid is ", Hybrid)
        
        if (issubset([Hybrid], trueHybrid)) # if the hybrid is contained in true hybrids
            # print(HyDeOut[row, :HyDeHybrid])
            HyDeOut[row, :HybridCorrectID] = 2
            if (HyDeOut[row, :HyDeHybrid] .== 1)
                HyDeOut[row, :HybridCorrectID] = 1
            end
        else
            HyDeOut[row, :HybridCorrectID] = 0
        end
    end

    # calculate D-statistics, p-values, z-score with guidance from cecile ane's calcD script
    ABBA_site=HyDeOut[row,:ABBA]
    ABAB_site=HyDeOut[row,:ABAB]

    HyDeOut[row, :D_statistic] = (ABBA_site-ABAB_site)/(ABBA_site+ABAB_site)

    n=ABBA_site+ABAB_site
    phat=ABBA_site/n
    HyDeOut[row, :D_stat_Zscore] = (phat-0.5)*sqrt(n)*2
    HyDeOut[row, :D_stat_pval] = ccdf(Normal(), abs(HyDeOut[row, :D_stat_Zscore]))*2

    # if there is a hybrid, then the D-statistic has successfully recovered it 
    #   IF HyDeOut[row, :HybridCorrectID] > 0
    #   AND p-value for d-statistic is sufficiently low.

end

# HyDeOut
CSV.write(string(outFile), HyDeOut)

