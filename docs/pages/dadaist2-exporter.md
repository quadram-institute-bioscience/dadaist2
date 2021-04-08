---
sort: 6
---
## dadaist2-exporter
**dadaist2-exporter** - tool to export dadaist2 output into MicrobiomeAnalyst
compatible format. _MicrobiomeAnalyst_ can be used as an **R** module or
via the user-friendly website [https://www.microbiomeanalyst.ca/](https://www.microbiomeanalyst.ca/) and
_Rhea_ ([https://lagkouvardos.github.io/Rhea/](https://lagkouvardos.github.io/Rhea/)).

## Author
Andrea Telatin <andrea.telatin@quadram.ac.uk>

## Synopsis
dadaist2-exporter \[options\] -i INPUT\_DIR

## Parameters
- _-i_, _--input-directory_ DIRECTORY

    Directory containing the paired end files in FASTQ format, gzipped or not.

- _-o_, _--output-directory_ DIRECTORY

    Output directory, by default will be a subdirectory called `MicrobiomeAnalyst`
    inside the input directory.

- _--skip-rhea_

    Do not create the **Rhea** subdirectory and its files.

- _--skip-ma_

    Do not create the **MicrobiomeAnalyst** subdirectory and its files.

- _--version_

    Print version and exit.

## Output
The output directory will contain:

- _metadata.csv_

    Metadata file to be used in the omonymous field.

- _table.csv_

    Feature table to be used in the 'OTU/ASV table' field.

- _taxonomy.csv_

    Taxonomy table to be used in the 'Taxonomy table' field.

- _seqs.fa_

    Not used in MicrobiomeAnalyst, but kept for reference.

## Source code and documentation
The program is freely available at [https://quadram-institute-bioscience.github.io/dadaist2](https://quadram-institute-bioscience.github.io/dadaist2)
released under the MIT licence. The website contains further DOCUMENTATION.
