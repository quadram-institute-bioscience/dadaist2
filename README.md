# dadaist2

[![Dadaist2 logo](docs/dadaist.png)](https://github.com/quadram-institute-bioscience/dadaist2#readme)

[![release](https://img.shields.io/github/v/release/quadram-institute-bioscience/dadaist2?label=github%20release)](https://github.com/quadram-institute-bioscience/dadaist2/releases)
[![version](https://img.shields.io/conda/v/bioconda/dadaist2?label=bioconda)](https://bioconda.github.io/recipes/dadaist2/README.html)
[![Conda](https://img.shields.io/conda/dn/bioconda/dadaist2)](https://bioconda.github.io/recipes/dadaist2/README.html)
[![Build Status](https://www.travis-ci.com/quadram-institute-bioscience/dadaist2.svg?branch=master)](https://www.travis-ci.com/quadram-institute-bioscience/dadaist2)

Standalone wrapper for [DADA2](https://benjjneb.github.io/dada2/index.html) package, to quickly generate a feature table and a
set of representative sequences from a folder with Paired End Illumina reads.

### [Documentation and tutorials](https://quadram-institute-bioscience.github.io/dadaist2)

Please check the [online documentation](https://quadram-institute-bioscience.github.io/dadaist2) and tutorials
for installation and usage notes.

## Authors
* Andrea Telatin, Quadram Institute Bioscience, UK
* Rebecca Ansorge, Quadram Institute Bioscience, UK
* Giovanni Birolo, University of Turin, Italy

## Bibliography
* Benjamin J Callahan, Paul J McMurdie, Michael J Rosen, Andrew W Han, Amy Jo A Johnson, and Susan P Holmes. **Dada2: high-resolution sample inference from illumina amplicon data**. Nature methods, 13(7):581, 2016. [doi:10.1038/nmeth.3869](https://doi.org/doi:10.1038/nmeth.3869).
* Sievers F, Wilm A, Dineen D, et al. **Fast, scalable generation of high-quality protein multiple sequence alignments using Clustal Omega**. Molecular Systems Biology. 2011 Oct;7:539. [doi:10.1038/msb.2011.75](https://doi.org/doi:10.1038/msb.2011.75).
* Price MN, Dehal PS, Arkin AP. **FastTree 2--approximately maximum-likelihood trees for large alignments**. Plos one. 2010 Mar;5(3):e9490. [doi:10.1371/journal.pone.0009490](https://doi.org/doi:10.1371/journal.pone.0009490).
* McMurdie PJ, Holmes S. **phyloseq: an R package for reproducible interactive analysis and graphics of microbiome census data**. Plos one. 2013 ;8(4):e61217. [doi:10.1371/journal.pone.0061217](https://doi.org/doi:10.1371/journal.pone.0061217).

The wrapper uses R scripts from:
* [q2-dada2, a Qiime2 plugin](https://github.com/qiime2/q2-dada2)
