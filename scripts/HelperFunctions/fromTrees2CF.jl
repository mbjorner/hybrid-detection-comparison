## Julia script to read a file with gene trees and 
## create a table of CFs

using PhyloNetworks

n15 = ["30","100","300","1000","3000"]
## Data folder:
for j in n15
    folder = string("./GitHub/phylo-microbes/data/knownGT/n15_n", j ,"/")

    ## Replicate:
    for i in 1:30
        file = string(i,"_astral.in")

        ## CF table filename matching the replicate:
        cftable = string(folder,split(file,'.')[1],".CFs.csv")

        ## this commands saves the CF table with the name given by cftable
        datCF = readTrees2CF(string(folder,file), writeTab=true, CFfile = cftable, writeSummary=false)
    end
end 