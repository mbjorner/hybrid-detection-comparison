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
ticrPOverall = DataFrame(network = String[], network_type = String[], hybrid_color = String[], 
                         gene_trees = Float64[],  trial_num = Float64[], ticr_pVal = Float64[])

# Step 1: navigate to overall directory containing results
cd("/Users/bjorner/GitHub/phylo-microbes/output/output_ticr")

network_names = ["n10","n15","n25","n50","n100"]
network_types = ["all","single"]
hybrid_colors = ["red","orange","blue","all"]
num_gene_trees = [30,50,100,300,500,1000,3000]

for net_names in network_names
    for net_types in network_types
        for hyb_cols in hybrid_colors
            for num_trees in num_gene_trees
                for file_number in 1:30
                    # naming conventions of output files for each trial is:
                    # network_names/network_types/hybrid_colors/????

                    file = DataFrame(CSV.File(string(trees,"_", num_trees, "_", file_number, "_ticr.csv")))
                    if isfile(file)
                        pVal = file[1,:overallPval]

                        global ticrPOverall
                        push!(ticrPOverall, [net_names, net_types, hyb_cols, num_trees, file_number, pVal])
            
                    end
                end
            end
        end 
    end
end

CSV.write(string(trees, "_TICR_results_withQMC.csv"), ticrPOverall)