## Replicating HyDe 4-taxon trees

In the HyDe paper, 4-taxon trees are used to demonstrate on toy examples the ability of HyDe to detect a hybrid taxon. 
These trees are of the format

(O:T3, ((P1:T1, #H1:0::(MIXING_PARAMETER)):T1, (P2:T1, (HYB:T1)#H1:0::(1-MIXING_PARAMETER)):T1):T2);

e.g. 

(O:1.0, ((P1:0.25,#H1:0::0.5):0.25, (P2:0.25, (HYB:0.25)#H1:0::0.5):0.25):0.5);
(O:1.0, ((P1:0.25,#H1:0::0.4):0.25, (P2:0.25, (HYB:0.25)#H1:0::0.6):0.25):0.5);
(O:1.0, ((P1:0.25,#H1:0::0.3):0.25, (P2:0.25, (HYB:0.25)#H1:0::0.7):0.25):0.5);
(O:1.0, ((P1:0.25,#H1:0::0.2):0.25, (P2:0.25, (HYB:0.25)#H1:0::0.8):0.25):0.5);
(O:1.0, ((P1:0.25,#H1:0::0.1):0.25, (P2:0.25, (HYB:0.25)#H1:0::0.9):0.25):0.5);
(O:1.0, ((P1:0.25,#H1:0::0):0.25, (P2:0.25, (HYB:0.25)#H1:0::1.0):0.25):0.5);

(O:2.0, ((P1:0.50,#H1:0::0.5):0.50, (P2:0.5, (HYB:0.5)#H1:0::0.5):0.5):1.0);
(O:2.0, ((P1:0.50,#H1:0::0.4):0.50, (P2:0.5, (HYB:0.5)#H1:0::0.6):0.5):1.0);
(O:2.0, ((P1:0.50,#H1:0::0.3):0.50, (P2:0.5, (HYB:0.5)#H1:0::0.7):0.5):1.0);
(O:2.0, ((P1:0.50,#H1:0::0.2):0.50, (P2:0.5, (HYB:0.5)#H1:0::0.8):0.5):1.0);
(O:2.0, ((P1:0.50,#H1:0::0.1):0.50, (P2:0.5, (HYB:0.5)#H1:0::0.9):0.5):1.0);
(O:2.0, ((P1:0.50,#H1:0::0):0.50, (P2:0.5, (HYB:0.5)#H1:0::1.0):0.5):1.0);

short:
*τ1 = 0.25, τ2 = 0.5, τ3 = 1.0

long:
*τ1 = 0.5, τ2 = 1.0, τ3 = 2.0

MIXING_PARAMETER: 0, 0.1, 0.2, 0.3, 0.4, 0.5

These trees are then saved to folders "long_branches" or "short_branches", and subsequently split into folders based on their mixing parameters. Gene trees are generated using simulating-gene-trees.jl, with outgroup "O"


julia simulating-gene-trees.jl long_mix0 30 2414561
julia simulating-gene-trees.jl long_mix0 100 5587631
julia simulating-gene-trees.jl long_mix0 300 7635942
julia simulating-gene-trees.jl long_mix0 1000 18731251

julia simulating-gene-trees.jl long_mix01 30 4712053
julia simulating-gene-trees.jl long_mix01 100 2928191
julia simulating-gene-trees.jl long_mix01 300 826186
julia simulating-gene-trees.jl long_mix01 1000 125867

julia simulating-gene-trees.jl long_mix02 30 3215791
julia simulating-gene-trees.jl long_mix02 100 9841484
julia simulating-gene-trees.jl long_mix02 300 8829164
julia simulating-gene-trees.jl long_mix02 1000 4706095

julia simulating-gene-trees.jl long_mix03 30 7527069
julia simulating-gene-trees.jl long_mix03 100 5722091
julia simulating-gene-trees.jl long_mix03 300 7567116
julia simulating-gene-trees.jl long_mix03 1000 7229109

julia simulating-gene-trees.jl long_mix04 30 8169091
julia simulating-gene-trees.jl long_mix04 100 5201735
julia simulating-gene-trees.jl long_mix04 300 0671274
julia simulating-gene-trees.jl long_mix04 1000 8582228

julia simulating-gene-trees.jl long_mix05 30 7093396
julia simulating-gene-trees.jl long_mix05 100 5710835
julia simulating-gene-trees.jl long_mix05 300 7962091
julia simulating-gene-trees.jl long_mix05 1000 4211033

julia simulating-gene-trees.jl short_mix0 30 471412
julia simulating-gene-trees.jl short_mix0 100 613699
julia simulating-gene-trees.jl short_mix0 300 865398
julia simulating-gene-trees.jl short_mix0 1000 30197016

julia simulating-gene-trees.jl short_mix01 30 1671437
julia simulating-gene-trees.jl short_mix01 100 63515565
julia simulating-gene-trees.jl short_mix01 300 998985998
julia simulating-gene-trees.jl short_mix01 1000 23872833

julia simulating-gene-trees.jl short_mix02 30 16347918
julia simulating-gene-trees.jl short_mix02 100 535618548
julia simulating-gene-trees.jl short_mix02 300 96321329
julia simulating-gene-trees.jl short_mix02 1000 89857020

julia simulating-gene-trees.jl short_mix03 30 4675259
julia simulating-gene-trees.jl short_mix03 100 1709154
julia simulating-gene-trees.jl short_mix03 300 8149859
julia simulating-gene-trees.jl short_mix03 1000 4616399

julia simulating-gene-trees.jl short_mix04 30 498895
julia simulating-gene-trees.jl short_mix04 100 771282
julia simulating-gene-trees.jl short_mix04 300 895932
julia simulating-gene-trees.jl short_mix04 1000 336772

julia simulating-gene-trees.jl short_mix05 30 992084
julia simulating-gene-trees.jl short_mix05 100 433732
julia simulating-gene-trees.jl short_mix05 300 654898
julia simulating-gene-trees.jl short_mix05 1000 239132



removing the _1 from the output files requires using the following command in the same directory as the files:

sed -i '' 's/_1//g' short*

sed -i '' 's/_1//g' long*

as of april2022, no longer require removal of _1; included in simulating-gene-trees.jl script


## Running seq-gen

From the HyDe paper, the following parameters were used on the four-taxon trees:

For each setting, the authors simulated N = 50000, 100000, 250000 and 500000 
coalescent independent sites under the GTR+I+Γ model using Seq-Gen

options: -mGTR -r 1.0 0.2 10.0 0.75 3.2 1.6 -f 0.15 0.35 0.15 0.35 -i 0.2 -a 5.0 -g 3

## Running HyDe 

The previous 4-taxon trees all have the same underlying map, with O as the outgroup.
This map is saved in fourTreeMap.txt

```
O   O
P1  P1
P2  P2
HYB HYB
```


19APR2022
Attempting new approach with gene trees vs. sequences. Now following HyDe approach of simulating tens of thousands of gene trees and only one base pair per sequence;

50000, 100000, 250000, 500000 

julia simulating-gene-trees.jl long_mix0 50000 24414561
julia simulating-gene-trees.jl long_mix0 100000 53587631
julia simulating-gene-trees.jl long_mix0 250000 762335942
julia simulating-gene-trees.jl long_mix0 500000 181731251

julia simulating-gene-trees.jl long_mix01 50000 47112053
julia simulating-gene-trees.jl long_mix01 100000 21928191
julia simulating-gene-trees.jl long_mix01 250000 8236186
julia simulating-gene-trees.jl long_mix01 500000 1225867

julia simulating-gene-trees.jl long_mix02 50000 342215791
julia simulating-gene-trees.jl long_mix02 100000 198141484
julia simulating-gene-trees.jl long_mix02 250000 84829164
julia simulating-gene-trees.jl long_mix02 500000 47026095

julia simulating-gene-trees.jl long_mix03 50000 75327069
julia simulating-gene-trees.jl long_mix03 100000 51722091
julia simulating-gene-trees.jl long_mix03 250000 475676116
julia simulating-gene-trees.jl long_mix03 500000 72229109

julia simulating-gene-trees.jl long_mix04 50000 81690291
julia simulating-gene-trees.jl long_mix04 100000 52101735
julia simulating-gene-trees.jl long_mix04 250000 06371274
julia simulating-gene-trees.jl long_mix04 500000 85982228

((HAVE ONLY RUN THESE: long_mix05 as trial, takes >1 hour to simulate gene trees up to 500k))
julia simulating-gene-trees.jl long_mix05 50000 70293396
julia simulating-gene-trees.jl long_mix05 100000 573110835
julia simulating-gene-trees.jl long_mix05 250000 79624091
julia simulating-gene-trees.jl long_mix05 500000 42110233

julia simulating-gene-trees.jl short_mix0 30 471411232
julia simulating-gene-trees.jl short_mix0 100 6543213699
julia simulating-gene-trees.jl short_mix0 300 865325398
julia simulating-gene-trees.jl short_mix0 1000 310197016

julia simulating-gene-trees.jl short_mix01 30 163271437
julia simulating-gene-trees.jl short_mix01 100 6312515565
julia simulating-gene-trees.jl short_mix01 300 99138985998
julia simulating-gene-trees.jl short_mix01 1000 2342872833

julia simulating-gene-trees.jl short_mix02 30 1645347918
julia simulating-gene-trees.jl short_mix02 100 53325618548
julia simulating-gene-trees.jl short_mix02 300 9612321329
julia simulating-gene-trees.jl short_mix02 1000 8932857020

julia simulating-gene-trees.jl short_mix03 30 412675259
julia simulating-gene-trees.jl short_mix03 100 1435709154
julia simulating-gene-trees.jl short_mix03 300 1238149859
julia simulating-gene-trees.jl short_mix03 1000 461546399

julia simulating-gene-trees.jl short_mix04 30 49883895
julia simulating-gene-trees.jl short_mix04 100 75171282
julia simulating-gene-trees.jl short_mix04 300 89505932
julia simulating-gene-trees.jl short_mix04 1000 35136772

julia simulating-gene-trees.jl short_mix05 30 91592084
julia simulating-gene-trees.jl short_mix05 100 43153732
julia simulating-gene-trees.jl short_mix05 300 15654898
julia simulating-gene-trees.jl short_mix05 1000 36239132
