---
sort: 1
---
# General information

`dadaist2` is a wrapper designed to perform a basic [DADA2](https://benjjneb.github.io/dada2/index.html)
analysis from the command line, starting from a directory containing a set of
paired-end samples in FASTQ (eventually gzipped) format.

The wrapper is written in _Perl_, and will run _R_ scripts via `Rscript --vanilla`.

## Main dependencies

* **Perl**, with some modules:
  - FASTX::Reader
  - File::Temp
  - an other standard modules (notably Pod::Usage and Digest::MD5)
* **R**, and some libraries:
  - dada2
  - phyloseq
  - DECIPHER
* **seqfu** (primer trimming)
* **fastp** (alternative to SeqFu QC, no trimming is performed)
* **clustalo** (for multiple sequence alignment)
* **fasttree** (to generate a tree of the representative sequences)


## Bibliography
* Benjamin J Callahan, Paul J McMurdie, Michael J Rosen, Andrew W Han, Amy Jo A Johnson, and Susan P Holmes. **Dada2: high-resolution sample inference from illumina amplicon data**. Nature methods, 13(7):581, 2016. [doi:10.1038/nmeth.3869](https://doi.org/doi:10.1038/nmeth.3869).
* Sievers F, Wilm A, Dineen D, et al. **Fast, scalable generation of high-quality protein multiple sequence alignments using Clustal Omega**. Molecular Systems Biology. 2011 Oct;7:539. [doi:10.1038/msb.2011.75](https://doi.org/doi:10.1038/msb.2011.75).
* Price MN, Dehal PS, Arkin AP. **FastTree 2--approximately maximum-likelihood trees for large alignments**. Plos one. 2010 Mar;5(3):e9490. [doi:10.1371/journal.pone.0009490](https://doi.org/doi:10.1371/journal.pone.0009490).
* McMurdie PJ, Holmes S. **phyloseq: an R package for reproducible interactive analysis and graphics of microbiome census data**. Plos one. 2013 ;8(4):e61217. [doi:10.1371/journal.pone.0061217](https://doi.org/doi:10.1371/journal.pone.0061217).

The wrapper uses R scripts from:
* [q2-dada2, a Qiime2 plugin](https://github.com/qiime2/q2-dada2)
