---
sort: 9
---
## dadaist2-importq2
**dadaist2-importq2** - create a PhyloSeq object from a set of
Qiime2 artifacts.

## Author
Andrea Telatin <andrea.telatin@quadram.ac.uk>

## Synopsis
    dadaist2-importq2 [options] 

## Parameters
- _-t_, _--feature-table_ ARTIFACT

    The feature table (e.g. from DADA2)

- _-m_, _--metadata-file_ FILE

    The metadata file used by Qiime2

- _-e_ _--tree_ ARTIFACT

    Rooted tree artifact.

- _-x_ _--taxonomy_ ARTIFACT

    Taxonomy table artifact.

- _-r_, _--rep-seqs_ ARTIFACT

    Representative sequences (e.g. from DADA2)

- _-o_, _--output-phyloseq_ FILE

    The filename for the PhyloSeq object to produce (default: phyloseq.rds)

- _--version_

    Print version and exit.

## Source code and documentation
The program is freely available at [https://quadram-institute-bioscience.github.io/dadaist2](https://quadram-institute-bioscience.github.io/dadaist2)
released under the MIT licence. The website contains further DOCUMENTATION.
