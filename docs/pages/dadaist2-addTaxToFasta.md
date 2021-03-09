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

- _-m_, _--method_

    Taxonomy assignment method (default: DECIPHER)

- _-i_, _--input_ FASTA

    Input file in FASTA format (or in DADA2 table format)

- _-o_, _--outdir_ DIR

    Output directory, or the current working directory if not specified.

- _-r_, _--reference_ FILE

    RData file with the training set in DECIPHER format.

- _-u_, _--underscore-join_

    Join taxa names that have spaces with an underscore (default:
    use double quotes)

## Source code and documentation
The program is freely available at [https://quadram-institute-bioscience.github.io/dadaist2](https://quadram-institute-bioscience.github.io/dadaist2)
released under the MIT licence. The website contains further DOCUMENTATION.
