 # following are functions to ascertain the ghost lineages at root of the tree,
 # and remove them to see how well functions can discern ghost lineages vs. discern hybrids 
 # only within a triplet or quartet

 # this script takes a single filename and creates an output file that contains
 # true negatives, true positives, false positives, false negatives at alpha levels of 0.05 and the bonferroni correction

 # will also contain a column for ghost lineages

using QuartetNetworkGoodnessFit, DataFrames, CSV, PhyloNetworks, Statistics, Distributions

include("/Users/bjorner/GitHub/phylo-microbes/scripts/HelperFunctions/calcD.jl")

net_directory = "/Users/bjorner/GitHub/ms_gene_trees/nets_newick/"

function loadNet(netname::AbstractString)
    net = readTopology(string(net_directory, netname))
    return net
end

function calculate_WC(testReturnsHybrid, isTrueHybridID, isHybridInTriple)
    return testReturnsHybrid && !isTrueHybridID && isHybridInTriple
end

function calcDpsd_concatenated(x, y, bbaa, nbootstrap=500)
    n = x+y+bbaa
    Dp = (x-y)/n
    p_abba = x/n
    d = Distributions.Binomial(n, p_abba)
    bx = rand(d, nbootstrap)
    bD = (2*bx .- n) ./ n # y=n-x so x-y = x-(n-x) = 2x-n
    z = Dp / Statistics.std(bD)
    pvalue = ccdf(Normal(), abs(z))*2
    return Dp, z, pvalue
end

function calculate_FP_FN_TP_TN(testReturnsHybrid, isTrueHybridID)
    true_positive = testReturnsHybrid && isTrueHybridID
    false_negative = !testReturnsHybrid && isTrueHybridID
    true_negative = !testReturnsHybrid && !isTrueHybridID
    false_positive = testReturnsHybrid && !isTrueHybridID

    return false_positive, false_negative, true_positive, true_negative
end

#=
returns whether tip subsets contain a hybrid relationship by removing nodes from a network
=#
function isHybrid!(net, taxa)
    for l in tipLabels(net)
        if l ∉ taxa
            PhyloNetworks.deleteleaf!(net,l,keeporiginalroot=true, simplify=true);
            #@show net
        end 
    end 

    if net.numHybrids > 0
        return true
    else
        return false
    end
end

#=
Given an input net, returns a Set of tip names that arose from a hybridization event
=#
function getHybrids(net::HybridNetwork)
    hybrids = Set()
    for i in 1:net.numHybrids
        # hardwiredCluster is invariant to the hybrid edge chosen, returns identical results no matter the edge
        hybridclade = hardwiredCluster(net.hybrid[i].edge[1], tipLabels(net));
        trueHybrids = tipLabels(net)[hybridclade]
        for hyb in trueHybrids
            push!(hybrids, hyb)
        end
    end
    return hybrids
end

#=
Returns if the specified hybrid is the actual (or one of the) hybrid(s) in the network
=#
function isTrueHybrid(net::HybridNetwork, HybridStringName::String)
    return issubset([HybridStringName], getHybrids(net))
end

#=
Returns the depth of the hybrid_minor_edge_parent

get height of hybrid node
get height of tip
tip - hybridnode
=#
function calculateLengthToHybridEdge(net, hybridLabel)
    directEdges!(net); preorder!(net);
    heights = PhyloNetworks.getHeights(net)
    tipHeight = findmax(heights)[1]
    heightVector = [node.number => (heights[i], node.name) for (i,node) in enumerate(net.nodes_changed)]
    hybridnumber = net.hybrid[hybridLabel].number
    hybridHeight = Dict(heightVector)[hybridnumber][1]

    return tipHeight - hybridHeight
end

#=
Returns Tip:Root / Hybrid:Root ratio assuming ultrametric tree with all nodes
=#
function calculateTipToHybridRatio(net, hybridLabel)
    directEdges!(net); preorder!(net);
    heights = PhyloNetworks.getHeights(net)
    tipHeight = findmax(heights)[1]
    heightVector = [node.number => (heights[i], node.name) for (i,node) in enumerate(net.nodes_changed)]
    hybridnumber = net.hybrid[hybridLabel].number
    hybridHeight = Dict(heightVector)[hybridnumber][1]

    return tipHeight / hybridHeight
end

#=
Returns the true mixing parameter of the minor edge of the given hybridlabel
=#
function getTrueMixingParameter(net, hybridLabel)
    minor_edge = PhyloNetworks.getMinorParentEdge(net.hybrid[hybridLabel])
    return minor_edge.gamma
end

# this indicates a ghost lineage at the root 
function isGhostHybridAtRoot(net)
    rootEdges = net.node[net.root].edge
    for i in 1:net.numHybrids
        for n in net.hybrid[i].edge
            for r in rootEdges
                if r.number == n.number
                    return true
                end
            end
        end
    end
    return false
end

function removeHybridAtRoot(net)
    rootEdges = net.node[net.root].edge
    print("root is", rootEdges)
    for i in 1:net.numHybrids
        for n in net.hybrid[i].edge
            print("n.number is ", n.number)
            for r in rootEdges
                if r.number == n.number
                    print("removing hybrid edge ", net.hybrid[i].edge)
                    PhyloNetworks.deletehybridedge!(net, n)
                end
            end
        end
    end
end

function isGhostHybrid(net, hybridlabel)
    # checks to see if the hybrid clades of the network are downstream
    # of the hybrid edge
    PhyloNetworks.directEdges!(net)
    hybridclade = hardwiredCluster(net.hybrid[hybridlabel].edge[1], tipLabels(net))
    hybridtips = tipLabels(net)[hybridclade]
    print("\n hybrid tips are: ", hybridtips)
    # step 2 is find the clades downstream of the node / downstream of the hybrid
    # parent of minor hybrid edge:
    parentnode = PhyloNetworks.getParent(net.hybrid[hybridlabel].edge[1]) 
    
    # children = PhyloNetworks.getChildren(parentnode)
    # majortree = PhyloNetworks.majorTree(net)
    
    downstreamclades = PhyloNetworks.hardwiredCluster(parentnode.edge[3], tipLabels(net))
    downstreamtips = tipLabels(net)[downstreamclades]
    print("\n downstreamtips are", downstreamtips)
    if issubset(hybridtips, downstreamtips) 
        return true
    else
        print("\n hybrid tips are ", hybridtips)
        print("\n downstream tips are ", downstreamtips)
        return false
    end
end

#=
get length of minor hybrid edge of specified hybrid
=#
function getLengthMinorEdge(net, hybridlabel)
    minoredge = PhyloNetworks.getMinorParentEdge(net.hybrid[hybridlabel])
    return PhyloNetworks.getlengths([minoredge])
end

function isSignificant(column, alpha::Float64)
    return column .< alpha
end

function isSignificantBonferroni(column, alpha::Float64)
    bonferroni = alpha / size(column, 1)
    return column .< bonferroni
end

function analyzeHyDe_DStat(filepath, filename, netname, savefilepath) 
    HyDeOut = DataFrame(CSV.File(filepath))
    net = loadNet(netname)
    outFile = string(savefilepath, filename, "_analyzed.csv")

    sig05 = isSignificant(HyDeOut[!, :Pvalue], 0.05)
    sig_bonferroni = isSignificantBonferroni(HyDeOut[!, :Pvalue], 0.05)
    outgroup = split(filename,"h")[1]
    outgroup = split(outgroup,"n")[1]
    setsOfTriplets = size(HyDeOut,1)

    column_names = [:P1, :Hybrid, :P2, :FP, :FN, :TP, :TN, :WC, :FP_bon, :FN_bon, :TP_bon, :TN_bon, :WC_bon, 
                    :hybridTripletExpected, :proposedHybridCorrect, :isGhostHybrid, :isGhostAtRoot, 
                    :isMultiHybrid, :lengthToHybridEdge, :tipToHybridRatio, 
                    :D, :D_z, :D_pvalue, :Dp, :Dp_z, :Dp_pvalue, :true_gamma, :proposed_gamma]

    # add all names to dataframe as empty columns
    df_results = DataFrame(column_names .=> Ref([]))

    for row in 1:setsOfTriplets

        net = loadNet(netname);
        P1 = string(HyDeOut[row, :P1]);
        Hybrid = string(HyDeOut[row, :Hybrid]);
        P2 = string(HyDeOut[row, :P2]);
        proposed_gamma = HyDeOut[row, :Gamma]
        true_gamma = -1
        triplet = [P1,Hybrid,P2];
        quad_includingoutgroup = [P1,Hybrid,P2,outgroup]

        hybridTripletExpected = isHybrid!(net, triplet)
        proposedHybridCorrect = false
        isGhostHybridBool = false
        isMultiHybrid = false
        isGhostHybridAtRootBool = false

        lengthToHybridEdge, tipToHybridRatio = -1, -1

        for i in  1:net.numHybrids
            if i == 2
                isMultiHybrid = true
            end
            lengthToHybridEdge = calculateLengthToHybridEdge(net, i)
            tipToHybridRatio = calculateTipToHybridRatio(net, i)
            true_gamma = getTrueMixingParameter(net, i)
            proposedHybridCorrect = isTrueHybrid(net, Hybrid)
            isGhostHybridBool = isGhostHybrid(net, i) # is there a bug here?
            isGhostHybridAtRootBool = isGhostHybridAtRoot(net) # this means that there is a hybrid present not ""between"" tested taxa
        end

        FP, FN, TP, TN = calculate_FP_FN_TP_TN(sig05[row], proposedHybridCorrect)
        FP_bon, FN_bon, TP_bon, TN_bon = calculate_FP_FN_TP_TN(sig_bonferroni[row], proposedHybridCorrect)
        # WC = true if hyde identifies a hybrid in the triple as expected, but it's NOT the correct hybrid

        WC = calculate_WC(sig05[row], proposedHybridCorrect, hybridTripletExpected)
        WC_bon = calculate_WC(sig_bonferroni[row], proposedHybridCorrect, hybridTripletExpected)

        ABBA_site = HyDeOut[row,:ABBA]
        ABAB_site = HyDeOut[row,:ABAB]
        BBAA_site = HyDeOut[row,:AABB]

        # bootstrap option to calculate D, z-score, and p-value
        D, D_z, D_pvalue = calcDsd_concatenated(ABBA_site, ABAB_site)
        Dp, Dp_z, Dp_pvalue = calcDpsd_concatenated(ABBA_site,ABAB_site,BBAA_site)
        
        push!(df_results, [P1, Hybrid, P2, FP, FN, TP, TN, WC, FP_bon, FN_bon, TP_bon, TN_bon, WC_bon,
                           hybridTripletExpected, proposedHybridCorrect, isGhostHybridBool, isGhostHybridAtRootBool, isMultiHybrid, 
                           lengthToHybridEdge, tipToHybridRatio, 
                           D, D_z, D_pvalue, Dp, Dp_z, Dp_pvalue, true_gamma, proposed_gamma])
    end

    CSV.write(string(outFile), df_results)
end

function analyzeTICR_MSC(filepath, filename, netname, savefilepath)
    TICR_MSC_Out = DataFrame(CSV.File(filepath))
    net = loadNet(netname)
    outFile = string(savefilepath, filename, "_analyzed.csv")

    sig05 = isSignificant(TICR_MSC_Out[!, :Pvalue], 0.05)
    sig_bonferroni = isSignificantBonferroni(TICR_MSC_Out[!, :Pvalue], 0.05)

    setsOfQuartets = size(TICR_MSC_Out,1)

    column_names = [:t1, :t2, :t3, :t4, :FP, :FN, :TP, :TN, :WC, :FP_bon, :FN_bon, :TP_bon, :TN_bon, :WC_bon, 
                    :hybridQuadExpected, :isGhostHybrid, :isGhostAtRoot, 
                    :isMultiHybrid, :lengthToHybridEdge, :tipToHybridRatio, 
                    :true_gamma]

    # add all names to dataframe as empty columns
    df_results = DataFrame(column_names .=> Ref([]))

    for row in 1:setsOfQuartets

        net = loadNet(netname);
        T1 = string(TICR_MSC_Out[row, :t1]); #"1"
        T2 = string(TICR_MSC_Out[row, :t2]);
        T3 = string(TICR_MSC_Out[row, :t3]);
        T4 = string(TICR_MSC_Out[row, :t4]);
        quartet = [T1,T2,T3,T4];

        colNames = names(MSCOutFile)
        
        # index of 12|34, 13|24, 14|23
        CF1234 = findall(x -> x== "12|34", colNames)[1]
        CF1324 = findall(x -> x== "13|24", colNames)[1]
        CF1423 = findall(x -> x== "14|23", colNames)[1]
        pVal   = findall(x -> x== "p_T3", colNames)[1]

        hybridQuadExpected = isHybrid!(net, quartet)
        isGhostHybridBool = false
        isMultiHybrid = false
        isGhostHybridAtRootBool = false
        lengthToHybridEdge, tipToHybridRatio = -1, -1

        for i in  1:net.numHybrids
            if i == 2
                isMultiHybrid = true
            end
            lengthToHybridEdge = calculateLengthToHybridEdge(net, i)
            tipToHybridRatio = calculateTipToHybridRatio(net, i)
            true_gamma = getTrueMixingParameter(net, i)
            isGhostHybridBool = isGhostHybrid(net, i) # is there a bug here?
            isGhostHybridAtRootBool = isGhostHybridAtRoot(net) # this means that there is a hybrid present not ""between"" tested taxa
        end

        
        # hybrid table is a little messier
        
        MSCDF = DataFrame(CF12_34 = Float64[],  CF13_24 = Float64[], CF14_23 = Float64[], Pval = Float64[], hybrid = Float64[])
        hybridMSC = Vector{Bool}(undef, size(expectedVals, 1))

        
        # for every row in the ticrout table so far 
        # iterNum = 0
        for row in 1:setsOfQuartets
        
            # extract the names of the 4 taxa
            t1 = string(TicrOut[row, 1])
            t2 = string(TicrOut[row, 2])
            t3 = string(TicrOut[row, 3])
            t4 = string(TicrOut[row, 4])
        
            foundFlag = false
            rowMSC = 0
        
            # index of t1,2,3,4 in MSCOut:
            t1Index = findall(x -> x==t1, colNames)[1]
            t2Index = findall(x -> x==t2, colNames)[1]
            t3Index = findall(x -> x==t3, colNames)[1]
            t4Index = findall(x -> x==t4, colNames)[1]
        
            while (!foundFlag) && (rowMSC < setsOfQuartets)
                # iterNum = iterNum + 1
                # println(iterNum)
        
                rowMSC = rowMSC + 1
                # look at only the column names matching t1/2/3/4
                if (MSCOut[rowMSC, t1Index] == 1) && (MSCOut[rowMSC, t2Index] == 1) && (MSCOut[rowMSC, t3Index] == 1) && (MSCOut[rowMSC, t4Index] == 1)
                    # add row to the list!
                    foundFlag = true
                    # index of 12|34, 13|24, 14|23
                    if MSCOut[rowMSC, pVal] < parse(Float64,alpha)
                        hybrid = 1
                    else
                        hybrid = 0
                    end
        
                    global MSCDF
                    global MSCOut
                    MSCDF = push!(MSCDF, [MSCOut[rowMSC, CF1234], MSCOut[rowMSC, CF1324], MSCOut[rowMSC, CF1423], MSCOut[rowMSC, pVal], hybrid])
                end
            end 
        end
        
    end

    CSV.write(string(outFile), df_results)
end

function main(pathToFile::String, splitby, pathToSaveFile)
    #filename is set up with the format string(netname,"/-gt", num_gene_trees, "-1-1.tre...", HyDe_Dstat.csv
    filename = split(pathToFile, "/")[size(split(pathToFile, "/"), 1)]
    print(filename)
    netname = split(filename, splitby)[1]
    if contains(filename, "HyDe")
        analyzeHyDe_DStat(pathToFile, filename, netname, pathToSaveFile)
    elseif contains(filename, "TICR_MSC")
        analyzeTICR_MSC(pathToFile, filename, netname, pathToSaveFile)
    else
        print("input file ", filename, " was not analyzed: does not fit naming conventions")
    end
end



netNameSplit="_"
savePath="analyzeMethodOutputFile/" # will save in current directory unless otherwise specified
main(ARGS[1], netNameSplit, savePath)