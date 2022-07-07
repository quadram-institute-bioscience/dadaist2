---
sort: 10
---
## dadaist2-metadata
**dadaist2-metadata** - create a sample sheet from a list of Paired End FASTQ files,
that can be used as a template to add further columns.
This is automatically called by `dadaist2`, but it can be used to generate a valid
templeate to be extended with more columns.

## Author
Andrea Telatin <andrea.telatin@quadram.ac.uk>

## Synopsis
    makeSampleSheet [options] -i INPUT_DIR

## Parameters
- _-i_, _--input-directory_ DIRECTORY

    Directory containing the paired end files in FASTQ format, gzipped or not.

- _-o_, _--output-file_ FILE

    Output file, if not specified will be printed to STDOUT.

- _-1_, _--for-tag_ (and _-2_, _--rev-tag_) TAG

    Identifier for forward and reverse reads (default: \_R1 and \_R2)

- _-s_, _id-separator_ STRING

    Sample name separator (default: \_)

- _-f_, _--field-separator_ CHAR

    Separator in the output file table (default: \\t)

- _-h_, _--header-first-col_ COLNAME

    dadaist2-metadata of the first column header (default: #SampleID)

- _--add-full-path_

    Add a colum with the absolute path of the sample Reads

- _--add-mock-column_ COLNAME

    Add an extra column named `COLNAME` having as value what is specified by
    `--mock-value`

- _---mock-value_ VALUE

    Default value used to fill an optional column (requires `--add-mock-column`). Default "sample".

- _--version_

    Print version and exit.

## Source code and documentation
The program is freely available at [https://quadram-institute-bioscience.github.io/dadaist2](https://quadram-institute-bioscience.github.io/dadaist2)
released under the MIT licence. The website contains further DOCUMENTATION.
