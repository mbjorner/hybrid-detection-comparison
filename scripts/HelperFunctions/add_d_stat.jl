# julia file for the post-processing of HyDe Files to add d-statistic and accompanying p-values:

# Marianne Bjorner
# 14MAY2021
# 
# Input:
#    Hyde output
#    Known network structure
#    significance level
# Output:
#    Table comparing HyDe output to expected results
#    Calculates D-statistic, p-value, z-score for D-statistic using HyDe ABBA / ABAB output

# exec '/Applications/Julia-1.5.app/Contents/Resources/julia/bin/julia'

#import Pkg; Pkg.add("QuartetNetworkGoodnessFit")
#import Pkg; Pkg.add("DataFrames")
#import Pkg; Pkg.add("CSV")
#import Pkg; Pkg.add("PhyloNetworks")
#import Pkg; Pkg.add("Distributions")
#import Pkg; Pkg.add("Statistics")

using QuartetNetworkGoodnessFit, DataFrames, CSV, PhyloNetworks, Statistics, Distributions

# constants
if (length(ARGS) > 0)
    HyDeFile = ARGS[1]
    outFile = string(HyDeFile,"D-stat.csv")
else
    HyDeFile = "/Users/bjorner/GitHub/HyDe/n10trial-out.txt"
    outFile = "output_test.csv"
end

HyDeOut = DataFrame(CSV.File(HyDeFile))


# create new column "Hybrid triplet" 1 / 0
insertcols!(HyDeOut, 9, :D_statistic => 0.0)
insertcols!(HyDeOut, 10, :D_stat_Zscore => 0.0)
insertcols!(HyDeOut, 11, :D_stat_pval => 0.0)

setsOfTriplets = size(HyDeOut,1)

for row in 1:setsOfTriplets
    # calculate D-statistics, p-values, z-score with guidance from cecile ane's calcD script
    ABBA_site=HyDeOut[row,:ABBA]
    ABAB_site=HyDeOut[row,:ABAB]

    HyDeOut[row, :D_statistic] = (ABBA_site-ABAB_site)/(ABBA_site+ABAB_site)
    n=ABBA_site+ABAB_site
    phat=ABBA_site/n
    HyDeOut[row, :D_stat_Zscore] = (phat-0.5)*sqrt(n)*2
    HyDeOut[row, :D_stat_pval] = ccdf(Normal(), abs(HyDeOut[row, :D_stat_Zscore]))*2

end

# HyDeOut
CSV.write(string(outFile), HyDeOut)