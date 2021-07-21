#!/bin/bash
# seqgen executable

# unpack tarred files
tar -xzf Seq-Gen-1.3.4.tar.gz

# creates makefile
cd Seq-Gen-1.3.4 
cd source
make

# back to safety
cd

./Seq-Gen-1.3.4/source/seq-gen -mHKY -t2.0 -f0.300414,0.191363,0.196748,0.311475 -l500 -s0.018 -n1 < $1 > $1_seqgen.out 2> $1_seqgen.log

# this $1_seqgen.out file can then be used by HyDe