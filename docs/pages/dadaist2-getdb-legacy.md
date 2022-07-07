---
sort: 8
---
## dadaist2-getdb-legacy
**dadaist2-getdb** - download reference databases for dadaist2

## Author
Andrea Telatin <andrea.telatin@quadram.ac.uk>

## List available databases
    dadaist2-getdb --list [query]

If a `query` keyword is specified, only matching entries will be printed.

## Download one or more databases
    dadaist2-getdb -d DATABASE_NAME [-o OUTPUT_DIR]

    dadaist2-getdb -d DB1 -d DB2 -d DB3 [-o OUTPUT_DIR]

    dadaist2-getdb -q QUERY_STRING

- _-d_, _--database_ ID

    Identifier of the database to be downloaded (list available database and their
    identifier name using `dadaist2-getdb --list`). This parameter can be repeated
    multiple times to download multiple databases.

- _-q_, _--query_ STRING

    Download all databases matching the query string ('.' for all)

- _-o_, _--output-dir_ DIR

    Output directory, or the current working directory if not specified.

- _-t_, _--temp-dir_ DIR

    Temporary directory (default: `$TMPDIR`).

## Source code and documentation
The program is freely available at [https://quadram-institute-bioscience.github.io/dadaist2](https://quadram-institute-bioscience.github.io/dadaist2)
released under the MIT licence. The website contains further DOCUMENTATION.
