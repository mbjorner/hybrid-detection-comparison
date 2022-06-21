# Marianne Bjorner
# plotting false positive and false negative rates

using DataFrames, CSV, PhyloNetworks

cd("/Users/bjorner/GitHub/phylo-microbes/output/n6out/")
cd("/Users/bjorner/GitHub/phylo-microbes/output/20220406output/")
cd("/Users/bjorner/GitHub/phylo-microbes/output/long_mix_out/")

cd("/Users/bjorner/GitHub/copyn15/")
cd("/Users/bjorner/github/phylo-microbes/data/HyDe_four_taxon/long_branches")

cd("/Users/bjorner/GitHub/copyn15/")

total_false = DataFrame(network_name = String[], gene_trees = Float64[],  trial_num = Float64[],
                        HyDe_fp = Float64[], HyDe_fn = Float64[], HyDe_tp = Float64[], HyDe_tn = Float64[], HyDe_wrongClade = Float64[],
                        Dstat_fp = Float64[], Dstat_fn = Float64[], Dstat_tp = Float64[], Dstat_tn = Float64[], Dstat_wc = Float64[])

#total_false = DataFrame(network_name = String[], gene_trees = Float64[],  trial_num = Float64[],
#                        HyDe_fp = Float64[], HyDe_fn = Float64[], HyDe_tp = Float64[], HyDe_tn = Float64[], HyDe_wrongClade = Float64[])
                       

network_names = ["n10", "n15"] # "n10","n10orange","n10red","n15","n15blue","n15orange","n15red"]
network_names = ["long_mix0", "long_mix01", "long_mix02", "long_mix03", "long_mix04", "long_mix05"]

network_names = ["n10","n10red","n10orange", "n15", "n15red", "n15orange", "n15blue"]
prefix = string(ARGS[1])
suffix = "n10n15bonbon"

#=
if suffix == "_lenpertree"
    seq_lengths = [50,100,150,200,500,1000,2000,5000,10000,50000,100000]
elseif suffix == "_totlen"
    seq_lengths = [15000,30000,60000,105000,255000,510000]
end
=#

# now know they should be total lengths, simulation of 1bp per tree

num_gene_trees = [3000,10000,50000,100000, 250000, 500000]

num_gene_trees = [50000,100000, 250000, 500000]
# seq_lengths = [10000,30000,50000,100000,250000,500000]
# num_gene_trees = [50, 100, 500, 1000]
for net_names in network_names
    # net_num = net_names[1:2] #[1:3]
    net_num = net_names
    print("analysing", net_names)
    #for seq_length in seq_lengths
    for num_trees in num_gene_trees
        for file_number in 1:30
            #filename = string(net_names,"/HyDe_Dstat/",net_names,".net_",net_num,"_", num_trees, "_", file_number, "_",seq_length, "_HyDe_Dstat.csv")
            #filename = string(net_names,"/HyDe_Dstat/", net_names,".net_",net_num,"_", num_trees, "_", file_number, "_",seq_length, "_HyDe_Dstat", suffix,".csv")
            #filename = string(net_names,num_trees,"-",file_number,"-1.tre_4_HyDe.csv")

            filename = string(net_names, "/", net_names, "-gt", num_trees, "-", file_number, "-1.tre_HyDe_Dstat.csv")

            if isfile(filename)
            file = DataFrame(CSV.File(filename))
            insertcols!(file, size(file, 2) + 1, :FP => 0);
            insertcols!(file, size(file, 2) + 1, :FN => 0);
            insertcols!(file, size(file, 2) + 1, :TP => 0);
            insertcols!(file, size(file, 2) + 1, :TN => 0);
            insertcols!(file, size(file, 2) + 1, :WC => 0);

            insertcols!(file, size(file, 2) + 1, :FP_Dstat => 0);
            insertcols!(file, size(file, 2) + 1, :FN_Dstat => 0);
            insertcols!(file, size(file, 2) + 1, :TP_Dstat => 0);
            insertcols!(file, size(file, 2) + 1, :TN_Dstat => 0);
            insertcols!(file, size(file, 2) + 1, :WC_Dstat => 0);

            # TODO: need to add D-statistic summary statistics

            for row in 1:size(file, 1)
                
                HybPredicted = file[row, :HyDeHybrid]
                HybTriple = file[row, :HybridTripletExpected]
                HybIDCorrect = file[row, :HybridCorrectID]

                if HybPredicted .== 1
                    if HybTriple .== 1
                        if HybIDCorrect .== 1
                            file[row, :TP] = 1
                        else #hybIDcorr2
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

                D_stat_p = file[row, :D_stat_pval];

                if D_stat_p .<= 0.05
                    if HybTriple .== 1
                        file[row, :TP_Dstat] = 1
                    else
                        file[row, :FP_Dstat] = 1
                    end
                elseif D_stat_p .> 0.05
                    if HybTriple .== 1
                        if HybIDCorrect .== 2
                            file[row, :FN_Dstat] = 1
                        else
                            file[row, :TN_Dstat] = 1
                        end
                    else
                        file[row, :TN_Dstat] = 1
                    end
                end

            end

            HyDe_FP = sum(file[!, :FP])
            HyDe_FN = sum(file[!, :FN])
            HyDe_TP = sum(file[!, :TP])
            HyDe_TN = sum(file[!, :TN])
            HyDe_WC = sum(file[!, :WC])

            Dstat_FP = sum(file[!, :FP_Dstat])
            Dstat_FN = sum(file[!, :FN_Dstat])
            Dstat_TP = sum(file[!, :TP_Dstat])
            Dstat_TN = sum(file[!, :TN_Dstat])
            Dstat_WC = sum(file[!, :WC_Dstat])

            global total_false
            push!(total_false, [net_names, num_trees, file_number, HyDe_FP, HyDe_FN, HyDe_TP, HyDe_TN, HyDe_WC, 
                                Dstat_FP, Dstat_FN, Dstat_TP, Dstat_TN, Dstat_WC])
           # push!(total_false,[net_names, num_trees, file_number, HyDe_FP, HyDe_FN, HyDe_TP, HyDe_TN, HyDe_WC])
            end
        end 
    end
end
#end


CSV.write(string(prefix, "_HyDe_DStat_p05",suffix,".csv"), total_false)
CSV.write(string(prefix, "_HyDe_p05",suffix,".csv"), total_false)


# Now a bonferroni corrected version: where level is determined by 0.05/nrows (number of triplet tests)



total_false_bf = DataFrame(network_name = String[], gene_trees = Float64[],  trial_num = Float64[],
                        HyDe_fp = Float64[], HyDe_fn = Float64[], HyDe_tp = Float64[], HyDe_tn = Float64[], HyDe_wrongClade = Float64[],
                        Dstat_fp = Float64[], Dstat_fn = Float64[], Dstat_tp = Float64[], Dstat_tn = Float64[], Dstat_wc = Float64[])

    for net_names in network_names
        #net_num = net_names[1:3]
        net_num = net_names
        for num_trees in num_gene_trees
            for file_number in 1:30

                filename = string(net_names, "-gt", num_trees, "-", file_number, "-1.tre_HyDe_Dstat.csv")
                filename = string(net_names, "/", net_names, "-gt", num_trees, "-", file_number, "-1.tre_HyDe_Dstat.csv")

                if isfile(filename)
                
                file = DataFrame(CSV.File(filename))
                bonLevel = 0.05/size(file,1);

                insertcols!(file, size(file, 2) + 1, :FPB => 0);
                insertcols!(file, size(file, 2) + 1, :FNB => 0);
                insertcols!(file, size(file, 2) + 1, :TPB => 0);
                insertcols!(file, size(file, 2) + 1, :TNB => 0);
                insertcols!(file, size(file, 2) + 1, :WCB => 0);

                insertcols!(file, size(file, 2) + 1, :FPB_Dstat => 0);
                insertcols!(file, size(file, 2) + 1, :FNB_Dstat => 0);
                insertcols!(file, size(file, 2) + 1, :TPB_Dstat => 0);
                insertcols!(file, size(file, 2) + 1, :TNB_Dstat => 0);
                insertcols!(file, size(file, 2) + 1, :WCB_Dstat => 0);

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
                    elseif pValHybrid .> bonLevel
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

                    # if there is a hybrid, then the D-statistic has successfully recovered it 
                    #   IF HyDeOut[row, :HybridCorrectID] > 0
                    #   AND p-value for d-statistic is sufficiently low.
                    
                    D_stat_p = file[row, :D_stat_pval];

                    if D_stat_p .<= bonLevel
                        if HybTriple .== 1
                            file[row, :TPB_Dstat] = 1
                        else
                            file[row, :FPB_Dstat] = 1
                        end
                    elseif D_stat_p .> bonLevel
                        if HybTriple .== 1
                            if HybIDCorrect .== 2
                                file[row, :FNB_Dstat] = 1
                            else
                                file[row, :TNB_Dstat] = 1
                            end
                        else
                            file[row, :TNB_Dstat] = 1
                        end
                    end

                end

                HyDe_FP = sum(file[!, :FPB])
                HyDe_FN = sum(file[!, :FNB])
                HyDe_TP = sum(file[!, :TPB])
                HyDe_TN = sum(file[!, :TNB])
                HyDe_WC = sum(file[!, :WCB])

                Dstat_FP = sum(file[!, :FPB_Dstat])
                Dstat_FN = sum(file[!, :FNB_Dstat])
                Dstat_TP = sum(file[!, :TPB_Dstat])
                Dstat_TN = sum(file[!, :TNB_Dstat])
                Dstat_WC = sum(file[!, :WCB_Dstat])

                global total_false_bf
                push!(total_false_bf, [net_names, num_trees, file_number, HyDe_FP, HyDe_FN, HyDe_TP, HyDe_TN, HyDe_WC, 
                                    Dstat_FP, Dstat_FN, Dstat_TP, Dstat_TN, Dstat_WC])
                end
            end 
        end
    end


CSV.write(string(prefix, "_HyDe_DStat_pbonferroni",suffix,".csv"), total_false_bf)