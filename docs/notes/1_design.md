---
sort: 1
---
# Program design

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
