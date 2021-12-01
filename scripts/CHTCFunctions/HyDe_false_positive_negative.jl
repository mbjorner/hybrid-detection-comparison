# Marianne Bjorner
# plotting false positive and false negative rates

using QuartetNetworkGoodnessFit, DataFrames, CSV, PhyloNetworks

cd("/Users/bjorner/GitHub/phylo-microbes/output/output_HyDe_seqvariants/")
trees="n15"

total_false = DataFrame(gene_trees = Float64[],  trial_num = Float64[], seq_length = Float64[], 
                        HyDe_fp = Float64[], HyDe_fn = Float64[], HyDe_tp = Float64[], HyDe_tn = Float64[], HyDe_wrongClade = Float64[])

num_gene_trees = [30,100,300,1000,3000]
seq_lengths = [10000,50000,100000]
# num_gene_trees = [50, 100, 500, 1000]
for seq_length in seq_lengths
    for num_trees in num_gene_trees
        for file_number in 1:30
            file = DataFrame(CSV.File(string("seq", seq_length, "/", trees, "_n", num_trees, "/", trees,"_", num_trees, "_", file_number, "_", seq_length, "_HyDe.csv")))

            insertcols!(file, size(file, 2) + 1, :FP => 0);
            insertcols!(file, size(file, 2) + 1, :FN => 0);
            insertcols!(file, size(file, 2) + 1, :TP => 0);
            insertcols!(file, size(file, 2) + 1, :TN => 0);
            insertcols!(file, size(file, 2) + 1, :WC => 0);

            for row in 1:size(file, 1)
                
                HybPredicted = file[row, :HyDeHybrid]
                HybTriple = file[row, :HybridTripletExpected]
                HybIDCorrect = file[row, :HybridCorrectID]

                if HybPredicted .== 1
                    if HybTriple .== 1
                        if HybIDCorrect .== 1
                            file[row, :TP] = 1
                        else
                            file[row, :WC] = 1 #wrong clade is also a "false positive" type result
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
            HyDe_WC = sum(file[!, :WC])

            global total_false
            push!(total_false, [num_trees, file_number, seq_length, HyDe_FP, HyDe_FN, HyDe_TP, HyDe_TN, HyDe_WC])
        end 
    end
end

CSV.write(string(trees, "summarytable_withWrongClades_HyDe.csv"), total_false)


# Now a bonferroni corrected version: where level is determined by 0.05/ntrials, (30)

bonLevel = 0.05/30;

total_false = DataFrame(gene_trees = Float64[],  trial_num = Float64[], seq_length = Float64[], 
                        HyDe_fp = Float64[], HyDe_fn = Float64[], HyDe_tp = Float64[], HyDe_tn = Float64[], HyDe_wrongClade = Float64[])

for seq_length in seq_lengths
    for num_trees in num_gene_trees
        for file_number in 1:30
            file = DataFrame(CSV.File(string("seq", seq_length, "/", trees, "_n", num_trees, "/", trees,"_", num_trees, "_", file_number, "_", seq_length, "_HyDe.csv")))

            insertcols!(file, size(file, 2) + 1, :FPB => 0);
            insertcols!(file, size(file, 2) + 1, :FNB => 0);
            insertcols!(file, size(file, 2) + 1, :TPB => 0);
            insertcols!(file, size(file, 2) + 1, :TNB => 0);
            insertcols!(file, size(file, 2) + 1, :WCB => 0);

            for row in 1:size(file, 1)
                
                pValHybrid = file[row, :Pvalue];

                HybPredicted = file[row, :HyDeHybrid]
                HybTriple = file[row, :HybridTripletExpected]
                HybIDCorrect = file[row, :HybridCorrectID]

                if pValHybrid .<= bonLevel
                    if HybTriple .== 1
                        if HybIDCorrect .== 1
                            file[row, :TPB] = 1
                        else
                            file[row, :WCB] = 1 #wrong clade is also a "false positive" type result
                        end
                    else
                        file[row, :FPB] = 1
                    end
                elseif HybPredicted .== 0
                    if HybTriple .== 1
                        if HybIDCorrect .== 2
                            file[row, :FNB] = 1
                        else
                            file[row, :TNB] = 1
                        end
                    else
                        file[row, :TNB] = 1
                    end
                end
            end

            HyDe_FP = sum(file[!, :FPB])
            HyDe_FN = sum(file[!, :FNB])
            HyDe_TP = sum(file[!, :TPB])
            HyDe_TN = sum(file[!, :TNB])
            HyDe_WC = sum(file[!, :WCB])

            global total_false
            push!(total_false, [num_trees, file_number, seq_length, HyDe_FP, HyDe_FN, HyDe_TP, HyDe_TN, HyDe_WC])
        end 
    end
end

CSV.write(string(trees, "summarytable_withWrongClades_BonferroniCorrected_HyDe.csv"), total_false)