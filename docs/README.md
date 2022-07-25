<a href="https://quadram-institute-bioscience.github.io/dadaist2" description="Dadaist documentation">
<img src="img/dadaist.png">
</a>
<br/>

# Dadaist2: highway to R

:package: See the **[repository](https://github.com/quadram-institute-bioscience/dadaist2)**

[![release](https://img.shields.io/github/v/release/quadram-institute-bioscience/dadaist2?label=github%20release)](https://github.com/quadram-institute-bioscience/dadaist2/releases)
[![version](https://img.shields.io/conda/v/bioconda/dadaist2?label=bioconda)](https://bioconda.github.io/recipes/dadaist2/README.html)
[![Conda](https://img.shields.io/conda/dn/bioconda/dadaist2)](https://bioconda.github.io/recipes/dadaist2/README.html)
[![Build Status](https://www.travis-ci.com/quadram-institute-bioscience/dadaist2.svg?branch=master)](https://www.travis-ci.com/quadram-institute-bioscience/dadaist2)
[![Dadaist-CI](https://github.com/quadram-institute-bioscience/dadaist2/actions/workflows/test-dadaist.yaml/badge.svg)](https://github.com/quadram-institute-bioscience/dadaist2/actions/workflows/test-dadaist.yaml)


Standalone wrapper for [DADA2](https://benjjneb.github.io/dada2/index.html) package, to quickly generate a feature table and a
set of representative sequences from a folder with Paired End Illumina reads.
*Dadaist2* is designed to simplify the stream of data from the read processing to the statistical analysis and plots.

Dadaist2 is a highway to downstream analyses:
* Generation of a [*PhyloSeq*](https://joey711.github.io/phyloseq/) object, for immediate usage in R
* Possibility to run in the pipeline a _custom R script_ that starts from the PhyloSeq object
* Generation of [*MicrobiomeAnalyst*](https://www.microbiomeanalyst.ca)-compatible files. MicrobiomeAnalyst provides a web-interface to performgi a broad range of visualizations and analyses.
* Generation of [*Rhea*](https://lagkouvardos.github.io/Rhea/)-compatible files. Rhea is a standardized set of scripts "_designed to help easy implementation by users_".

In addition to this, Dadaist:
* Can automatically detect quality boundaries or trim the primers
* Has a custom mode for _variable length_ amplicons (i.e. ITS), to detect features longer than the sum of the paired-end reads.
* Ships an open source implementation of *[UNCROSS2](https://www.biorxiv.org/content/10.1101/400762v1.full)* by Robert Edgar.
* Has a modular design that allows recycling parts of it in custom workflows.
* Prepares [a MultiQC-enabled](https://quadram-institute-bioscience.github.io/dadaist2/mqc/) overview of the experiment
* Produces an easy to inspect [HTML execution log](https://quadram-institute-bioscience.github.io/dadaist2/mqc/log.html)

You can [read more](introduction) about the features.

## The workflow

<img src="img/scheme_small.png">

## Contents

{% include list.liquid all=true %}
