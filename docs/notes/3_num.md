---
sort: 3
---

# Numerical ecology

The primary analysis of a metabarcoding experiment processes a set of FASTQ files (raw reads) to generate:
* a set of _representative sequences_ (either Amplicon Sequence Variants, ASVs, or Operational Taxonomic Units, OTUs)
* a _feature table_ (or _contingency table_): a matrix of counts of hits against each representative sequence per sample

Additionally:
* _taxonomic annotation_ of each representative sequence
* a _phylogenetic tree_ of the representative sequences

These files can be analysed using the principles of *numerical ecology*, to 

## MicrobiomeAnalyst

[MicrobiomeAnalyst](https://www.microbiomeanalyst.ca/MicrobiomeAnalyst/upload/OtuUploadView.xhtml)
is both an R module and a webserver to perform a range of explorative analyses and statistical tests,
like:
* Compositional profiling
* Comparative analysis
* Functional analysis
* Taxon Set Enrichment Analysis

A [nature protocol](https://www.nature.com/articles/s41596-019-0264-1) is available.

## Rhea
Dadaist2 implements the [Rhea](https://lagkouvardos.github.io/Rhea/) workflow to normalize the feature table,
analyse the alpha and beta diversity, generate taxonomy barplots.

> Lagkouvardos I, Fischer S, Kumar N, Clavel T. (2017) _Rhea: a transparent and modular R pipeline for microbial profiling based on 16S rRNA gene amplicons_. PeerJ 5:e2836 https://doi.org/10.7717/peerj.2836

Dadaist2 produce a _Rhea_ subdirectory with the input files to follow the full Rhea protocol. In addition some steps (those not requiring assumptions on the experiment) are performed automatically:
* Normalization (this can be invoked independently via _dadaist2-normalize_)
* Alpha diversity (this can be invoked independently via _dadaist2-alpha_)

## PhyloSeq

[PhyloSeq](https://joey711.github.io/phyloseq/) is an R module that allows several
analyses of microbiome datasets.

Dadaist2 conveniently produces a phyloseq object that can be loaded with:

```r
ps <- loadRDS("phyloseq.rds")
```