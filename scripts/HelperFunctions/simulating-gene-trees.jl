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
if numgt > 1000
    numgt % 1000 == 0 || error("we can only handle multiples of 1000 right now")
    k = convert(Int,numgt/1000)
end

Random.seed!(seed);
# ss = sample(1:55555,nrep*k)

for i in 1:nrep
    @show i
    nn = numgt > 1000 ? 1000 : numgt
    for j in 1:k
        # create new seed so files are different each iteration
        ss = sample(1:55555,nrep*k)
        @show j
        if k == 1
            simulateGeneTrees(string(i,"-",j),file,"",outgroup,nn, ss[i], hybridlambda)
        elseif k > 1
            simulateGeneTrees(string(i,"-",j,"-",k),file,"",outgroup,nn, ss[i], hybridlambda)
        end
    end

    # remove files that were concatenated, concatenate gt files
    filename1 = string(file,"-gt",nn,"-",i,"-1-",k,".tre")
    for l in 1:(k-1)
        filename2 = string(file,"-gt",nn,"-",i,"-",l+1,"-",k,".tre")
        run(`/bin/bash -c "cat $filename2 >> $filename1"`)
        run(`/bin/bash -c "rm $filename2"`)

    end

    # rename as appropriate
    finalfilename = string(file,"-gt",nn*k,"-",i,"-1.tre")
    if k > 1 
        run(`mv $filename1 $finalfilename`)
    end
end

 # get rid of "_1" from taxon names in files
 run(`/bin/bash -c "sed -i '' 's/_1//g' $file*"`)


