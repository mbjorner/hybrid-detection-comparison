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
ticrPOverall = DataFrame(network = String[], gene_trees = Float64[],  trial_num = Float64[], ticr_pVal = Float64[])
MSC_results_alpha05 = DataFrame(network = String[], gene_trees = Float64[],  trial_num = Float64[], 
                        FP=Float64[], FN=Float64[], TP=Float64[], TN=Float64[])
MSC_results_alphaBonferroni = DataFrame(network = String[], gene_trees = Float64[],  trial_num = Float64[], 
                        FP=Float64[], FN=Float64[], TP=Float64[], TN=Float64[])

# Step 1: navigate to overall directory containing results
cd("/Users/bjorner/GitHub/phylo-microbes/output/2022FEB15_output_alln10_n15/")

cd("/Users/bjorner/GitHub/phylo-microbes/output/20220406output/")


network_names = ["n10","n10orange","n10red","n15","n15blue","n15orange","n15red"]
num_gene_trees = [30,100,300,1000,3000]

network_names = ["n6","n10","n15"]
num_gene_trees = [30,100,300,1000,3000]

for net_names in network_names

    #net_num = net_names[1:3]
    net_num = net_names

    for num_trees in num_gene_trees
        for file_number in 1:30
            filename = string(net_names,"/",net_names,".net_",net_num,"_", num_trees, "_", file_number, "_TICR_MSC_summary.csv")
            if isfile(filename)
                file = DataFrame(CSV.File(filename))
            
                pVal = file[1,:overallPval]

                global ticrPOverall
                push!(ticrPOverall, [net_names, num_trees, file_number, pVal])

                # identify number of false positive, negatives, etc. within MSC values of table, depending on p-value (05, or bonferroni corrected)
              

                insertcols!(file, size(file, 2) + 1, :MSC_FP => 0);
                insertcols!(file, size(file, 2) + 1, :MSC_FN => 0);
                insertcols!(file, size(file, 2) + 1, :MSC_TP => 0);
                insertcols!(file, size(file, 2) + 1, :MSC_TN => 0);
                insertcols!(file, size(file, 2) + 1, :HYB_EX => convert.(Int64, file[!, :hybridExpected]));

                for row in 1:size(file, 1)
                    hyb = file[row, :HYB_EX]
                    alpha = 0.05/size(file,1)
                    if file[row, :MSC_pVal] .< alpha
                        if hyb == 0
                            file[row, :MSC_FP] = 1
                        else # hyb == 1
                            file[row, :MSC_TP] = 1
                        end
                    elseif file[row, :MSC_pVal] .> alpha
                        if hyb == 1
                            file[row, :MSC_FN] = 1
                        else # hyb == 0
                            file[row, :MSC_FP] = 1
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
                        if hyb == 0
                            file[row, :MSC_FP] = 1
                        else 
                            file[row, :MSC_TP] = 1
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
                TRUE_POS = sum(file[!, :HYB_EX])
                TRUE_NEG = size(file, 1) - TRUE_POS

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

CSV.write(string(prefix,mscbonferroni), MSC_results_alphaBonferroni)
CSV.write(string(prefix,msc05), MSC_results_alpha05)
CSV.write(string(prefix,ticrout), ticrPOverall)