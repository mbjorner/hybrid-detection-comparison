# Marianne Bjorner
# updated 25JAN2022

# This creates a summary table of results of TICR using the TICR_MSC summary tables for each
# individual trial

using QuartetNetworkGoodnessFit, DataFrames, CSV, PhyloNetworks

# network      is n10,n15,n25,n50
# network_type is either single hybridization or all hybridizations
# hybrid_color is red, orange, blue, or all, depending on the network type (single for colors, all for all)
# gene_trees
# trial_number
# tice_pVal    is overall p value from TICR
ticrPOverall = DataFrame(network=String[], gene_trees=Float64[], trial_num=Float64[], ticr_pVal=Float64[])
MSC_results_alpha05 = DataFrame(network=String[], gene_trees=Float64[], trial_num=Float64[],
    FP=Float64[], FN=Float64[], TP=Float64[], TN=Float64[])
MSC_results_alphaBonferroni = DataFrame(network=String[], gene_trees=Float64[], trial_num=Float64[],
    FP=Float64[], FN=Float64[], TP=Float64[], TN=Float64[])

# Step 1: navigate to overall directory containing results
cd("/Users/bjorner/GitHub/phylo-microbes/analysis051422/")

function isGhostHybrid(net, hybridlabel)
    # checks to see if the hybrid clades of the network are downstream
    # of the hybrid edge
    net = PhyloNetworks.directEdges!(net)

    hybridclade = hardwiredCluster(net.hybrid[hybridlabel].edge[1], tipLabels(net))
    hybridtips = tipLabels(net)[hybridclade]
    # step 2 is find the clades downstream of the node / downstream of the hybrid
    # parent of minor hybrid edge:
    parentnode = PhyloNetworks.getParent(net.hybrid[hybridlabel].edge[1]) 
    
    # children = PhyloNetworks.getChildren(parentnode)
    # majortree = PhyloNetworks.majorTree(net)
    
    downstreamclades = PhyloNetworks.hardwiredCluster(parentnode.edge[3], tipLabels(net))
    downstreamtips = tipLabels(net)[downstreamclades]
    if issubset(hybridtips, downstreamtips) 
        return true
    else
        return false
    end
end

network_names = ["n10", "n10orange", "n10red", "n15", "n15blue", "n15orange", "n15red"]
num_gene_trees = [30, 100, 300, 1000, 3000]

#network_names = ["n6","n10","n15"]
#num_gene_trees = [30,100,300,1000,3000]

#network_names = ["n10","n10red","n10orange"]
#num_gene_trees = [30,100,300,1000,3000,10000,50000,100000,250000,500000]

#  /Users/bjorner/GitHub/phylo-microbes/output/20220511output/n10-gt300-11-1.tre_TICR_MSC_summary.csv

for net_names in network_names
    net_num = net_names[1:3]
    print(net_num)
    for num_trees in num_gene_trees
        for file_number in 1:1
            filename = string(net_names,"/",net_names, ".net_",net_num,"_", num_trees, "_", file_number, "_TICR_MSC_summary.csv")
            if isfile(filename)
                file = DataFrame(CSV.File(filename))
                netFile = string(net_names,".net")

                setsOfQuartets = size(file, 1)

                insertcols!(file, size(file, 2) + 1, :HYB_EX => 0)
                insertcols!(file, size(file, 2) + 1, :ghostHybrid => 0)

                for row in 1:setsOfQuartets
                    # extract the quartet that it tells you

                    net = readTopology(netFile)
                    T1 = string(file[row, :t1]) #"1"
                    T2 = string(file[row, :t2])
                    T3 = string(file[row, :t3])
                    T4 = string(file[row, :t4])
                    quartet = [T1, T2, T3, T4]

                    for l in tipLabels(net)
                        if l ∉ quartet
                            PhyloNetworks.deleteleaf!(net, l, keeporiginalroot=true, simplify=true)
                            #@show net
                        end
                    end

                    if net.numHybrids > 0 # then the triplets contain a hybrid relationship
                        file[row, :HYB_EX] = 1
                        if isGhostHybrid(net, 1)
                            file[row, :ghostHybrid] = 1
                        else
                            file[row, :ghostHybrid] = 0
                        end
                    else
                        file[row, :HYB_EX] = 0
                    end

                end

                CSV.write(string(filename, "withGhosts.csv"), file)


                pVal = file[1, :overallPval]

                global ticrPOverall
                push!(ticrPOverall, [net_names, num_trees, file_number, pVal])

                # identify number of false positive, negatives, etc. within MSC values of table, depending on p-value (05, or bonferroni corrected)


                insertcols!(file, size(file, 2) + 1, :MSC_FP => 0)
                insertcols!(file, size(file, 2) + 1, :MSC_FN => 0)
                insertcols!(file, size(file, 2) + 1, :MSC_TP => 0)
                insertcols!(file, size(file, 2) + 1, :MSC_TN => 0)

                for row in 1:size(file, 1)
                    hyb = file[row, :HYB_EX]
                    alpha = 0.05 / size(file, 1)
                    if file[row, :MSC_pVal] .< alpha #if significant
                        if hyb == 1
                            file[row, :MSC_TP] = 1
                        else # hyb == 0
                            file[row, :MSC_FP] = 1
                        end
                    elseif file[row, :MSC_pVal] .> alpha
                        if hyb == 1
                            file[row, :MSC_FN] = 1
                        else # hyb == 0
                            file[row, :MSC_TN] = 1
                        end
                    end
                end

                MSC_FP = sum(file[!, :MSC_FP])
                MSC_FN = sum(file[!, :MSC_FN])
                TRUE_POS = sum(file[!, :MSC_TP])
                TRUE_NEG = sum(file[!, :MSC_TN])
                # TRUE_POS = sum(file[!, :HYB_EX])
                # TRUE_NEG = size(file, 1) - TRUE_POS

                global MSC_results_alphaBonferroni
                push!(MSC_results_alphaBonferroni, [net_names, num_trees, file_number, MSC_FP, MSC_FN, TRUE_POS, TRUE_NEG])

                for row in 1:size(file, 1)
                    hyb = file[row, :HYB_EX]
                    alpha = 0.05
                    file[row, :MSC_FP] = 0
                    file[row, :MSC_FN] = 0
                    file[row, :MSC_TP] = 0
                    file[row, :MSC_TN] = 0
                    if file[row, :MSC_pVal] .< alpha
                        if hyb == 1
                            file[row, :MSC_TP] = 1
                        else
                            file[row, :MSC_FP] = 1
                        end
                    elseif file[row, :MSC_pVal] .> alpha
                        if hyb == 1
                            file[row, :MSC_FN] = 1
                        else
                            file[row, :MSC_TN] = 1
                        end
                    end
                end

                MSC_FP = sum(file[!, :MSC_FP])
                MSC_FN = sum(file[!, :MSC_FN])
                TRUE_POS = sum(file[!, :MSC_TP])
                TRUE_NEG = sum(file[!, :MSC_TN])

                global MSC_results_alpha05
                push!(MSC_results_alpha05, [net_names, num_trees, file_number, MSC_FP, MSC_FN, TRUE_POS, TRUE_NEG])


            end
        end
    end
end

prefix = ARGS[1]
ticrout = "_ticr_results.csv"
msc05 = "_msc05_results.csv"
mscbonferroni = "_mscbonferroni_results.csv"

CSV.write(string(prefix, mscbonferroni), MSC_results_alphaBonferroni)
CSV.write(string(prefix, msc05), MSC_results_alpha05)
CSV.write(string(prefix, ticrout), ticrPOverall)

function isHybrid1AtRoot(net)
    root = net.root
    for n in net.hybrid[1].edge
        if root == n.number
            return true
        end
    end
    return false
end

# if there is a hybrid at the root, this will remove the hybrid there
function removeHybridAtRoot(net)
    rootEdges = net.node[net.root].edge
    for i in 1:net.numHybrids
        print(i)
        for n in net.hybrid[i].edge
            for r in rootEdges
                if r.number == n.number
                    PhyloNetworks.deletehybridedge!(net, n)
                end
            end
        end
    end
end

