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



