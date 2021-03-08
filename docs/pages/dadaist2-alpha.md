---
sort: 3
---
## dadaist2-alpha
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

    Input file, the **normalized** OTU table

- _-o_, _--output-outdir_ DIR

    Output directory

- _-e_, _--effective-richness_ FLOAT

    Effective richness (default: 0.0025)

- _-s_, _--standard-richness_ INT

    Standard richness (default: 1000)

## Output files
- _alpha-diversity.tab_

    Table with: Richness, Shannon.Index, Shannon.Effective, Simpson.Index, Simpson.Effective, and Evenness
    for each sample

## Citation
If you use **Rhea** in your work please cite/attribute the original publication:

     Lagkouvardos I, Fischer S, Kumar N, Clavel T. (2017) 
     Rhea: a transparent and modular R pipeline for microbial profiling based on 16S rRNA gene amplicons. 
     PeerJ 5:e2836 https://doi.org/10.7717/peerj.2836
    

## Source code and documentation
This wrapper is part of **Dadaist2** freely available at 
[https://quadram-institute-bioscience.github.io/dadaist2](https://quadram-institute-bioscience.github.io/dadaist2)
released under the MIT licence. The website contains further DOCUMENTATION.
