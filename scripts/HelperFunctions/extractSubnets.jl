using PhyloNetworks, PhyloPlots

## read true network: we need to use Level1 so that missing branch lengths are set to 1.0
net = readTopologyLevel1("(10,(#H2,(1,(2,(((9)#H1,(3,(4,((5,6),(7,(8,#H1)))))))#H2))));")
## set the triplet to extract:
triplet = ["1","2","3"] ##need to be strings!

## extract triplet:
for l in tipLabels(net)
    if l ∉ triplet
        PhyloNetworks.deleteLeaf!(net,l)
    end 
end 

plot(net,:R) ##just to visualize

## test if it has a hybrid:
net.numHybrids > 0 && println("net has a hybrid")

## if the network has a hybrid, who is the hybrid?
## the hardwired function produces the clade below any edge
## all the edges connected to the hybrid node will 
## produce the same clade, so choosing the 1st edge here
hybridclade = hardwiredCluster(net.hybrid[1].edge[1],tipLabels(net))
## who is the hybrid:
tipLabels(net)[hybridclade]

plot(net,:R) ##to check the correct taxa is identified as hybrid in this case