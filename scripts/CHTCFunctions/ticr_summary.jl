# Marianne Bjorner
# plotting false positive and false negative rates


using QuartetNetworkGoodnessFit, DataFrames, CSV, PhyloNetworks


cd("/Users/bjorner/GitHub/phylo-microbes/output/output_ticr")
trees="n15"

ticrPOverall = DataFrame(gene_trees = Float64[],  trial_num = Float64[], ticr_pVal = Float64[])

num_gene_trees = [30,100,300,1000,3000]
# num_gene_trees = [50, 100, 500, 1000]

for num_trees in num_gene_trees
    for file_number in 1:30
        file = DataFrame(CSV.File(string(trees,"_", num_trees, "_", file_number, "_ticr.csv")))

        pVal = file[1,:overallPval]

        global ticrPOverall
        push!(ticrPOverall, [num_trees, file_number, pVal])
    end 
end

CSV.write(string(trees, "_TICR_results_withQMC.csv"), ticrPOverall)