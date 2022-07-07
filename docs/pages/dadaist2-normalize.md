---
sort: 11
---
## dadaist2-normalize
**dadaist2-normalize** - Normalize OTU table using the **Rhea** protocol.
The Rhea protocol ([https://lagkouvardos.github.io/Rhea/](https://lagkouvardos.github.io/Rhea/)) is a complete
set of scripts to analyse microbiome files.

This wrapper is part of the _AutoRhea_ script bundled with _Dadaist2_.
If used, please, cite the Rhea paper (see below).

## Authors
Andrea Telatin and Rebecca Ansorge

## Usage
    dadaist2-normalize [options] -i TABLE -o OUTDIR

- _-i_, _--input-table_ FILE

    Input file in in PhyloSeq object (R Object)

- _-o_, _--output-outdir_ DIR

    Output directory

- _-r_, _--random-subsampling_

    Use random subsampling (default: off)

- _-f_, _fixed-value_

    Normalized using a fixed value (default: minimum)

- _-c_, _--cutoff_ INT

    Normalization cutoff (if _--fixed-value_ is used)

- _-n_, _--n-labels_ INT

    Highlight the INT  most undersampled samples

## Citation
If you use **Rhea** in your work please cite/attribute the original publication:

    Lagkouvardos I, Fischer S, Kumar N, Clavel T. (2017)
    Rhea: a transparent and modular R pipeline for microbial profiling based on 16S rRNA gene amplicons.
    PeerJ 5:e2836 https://doi.org/10.7717/peerj.2836

## Source code and documentation
This wrapper is part of **Dadaist2** freely available at
[https://quadram-institute-bioscience.github.io/dadaist2](https://quadram-institute-bioscience.github.io/dadaist2)
released under the MIT licence. The website contains further DOCUMENTATION.
