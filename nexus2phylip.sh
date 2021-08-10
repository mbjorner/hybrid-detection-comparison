#!/usr/bin/env python

'''
general instructions on how to convert from nexus to phylip format
acquired from 
http://sequenceconversion.bugaco.com/converter/biology/sequences/nexus_to_phylip.php
'''

from Bio import SeqIO

records = SeqIO.parse(input, "nexus")
count = SeqIO.write(records, input + ".phylip", "phylip")
print("Converted %i records" % count)
