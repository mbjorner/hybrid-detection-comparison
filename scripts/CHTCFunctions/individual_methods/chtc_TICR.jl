# Marianne Bjorner
# May 30, 2021
#
# accepts inputs of gene trees and quartetMaxCut tree
# https://argparsejl.readthedocs.io/en/latest/argparse.html
#=
import Pkg; Pkg.add("QuartetNetworkGoodnessFit")
import Pkg; Pkg.add("DataFrames")
import Pkg; Pkg.add("CSV")
import Pkg; Pkg.add("PhyloNetworks")
import Pkg; Pkg.add("ArgParse")
=#
using QuartetNetworkGoodnessFit, DataFrames, CSV, PhyloNetworks

function main()
    # parsed_args = parse_commandline()
    
    geneTreeFile = ARGS[1] #
    tree = ARGS[2]      # OR input network
    outFile = ARGS[3]      #

    treeCF = readTrees2CF(geneTreeFile);

    # thought that because of results of p-values giving high false negatives/false positives, this was indicative of this not working, but it seems
    # the issue is really that p-values are representations of how well they are being represented by the QMC tree.
    # treeCF = DataFrame(CSV.File("tableCF.txt"));
    net = readTopology(tree);
    net = majorTree(net);

    ticrOut = ticr!(net, treeCF, true, quartetstat = :maxCF, test = :onesided)
    
    treeCF = writeTableCF(treeCF);
    if length(ticrOut[5]) != nrow(treeCF)
        println("These are not the same length, should end")
        println("length of ticrOut is ", length(ticrOut[5]))
        println("number of rows of CFtree is ", nrow(treeCF))
    end
    
    insertcols!(treeCF, 9, :pValTicr => ticrOut[5]);
    insertcols!(treeCF, 10, :overallPval => ticrOut[1]);
    
    CSV.write(string(outFile), treeCF);

end

main()