# dadaist2-assigntax

dadaist2-assigntax is a tool for taxonomic assignment of metabarcoding sequences. It is part of the dadaist2 suite and supports classification using either the DECIPHER or DADA2 R packages.

## Usage

```text
usage: dadaist2-assigntax [-h] [-m {DECIPHER,DADA2}] -i INPUT [-o OUTDIR] -r REFERENCE [-t THREADS] [-f FASTA_OUT] [-u] [--version]

Assign taxonomy using R DECIPHER or DADA2

options:
  -h, --help            show this help message and exit
  -m {DECIPHER,DADA2}, --method {DECIPHER,DADA2}
                        Taxonomy assignment method
  -i INPUT, --input INPUT
                        Input FASTA file
  -o OUTDIR, --outdir OUTDIR
                        Output directory
  -r REFERENCE, --reference REFERENCE
                        Reference database
  -t THREADS, --threads THREADS
                        Number of threads
  -f FASTA_OUT, --fasta-out FASTA_OUT
                        Save taxonomy assigned FASTA file
  -u, --underscore-join
                        Join taxa names with underscore
  --version             show program's version number and exit
```
Example:

```bash
./dadaist2-assigntax -i input.fasta -r reference.RData -o output_dir -m DECIPHER -t 4
```

## Input

A FASTA file containing ASV/OTU representative sequences.

A reference database:

* `.RData` file for DECIPHER.

* `.fa.gz` (compressed FASTA) for DADA2.

## Output

* `taxonomy.tsv`: A tab-delimited file with taxonomic classifications.
* `taxonomy.decipher` (DECIPHER mode): Raw output from DECIPHER.
* `taxonomy_summary.png` (DECIPHER mode): Taxonomic summary plot.

## Example

Run with DECIPHER:

```bash
./dadaist2-assigntax -i rep-seqs.fasta -r silva_RData -o results -m DECIPHER -t 8
```
Run with DADA2:

```bash
./dadaist2-assigntax -i rep-seqs.fasta -r silva.fasta.gz -o results -m DADA2 -t 8
```

