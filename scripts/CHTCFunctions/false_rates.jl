# Marianne Bjorner
# plotting false positive and false negative rates


using QuartetNetworkGoodnessFit, DataFrames, CSV, PhyloNetworks


cd("/Users/bjorner/GitHub/phylo-microbes/output/summary/output")
trees="n10"

total_false = DataFrame(gene_trees = Float64[],  trial_num = Float64[], ticr_fp = Float64[], ticr_fn = Float64[], msc_fp = Float64[], msc_fn = Float64[])

num_gene_trees = [30,100,300,1000,3000]
for num_trees in num_gene_trees
    for file_number in 1:30
      file = DataFrame(CSV.File(string("n10_", num_trees, "_", file_number, "_TICR_MSC_summary.csv")))

       insertcols!(file, size(file, 2) + 1, :TICR_hybrid => 0);
        insertcols!(file, size(file, 2) + 1, :TICR_FP => 0);
        insertcols!(file, size(file, 2) + 1, :TICR_FN => 0);
        insertcols!(file, size(file, 2) + 1, :MSC_FP => 0);
        insertcols!(file, size(file, 2) + 1, :MSC_FN => 0);
        insertcols!(file, size(file, 2) + 1, :HYB_EX => convert.(Int64, file[!, :hybridExpected]));

        for row in 1:size(file, 1)
            if file[row, :pValTicr] .< 0.05
                file[row, :TICR_hybrid] = 1
            end

            hyb = file[row, :HYB_EX]

            if file[row, :TICR_hybrid] .> hyb
                file[row, :TICR_FP] = 1
            elseif file[row, :TICR_hybrid] .< hyb
                file[row, :TICR_FN] = 1
            end

            if file[row, :MSC_hybrid] .> hyb
                file[row, :MSC_FP] = 1
            elseif file[row, :MSC_hybrid] .< hyb
                file[row, :MSC_FN] = 1
            end
    
        end

        TICR_FP = sum(file[!, :TICR_FP])
        TICR_FN = sum(file[!, :TICR_FN])
        MSC_FP = sum(file[!, :MSC_FP])
        MSC_FN = sum(file[!, :MSC_FN])

        global total_false
        push!(total_false, [num_trees, file_number, TICR_FP, TICR_FN, MSC_FP, MSC_FN])
    end 
end

CSV.write(string(trees, "summarytable.csv"), total_false)