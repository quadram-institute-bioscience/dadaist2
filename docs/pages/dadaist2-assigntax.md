---
sort: 4
---
## dadaist2-assigntax
**dadaist2-assigntax** - Assign Taxonomy

## Author
Andrea Telatin <andrea.telatin@quadram.ac.uk>

## Usage
    dadaist2-assigntax [options] -i FASTA -o DIR -r REFERENCE 

- _-m_, _--method_

    Taxonomy assignment method, either DECIPHER or DADA2
    (default: DECIPHER)

- _-i_, _--input_ FASTA

    Input file in FASTA format (or in DADA2 table format)

- _-o_, _--outdir_ DIR

    Output directory, or the current working directory if not specified.

- _-f_, _--fasta_ FILE

    Save taxonomy assigned FASTA file.

- _-r_, _--reference_ FILE

    RData file with the training set in DECIPHER format.

- _-t_, _--threads_ INT

    Number of threads to use.

- _-u_, _--underscore-join_

    Join taxa names that have spaces with an underscore (default:
    use double quotes)

## Source code and documentation
The program is freely available at [https://quadram-institute-bioscience.github.io/dadaist2](https://quadram-institute-bioscience.github.io/dadaist2)
released under the MIT licence. The website contains further DOCUMENTATION.
