# dadaist2

**dadaist2** - a shell wrapper for DADA2, to detect representative sequences and generate
a feature table starting from Illumina Paired End reads.

## AUTHOR

Andrea Telatin <andrea.telatin@quadram.ac.uk>

## SYNOPSIS

dadaist2 \[options\] -i INPUT\_DIR -o OUTPUT\_DIR

## PARAMETERS

- _-i_, _--input-directory_ DIRECTORY

    Directory containing the paired end files in FASTQ format, gzipped or not.

- _-o_, _--output-directory_ DIRECTORY

    Output directory (will be created).

- _-d_, _--database_ DATABASE

    Reference database in gzipped FASTA format, specify 'skip' not to assign
    taxonomy (default: skip)

- _-q_, _--min-qual_ FLOAT

    Minimum average quality for DADA2 truncation (default: 28)

- _-r_, _--save-rds_

    Save a copy of the RDS file (default: off)

- _-1_, _--for-tag_ STRING \[and _-2_, _--rev-tag_\]

    String identifying the forward (and reverse) pairs. Default are \_R1 and \_R2.

- _-s_, _--id-separator_ STRING

    String used to separate the "sample name" from the filename. Default "\_".

- _-p_, _--prefix_ STRING

    Prefix for the output FASTA file, if "MD5" is specified, the sequence MD5 hash
    will be used instead. Default is "ASV".

- _-l_, _--log-file_ FILE

    Filename for the program log.

## SOURCE CODE AND DOCUMENTATION

The program is freely available at https://github.com/quadram-institute-bioscience/dadaist2
released under the MIT licence. The website contains further DOCUMENTATION.
