# Marianne Bjorner
# APR292021
# 
# input: 3 separate CSVs
#        expected quartet file
#        TICR output
#        MSCQuartets output

# output: 


# exec '/Applications/Julia-1.5.app/Contents/Resources/julia/bin/julia'

using QuartetNetworkGoodnessFit, DataFrames, CSV, PhyloNetworks


cd("/Users/bjorner/GitHub/phylo-microbes/data/knownGT/n10_n30/")
TicrOut = DataFrame(CSV.File("1_TICR.csv"))
Expected = DataFrame(CSV.File("trueNet10_1.csv"))

cd("/Users/bjorner/GitHub/phylo-microbes/output/")
MSCOut = DataFrame(CSV.File("n10_n30_1_astral.in_output.csv"))


alpha = 0.05

# create a matrix of sets of 3, of the floats at Expected[6,7] - or just Expected[7]
setsOfQuartets = size(TicrOut, 1)
expectedVals = reshape(Expected[7], (3, setsOfQuartets))'

# paste to end of TICROutPut

insert!(TicrOut, size(TicrOut, 2) + 1, expectedVals[:,1], :expCF12_34)
insert!(TicrOut, size(TicrOut, 2) + 1, expectedVals[:,2], :expCF13_24)
insert!(TicrOut, size(TicrOut, 2) + 1, expectedVals[:,3], :expCF14_23)

#create new matrix of size size(expectedVals, 1)
hybridExpected = Vector{Bool}(undef, size(expectedVals, 1))
for i in size(expectedVals, 1)
    if (expectedVals[i,1] == expectedVals[i,2] || expectedVals[i,2] == expectedVals[i,3] || expectedVals[i,1] == expectedVals[i,3])
        result = 0
    else
        result = 1
    end
    hybridExpected[i] = result
end

insert!(TicrOut, size(TicrOut, 2) + 1, hybridExpected, :hybridExpected)

# hybrid table is a little messier

hybridMSC = Vector{Bool}(undef, size(expectedVals, 1))
MSCDF = DataFrame(CF12_34 = Int[],  CF13_24 = Int[], CF14_23 = Int[], Pval = Float64[], hybrid = Int[])
colNames = names(MSCOut)

# index of 12|34, 13|24, 14|23
CF1234 = findall(x -> x== "12|34", colNames)[1]
CF1324 = findall(x -> x== "13|24", colNames)[1]
CF1423 = findall(x -> x== "14|23", colNames)[1]
pVal   = findall(x -> x== "p_T3", colNames)[1]

# for every row in the ticrout table so far 
iter = 0
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
        iter = iter + 1
        println(iter)

        rowMSC = rowMSC + 1
        # look at only the column names matching t1/2/3/4
        if (MSCOut[rowMSC, t1Index] == 1) && (MSCOut[rowMSC, t2Index] == 1) && (MSCOut[rowMSC, t3Index] == 1) && (MSCOut[rowMSC, t4Index] == 1)
            # add row to the list!
            foundFlag = true
            # index of 12|34, 13|24, 14|23
            if MSCOut[rowMSC, pVal] < alpha
                hybrid = 1
            else
                hybrid = 0
            end
            println("here")
            MSCDF = push!(MSCDF, [MSCOut[rowMSC, CF1234], MSCOut[rowMSC, CF1324], MSCOut[rowMSC, CF1423], MSCOut[rowMSC, pVal], hybrid])
        end
    end 
end

MSCDF #is a 210x5 dataframe
# paste her into the rest

insert!(TicrOut, size(TicrOut, 2) + 1, MSCDF[:,1], :MSC_Count12_34)
insert!(TicrOut, size(TicrOut, 2) + 1, MSCDF[:,2], :MSC_Count13_24)
insert!(TicrOut, size(TicrOut, 2) + 1, MSCDF[:,3], :MSC_Count14_23)
insert!(TicrOut, size(TicrOut, 2) + 1, MSCDF[:,4], :MSC_pVal)
insert!(TicrOut, size(TicrOut, 2) + 1, MSCDF[:,5], :MSC_hybrid)

# save output to CSV file

cd("/Users/bjorner/GitHub/phylo-microbes/output/")
CSV.write(string("/Users/bjorner/GitHub/phylo-microbes/data/knownGT/n10_n30/summaryTable", "1_astral" ,".csv"), TicrOut)
 


# print rows where isHybrid (TICR), hybridExpected (expected (real)), OR MSC hybrid are 1
# false positive / false negative rates

# MSCquartets
falsePositivesTICR = 0
falsePositivesMSC = 0
allNegatives = 0
for row in 1:setsOfQuartets
    if string(TicrOut[row, :HybridExpected]) == string(0)
        allNegatives = allNegatives + 1
        if string(TicrOut[row, :MSC_hybrid]) == string(1)
            falsePositivesMSC = falsePositivesMSC + 1
        end
        if string(TicrOut[row, :isHybrid]) == string("TRUE")
            falsePositivesTICR = FalsePositivesTICR + 1
        end
    end
end

