# dadaist2

[![Dadaist2 logo](docs/dadaist.png)](https://github.com/quadram-institute-bioscience/dadaist2#readme)

[![version](https://img.shields.io/conda/v/bioconda/dadaist2?label=bioconda)](https://bioconda.github.io/recipes/dadaist2/README.html)
[![Conda](https://img.shields.io/conda/dn/bioconda/dadaist2)](https://bioconda.github.io/recipes/dadaist2/README.html)
[![Build Status](https://travis-ci.org/quadram-institute-bioscience/dadaist2.svg?branch=master)](https://travis-ci.org/quadram-institute-bioscience/dadaist2)

Standalone wrapper for [DADA2](https://benjjneb.github.io/dada2/index.html) package, to quickly generate a feature table and a
set of representative sequences from a folder with Paired End Illumina reads.


## Usage

```
dadaist2  [options] -i INPUT_DIR -o OUTPUT_DIR
```

Other options:
* `-1`, `--for-tag` STRING, string identifying a file as being _forward_ (default: \_R1)
* `-2`, `--rev-tag` STRING, string identifying a file as being _reverse_ (default: \_R2)
* `-d`, `--database` FILE, database in gzipped FASTA format
* `-s`, `--id-separator` STRING, string delimiting the Sample ID (default: _)
* `-l`, `--log-filename` FILE, to change the log file path (default: output_dir/dadaist.log)
* `-t`, `--threads` INT, to specify the number of threads
* `-p`, `--prefix` STRING, representative sequences name prefix (default: 'ASV'). If set to "MD5" the MD5 hash of the sequence will be used as sequence name (as Qiime2 does)
* `--skip-plots`, do not plot [quality plots](docs/quality_plot.png)
* `--tmp-dir` DIR, specify working directory
* `--version` will print the program version and exit
* `--help` will print the usage

## Input

A directory containing the FASTQ files, that are usually gzipped. Paired-end are expected, but this will change in a future release. See the `data` directory for an example.

## Output

The output directory will contain:
* _feature-table.tsv_ - the feature table
* _rep-seqs.fasta_ - the representative sequences (ASVs)
* _taxonomy.txt_ - taxonomic assignment (optional)
* JSON file of the _fastp_ filter
* PDF plots of the [quality profiles](docs/quality_plot.png)

## Citation

This is a wrapper around DADA2:
* Benjamin J Callahan, Paul J McMurdie, Michael J Rosen, Andrew W Han, Amy Jo A Johnson, and Susan P Holmes. **Dada2: high-resolution sample inference from illumina amplicon data**. Nature methods, 13(7):581, 2016. [doi:10.1038/nmeth.3869](https://doi.org/doi:10.1038/nmeth.3869).
The wrapper uses R scripts from
* Alternative to [q2-dada2, a Qiime2 plugin](https://github.com/qiime2/q2-dada2), as does not require full Qiime2 installation. If you wish to use Qiime2, that would be the recommended way.
