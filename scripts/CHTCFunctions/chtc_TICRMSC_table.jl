# Marianne Bjorner
# APR292021
# 
# input: 3 separate CSVs
#        1 expected quartet file
#        2 TICR output
#        3 MSCQuartets output

# output: 


# exec '/Applications/Julia-1.5.app/Contents/Resources/julia/bin/julia'

using QuartetNetworkGoodnessFit, DataFrames, CSV, PhyloNetworks

TicrOut = DataFrame(CSV.File(ARGS[2]))
Expected = DataFrame(CSV.File(ARGS[1]))
MSCOut = DataFrame(CSV.File(ARGS[3]))

alpha = ARGS[4]

# create a matrix of sets of 3, of the floats at Expected[6,7] - or just Expected[7]
setsOfQuartets = size(TicrOut, 1)
overallPval = TicrOut[10];
print(setsOfQuartets)
expectedVals = reshape(Expected[!, 7], (3, setsOfQuartets))'

# paste to end of TICROutPut

insertcols!(TicrOut, size(TicrOut, 2) + 1, :expCF12_34 => expectedVals[:,1])
insertcols!(TicrOut, size(TicrOut, 2) + 1, :expCF13_24 => expectedVals[:,2])
insertcols!(TicrOut, size(TicrOut, 2) + 1, :expCF14_23 => expectedVals[:,3])
insertcols!(TicrOut, size(TicrOut, 2) + 1, :overallPvalue => overallPval)

#create new matrix of size size(expectedVals, 1)
hybridExpected = Vector{Bool}(undef, size(expectedVals, 1))
for i in 1:size(expectedVals, 1) #for number of rows
    if (expectedVals[i,1] .== expectedVals[i,2] || expectedVals[i,2] .== expectedVals[i,3] || expectedVals[i,1] .== expectedVals[i,3])
        result = 0
    else
        result = 1
    end
    hybridExpected[i] = result
end

insertcols!(TicrOut, size(TicrOut, 2) + 1, :hybridExpected => hybridExpected)

# hybrid table is a little messier

hybridMSC = Vector{Bool}(undef, size(expectedVals, 1))
colNames = names(MSCOut)

# index of 12|34, 13|24, 14|23
CF1234 = findall(x -> x== "12|34", colNames)[1]
CF1324 = findall(x -> x== "13|24", colNames)[1]
CF1423 = findall(x -> x== "14|23", colNames)[1]
pVal   = findall(x -> x== "p_T3", colNames)[1]

# for every row in the ticrout table so far 
# iterNum = 0
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
        # iterNum = iterNum + 1
        # println(iterNum)

        rowMSC = rowMSC + 1
        # look at only the column names matching t1/2/3/4
        if (MSCOut[rowMSC, t1Index] == 1) && (MSCOut[rowMSC, t2Index] == 1) && (MSCOut[rowMSC, t3Index] == 1) && (MSCOut[rowMSC, t4Index] == 1)
            # add row to the list!
            foundFlag = true
            # index of 12|34, 13|24, 14|23
            if MSCOut[rowMSC, pVal] < parse(Float64,alpha)
                hybrid = 1
            else
                hybrid = 0
            end
            println("here")
            global MSCDF
            global MSCOut
            MSCDF = push!(MSCDF, [MSCOut[rowMSC, CF1234], MSCOut[rowMSC, CF1324], MSCOut[rowMSC, CF1423], MSCOut[rowMSC, pVal], hybrid])
        end
    end 
end

MSCDF #is a 210x5 dataframe
# paste her into the rest

insertcols!(TicrOut, size(TicrOut, 2) + 1, :MSC_Count12_34 => MSCDF[:,1])
insertcols!(TicrOut, size(TicrOut, 2) + 1, :MSC_Count13_24 => MSCDF[:,2])
insertcols!(TicrOut, size(TicrOut, 2) + 1, :MSC_Count14_23 => MSCDF[:,3])
insertcols!(TicrOut, size(TicrOut, 2) + 1, :MSC_pVal => MSCDF[:,4])
insertcols!(TicrOut, size(TicrOut, 2) + 1, :MSC_hybrid => MSCDF[:,5])

# save output to CSV file

CSV.write(string(ARGS[5]), TicrOut)
 


# print rows where isHybrid (TICR), hybridExpected (expected (real)), OR MSC hybrid are 1
# false positive / false negative rates

# MSCquartets
# falsePositivesTICR = 0
#falsePositivesMSC = 0
#allNegatives = 0
#for row in 1:setsOfQuartets
#    if string(TicrOut[row, :HybridExpected]) == string(0)
#        allNegatives = allNegatives + 1
##        if string(TicrOut[row, :MSC_hybrid]) == string(1)
#            falsePositivesMSC = falsePositivesMSC + 1
#        end
#        if string(TicrOut[row, :isHybrid]) == string("TRUE")
#            falsePositivesTICR = FalsePositivesTICR + 1
#        end
#    end
# end

