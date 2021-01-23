## dadaist2-exporter
**dadaist2-exporter** - tool to export dadaist2 output into MicrobiomeAnalyst
compatible format. MicrobiomeAnalyst can be used as an **R** module or
via the user-friendly website [https://www.microbiomeanalyst.ca/](https://www.microbiomeanalyst.ca/).

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
The program is freely available at https://github.com/quadram-institute-bioscience/dadaist2
released under the MIT licence. The website contains further DOCUMENTATION.
