---
sort: 15
---
## dadaist2-taxonomy-binning
**dadaist2-taxonomy-binning** - Normalize OTU table using the **Rhea** protocol.
The Rhea protocol ([https://lagkouvardos.github.io/Rhea/](https://lagkouvardos.github.io/Rhea/)) is a complete
set of scripts to analyse microbiome files. 

This wrapper is part of the _AutoRhea_ script bundled with _Dadaist2_. 
If used, please, cite the Rhea paper (see below).

## Authors
Andrea Telatin and Rebecca Ansorge

## Usage
    dadaist2-taxonomy-binning -i TABLE -o OUTDIR 

- _-i_, _--input-table_ FILE

    Input OTU table, the **normalized** and with **taxonomy column**.
    The default name is `OTUs_Table-norm-rel-tax.tab`.

- _-o_, _--output-outdir_ DIR

    Output directory. 

## Output files
- _0.Kingdom.all.tab_

    Relative abundances a the Kingdom level

- _1.Phyla.all.tab_

    Relative abundances a the Phylum level

- _2.Classes.all.tab_

    Relative abundances a the Class level

- _3.Orders.all.tab_

    Relative abundances a the Order level

- _4.Families.all.tab_

    Relative abundances a the Family level

- _5.Genera.all.tab_

    Relative abundances a the Genus level

- _tax.summary.all.tab_

    Summary table (all ranks)

- _taxonomic-overview.pdf_

    Stacked bar plots in PDF format

## Citation
If you use **Rhea** in your work please cite/attribute the original publication:

     Lagkouvardos I, Fischer S, Kumar N, Clavel T. (2017) 
     Rhea: a transparent and modular R pipeline for microbial profiling based on 16S rRNA gene amplicons. 
     PeerJ 5:e2836 https://doi.org/10.7717/peerj.2836
    

## Source code and documentation
This wrapper is part of **Dadaist2** freely available at 
[https://quadram-institute-bioscience.github.io/dadaist2](https://quadram-institute-bioscience.github.io/dadaist2)
released under the MIT licence. The website contains further DOCUMENTATION.
