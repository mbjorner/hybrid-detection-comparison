"""
Marianne Bjorner
July 4 2022

This python script builds on the original calculate_D_D3_v2.py file as found in 
https://github.com/mhibbins/D3_introgression/tree/master/analysis which was developed
for D3 test.


/Users/bjorner/GitHub/phylo-microbes/data/knownGT/multiNet/n10/n10-gt500000-22-1.tre
-- put through seqgen
seqgen_out=${gene_trees}_seqgen.out
THETA=0.01
./Seq-Gen-1.3.4/source/seq-gen -mGTR -s $THETA -l 1 -r 1.0 0.2 10.0 0.75 3.2 1.6 \
        -f 0.15 0.35 0.15 0.35 -i 0.2 -a 5.0 -g 3 -q < ${gene_trees} > ${seqgen_out} 2> ${gene_trees}_seqgen.log

Command then run e.g.
D3_D_combinations.py /Users/bjorner/GitHub/n10-gt500000-22-1.tre_seqgen.out /Users/bjorner/GitHub/phylo-microbes/maps/n10h2map.txt


For a given input file that is a sequence alignment, (ARG 1)
each permutation of three taxa (as given in a path to a map file - ARG 2) 
is tested for introgression using the D3 test (as well as Dp, D, and D3_v2) followed by block jackknife.
"""

from __future__ import print_function
import re
import sys
import random
import itertools
import pandas as pd

# these are to name the output files created
all_permutations_csv_name = "allgroups.csv"
only_ingroup_permutations_csv_name = "only_ingroups.csv"

# to store all sequences as a name -> sequence (key, value) pair
sequences = {}

# array of names of whatever taxa you want to analyze and calculate D, D3, Dp etc. values for.
names = []

# this reads in and populates "names" from a map file. The map file is simply a text file with the names of the individuals from which
# the sequences come, and **should be the same as the names found in the alignment file**. Format: one taxon on each line, and one word only.
# for simplicity, I also made the outgroup the last taxon listed in the map file. A map file makes separating the sequences much easier.
""" 
(Acceptable format - would create [taxa1, taxa2, taxa3, taxa4, outgroup])
taxa1
taxa2
taxa3
taxa4
outgroup


(Unacceptable format - spaces between taxa, would create [taxon, taxon, taxon, taxon, outgroup])
taxon 1
taxon 2
taxon 3
taxon 4
outgroup
""" 
f = open(sys.argv[2], "r")
for line in f: 
    name = line.split(" ")
    sequences[str(name[0])] = [] # creating the keys for the names.
    names.append(str(name[0]))

print(names)

with open(sys.argv[1], 'r') as alignment_file: #read in the alignment file, and populate to sequences: assuming complete alignment
    basepairs = "ATCG?"
    splitby = " " + names[0] + " " + names[1] + "\n"
    reps  = alignment_file.read().split(splitby) # this is to calculate the number of gene trees
    split_reps = [r.splitlines() for r in reps]
    for s in split_reps: # for each gene
        taxa = ""
        atcg = ""
        for l in s: # for each taxon represented by each gene
            # if l l.split()[0] exists in sequences and l.split()[1] is ATCG
            line_contents = str(l.split()[0])
            if (line_contents in names):
                taxa = line_contents
            elif (re.match("^[ATCG?]*$", line_contents)):
                atcg = line_contents
                sequences[taxa].append(atcg)
                
            if len(l.split()) > 1:
                atcg = str(l.split()[1])
                if (taxa in names) and re.match("^[ATCG?]*$", atcg):
                    sequences[taxa].append(atcg)
            # this assumes that the same line contains sequence information. If this is not the case, the splits need to be calculated differently, or
            # you may need to change the [1]
            
            # this is a regular expression match, where it will only read in lines with characters ATCG?. If your alignment file has other characters 
            # (e.g. X, -, or is amino acids, then this will not be ok and the sequence dictionary will fail to populate.
            # In this case add characters to the regex between the [] )
            
        # FASTA FORMAT
                
# concatenates sequences (assuming multiple genes sequenced)
"""
As a sanity check, you can run len(sequences[keys]) to check that they are of the same length.
"""
for keys in sequences:
    sequences[keys] = ''.join(sequences[keys])
    print(len(sequences[keys]))

# Function for the ABBA-BABA statistic , Dp statistic

def calculate_D_Dp(sp1_genome, sp2_genome, sp3_genome, sp4_genome):
    
    ABBA_count, BABA_count, BBAA_count = 0, 0, 0

    for i in range(len(sp1_genome)):
        if sp2_genome[i] == sp3_genome[i] and sp2_genome[i] != sp4_genome[i] and sp4_genome[i] == sp1_genome[i]: #ABBA sites
            ABBA_count += 1
        elif sp2_genome[i] == sp4_genome[i] and sp3_genome[i] != sp4_genome[i] and sp3_genome[i] == sp1_genome[i]: #BABA sites
            BABA_count += 1
        elif sp1_genome[i] == sp2_genome[i] and sp2_genome[i] != sp3_genome[i] and sp3_genome[i] == sp4_genome[i]: #BBAA sites
            BBAA_count += 1

    D = (float(ABBA_count) - float(BABA_count))/(float(ABBA_count) + float(BABA_count)) #D statistic
    Dp = (float(ABBA_count) - float(BABA_count))/(float(BBAA_count) + float(ABBA_count) + float(BABA_count)) #Dp statistic
    
    return D, Dp

#Function for D3 

def calculate_D3(sp2_genome, sp3_genome, sp4_genome):
    
    D23, D24, D34 = 0, 0, 0

    for i in range(len(sp2_genome)): #Count number of pairwise differences
        if sp2_genome[i] != sp3_genome[i]:
            D23 += 1
        if sp2_genome[i] != sp4_genome[i]:
            D24 += 1
        if sp3_genome[i] != sp4_genome[i]:
            D34 += 1

    D23, D24, D34 = float(D23)/len(sp2_genome), float(D24)/len(sp2_genome), float(D34)/len(sp2_genome) #Divide by genome length (100 million bp)

    three_pairwise = [(D24-D23)/(D23+D24), (D23-D34)/(D23+D34), abs(D24-D34)/(D24+D34)] #Get the three pairwise divergence comparisons 

    three_pairwise_abs = [abs(value) for value in three_pairwise] #Get absolute values of comparisons

    # xrange was assumed equivalent to range.
    index_min = min(range(len(three_pairwise_abs)), key=three_pairwise_abs.__getitem__) #get index of D3 value

    D3 = three_pairwise[index_min]  #Get value of D3

    # I moved ""peter's version"" of D3 in here D3_v2 to see if it does anything. This avoids having to recalculate D23, D24, D34.
    D3_v2 = (D24 - D23)/D34  # Peter's version of D3 
    
    return D3, D3_v2



#Function to estimate variance of D and Dp using block jackknife

def D_block_bootstrap(sp1_genome, sp2_genome, sp3_genome, sp4_genome, n_replicates):
    
    D_estimates = []
    Dp_estimates = []
    
    for i in range(n_replicates): #for each bootstrap replicate

        sp1_bootstrapped, sp2_bootstrapped, sp3_bootstrapped, sp4_bootstrapped = [], [], [], [] #to store bootstrapped genomes

        for j in range(100): #for each resampling window
        
            sampling_index = random.randint(0, len(sp1_genome)-10000) #index to slice 

            #sample windows 
            sp1_bootstrapped.append(sp1_genome[sampling_index:sampling_index+10000])
            sp2_bootstrapped.append(sp2_genome[sampling_index:sampling_index+10000])
            sp3_bootstrapped.append(sp3_genome[sampling_index:sampling_index+10000])
            sp4_bootstrapped.append(sp4_genome[sampling_index:sampling_index+10000])
        
        #concatenate resampling windows
        sp1_bootstrapped = ''.join(sp1_bootstrapped)
        sp2_bootstrapped = ''.join(sp2_bootstrapped)
        sp3_bootstrapped = ''.join(sp3_bootstrapped)
        sp4_bootstrapped = ''.join(sp4_bootstrapped)

        #estimate statistics 
        D_Dp = calculate_D_Dp(sp1_bootstrapped, sp2_bootstrapped, sp3_bootstrapped, sp4_bootstrapped)
        D_estimates.append(D_Dp[0])
        Dp_estimates.append(D_Dp[1])

    #estimate means
    mean_D = sum(D_estimates)/float(len(D_estimates))
    mean_Dp = sum(Dp_estimates)/float(len(Dp_estimates))

    #estimate variance
    D_stdev = ((sum([(x - mean_D)**2 for x in D_estimates]))/len(D_estimates))**(0.5)
    Dp_stdev = ((sum([(x - mean_Dp)**2 for x in Dp_estimates]))/len(Dp_estimates))**(0.5)

    return D_stdev, Dp_stdev

# I separated this from D block bootstrap because it doesn't use sp_1, but they can be recoupled again.
def D3_block_bootstrap(sp2_genome, sp3_genome, sp4_genome, n_replicates):
    
    D3_estimates = []
    D3_v2_estimates = []
    
    for i in range(n_replicates): #for each bootstrap replicate

        sp2_bootstrapped, sp3_bootstrapped, sp4_bootstrapped = [], [], [] #to store bootstrapped genomes

        for j in range(100): #for each resampling window
        
            # this may need to be a function of length of the genome, instead.
            """
            IMPORTANT:
            this assumes that the length of the genome is at the very least 10000 (and preferably much greater!)
            If it isn't, you should change the size of the sampling window
            """
            sampling_index = random.randint(0, len(sp2_genome)-10000) #index to slice 

            #sample windows 
            sp2_bootstrapped.append(sp2_genome[sampling_index:sampling_index+10000])
            sp3_bootstrapped.append(sp3_genome[sampling_index:sampling_index+10000])
            sp4_bootstrapped.append(sp4_genome[sampling_index:sampling_index+10000])
        
        #concatenate resampling windows
        sp2_bootstrapped = ''.join(sp2_bootstrapped)
        sp3_bootstrapped = ''.join(sp3_bootstrapped)
        sp4_bootstrapped = ''.join(sp4_bootstrapped)


        #estimate statistics 
        D3_D3v2_est = calculate_D3(sp2_bootstrapped, sp3_bootstrapped, sp4_bootstrapped)
        D3_estimates.append(D3_D3v2_est[0])
        D3_v2_estimates.append(D3_D3v2_est[1])

    #estimate means
    mean_D3 = sum(D3_estimates)/float(len(D3_estimates))    
    mean_D3_v2 = sum(D3_v2_estimates)/float(len(D3_v2_estimates))

    #estimate variance
    D3_stdev = ((sum([(x - mean_D3)**2 for x in D3_estimates]))/len(D3_estimates))**(0.5)
    D3_v2_stdev = ((sum([(x - mean_D3_v2)**2 for x in D3_v2_estimates]))/len(D3_v2_estimates))**(0.5)

    return D3_stdev, D3_v2_stdev


# outgroup (sp1_genome) is the last value in the map that we input.

# perform with D3
""" This is commented out assuming you don't want to do all permutations including the outgroup
all_permutations = list(itertools.permutations(names, 3))

column_names = ["t1", "t2", "t3", "D3", "D3_stdev", "D3v2", "D3v2_stdev"]
data = []
for triple in all_permutations:
    sp2 = triple[0]
    sp3 = triple[1]
    sp4 = triple[2]

    sp2_genome = sequences[sp2]
    sp3_genome = sequences[sp3]
    sp4_genome = sequences[sp4]

    D3_D3V2 = calculate_D3(sp2_genome, sp3_genome, sp4_genome)
    D3, D3_v2 = D3_D3V2[0], D3_D3V2[1]
    
    D3_D3v2_stdevs = D3_block_bootstrap(sp2_genome, sp3_genome, sp4_genome, 1000)
    D3_stdev, D3v2_stdev = D3_D3v2_stdevs[0], D3_D3v2_stdevs[1]
    
    # write a line to a file in the form of "t1  t2  t3  D3 d3stdev  D3v2 d3v2stddev"
    data.append([sp2, sp3, sp4, D3, D3_stdev, D3_v2, D3v2_stdev])

df_allpermutations = pd.DataFrame(data, columns=column_names)
df_allpermutations.to_csv(all_permutations_csv_name)
"""

# perform with D, D3
outgroup = names.pop() # this is why the last taxon in the list should be the outgroup, because we pop (or remove and read) it here. 

# collecting a list of all possible triples because the value of
# D changes based on how they are input 
only_ingroup_permutations = list(itertools.permutations(names, 3))
print(len(only_ingroup_permutations))

# this is for writing some dataframe later. If you don't want to calculate Dp, D, D3v2, or are only interested in specific taxa you can alter the code.
column_names = ["t1", "t2", "t3", "D", "D_stdev", "D3", "D3_stdev", "Dp", "Dp_stdev", "D3v2", "D3v2_stdev"]
data = []
i = 0
for triple in only_ingroup_permutations:
    sp1 = outgroup # species 1 is the outgroup. This is to keep it consistent with how Hibbins and Hahn originally wrote D vs D3 functions.
    sp2 = triple[0]
    sp3 = triple[1]
    sp4 = triple[2]

    sp1_genome = sequences[sp1] # finds the entry in the mapfile and returns as a sequence in string form
    sp2_genome = sequences[sp2]
    sp3_genome = sequences[sp3]
    sp4_genome = sequences[sp4]

    D_Dp = calculate_D_Dp(sp1_genome, sp2_genome, sp3_genome, sp4_genome)
    D, Dp = D_Dp[0], D_Dp[1]
    
    # here I'm using 100 instead of 1000 as in their original (because of time, I guess)
    D_Dp_stdev = D_block_bootstrap(sp1_genome, sp2_genome, sp3_genome, sp4_genome, 100)
    D_stdev, Dp_stdev = D_Dp_stdev[0], D_Dp_stdev[1]

    D3_D3V2 = calculate_D3(sp2_genome, sp3_genome, sp4_genome)
    D3, D3_v2 = D3_D3V2[0], D3_D3V2[1]
    
    D3_D3v2_stdevs = D3_block_bootstrap(sp2_genome, sp3_genome, sp4_genome, 100)
    D3_stdev, D3v2_stdev = D3_D3v2_stdevs[0], D3_D3v2_stdevs[1]
    
    data.append([sp2, sp3, sp4, D, D_stdev, D3, D3_stdev, Dp, Dp_stdev, D3_v2, D3v2_stdev])
    i = i + 1
    print(i) # this was to keep track of progress because the bootstrapping (or at least I thought it was the bootstrapping... ) took a really long time
    # write a line to a file in the form of "t1 (sp2)  t2 (sp3)  t3 (sp4)  D  D_stdev  D3  D3_stdev  D3v2  D3v2_stdev"

"""
Writes and saves dataframe
"""
df_only_ingroups = pd.DataFrame(data, columns=column_names)
df_only_ingroups.to_csv(only_ingroup_permutations_csv_name)

