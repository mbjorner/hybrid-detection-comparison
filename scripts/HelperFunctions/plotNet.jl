# julia script to debug file format

using PhyloPlots
using PhyloNetworks

function plotnet(net::HybridNetwork)
    plot(net, :R, style=:majortree, useEdgeLength=true, showEdgeLength=true, showGamma=true)
end

function plotnet(newickstring::AbstractString)
    plotnet(readTopology(newickstring))
end
