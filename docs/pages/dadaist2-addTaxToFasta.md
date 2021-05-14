---
sort: 2
---
## dadaist2-addTaxToFasta
**dadaist2-addTaxToFasta** - Add taxonomy annotation to the FASTA file with
the representative sequences

## Author
Andrea Telatin <andrea.telatin@quadram.ac.uk>

## Usage
    dadaist2-assigntax -i FASTA -o DIR -r REFERENCE [-t THREADS]

- _-f_, _--fasta_ FASTA

    Input file in FASTA format (or in DADA2 table format)

- _-o_, _--output_ FASTA

    Output file in FASTA format. If not provided will be printed to the standard output.

- _-t_, _--taxonomy_ FILE

    "taxonomy.tsv" file as produced by `dadaist2-assigntax`

## Source code and documentation
The program is freely available at [https://quadram-institute-bioscience.github.io/dadaist2](https://quadram-institute-bioscience.github.io/dadaist2)
released under the MIT licence. The website contains further DOCUMENTATION.
