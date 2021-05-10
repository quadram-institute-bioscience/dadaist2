---
sort: 5
---

# Continuous integration

Dadaist2 is a pipeline wrapping third party tools and scripts (most notably _DADA2_, _DECIPHER_, _Rhea_)
and some custom components (_e. g._ _crosstalk_, _octave plots_ ...) in a coherent framework. 

Most functions are provided as modules, and we are committed to update each module ensuring that the 
output remains reliable and in line with the original tool. To ensure that the reliability is preserved
at each release, we set up a set of tests:

* continuous integration with CircleCI tests, at each commit:
  * the generation of a feature table (and representative sequences) without a taxonomy assignment
  * the generation of a feature table (and representative sequences) *with* a taxonomy assignment
  * that the taxonomy assignment module (standalone) works correctly

## Function tests

In addition to the continuous integration, there is a more complete set of tests that is performed at each
release:

* QC
* DADA2 denoising
* Taxonomy (DADA and DECIPHER)

### QC test

The QC is available via `cutadapt` or via `fastp`. 
### DADA2 test

DADA2 provides [a tutorial](https://benjjneb.github.io/dada2/tutorial_1_8.html)
(wrote for version 1.8), based on the [MiSeq SOP](https://mothur.org/wiki/miseq_sop/) 
dataset (from [Mothur](https://mothur.org)).

In the repository we have a script (here 
[dada2-sop.R](https://github.com/quadram-institute-bioscience/dadaist2/blob/master/test/miseq-sop-compare/dada2-sop.R))
that uses the exact commands provided by the tutorial, which does not include any QC step.

### Taxonomy (DADA and DECIPHER)

## Pipeline tests

A pipeline require that the utilized components (see _Function Tests_) work together,
generating the expected output to be fed to the downstream steps.

At each release we test:

* MicrobiomeAnalyst output
* Rhea output


---


