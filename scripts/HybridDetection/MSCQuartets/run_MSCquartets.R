library(MSCquartets)
library(ape)

setwd("~/Github/phylo-microbes/")

# look into https://stackoverflow.com/questions/14958516/read-all-files-in-directory-and-apply-multiple-functions-to-each-data-frame

networks = c("n10")
num_tree = c("n100", "n1000", "n30", "n300", "n3000")
times = c()

for (netnums in networks) {
  for (numtrees in num_tree) {
    start_time = Sys.time()
    for (i in 1:30) {
      fileName = paste("data/knownGT/",netnums,"_",numtrees,"/",i,"_astral.in", sep = "") 
      gene_trees = read.tree(file = fileName)
      
      # if fileName not found, skip / if read.tree invalid for this file, skip
      QT = quartetTable(gene_trees, taxonnames = NULL, epsilon = 0, random = 0)
      QTR = quartetTableResolved(QT, omit = F)
      
      MSC = quartetTreeTestInd(QTR, model = "T3")
      Star = quartetStarTestInd(QTR)
      
      # quartet tree test to see if the output tree fits the MSC model
      
      quartetTreeTest(
        obs,
        model = "T3",
        lambda = 0,
        method = "MLest",
        smallcounts = "approximate",
        bootstraps = 10^4
      )
      
      CFpVals = cbind(MSC, Star[, "p_star"])

      write.csv(CFpVals, paste("output/", netnums, "_",numtrees,"_",i,"_astral.in", "_", "output.csv", sep = "")) 
    }
    end_time = Sys.time()
    timing = end_time-start_time
    average_time_per_sample = timing / 30
    
    times = cbind(times, c(paste(netnums, "_", numtrees, sep = ""), timing, average_time_per_sample))
  }
}

# counting occurrences of displayed quartets seems to take the most time (original CF)
# idea: embed timer into QT to get true time

write.csv(times, "output/times.csv")
