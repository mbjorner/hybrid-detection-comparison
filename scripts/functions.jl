## Julia script to simulate gene trees on a network
## Claudia February 2021

## function to simulate gene trees on a network
## i: replicate
## file: e-newick format of network
## folder: where to save the results (same as where file is stored)
## outgroup: to root the network
## numgt: number of gene trees to simulate
## seed: random seed
## hybridlambda: path to hybridlambda executable
## this functions does not return anything. it writes a textfile with the gene trees
function simulateGeneTrees(i::String, file::String, folder::String, outgroup::String,
                           numgt::Int, seed::Int, hybridlambda::String)
    net = readTopology(string(folder,file,".net"))
    rootatnode!(net,outgroup)
    net2 = hybridlambdaformat(net)
    ##plot(net,:R)
    f = open("rooted.net", "w")
    write(f, net2)
    close(f)
    ## Now we make ultrametric (we don't seem to need it anymore)
    ##rt = read(`$makeultrametric rooted.net`, String)
    ##write("rooted-um.net",rt)

    ## Simulate gene trees with hybrid-lambda on the network
    ## (which is in coalescent units, so we use -spcu)
    ## outfile with simulated gene trees: simGT_coal_unit
    p=Pipe()
    @show "starting hybridlambda..."
    run(pipeline(`$hybridlambda -spcu rooted.net -o simGT -num $numgt -seed $seed`,stderr=p))
    close(p.in)
    close(p.out)
    close(p)
    close(Base.pipe_writer(p))
    GC.gc()


    ## rename the gene trees file
    newfile = string(folder,file,"-gt",numgt,"-",i,".tre")
    try
        run(`mv simGT_coal_unit $newfile`)
    catch
        println("something went wrong in hybridlambda")
    end 
end
