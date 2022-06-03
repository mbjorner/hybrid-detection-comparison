# Marianne Bjorner
# 02JUN2022
# 
# Input:
#    Hyde output
# Output:
#    Calculates D-statistic, p-value, z-score for D-statistic using HyDe ABBA / ABAB output

using QuartetNetworkGoodnessFit, DataFrames, CSV, PhyloNetworks, Statistics, Distributions, Random


# inputs
    HyDeFile = ARGS[1] #"/Users/bjorner/GitHub/HyDe/n10trial-out.txt"

# output file destination
    outFile = ARGS[2]

HyDeOut = DataFrame(CSV.File(HyDeFile))

num_columns = size(HyDeOut,2)
insertcols!(HyDeOut, num_columns + 1, :D_statistic => 0.0)
insertcols!(HyDeOut, num_columns + 2, :D_stat_Zscore => 0.0)
insertcols!(HyDeOut, num_columns + 3, :D_stat_pval => 0.0)
insertcols!(HyDeOut, num_columns + 4, :D_stat_Zscore_boot => 0.0)
insertcols!(HyDeOut, num_columns + 5, :D_stat_pvalue_boot => 0.0)

setsOfTriplets = size(HyDeOut,1)

for row in 1:setsOfTriplets
    # calculate D-statistics, p-values, z-score with guidance from cecile ane's calcD.jl script 
    # https://gist.github.com/cecileane/0894d70161a2b490dbb330b96a29550a
    ABBA_site = HyDeOut[row,:ABBA]
    ABAB_site = HyDeOut[row,:ABAB]

    D = (ABBA_site-ABAB_site)/(ABBA_site+ABAB_site)

    HyDeOut[row, :D_statistic] = D
    n = ABBA_site + ABAB_site
    phat = ABBA_site/n
    HyDeOut[row, :D_stat_Zscore] = (phat-0.5)*sqrt(n)*2
    HyDeOut[row, :D_stat_pval] = ccdf(Normal(), abs(HyDeOut[row, :D_stat_Zscore]))*2

    d = Distributions.Binomial(round(n), 0.5)
    nbootstrap = 5000
    bx = rand(d, nbootstrap)
    bD = (2*bx .- round(n)) ./ round(n) # y=n-x so x-y = x-(n-x) = 2x-n
    z_boot = D / Statistics.std(bD)
    pvalue_boot = ccdf(Normal(), abs(z_boot))*2

    HyDeOut[row, :D_stat_Zscore_boot] = z_boot
    HyDeOut[row, :D_stat_pvalue_boot] = pvalue_boot

end

# HyDeOut
CSV.write(string(outFile), HyDeOut)