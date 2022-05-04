from __future__ import print_function
from sys import argv

# instead, this should match the total number of taxa available

# this is a dictionary structure, can easily create new keys using input from map file OR simply number of taxa
# this creates a dictionary of 1-n sequences, labeled as such
# in order to create this with P1, P2, HYB, O, import map file
def concatenation_by_num(n, outfile, infile):

    matrix = {}
    rangeN = int(n) + 1 
    for i in range (1, rangeN):
        matrix[str(i)] = []

# this is the nexus file created by seqgen
    with open(infile) as f:
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

def concatenation_by_name(map, outfile, infile):
    # read from map file all names of taxa
    matrix = {}
    names = []

    f = open(map, "r")
    for line in f: 
        name = line.split(" ")
        matrix[str(name[0])] = []
        names.append(str(name[0]))
    
    print(names)

# this is the nexus file created by seqgen
    basepairs = "ATCG?"
    with open(infile) as f:
        splitby = " " + names[0] + " " + names[1] + "\n"
        reps  = f.read().split(splitby)
        split_reps = [r.splitlines() for r in reps] # reps is the number of trees simulated
        for s in split_reps:
            for l in s:
                # if l l.split()[0] exists in matrix and l.split()[1] is ATCG
                taxa = str(l.split()[0])
                atcg = str(l.split()[1])
                if (taxa in names) and (atcg in basepairs):
                    matrix[taxa].append(atcg)
    
    for entry in names:
        print(entry, "\t", sep='', end='', file=outfile)
        for base in matrix[entry]:
            print(base, sep='', end='', file=outfile)
        print("\n", end='', file=outfile)



def main():

    n = argv[3] # number of taxa? 
    outfile = open(argv[2], 'w') # this is what will become the input file for hyde, a translation of the seqgen outfile

    if is_integer(n):
        concatenation_by_num(n, outfile, argv[1])
    
    if not is_integer(n):
        concatenation_by_name(n, outfile, argv[1])


def is_integer(n):
    try:
        float(n)
    except ValueError:
        return False
    else:
        return float(n).is_integer()

if __name__ == "__main__":
    main()