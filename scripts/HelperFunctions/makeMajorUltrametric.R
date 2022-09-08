# n25 topo major
# ((t23:0.153,((t5:0.174,(((((t22:0.003,t20:0.003):0.063,t18:0.066):0.011,t13:0.077):0.178,(((t9:0.001,t15:0.001):0.125,(t21:0.019,t17:0.019):0.107):0.079,t2:0.205):0.049):3.921,((t7:0.037,t3:0.037):0.341,(((t10:0.045,(t16:0.022,(t6:0.003,t12:0.003):0.018):0.023):0.144,(t8:0.015,t11:0.015):0.174):0.046,t1:0.235):0.143):1.602):1.806):0.018,((t19:0.023,t14:0.023):0.029,t4:0.052):0.104):0.003):0.142,t25:0.011,t24:0.011);

# n50 topo major
# (t47:0.052,(t29:0.053,(t35:0.237,(t9:0.544,(((t23:0.003,t13:0.003):0.436,((((t40:0.018,t34:0.018):0.038,((t12:0.011,t14:0.011):0.017,t30:0.028):0.028):0.219,(t32:0.041,(t41:0.012,t4:0.012):0.029):0.233):0.059,t25:0.334):0.105):0.372,(((((((t1:0.016,(t48:0.003,t27:0.003):0.013):0.018,t17:0.034):0.037,((t45:0.01,t39:0.01):0.034,t28:0.045):0.026):0.196,(t38:0.0,t21:0.0):0.267):0.059,((((t16:0.024,(t5:0.004,(t19:0.003,t42:0.003):0.001):0.02):0.032,t44:0.056):0.022,(t2:0.047,t15:0.047):0.03):0.228,((t18:0.0,t20:0.0):0.151,(t3:0.009,t31:0.009):0.142):0.155):0.02):0.323,((t7:0.143,t37:0.143):0.058,t24:0.2):0.449):0.109,((((t26:0.009,t50:0.009):0.007,(t33:0.003,t46:0.003):0.013):0.009,t10:0.025):0.138,(t11:0.046,t43:0.046):0.117):0.595):0.019):0.267):0.306):0.185):0.001,(((t36:0.003,t22:0.003):0.012,(t6:0.013,t8:0.013):0.003):0.02,t49:0.036):0.016);

# Following https://brettkvo.com/how-to-create-a-ultrametric-dichotomous-phylogeny-in-r-using-vertlife-org-or-birdtree-org/
# we desire to turn these trees into ultrametric trees

n25topo = "((t23:0.153,((t5:0.174,(((((t22:0.003,t20:0.003):0.063,t18:0.066):0.011,t13:0.077):0.178,(((t9:0.001,t15:0.001):0.125,(t21:0.019,t17:0.019):0.107):0.079,t2:0.205):0.049):3.921,((t7:0.037,t3:0.037):0.341,(((t10:0.045,(t16:0.022,(t6:0.003,t12:0.003):0.018):0.023):0.144,(t8:0.015,t11:0.015):0.174):0.046,t1:0.235):0.143):1.602):1.806):0.018,((t19:0.023,t14:0.023):0.029,t4:0.052):0.104):0.003):0.142,t25:0.011,t24:0.011);"
n50topo = "(t47:0.052,(t29:0.053,(t35:0.237,(t9:0.544,(((t23:0.003,t13:0.003):0.436,((((t40:0.018,t34:0.018):0.038,((t12:0.011,t14:0.011):0.017,t30:0.028):0.028):0.219,(t32:0.041,(t41:0.012,t4:0.012):0.029):0.233):0.059,t25:0.334):0.105):0.372,(((((((t1:0.016,(t48:0.003,t27:0.003):0.013):0.018,t17:0.034):0.037,((t45:0.01,t39:0.01):0.034,t28:0.045):0.026):0.196,(t38:0.0,t21:0.0):0.267):0.059,((((t16:0.024,(t5:0.004,(t19:0.003,t42:0.003):0.001):0.02):0.032,t44:0.056):0.022,(t2:0.047,t15:0.047):0.03):0.228,((t18:0.0,t20:0.0):0.151,(t3:0.009,t31:0.009):0.142):0.155):0.02):0.323,((t7:0.143,t37:0.143):0.058,t24:0.2):0.449):0.109,((((t26:0.009,t50:0.009):0.007,(t33:0.003,t46:0.003):0.013):0.009,t10:0.025):0.138,(t11:0.046,t43:0.046):0.117):0.595):0.019):0.267):0.306):0.185):0.001,(((t36:0.003,t22:0.003):0.012,(t6:0.013,t8:0.013):0.003):0.02,t49:0.036):0.016);"

library(ape)
library(phytools)
library(picante)
library(plyr)

treefile <- read.newick("n25topomajor.net")
consensus<-consensus.edges(treefile, consensus.tree=consensus(treefile,p=0.5))  
plotTree(consensus, fsize=0.6)
print(consensus$edge.length)

#how does it look?  too many zeros at the end?  There appears to be a bug.  If so, you will need to run the code below....
#This makes a single-number vector that represents the length of the consensus$edge.length
n <- length(consensus$edge.length)  

#need to reduce the number of elements by 1... We also add a very small amount to make sure no branch length is zero.    
consensus$edge.length <- consensus$edge.length[1:n-1] + .0000001
print(consensus$edge.length) 
#how does it look now?  It should not have a zero for the last row.  Plot to confirm it works.
plotTree(consensus, fsize=0.6)



consensus_ultra=chronos(consensus, lambda=0)
consensus_ultra$edge.length <- plyr::round_any(consensus_ultra$edge.length[1:n-1] + .0000001, 0.01, f = ceiling)  

consensus_ultra=chronos(consensus_ultra, lambda=0)
# Lambda is the rate-smoothing parameter.  Generally, we want lambda to be small, so there is very little smoothing  See here (citation at bottom): http://www.justinbagley.org/1226/update-new-functions-for-generating-starting-trees-for-beast-or-starbeast-in-r
#Check again; now it's ultrametric.
is.ultrametric(consensus_ultra) 

#Make the tree dichotomous (so each node splits into only two branches)   
tree.unmatched <- multi2di(consensus_ultra, random=TRUE) 
# scales the tree branch edges to be comparable to other networks we are using, 
tree.unmatched$edge.length <- tree.unmatched$edge.length * 20
#Let's plot our new tree.  Huzzah!
plotTree(tree.unmatched,fsize=0.6)

newick = write.tree(tree.unmatched)
print(newick)
