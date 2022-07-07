---
sort: 17
---
## dadaist2-crosstalk
**dadaist2-crosstalk** is an open source implementation of the
UNCROSS2 ([https://www.biorxiv.org/content/10.1101/400762v1.full.pdf](https://www.biorxiv.org/content/10.1101/400762v1.full.pdf))
algorithm by Robert Edgar.

## Usage

    usage: dadaist2-crosstalk [-h] -i INPUT [-o OUTPUT] [-v] [-d] [--version]
    
    Denoise Illumina cross-talk from OTU tables
    
    optional arguments:
      -h, --help            show this help message and exit
      -i INPUT, --input INPUT
                            OTU table filename
      -o OUTPUT, --output OUTPUT
                            Cleaned OTU table filename
      -v, --verbose         Print extra information
      -d, --debug           Print debug information
      --version             show program's version number and exit

## Rationale

Metabarcoding experiments usually result in highly multiplexed sequencing runs 
where each sample is identified by a molecular barcode that is also sequenced. 
De-multiplexing errors can cause assignment of reads to the wrong sample. 
While the effect is often negligible, it may affect analysis when a fraction 
of reads leak from a high abundance sample to a small or even zero abundance sample, 
which can affect diversity rate estimation. 

Removal of crosstalk between samples in feature tables has been already tackled 
by the UNCROSS2 algorithm, implemented in the closed source USEARCH software.

## Input and Output

Input is a feature table in TSV format having the OTU/ASV IDs in the first column
and each following column being the count of occurrences in a sample.

The output is a denoised table with the same format.
