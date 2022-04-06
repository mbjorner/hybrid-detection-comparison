from __future__ import print_function
from sys import argv

n = argv[3] # number of taxa? 
outfile = open(argv[2], 'w') # this is what will become the input file for hyde, a translation of the seqgen outfile

# instead, this should match the total number of taxa available

# this is a dictionary structure, can easily create new keys using input from map file OR simply number of taxa
matrix = {}
rangeN = int(n) + 1 
for i in range (1, rangeN):
    matrix[str(i)] = []

# this is the nexus file created by seqgen
with open(argv[1]) as f:
    splitby = " " + n + " 1\n"
    reps  = f.read().split(splitby)
    split_reps = [r.splitlines() for r in reps] # reps is the number of trees simulated
    for s in split_reps:
        for l in s:
            if len(l) > 30:
                matrix[str(l.split()[0])].append(l.split()[1])

for i in range(1, rangeN):
    print(str(i), "\t", sep='', end='', file=outfile)
    for base in matrix[str(i)]:
        print(base, sep='', end='', file=outfile)
    print("\n", end='', file=outfile)