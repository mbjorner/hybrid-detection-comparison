 # following are functions to ascertain the ghost lineages at root of the tree,
 # and remove them to see how well functions can discern ghost lineages vs. discern hybrids 
 # only within a triplet or quartet

 # this script takes a single filename and creates an output file that contains
 # true negatives, true positives, false positives, false negatives at alpha levels of 0.05 and the bonferroni correction

 # will also contain a column for ghost lineages
function main(filename)
    #filename is set up with the format string(netname,"/-gt", num_gene_trees, "-1-1.tre...", HyDe_Dstat.csv
    netname = split(filename, "-")[1]
    if contains(filename, "HyDe")
        analyzeHyDe_DStat(filename, netname)
    elseif contains(filename, "TICR_MSC")
        analyzeTICR_MSC(filename, netname)
    else
        print("input file ", filename, " was not analyzed: does not fit naming conventions")
    end
end


function analyzeTICR_MSC(filename, truenetwork)

end

function analyzeHyDe_DStat(filename, truenetwork)
    # read in file as DataFrame
    # add columns for ghost lineage
    # add columns for other stuff
    # add something else idk
    # 
end

# this indicates a ghost lineage at the root 
function isHybridAtRoot(net)
    rootEdges = net.node[net.root].edge
    for i in 1:net.numHybrids
        for n in net.hybrid[i].edge
            for r in rootEdges
                if r.number == n.number
                    return true
                end
            end
        end
    end
    return false
end

function removeHybridAtRoot(net)
    rootEdges = net.node[net.root].edge
    print("root is", rootEdges)
    for i in 1:net.numHybrids
        for n in net.hybrid[i].edge
            print("n.number is ", n.number)
            for r in rootEdges
                if r.number == n.number
                    print("removing hybrid edge ", net.hybrid[i].edge)
                    PhyloNetworks.deletehybridedge!(net, n)
                end
            end
        end
    end
end

# if numHybrids is 2, then there is still a hybrid in the triplet
function getHybrids(net)
    hybrids = Set()
    for i in 1:net.numHybrids
        hybridclade = hardwiredCluster(net.hybrid[i].edge[1], tipLabels(net));
        trueHybrids = tipLabels(net)[hybridclade]
        for hyb in trueHybrids
            push!(hybrids, hyb)
        end
    end
    return hybrids
end


function isGhostHybrid(net, hybridlabel)
    # checks to see if the hybrid clades of the network are downstream
    # of the hybrid edge
    net = PhyloNetworks.directEdges!(net)
    hybridclade = hardwiredCluster(net.hybrid[hybridlabel].edge[1], tipLabels(net))
    hybridtips = tipLabels(net)[hybridclade]
    print("\n hybrid tips are: ", hybridtips)
    # step 2 is find the clades downstream of the node / downstream of the hybrid
    # parent of minor hybrid edge:
    parentnode = PhyloNetworks.getParent(net.hybrid[hybridlabel].edge[1]) 
    
    # children = PhyloNetworks.getChildren(parentnode)
    # majortree = PhyloNetworks.majorTree(net)
    
    downstreamclades = PhyloNetworks.hardwiredCluster(parentnode.edge[3], tipLabels(net))
    downstreamtips = tipLabels(net)[downstreamclades]
    print("\n downstreamtips are", downstreamtips)
    if issubset(hybridtips, downstreamtips) 
        return true
    else
        print("\n hybrid tips are ", hybridtips)
        print("\n downstream tips are ", downstreamtips)
        return false
    end
end


```
get length of the minor hybrid edge
```
function getLengthMinorEdge(net, hybridlabel)
    if !contains(string(net.hybrid[hybridlabel].edge[1]), "minor")
        error("error, not minor edge, problem in distHybEdge method")
    end
    return PhyloNetworks.getlengths(net.hybrid[hybridlabel].edge)[1]
end

```
gets the largest height of the tree, assumes the tree is ultrametric
```
function getHeightTree(net)
    nodeheight = PhyloNetworks.getHeights(net)
    return nodeheight[size(nodeheight,1)]
end

```
gets the distance of hybrid edges to the kids it attaches to
```
function distHybEdgeToKids(net, hybridlabel)
    parentnode = PhyloNetworks.getParent(net.hybrid[hybridlabel].edge[1]) 
    treeHeight = getHeightTree(net)
    heightsdict = Dict()
    for (i,node) in enumerate(net.nodes_changed)
        heightsdict[string(node.number)] = (nodeheight[i], node.name)
    end
    
    return treeHeight - get(heightsdict, string(parentnode.number), 0)[1]
    
end

```
get distance between the three/four taxa of the tree, 
returned as pairwise distance matrix, sans hybrid edges

essentially, this is Dijkstra's algorithm
```
function getPairwiseDistanceMajorTree(net)
    net = majorTree(net)
end

function getPairwiseDistance(net)
end


function getGammas(net)
    return PhyloNetworks.getGammas(net)
end

```
returns distance from one node to the other as a sum of edge lengths between them in the major tree
```
function getlength(net, node1, node2)
    net = majorTree(net)
    edges = edgesBetween(net, node1, node2)
    edgeArray = PhyloNetworks.getlengths(edges)
    sumEdges = 0
    for edge in edgeArray
        sumEdges = sumEdges + edge
    end
    return sumEdges
end

```
edges between the network's node 1 and node 2
```
function edgesBetween(net, node1, node2)
    edges = Set()
    getparent(node1)
    getparent(node2)
    push!(edges)
end