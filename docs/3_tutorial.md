---
sort: 3
permalink: /tutorial
---

# Dadaist2: a first tutorial

## Get ready

[Install Dadaist2](({{ 'installation' | relative_url }})) and activate the Miniconda environment (if needed).   

For this tutorial we will analyze three small samples (also present in the repository).
This will create a `./data` directory.

```bash
wget "https://github.com/quadram-institute-bioscience/dadaist2/releases/download/v1.2.4/data.zip"
unzip data.zip && rm data.zip
```

Let's start checking the number of reads per sample. The reads are in `data/16S`:

```bash
seqfu count --basename data/16S/*.gz
```

This will tell the number of reads, checking that the forward (R1) and reverse (R2)
pair have the same amount of reads. This should be the output produced:

```
F99_S0_L001_R1_001.fastq.gz	4553	Paired
A01_S0_L001_R1_001.fastq.gz	6137	Paired
A02_S0_L001_R1_001.fastq.gz	5414	Paired
```

:warning: Sample names should not begin with numbers (eg: `1_R1.fastq.gz`). This will be
prohibited in a future release, and will trigger a warning in the current release.

## Download a reference database

Dadaist2 provides a convenient tool to download some pre-formatted reference databases.
To have a list of the available to download:
```bash
dadaist2-getdb --list
```

This should produce something like:
```text
dada2-hitdb: HITdb is a reference taxonomy for Human Intestinal 16S rRNA genes
dada2-rdp-species-16: RDP taxonomic training data formatted for DADA2 (RDP trainset 16/release 11.5)
dada2-rdp-train-16: RDP taxonomic training data formatted for DADA2 (RDP trainset 16/release 11.5)
dada2-silva-138: SILVA release 138
dada2-silva-species-138: SILVA release 138 (species)
decipher-gtdb95: GTDB
decipher-silva-138: SILVA release 138 (Decipher)
decipher-unite-2020: UNITE 2020 (Decipher)
testset: FASTQ input, Small 16S dataset to test the suite
```
Some reference files are for DADA2, others are for DECIPHER. Dadaist2 will automatically select the
correct classifier based on the extension of the reference database.

The keyword before the column is the dataset name, to download it we need to choose a destination directory,
we can for example make a `refs` subdirectory:

```bash
mkdir -p refs
dadaist2-getdb -d decipher-silva-138 -o ./refs
```

This will place `SILVA_SSU_r138_2019.RData` in the output directory.

## Generate a mapping file

A metadata file is not mandatory, but it's easy to generate one to be extended with more columns if needed.

```bash
dadaist2-metadata -i data/16S > metadata.tsv
```
This should generate a file called _metadata.tsv_ with the following content:
```text
#SampleID  Files
A01        A01_S0_L001_R1_001.fastq.gz,A01_S0_L001_R2_001.fastq.gz
A02        A02_S0_L001_R1_001.fastq.gz,A02_S0_L001_R2_001.fastq.gz
F99        F99_S0_L001_R1_001.fastq.gz,F99_S0_L001_R2_001.fastq.gz
```

## Run the analysis

Dadaist2 provides options to:
* select the QC strategy (fastp, cutadapt of seqfu)
* select the taxonomy classifier (DECIPHER or DADA2 naive classifier)
* adjust various steps via command line parameters


As a first run, we recommend using the default parameters:
```bash
dadaist2 -i data/16S/ -o example-output -d refs/SILVA_SSU_r138_2019.RData -t 8 -m metadata.tsv --verbose
```

Briefly:
* `-i` points to the input directory containing paired end reads (by default recognised by `_R1` and `_R2` tags, but this can be customised)
* `-o` is the output directory
* `-d` is the reference database in DADA2 or DECIPHER format (we downloaded a DECIPHER database)
* `-m` link to the metadata file (if not supplied a blank one will be generated and used)
* `-t` is the number of processing threads
* `--verbose` will print more information about the analysis

## Warnings and errors

Dadaist2 will print the following warning:

```
DADA2 filtered too many reads: 9.0102% from total 16104 to 1451
```

We can inspect the filtering steps in the output directory (`dada2_stats.tsv`) to
check the steps with the highest loss (can differs slightly):

Sample name | input  |  filtered | denoised | merged | non-chimeric
------ | ------- | --------: | ------: | -----: | ----------:
A01    | 6137      |2291      |2291      |1924      |765
A02    | 5414      |2079      |2079      |1865      |413
F99    | 4553      |1770      |1770      |1517      |273

If, for example, the highest loss is at "merged", it means we truncated too much
and we didn't have overlap between the reads.
In this case a good loss is at the first step (filtered), as these sample
reads are not of very high quality and are just used to test the pipeline. 

But if the pipeline ended, it means you are ready to run it with real samples
as [described in another tutorial]({{ site.baseurl }}{% link 4_usage.md %}).


## The output directory

Notable files:
* **rep-seqs.fasta** representative sequences (ASVs) in FASTA format
* **rep-seqs-tax.fasta** representative sequences (ASVs) in FASTA format, with taxonomy labels as comments
* **feature-table.tsv** table of raw counts (after cross-talk removal if specified)
* **taxonomy.tsv** a text file with the taxonomy of each ASV (used to add the labels to the _rep-seqs-tax.fasta_)
* copy of the **metadata.tsv** file

Subdirectories:
* **MicrobiomeAnalyst** a set of files formatted to be used with the online (also available offline as R package) software [MicrobiomeAnalyst](https://www.microbiomeanalyst.ca/MicrobiomeAnalyst/upload/OtuUploadView.xhtml).
* **Rhea** a directory with files to be used with the [Rhea pipeline](https://lagkouvardos.github.io/Rhea/), as well as some pre-calculated outputs (Normalization and Alpha diversity are done by default, as they don't require knowledge about metadata categories)
* **R** a directory with the PhyloSeq object
