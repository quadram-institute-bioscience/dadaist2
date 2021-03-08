---
sort: 7
---
## dadaist2-getdb
**dadaist2-getdb** - download reference databases for dadaist2

## Author
Andrea Telatin <andrea.telatin@quadram.ac.uk>

## List available databases
    dadaist2-getdb --list

## Download a database
    dadaist2-getdb -d DATABASE_NAME [-o OUTPUT_DIR]

- _-d_, _--database_ ID

    Identifier of the database to be downloaded (list available database and their
    identifier name using `dadaist2-getdb --list`).

- _-o_, _--output-dir_ DIR

    Output directory, or the current working directory if not specified.

## Source code and documentation
The program is freely available at [https://quadram-institute-bioscience.github.io/dadaist2](https://quadram-institute-bioscience.github.io/dadaist2)
released under the MIT licence. The website contains further DOCUMENTATION.
