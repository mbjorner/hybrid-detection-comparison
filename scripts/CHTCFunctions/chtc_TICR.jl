# Marianne Bjorner
# May 30, 2021
#
# accepts inputs of gene trees and quartetMaxCut tree
# https://argparsejl.readthedocs.io/en/latest/argparse.html

import Pkg; Pkg.add("ArgParse")
import Pkg; Pkg.add("QuartetNetworkGoodnessFit")
import Pkg; Pkg.add("DataFrames")
import Pkg; Pkg.add("CSV")
import Pkg; Pkg.add("PhyloNetworks")

using QuartetNetworkGoodnessFit, DataFrames, CSV, PhyloNetworks, ArgParse

# function parse_commandline()
#    s = ArgParseSettings()

#    @add_arg_table s begin
#        "geneTreeFile"
#            help = "gene tree file"
#            required = true
#        "quartetMaxCut"
#            help = "quartet max cut .tre file"
#            required = true
#    end

 #   return parse_args(s)

# end
 

function main()
    # parsed_args = parse_commandline()
    
    geneTreeFile = ARGS[1]
    QMCTree = ARGS[2]

    treeCF = readTrees2CF(geneTreeFile);
    net = readTopology(QMCTree);

    ticrOut = ticr!(net, treeCF, true, quartetstat = :maxCF, test = :onesided)

    numTrial = ARGS[1][1]
    io = open(string("n10_n30_", numTrial, "_ticr.txt"), "w");
    write(io, Base.string(ticrOut));
end

main()