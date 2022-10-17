# Marianne Bjorner
# plotting false positive and false negative rates


using QuartetNetworkGoodnessFit, DataFrames, CSV, PhyloNetworks


cd("/Users/bjorner/GitHub/phylo-microbes/data/foranal20220517")
trees=["n10", "n10red", "n10orange", "n15", "n15red", "n15orange", "n15blue"]

ticrPOverall = DataFrame(net_name = String[], gene_trees = Float64[],  trial_num = Float64[], ticr_pVal = Float64[])

num_gene_trees = [30,100,300,1000,3000]
# num_gene_trees = [50, 100, 500, 1000]
for tree in trees
for num_trees in num_gene_trees
    for file_number in 1:30

        file = string(tree,"-gt", num_trees, "-", file_number, "-1.tre_TICR.csv")
        if startswith(tree, "n10")
            file = string(tree, "/", tree,"-gt", num_trees, "-", file_number, "-1.tre_TICR_MSC_summary.csv")
        end
        if isfile(file)
            print("valid")
            file = DataFrame(CSV.File(file))
        
        pVal = file[1,:overallPval]

        global ticrPOverall
        push!(ticrPOverall, [tree, num_trees, file_number, pVal])
        end
    end 
end
end

CSV.write(string("n10n15_TICR_results_majorTree20220518.csv"), ticrPOverall)