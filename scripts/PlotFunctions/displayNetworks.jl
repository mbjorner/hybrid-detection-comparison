# Marianne Bjorner
# Sep 29 2022

# this displays and saves all networks used in hybrid detection comparison

using PhyloNetworks, PhyloPlots, Plots, RCall, Gadfly, Cairo, Fontconfig

## Networks used
n4h1 = readTopology("(4:8.0,((1:1.5,#H1:0.75::0.5):1.5,(3:1.5,(2:0.75)#H1:0.75::0.5):1.5):5.0);");
PhyloPlots.rotate!(n4h1, -5)

n4h1_introgression = readTopology("(4:8.0,((3:1.5,#H1:0::0.5):1.5,(1:1.5,(2:1.5)#H1:0::0.5):1.5):5.0);");
PhyloPlots.rotate!(n4h1_introgression, -5)

n5h2 = readTopology("(5:9.5,(((1:1.5,#H1:0.75::0.5):1.5,((3:1.5,(2:0.75)#H1:0.75::0.5):0.75)#H2:0.75::0.5):1.5,(4:3.0,#H2:0.75::0.5):1.5):5.0);");
PhyloPlots.rotate!(n5h2, -9)
PhyloPlots.rotate!(n5h2, -7)

n8h3 = readTopology("(8:11.0,((((1:1.5,#H1:0.75::0.5):1.5,(3:1.5,(2:0.75)#H1:0.75::0.5):1.5):1.5,(4:3.75)#H3:0.75::0.5):1.5,(((5:1.5,#H2:0.75::0.5):1.5,(7:1.5,(6:0.75)#H2:0.75::0.5):1.5):1.5,#H3:0.75::0.5):1.5):5.0);");
PhyloPlots.rotate!(n8h3, -10)
PhyloPlots.rotate!(n8h3, -7)
PhyloPlots.rotate!(n8h3, -13)


n10h2 = readTopology("(10:9.6,(#H1:2.9::0.3,(1:7.2,(2:6.0,(((9:0.4)#H2:5.0::0.8,(3:4.4,(4:3.5,((5:0.2,6:0.2):2.1,(7:1.4,(8:0.4,#H2:0.0::0.2):1.0):0.9):1.2):0.9):1.0):0.1)#H1:0.5::0.7):1.2):1.2):1.2);");
### Rotate node to taxon 8
PhyloPlots.rotate!(n10h2, -14)

n10h1_deep = readTopology("(10:9.6,(#H1:2.9::0.3,(1:7.2,(2:6.0,((9:5.4,(3:4.4,(4:3.5,((5:0.2,6:0.2):2.1,(7:1.4,8:1.4):0.9):1.2):0.9):1.0):0.1)#H1:0.5::0.7):1.2):1.2):1.2);");
n10h1_shallow = readTopology("(10:9.6,(1:7.2,(2:6.0,((9:0.4)#H2:5.0::0.8,(3:4.4,(4:3.5,((5:0.2,6:0.2):2.1,(7:1.4,(8:0.4,#H2:0.0::0.2):1.0):0.9):1.2):0.9):1.0):0.6):1.2):2.4);");
### Rotate node to taxon 8
PhyloPlots.rotate!(n10h1_shallow, -12)

n15h3 = readTopology("(15:11.0,(1:10.0,((14:8.0,(((7:2.8,((10:0.6)#H3:1.0::0.8,(9:0.4,8:0.4):1.2):1.2):0.8,((11:1.6,#H3:1.0::0.2):1.2,(13:0.4,12:0.4):2.4):0.8):3.4, #H1:0.4::0.3):1.0):1.2, ((((2:0.4,3:0.4):1.4)#H2:3.8::0.8,(((4:2.8,#H2:1.0::0.2):0.8,5:3.6):1.2,6:4.8):0.8 ):1.0)#H1:2.6::0.7):0.8):1.0);");
n15h1_shallow = readTopology("(15:11.0,(1:10.0,((14:8.0,((7:2.8,((10:0.6)#H3:1.0::0.8,(9:0.4,8:0.4):1.2):1.2):0.8,((11:1.6,#H3:1.0::0.2):1.2,(13:0.4,12:0.4):2.4):0.8):4.4):1.2,((2:0.4,3:0.4):5.2,((4:3.6,5:3.6):1.2,6:4.8):0.8):3.6):0.8):1.0);");
n15h1_intermediate = readTopology("(15:11.0,(1:10.0,((14:8.0,((7:2.8,(10:1.6,(9:0.4,8:0.4):1.2):1.2):0.8,(11:2.8,(13:0.4,12:0.4):2.4):0.8):4.4):1.2, (  ((2:0.4,3:0.4):1.4)#H2:3.8::0.8  ,  (((4:2.8,#H2:1.0::0.2):0.8,5:3.6):1.2,6:4.8):0.8 ):3.6):0.8):1.0);");
n15h1_deep = readTopology("(15:11.0,(1:10.0,((14:8.0,(((7:2.8,(10:1.6,(9:0.4,8:0.4):1.2):1.2):0.8,(11:2.8,(13:0.4,12:0.4):2.4):0.8):3.4, #H1:0.4::0.3):1.0):1.2,((  (2:0.4,3:0.4):5.2  ,  ((4:3.6,5:3.6):1.2,6:4.8):0.8 ):1.0  ) #H1:2.6::0.7):0.8):1.0);");
n25h5 = readTopology("(25:15.0,((23:13.0,(((5:10.0,((((7:1.0,3:1.0):6.0,(((10:4.0,(16:3.0,((6:1.0,12:1.0):1.0,#H26:1.0::0.369):1.0):1.0):1.0,(8:2.0,(11:1.0)#H26:1.0::0.631):3.0):1.0,1:6.0):1.0):1.0)#H30:1.0::0.656,((((22:3.0,(20:2.0,#H28:1.0::0.449):1.0):1.0,18:4.0):1.0,13:5.0):1.0,(((9:2.0,(15:1.0)#H32:1.0::0.605):1.0,((21:1.0,17:1.0):1.0,#H32:1.0::0.395):1.0):1.0,(2:1.0)#H28:3.0::0.551):2.0):3.0):1.0):1.0,(((19:1.0,14:1.0):1.0,4:2.0):7.0,#H30:1.0::0.344):2.0):1.0)#H34:1.0::0.976):1.0,(24:13.0,#H34:1.0::0.024):1.0):1.0);");

networks = [n4h1, n4h1_introgression, n5h2, n8h3, n10h2, n10h1_deep, n10h1_shallow,
            n15h3, n15h1_shallow, n15h1_intermediate, n15h1_deep, n25h5]

function plotnet(net::HybridNetwork)
    plot(net, :R, useEdgeLength=true, showEdgeLength=true, showGamma=true)
end

function plotnet(newickstring::AbstractString)
    plotnet(readTopology(newickstring))
end

# Following methodology found http://crsl4.github.io/PhyloNetworks.jl/latest/man/snaq_plot/

macro Name(arg)
    string(arg)
end

@rlibrary ggplot2

plot(net, :R, showGamma = false, useEdgeLength=true, showEdgeLength=true)

for net in networks
    imagefilename =  string(@Name(net), ".svg")
    draw(SVG(imagefilename,4inch,3inch), plot(net, showGamma = true, useEdgeLength=true, showEdgeLength=true))


    #R"png"(imagefilename, width=4, height=3) # starts image file
    #R"par"(mar=[0,0,0,0]) # to reduce margins (no margins at all here)
    #plot(net, showGamma=false, useEdgeLength=true, showEdgeLength=true); # network is plotted & sent to file
    #R"dev.off()"; # wrap up and save image file 
end

imagefilename =  string(@Name(n10h1_deep), ".png")
draw(PNG(imagefilename,4inch,3inch), plot(n10h1_deep, :R, style=:fulltree, showGamma=false, useEdgeLength=true, showEdgeLength=true))

plot(n10h1_deep, :R, style=:fulltree, showGamma=false, useEdgeLength=true, showEdgeLength=true)
plot(n10h1_shallow, :R, style=:fulltree, showGamma=false, useEdgeLength=true, showEdgeLength=true)
plot(n10h2, :R, style=:fulltree, showGamma=false, useEdgeLength=true, showEdgeLength=true)
plot(n4h1_introgression, :R, style=:fulltree, showGamma=false, useEdgeLength=true, showEdgeLength=true)

plot(n4h1, :R, style=:fulltree, showGamma=false, useEdgeLength=true, showEdgeLength=true)
plot(n5h2, :R, style=:fulltree, showGamma=false, useEdgeLength=true, showEdgeLength=true)
plot(n8h3, :R, style=:fulltree, showGamma=false, useEdgeLength=true, showEdgeLength=true)
plot(n15h3, :R, style=:fulltree, showGamma=false, useEdgeLength=true, showEdgeLength=true)
plot(n15h1_deep, :R, style=:fulltree, showGamma=false, useEdgeLength=true, showEdgeLength=true)

plot(n15h1_intermediate, :R, style=:fulltree, showGamma=false, useEdgeLength=true, showEdgeLength=true)
plot(n15h1_shallow, :R, style=:fulltree, showGamma=false, useEdgeLength=true, showEdgeLength=true)
plot(n25h5, :R, style=:fulltree, showGamma=false, useEdgeLength=true, showEdgeLength=true)