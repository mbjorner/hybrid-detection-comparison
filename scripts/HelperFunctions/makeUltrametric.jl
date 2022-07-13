using PhyloNetworks

"""
from an input HybridNetwork, lengthens the external edges to match the length of the longest
tip_height as measured from the root of the tree
"""
function makeUltrametric!(net::HybridNetwork)
    ## Base case: does not change the network as it is already ultrametric
    if isUltrametric(net)
        return
    end

    ## network is not ultrametric
    preorder!(net) # PhyloNetworks.directEdges!(net) ?? should we also direct the edges or is this unneeded
    heights = PhyloNetworks.getHeights(net)
    max_tip_height = findmax(heights)[1]
    heights_dict = Dict([node.name => (heights[i], node.number, node) for (i,node) in enumerate(net.nodes_changed)])
    labels = tipLabels(net)
    for tip_name in labels
        tip_height = heights_dict[tip_name][1]
        node = heights_dict[tip_name][3]
        if tip_height != max_tip_height # should there be floating point error accounted for?
            # change the length of the external edge that the tip is attached to to make it same length
            length_difference = max_tip_height - tip_height
            edgeToChange = PhyloNetworks.getMajorParentEdge(node)
            edgeToChange.length = edgeToChange.length + length_difference
        end
    end

end

"""
Returns whether HybridNetwork is ultrametric. 
An ultrametric network is defined as a network 
where all tips are equidistant from the root.

notes: unsure if it should be named isUltrametric! because it calls preorder!(net)
"""
function isUltrametric(net::HybridNetwork)
    preorder!(net) # PhyloNetworks.directEdges!(net) ?? should we also direct the edges or is this unneeded
    heights = PhyloNetworks.getHeights(net)
    max_tip_height = findmax(heights)[1]
    heights_dict = Dict([node.name => (heights[i], node.number) for (i,node) in enumerate(net.nodes_changed)])
    labels = tipLabels(net)
    for tip_name in labels
        tip_height = heights_dict[tip_name][1]
        if abs(tip_height - max_tip_height) > 0.00001  # should there be floating point error accounted for?
            return false
        end
    end
    return true
end


# tests that network is unchanged if it's already ultrametric
function testMakeUltrametric(net::HybridNetwork)
    initial_net = writeTopology(net)
    is_um_net = isUltrametric(net)
    makeUltrametric!(net)
    is_new_um_net = isUltrametric(net)
    transformed_net = writeTopology(net)

    if !(transformed_net == initial_net) && is_um_net
        ### floating point errors in either writeTopology or transformed_net: how do I solve for this?
        print("failed test, changes initial ultrametric network: \n", 
                "\t initial net: ", initial_net, "\n\t final net: ", transformed_net, "\n\n")
    elseif !is_um_net && (transformed_net == initial_net)
        print("failed test, changes does not change initial un-ultrametric network, \n", 
              "\t initial net: ", initial_net, "\n\t final net: ", transformed_net, "\n\n")
    elseif !is_um_net && !(transformed_net == initial_net) && is_new_um_net
        print("passed, does change initial un-ultrametric net to ultrametric\n\n")
        return true
    elseif !is_um_net && !(transformed_net == initial_net) && !is_new_um_net
        ### floating point errors create this issue
        print("failed, changes initial un-ultrametric net to another un-ultrametric net :\n",
              "\t initial net: ", initial_net, "\n\t final net: ", transformed_net, "\n\n")
    elseif is_um_net && (transformed_net == initial_net)
        print("passed, does not change initial ultrametric network\n\n")
        return true
    end
    return false
end

# tests that network is unchanged in newick representation if isUltrametric is called
function testIsUltrametric(net::HybridNetwork)
    initial_net = writeTopology(net)
    isUltrametric(net)
    transformed_net = writeTopology(net)

    unchanged = initial_net == transformed_net
    if unchanged
        print("test passed, initial network unchanged\n\n")
        return true
    else
        print("test failed, initial network changed when calling isUltraMetric\n", 
              "initial net is: ", initial_net, "\nfinal net is: ", transformed_net,"\n\n")
        return false
    end
end

function runTests(net_array)
    testsPassed = 0
    testsTotal = 0
    for net in net_array
        if testIsUltrametric(net)
            testsPassed = testsPassed + 1
        end
        if testMakeUltrametric(net)
            testsPassed = testsPassed + 1
        end
        testsTotal = testsTotal + 2
    end

    print("\t\t\t PASSED ", testsPassed , " of ", testsTotal, " total tests")

end

net_not_ultrametric = readTopology("(((C:1,(A:1)#H1:1.5::0.7):1,(#H1:0.3::0.3,E:2.0):2.2):1.0,O:5.2);");
net_ultrametric = readTopology("(10:9.6,(#H1:2.9::0.3,(1:7.2,(2:6.0,((9:5.4,(3:4.4,(4:3.5,((5:0.2,6:0.2):2.1,(7:1.4,8:1.4):0.9):1.2):0.9):1.0):0.1)#H1:0.5::0.7):1.2):1.2):1.2);");
t25big_not_ultrametric = readTopology("((t23:0.1529152972,(((t5:0.1742374953,((((t7:0.03701669352,t3:0.03701669352):0.3407026256,
                                        (((t10:0.04459338561,(t16:0.02154361617,((t6:0.003451109906,t12:0.003451109906):0.01528756611593066,
                                        #H26:0.0::0.36876441171047525):0.0028049401540693394):0.02304976944):0.1443262328,(t8:0.01505489628,
                                        (t11:0.0001302054392005513)#H26:0.01492469084079945::0.6312355882895248):0.1738647222):0.04565597165,
                                        t1:0.2345755901):0.143143729):0.8555897296291333)#H30:0.7465149403708666::0.6562886539999526,
                                        ((((t22:0.002735944325,(t20:0.0009194177853483883,#H28:0.0::0.4488376427119638):0.0018165265396516118):0.06284850635,
                                        t18:0.06558445067):0.01147941802,t13:0.07706386869):0.1775396659,(((t9:0.001097780354,
                                        (t15:0.0006062338328663671)#H32:0.0004915465211336328::0.6048820881657472):0.1249432998,((t21:0.01920083843,
                                        t17:0.01920083843):0.0672246242136909,#H32:0.0::0.3951179118342528):0.039615617586309104):0.07923131404,
                                        (t2:0.14875716867381913)#H28:0.05651522552618088::0.5511623572880362):0.04933114034):3.921257451):1.805586494):0.01838017514,
                                        (((t19:0.02301105435,t14:0.02301105435):0.02867005422,t4:0.05168110857):0.08023888482507495,
                                        #H30:0.0::0.3437113460000474):0.02393732677492505):0.0)#H34:0.00294202294::0.976224958374261):0.1415983706,t25:0.01131692658,
                                        (t24:0.0077794867038045645,#H34:0.0::0.023775041625738957):0.0035374398761954346);")



function multiplyEdgeLengths!(net, factor)
    for edge in net.edge
        edge.length = edge.length * factor
    end
end

PhyloNetworks.rootatnode!(t25big_not_ultrametric, "t25")
makeUltrametric!(t25big_not_ultrametric)
multiplyEdgeLengths!(t25)


arr_net = [net_not_ultrametric, net_ultrametric, t25big_not_ultrametric]
runTests(arr_net)