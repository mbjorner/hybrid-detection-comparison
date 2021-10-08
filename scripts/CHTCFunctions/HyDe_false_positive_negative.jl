# Marianne Bjorner
# plotting false positive and false negative rates

using QuartetNetworkGoodnessFit, DataFrames, CSV, PhyloNetworks

cd("/Users/bjorner/GitHub/phylo-microbes/output/HyDe_output")
trees="n15"

total_false = DataFrame(gene_trees = Float64[],  trial_num = Float64[], seq_length = Float64[], HyDe_fp = Float64[], HyDe_fn = Float64[], HyDe_tp = Float64[], HyDe_tn = Float64[])

num_gene_trees = [30,100,300,1000,3000]
seq_lengths = [10000,30000,50000,100000]
# num_gene_trees = [50, 100, 500, 1000]
for seq_length in seq_lengths
    for num_trees in num_gene_trees
        for file_number in 1:30
            file = DataFrame(CSV.File(string(trees,"_", num_trees, "_", file_number, "_", seq_length, "_HyDe.csv")))

            insertcols!(file, size(file, 2) + 1, :FP => 0);
            insertcols!(file, size(file, 2) + 1, :FN => 0);
            insertcols!(file, size(file, 2) + 1, :TP => 0);
            insertcols!(file, size(file, 2) + 1, :TN => 0);

            for row in 1:size(file, 1)
                
                HybPredicted = file[row, :HyDeHybrid]
                HybTriple = file[row, :HybridTripletExpected]
                HybIDCorrect = file[row, :HybridCorrectID]

                if HybPredicted .== 1
                    if HybTriple .== 1
                        if HybIDCorrect .== 1
                            file[row, :TP] = 1
                        else
                            file[row, :FP] = 1
                        end
                    else
                        file[row, :FP] = 1
                    end
                elseif HybPredicted .== 0
                    if HybTriple .== 1
                        if HybIDCorrect .== 2
                            file[row, :FN] = 1
                        else
                            file[row, :TN] = 1
                        end
                    else
                        file[row, :TN] = 1
                    end
                end
            end

            HyDe_FP = sum(file[!, :FP])
            HyDe_FN = sum(file[!, :FN])
            HyDe_TP = sum(file[!, :TP])
            HyDe_TN = sum(file[!, :TN])

            global total_false
            push!(total_false, [num_trees, file_number, seq_length, HyDe_FP, HyDe_FN, HyDe_TP, HyDe_TN])
        end 
    end
end

CSV.write(string(trees, "summarytable_HyDe.csv"), total_false)