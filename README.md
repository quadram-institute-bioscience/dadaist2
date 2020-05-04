# dadaist2

[![Dadaist2 logo](docs/dadaist.png)](https://github.com/quadram-institute-bioscience/dadaist2#readme)

Standalone CLI DADA2 package


## Usage

```
dadaist -i INPUT_DIR -o OUTPUT_DIR [-t TMP_DIR]
```

Other options:
* `-1`, `--for-tag` STRING, string identifying a file as being _forward_ (default: \_R1)
* `-2`, `--rev-tag` STRING, string identifying a file as being _reverse_ (default: \_R2)
* `-s`, `--id-separator` STRING, string delimiting the Sample ID (default: _)
* `-l`, `--log-filename` FILE, to change the log file path (default: output_dir/dadaist.log)
* `-t`, `--threads` INT, to specify the number of threads
* `--version` will print the program version and exit
* `--help` will print the usage 

## Input 

A directory containing the FASTQ files, that are usually gzipped. Paired-end are expected, but this will change in a future release. See the `data` directory for an example.

## Output

The output directory will contain:
* _feature-table.tsv_ - the feature table 
* _rep-seqs.fasta_ - the representative sequences (ASVs)
