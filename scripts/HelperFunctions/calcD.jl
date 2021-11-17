#=
inspired from evobiR::CalcD but requires package "seqinr" only
used in [Blair & Ané 2020](https://doi.org/10.1093/sysbio/syz056)
=#

using BioSymbols
using PhyloNetworks
using Random
using Statistics
using Distributions
using DataFrames
using CSV

"""
    calcPatternCounts(filename; taxa=["P1","P2","P3","O"], ambig=:D)

Take a single 4-taxon alignment and calculate 3 numbers of sites:
total, ABBA sites, and BABA sites. By default, sites with any ambiguity
are dropped (`ambig=:D`) before calculating these 3 numbers.
Alternatively, they could be resolved (`ambig=:R`). Otherwise,
ambiguous sites are just left alone (e.g. ignored: `ambig=:I`).
In that case for instance, `N--N` would count as an ABBA pattern.

warning: bug in `PhyloNetworks.readFastaToArray` with some ambiguous sites,
due to a bug in BioSequences, see
[FASTA.Reader](https://github.com/BioJulia/BioSequences.jl/issues/64).
A quick & dirty trick is used here.
Fix this bug in `PhyloNetworks.readFastaToArray`: use
sequence(DNASequence, record) instead of sequence(record)
"""
function calcPatternCounts(file::String; taxa=["P1","P2","P3","O"], ambig=:D)
  # read alignment and make it a matrix
  species, alg = PhyloNetworks.readFastaToArray(file)
  ## bug: due to [FASTA.Reader](https://github.com/BioJulia/BioSequences.jl/issues/64)
  ## quick fix, as suggested in the github issue:
  for i in 1:length(alg)
    if !(eltype(alg[i]) <: DNA)
        alg[i] = DNASequence(convert(String, alg[i]))
    end
  end
  # alg = PhyloNetworks.readfastatodna(file) with next registered version
  # perhaps do better using BioSequences or BioAlignments directly:
  # r = FASTA.Reader(open("trial0_concat.fasta"))

  # check that there are 4 taxa, and all have same alignment length
  # sometimes, 1 or more taxa might be missing a gene of interest
  goodalign = length(alg) == 4
  ind = indexin(taxa, species) # species[ind] in correct order to look at ABBA and BABA
  nsites = length(alg[1])

  if goodalign
    goodalign = [length(alg[i]) for i in 2:4] == [nsites, nsites, nsites]
  end
  goodalign || return (missing,missing,missing)

  ## deal with ambiguity in sequence data
  # R: A or G
  # Y: C or T
  # S: G or C
  # W: A or T
  # K: G or T
  # M: A or C

  if ambig in [:D, :R]
    # D: drop all ambiguous sites
    # R: resolve, but first drop any site having a 3- or 4-ambiguity
    target = (BioSymbols.ACGT..., DNA_R, DNA_Y, DNA_S, DNA_W, DNA_K, DNA_M)
    for j in nsites:-1:1
      keepj = (ambig==:D ?
               all(s -> BioSymbols.iscertain(s[j]), alg) :
               all(s -> s[j] in target, alg) )
      if keepj continue; end
      for s in alg
        deleteat!(s,j)
      end
    end
  end
  nsites = length(alg[1]) # possibly less than before
  ## resolve remaining ambigous sites randomly
  if ambig == :R
    function resolver(x)
      if iscertain(x) return x; end
      if x==DNA_R return rand([DNA_A, DNA_G]); end
      if x==DNA_Y return rand([DNA_C, DNA_T]); end
      if x==DNA_S return rand([DNA_G, DNA_C]); end
      if x==DNA_W return rand([DNA_A, DNA_T]); end
      if x==DNA_K return rand([DNA_G, DNA_T]); end
      if x==DNA_M return rand([DNA_A, DNA_C]);
      else error("weird base: $x"); end
    end
    for a in alg
      for j in 1:nsites
        isambiguous(a[j]) || continue
        a[j] = resolver(a[j])
      end
    end
  end
  # now calculate the number of sites with pattern ABBA or BABA
  abba = 0
  baba = 0
  nsites>0 || return (0,0,0)
  pattern = Vector{DNA}(undef, 4) # to avoid garbage collection
  for j in 1:nsites
    # pattern = [alg[ind[i]][j] for i in 1:4]
    for i in 1:4 pattern[i] = alg[ind[i]][j]; end
    length(unique(pattern)) == 2 || continue   # focus on biallelic sites
    pattern[1] != pattern[2] || continue   # focus on xy.. patterns
    pattern[3] != pattern[4] || continue   # focus on ..xy patterns 
    if pattern[3] == pattern[1]
      baba += 1
    else # pattern[3] == pattern[2]
      abba += 1
    end
  end
  return nsites,abba,baba
end

"""
    calcD(x, y)

Take a vector `x` of ABBA counts and a vector `y` of BABA counts, assuming that
in each list: 1 count corresponds to 1 gene. Then calculate the D statistics for
the concatenated data, that is: [sum(ABBA) - sum(BABA)] / [sum(ABBA) + sum(BABA)]
"""
function calcD(x, y)
  sx = sum(x); sy = sum(y)
  return (sx - sy)/(sx + sy)
end

"""
     calcDztest_concatenated(x,y)
     calcDsd_concatenated(x, y, nbootstrap=500)

Take the outcome of `calcPatternCounts` from a concatenated alignment
(except for the total number of non-ignored sites):
number of ABBA sites `x` and number of BABA sites `y`, and test whether
the data is consistent with mean D=0.

Output: D statistic, its standard deviation, and test p-value (2-tailed).

Assumptions:

1. independent sites in the single (concatenated) alignment
  from which `x,y` come from.
2. the number of "informative" sites for the ABBA-BABA test, that is, the
  number of ABBA + BABA sites is considered fixed. In other words, the test
  conditions on the number of informative sites.

Note that D = (x-y)/(x+y) becomes phat - (1-phat) = 2*(phat -0.5)
where phat = estimated proportion of ABBA sites among informative sites,
that is, among ABBA & BABA sites.
Testing "mean D=0" is equivalent to testing p=0.5, which amounts to doing
is simple binomial test, or chi-square goodness-of-fit test if all sites
are assumed independent.

The first version does a z test (equivalent to chi-square goodness-of-fit test).

The second version calculates the standard deviation of the D statistics
using bootstrap, re-sampling the ABBA-BABA sites (*not* resampling all sites:
see assumption 2 above). Then calculates z = D/sd and
pvalue = two-tailed probability beyond z under N(0,1).
This second version could be modified to allow for linkage between sites
(in which case the z-test becomes invalid).
"""
function calcDztest_concatenated(x,y)
  n = x+y
  D = (x-y)/n
  phat = x/n
  z = (phat-0.5)*sqrt(n)*2 #  = (phat - p0) / sqrt(p0 * (1-p0) * 1/n) when p0=0.5
  pvalue = ccdf(Normal(), abs(z))*2
  return D, z, pvalue
end

function calcDsd_concatenated(x, y, nbootstrap=500)
  n = x+y
  D = (x-y)/n
  p_abba = x/n
  d = Distributions.Binomial(n, p_abba)
  bx = rand(d, nbootstrap)
  bD = (2*bx .- n) ./ n # y=n-x so x-y = x-(n-x) = 2x-n
  z = D / Statistics.std(bD)
  pvalue = ccdf(Normal(), abs(z))*2
  return D, z, pvalue
end

"""
    calcDsd_byloci(x, y, nbootstrap=500)

Take a list of ABBA counts and a list of BABA counts, like `calcD`.
Calculate the standard deviation of the D statistics using bootstrap,
re-sampling loci. This is assuming independent loci
(but not independent sites within loci).

Default is 500 bootstrap replicates.
"""
function calcDsd_byloci(x, y, nbootstrap=500)
  nloci = length(x)
  bD = Vector{Float64}(undef, nbootstrap)
  for b in 1:nbootstrap
    bsx=0; bsy=0
    bloci = rand(1:nloci, nloci) # sample loci with replacement
    for locus in bloci
      bsx += x[locus]
      bsy += y[locus]
    end
    bD[b] = (bsx - bsy)/(bsx + bsy)
  end
  return Statistics.std(bD)
end
