# julia script to debug file format

using PhyloPlots
using PhyloNetworks

net = readTopology(ARGS[1])
plot(net, :R, style=:majortree, useEdgeLength=true, showEdgeLength=true)


(10:9.6,(1:7.2,(2:7.2,((9:0.4)#H2:5.0::0.8,(3:4.4,(4:3.5,((5:0.2,6:0.2):2.1,(7:1.4,(8:0.4,#H2:0.0::0.2):1.0):0.9):1.2):0.9):1.0):0.6):1.2):1.2);

(10:9.6,(#H1:2.9::0.7,(1:7.2,(2:6.0,((9:5.4,(3:4.4,(4:3.5,((5:0.2,6:0.2):2.1,(7:1.4,8:1.4):0.9):1.2):0.9):1.0):0.1)#H1:0.5::0.3):1.2):1.2):1.2);
