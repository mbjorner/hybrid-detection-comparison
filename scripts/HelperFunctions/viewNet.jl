# julia script to debug file format

using PhyloPlots
using PhyloNetworks

net = readTopology(ARGS[1])
plot(net, :R, style=:majortree, useEdgeLength=true, showEdgeLength=true)