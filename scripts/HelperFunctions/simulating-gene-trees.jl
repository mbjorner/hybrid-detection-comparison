## julia script to simulate gene trees on complex networks
## julia simulating-gene-trees.jl file numgt seed
## Claudia August 2020

# import Pkg; Pkg.add("Distributions")
using PhyloNetworks, Random, Distributions
##using PhyloPlots
##using StatsBase, DataFrames, CSV
include("functions.jl")


## Mac:
hybridlambda = "/Users/Clauberry/Dropbox/software/hybrid-Lambda/src/hybrid-Lambda"
hybridlambda = "/Users/bjorner/GitHub/hybrid-lambda/src/hybrid-Lambda" # cloned github repo and make
##makeultrametric = "/Users/Clauberry/Dropbox/Documents/solislemus-lab/my-projects/present/ransanec/ransanec/scripts/makeultrametric"
folder = "/Users/bjorner/GitHub/phylo-microbes/data/" #knownGT/singleNet/"
#folder = "/Users/bjorner/GitHub/phylo-microbes/data/HyDe_four_taxon/long_branches/"

file = "20211109_simpleNetwork"
numgt = 500
seed = 704329
nrep = 30 ##fixed (should be 30)

if length(ARGS) > 0
    file = ARGS[1]
    numgt = parse(Int,ARGS[2])
    seed = parse(Int,ARGS[3])
end


if file == "n25h5"
    outgroup = "t25"
elseif file == "n50h10"
    outgroup = "t50"
elseif file == "n100h20"
    outgroup = "t53" ## t100 has root mismatch
end

## Create folder for files
folder = string(folder,file,"/")
cd(folder)

k = 1
#if numgt > 1000
#    numgt % 1000 == 0 || error("we can only handle multiples of 1000 right now")
#    k = convert(Int,numgt/1000)
#end

Random.seed!(seed);
ss = sample(1:55555,nrep*k)

for i in 1:nrep
    @show i
    for j in 1:k
        @show j
        nn = numgt #> 1000 ? 1000 : numgt
        simulateGeneTrees(string(i,"-",j),file,"",outgroup,nn, ss[i], hybridlambda)
    end
end



