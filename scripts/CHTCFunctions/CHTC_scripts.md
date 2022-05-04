# CHTC scripts

1. login to campus VPN 

2. ssh into CHTC

``` bash

ssh submit-1.chtc.wisc.edu

```

3. transfer (secure copy) all scripts from home computer to chtc
- command-t to open new tab in terminal
```bash

(base) % cd github/phylo-microbes/scripts/CHTCFunctions
(base) % scp chtc* bjorner@submit-1.chtc.wisc.edu:/home/bjorner
```
- it will ask again for the password to login to CHTC 

## TICR

TICR depends on a quartet maxcut tree, and an input file. This runs in julia.

1. Download julia onto CHTC following https://chtc.cs.wisc.edu/julia-jobs
- using julia-#.#.#-linux-x86_64.tar.gz.

2. Download packages QuartetNetworkGoodnessFit, DataFrames, CSV, and PhyloNetworks

In order to make the Concordance Factor tables available, we need several things:

- TICR, as downloaded from github. This can be downloaded as a docker

```bash 
git clone https://github.com/nstenz/TICR.git
```

 1. tar the file, and transport to chtc.

 ```bash
tar -czvf TICR.tar.gz TICR 
scp TICR.tar.gz bjorner@submit-1.chtc.wisc.edu:/home/bjorner

 ```

2. CHTC runs others with linux x86_64; quartet maxcut executable used must correspond to that. Can be downloaded from http://research.haifa.ac.il/~ssagi/software/QMCN.tar.gz

```bash
scp find-cut-Linux-64 bjorner@submit-1.chtc.wisc.edu:/home/bjorner

```

## MSCQuartets

MSCQuartets depends only on an input file. This runs in R.

1. Download R onto CHTC following https://chtc.cs.wisc.edu/r-jobs

2. Download packages ape and MSCQuartets
```bash

```

## HyDe

HyDe depends on an input file that had sequences generated. This runs in python.

1. Download python onto CHTC following https://chtc.cs.wisc.edu/python-jobs

2. We are going to create a miniconda environment on CHTC called "HyDe", following https://chtc.cs.wisc.edu/conda-installation 

```bash

[bjorner@submit]$ wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
[bjorner@submit]$ sh Miniconda3-latest-Linux-x86_64.sh

```
press ENTER when prompted, continue pressing enter until prompted to accept/reject license terms
enter 'yes'
It will then prompt you to select installation location; press ENTER to confirm location

```bash
Miniconda3 will now be installed into this location:
/home/bjorner/miniconda3

  - Press ENTER to confirm the location
  - Press CTRL-C to abort the installation
  - Or specify a different location below
```
press ENTER
it the asks "Do you wish the installer to initialize Miniconda3"
enter 'yes'
close and reopen the chtc environment (type 'exit', re-ssh in)

```bash

conda create -n HyDe
conda activate HyDe
# install dependencies using either conda install or pip install
conda install cython numpy matplotlib seaborn 
pip install multiprocess

pip install phyde

```

```bash
# leave the conda environment
conda deactivate
conda install -c conda-forge conda-pack

# Enter 'y' when prompted
# use conda pack to create a zipped HyDe environment
conda pack -n HyDe
chmod 644 HyDe.tar.gz
ls -sh HyDe.tar.gz
# 566M --size
```

Since the distribution that contains phyde is quite large, it needs to be loaded on web proxy, SQUID.

https://chtc.cs.wisc.edu/file-avail-squid

```bash
cp HyDe.tar.gz /squid/bjorner/
```

in a submit file, HyDe should be retrieved with http://proxy.chtc.wisc.edu/SQUID/bjorner/HyDe.tar.gz

From HyDe downloaded, naviagate to scripts folder and copy over run_hyde.py folder to chtc.

```bash
cd github/hyde/scripts/
scp run_hyde.py bjorner@submit-1.chtc.wisc.edu:/home/bjorner

```

give executable file permissions: 


```bash
chmod +x run_HyDe.sh

```


### seqgen

1. seq-gen is available in a tarball format from https://github.com/rambaut/Seq-Gen/releases/tag/1.3.4

2. download onto computer

3. copy to chtc

```bash

scp Seq-Gen-1.3.4* bjorner@submit-1.chtc.wisc.edu:/home/bjorner

```

the makefile is stored in source, unpack tar file, change directory to source, and make - (should this be done in the body of the executable? submitted as a makefile?)

```bash

cd source
make
```

After simulations are run, they should produce output files of TICR and MSC summary tables
These can be moved from the home directory into an output folder, a tar ball can be created,
and this can be transfered back to the home computer for data analysis. 

```bash

mv *prefix*.csv output
tar -czvf output.tar.gz output

# then on home computer, transfer the file back:
scp bjorner@submit-1.chtc.wisc.edu:/home/bjorner/output.tar.gz ./

```


Simulating scripts;

```bash 

git clone https://github.com/hybridLambda/hybrid-Lambda.git
cd hybrid-lambda 
cd src 
make

```

quota -vs

rm *_TICR_MSC_*
mv *_HyDe.csv output_HyDe

cd output_HyDe

mv *_10000_* seq10000
mv *_100000_* seq100000
mv *_50000_* seq50000

mv n15_100_* n15_n100
mv n15_1000_* n15_n1000
mv n15_3000_* n15_n3000
mv n15_300_* n15_n300
mv n15_30_* n15_n30

mv n10_100_* n10_n100
mv n10_1000_* n10_n1000
mv n10_3000_* n10_n3000
mv n10_300_* n10_n300
mv n10_30_* n10_n30



seeds for trees generated: 

n10 orange
30    382591
100   837666
300   925411
1000  765303
3000  101123

julia simulating-gene-trees.jl n10orange 30 382591
julia simulating-gene-trees.jl n10orange 100 837666
julia simulating-gene-trees.jl n10orange 300 925411
julia simulating-gene-trees.jl n10orange 1000 765303
#julia simulating-gene-trees.jl n10orange 3000 101123

n10 red
30    498266
100   896259
300   120985
1000  792469
3000  110863

julia simulating-gene-trees.jl n10red 30 498266
julia simulating-gene-trees.jl n10red 100 896259
julia simulating-gene-trees.jl n10red 300 120985
julia simulating-gene-trees.jl n10red 1000 792469
#julia simulating-gene-trees.jl n10red 3000 110863

n15 blue

julia simulating-gene-trees.jl n15blue 30 254790
julia simulating-gene-trees.jl n15blue 100 168904
julia simulating-gene-trees.jl n15blue 300 578520
julia simulating-gene-trees.jl n15blue 1000 469980
julia simulating-gene-trees.jl n15blue 3000 808631

30    254790
100   168904
300   578520
1000  469980
3000  808631



n15 red

julia simulating-gene-trees.jl n15red 30 987034
julia simulating-gene-trees.jl n15red 100 291823
julia simulating-gene-trees.jl n15red 300 746134
julia simulating-gene-trees.jl n15red 1000 219083
julia simulating-gene-trees.jl n15red 3000 487245

30    987034
100   291823
300   746134
1000  219083
3000  487245

n15 orange
30    614827
100   129368
300   123954
1000  789102
3000  347796

julia simulating-gene-trees.jl n10orange 30 382591
julia simulating-gene-trees.jl n10orange 100 837666
julia simulating-gene-trees.jl n10orange 300 925411
julia simulating-gene-trees.jl n10orange 1000 765303
julia simulating-gene-trees.jl n10orange 3000 101123

julia simulating-gene-trees.jl n10red 30 498266
julia simulating-gene-trees.jl n10red 100 896259
julia simulating-gene-trees.jl n10red 300 120985
julia simulating-gene-trees.jl n10red 1000 792469
julia simulating-gene-trees.jl n10red 3000 110863

julia simulating-gene-trees.jl n15blue 30 254790
julia simulating-gene-trees.jl n15blue 100 168904
julia simulating-gene-trees.jl n15blue 300 578520
julia simulating-gene-trees.jl n15blue 1000 469980
julia simulating-gene-trees.jl n15blue 3000 808631

julia simulating-gene-trees.jl n15red 30 987034
julia simulating-gene-trees.jl n15red 100 291823
julia simulating-gene-trees.jl n15red 300 746134
julia simulating-gene-trees.jl n15red 1000 219083
julia simulating-gene-trees.jl n15red 3000 487245

julia simulating-gene-trees.jl n15orange 30 614827
julia simulating-gene-trees.jl n15orange 100 129368
julia simulating-gene-trees.jl n15orange 300 123954
julia simulating-gene-trees.jl n15orange 1000 789102
julia simulating-gene-trees.jl n15orange 3000 347796


julia simulating-gene-trees.jl n25h5 1000 658488
julia simulating-gene-trees.jl n50h10 1000 94606
julia simulating-gene-trees.jl n100h20 1000 649239

julia simulating-gene-trees.jl n25h5 5000 772771
julia simulating-gene-trees.jl n50h10 5000 283575
julia simulating-gene-trees.jl n100h20 5000 990579

removing the _1 from the output files requires running them with

sed -i '' 's/_1//g' n*tre

## Space requirements

The space/memory requirements for running chtc_phylo.sub/chtc_phylo.sh on CHTC depends on both the size of the networks and the number
of gene trees used.

The memory and disk space can be altered in the following lines:

```bash 
quest_memory = 64GB
request_disk = 64GB
```

For networks of size 10 taxa, 16GB is sufficient for both disk space and memory, up to 1000 gene trees
For networks of size 10 taxa with more than 1000 gene trees (3000), 32GB is necessary for both memory and disk space.

For networks of size 15 32GB is sufficient for both disk and memory, up to 1000 gene trees.
For networks of size 15 taxa with more than 1000 gene trees (3000 tested), 64GB is necessary for both memory and disk space.

This space is primarily taken up by the generation of sequences for these trees, as lengths of 500kbp for 3000 gene trees, e.g. 
requires a larger amount of space than prior tests run for smaller sequence lengths and gene tree numbers.

The generation of networks of 25, 50, and 100 taxa, the larger networks used, will require more space, dependent on the number of
gene trees tested. So far (27JAN2022), we do not yet have 5000 gene-tree datasets for these, as simulating-gene-trees.jl cannot generate these.

## HyDe: many more gene tree simulations needed, 1 base pair sequence generated each
As of April 2022, a determination was made to increase the number of gene trees simulated per network and reduce the length of sequences generated per tree. This was to ensure that each site was independent from each other, which was important for the success of HyDe (and also the D-statistic). In turn, the following gene trees were simulated to match the original HyDe paper parameters:

```

# n10 orange

julia simulating-gene-trees.jl n10orange 10000 12382591
julia simulating-gene-trees.jl n10orange 50000 2843666
julia simulating-gene-trees.jl n10orange 100000 9525411
julia simulating-gene-trees.jl n10orange 250000 1866503
julia simulating-gene-trees.jl n10orange 500000 9313503

# n10 red

julia simulating-gene-trees.jl n10red 10000 234266
julia simulating-gene-trees.jl n10red 50000 6096259
julia simulating-gene-trees.jl n10red 100000 42779985
julia simulating-gene-trees.jl n10red 250000 3871469
julia simulating-gene-trees.jl n10red 500000 2351863

# n15 blue

julia simulating-gene-trees.jl n15blue 10000 2235790
julia simulating-gene-trees.jl n15blue 50000 5716904
julia simulating-gene-trees.jl n15blue 100000 2557520
julia simulating-gene-trees.jl n15blue 250000 14626350
julia simulating-gene-trees.jl n15blue 500000 3426831

# n15 red

julia simulating-gene-trees.jl n15red 10000 2097034
julia simulating-gene-trees.jl n15red 50000 3421823
julia simulating-gene-trees.jl n15red 100000 2273134
julia simulating-gene-trees.jl n15red 250000 5212183
julia simulating-gene-trees.jl n15red 500000 96348745

# n15 orange

julia simulating-gene-trees.jl n15orange 10000 61221591
julia simulating-gene-trees.jl n15orange 50000 2822616
julia simulating-gene-trees.jl n15orange 100000 2914211
julia simulating-gene-trees.jl n15orange 250000 579303
julia simulating-gene-trees.jl n15orange 500000 74192023
```

all files were compressed for transport to chtc submit-1 server, then unzipped there in input folder

```

cd ~/GitHub/phylo-microbes/data/knownGT/singleNet
tar -czf n15blue.tar.gz n15blue 
tar -czf n15red.tar.gz n15red
tar -czf n15orange.tar.gz n15orange
tar -czf n10orange.tar.gz n10orange
tar -czf n10red.tar.gz n10red

# ensure logged in to campus vpn before transmitting:

scp n1*tar.gz bjorner@submit-1.chtc.wisc.edu:/home/bjorner/input

# can then unzip files on chtc

chtc > tar -xf n15blue.tar.gz n15blue
chtc > tar -xf n15red.tar.gz n15red
chtc > tar -xf n15orange.tar.gz n15orange
chtc > tar -xf n10red.tar.gz n10red
chtc > tar -xf n10orange.tar.gz n10orange 

```

Each collection of files "net15" (n15red = 1 collection) is approximately 9GB unzipped.
Each collection of files "net10" (n10red = 1) is approximately 6GB unzipped
Estimated 6/10 GB per additional taxon. 25 taxon trees would need 15GB, 50 @ 30 GB 
(too much for chtc to support storage-wise if full 30 samples of 500k gene trees).


# simulating larger trees for n15 and n10
Also required was simulating larger sets of gene trees for the original n15 and n10 files. In order to keep all gene tree simulations to the same standard, the original n10 and n15 files (for 30, 100, 300, 1000, and 3000 gene trees) that were run with ms were replaced with gene trees run with hybridlambda.


```

# n10
julia simulating-gene-trees.jl n10 30 56435034
julia simulating-gene-trees.jl n10 100 2121050013
julia simulating-gene-trees.jl n10 300 2101274134
julia simulating-gene-trees.jl n10 1000 3045383
julia simulating-gene-trees.jl n10 3000 12070630
julia simulating-gene-trees.jl n10 10000 59123790
julia simulating-gene-trees.jl n10 50000 41569201
julia simulating-gene-trees.jl n10 100000 36027523
julia simulating-gene-trees.jl n10 250000 11271910
julia simulating-gene-trees.jl n10 500000 32354231

# n15
julia simulating-gene-trees.jl n15 30 3091624
julia simulating-gene-trees.jl n15 100 13489001
julia simulating-gene-trees.jl n15 300 43271420
julia simulating-gene-trees.jl n15 1000 7340932
julia simulating-gene-trees.jl n15 3000 45708234
julia simulating-gene-trees.jl n15 10000 791322034
julia simulating-gene-trees.jl n15 50000 10950013
julia simulating-gene-trees.jl n15 100000 207064134
julia simulating-gene-trees.jl n15 250000 90553183
julia simulating-gene-trees.jl n15 500000 29600630

```

These were also compressed and transferred to chtc as above.

```
cd ~/GitHub/phylo-microbes/data/knownGT/multiNet
tar -czf n10.tar.gz n10 
tar -czf n15.tar.gz n15

# ensure logged in to campus vpn before transmitting:

scp n1*tar.gz bjorner@submit-1.chtc.wisc.edu:/home/bjorner/input

# can then unzip files on chtc

chtc > tar -xf n15.tar.gz n15
chtc > tar -xf n10.tar.gz n10
```