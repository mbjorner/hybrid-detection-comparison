# julia script to debug file format

using PhyloPlots
using PhyloNetworks

function plotnet(net::HybridNetwork)
    plot(net, :R, style=:majortree, useEdgeLength=true, showEdgeLength=true, showGamma=true)
end

function plotnet(newickstring::AbstractString)
    plotnet(readTopology(newickstring))
end

# function that automatically scales the timing events of ms functions, and returns format as a string
function ms_scale_times(msCommand::AbstractString, scalefactor::Float64)
    # following every -ej or -es event, there is a time. If !-ej && !-es, ignore. otherwise
    # scale time following -ej or -es event by whatever factor is specified.
    ms_scaled = ""
    isTimeNext = false
    msCommand_split = split(msCommand, " ")
    for substring in msCommand_split
        if isTimeNext
            time = parse(Float64, substring)
            newTime = time * scalefactor
            ms_scaled = string(ms_scaled, " ", newTime)
            isTimeNext = false
            continue
        elseif startswith(substring, "-e")
            isTimeNext = true
            ms_scaled = string(ms_scaled, " ", substring)
        else
            ms_scaled = string(ms_scaled, " ", substring)
        end
    end


    return ms_scaled
end