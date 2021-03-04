input_file=./GitHub/phylo-microbes/data/n25h5/n25h25
output_dir=./GitHub/phylo-microbes/data/sequences/n25h5

choices=(-gt50-, -gt100-, -gt500-, -gt1000-)
# there are 6 copies of each gt1000 tree for some reason... I will not be doing those.
end = .tre
for j in ${choices[@]}
do 
for i in {1..30}
    do
       ./Seq-Gen/seq-gen -mHKY -t2.0 -f0.300414,0.191363,0.196748,0.311475 -l500 -n1 < ${input_file}${j}${i}.tre > ${input_file}${j}${i}.phy
    done
done