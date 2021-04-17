---
sort: 13
---
## dadaist2-mqc-report

**dadaist2-mqc-report** generates a MultiQC-ready folder starting from the data
available in a _Dadaist2_ run where taxonomy was assigned.

An [example report](https://quadram-institute-bioscience.github.io/dadaist2/mqc/) is
available.

## Synopsis

```
usage: dadaist2-mqc-report [-h] -i INPUT_DIR [-t TOPTAXA] -o OUTPUT_DIR

Produce multiqc report

optional arguments:
  -h, --help            show this help message and exit
  -i INPUT_DIR, --input-dir INPUT_DIR
  -t TOPTAXA, --toptaxa TOPTAXA
  -o OUTPUT_DIR, --output-dir OUTPUT_DIR
```

## Description

Beside checking the [execution logs](https://quadram-institute-bioscience.github.io/dadaist2/mqc/log.html), it's useful to have an overview of the whole experiment before performing
accurate analyses.

### Content of the report

* DADA2 denoising statistics: how many input reads, filtered reads, denoised reads, merged reads and final reads after chimera removal
* [Octave plots](https://www.biorxiv.org/content/10.1101/389833v1) 
to evaluate the distribution of the abundance counts
* The most abundant FASTA sequences, both classified and unclassified
* Taxonomic barplots at different levels


## Usage

MultiQC is required, an it's automatically installed with the `dadaist2-full` package
but not with the thinner `dadaist2`. See installation.

1. Generate the report files: `dadaist2-mqc-report -i DadaistOutput -o DadaistOutput/qc/`
2. Generate the report: `multiqc -c DadaistOutput/qc/config.yaml DadaistOutput/qc/`
3. Open the report with a browser (will be `multiqc_report.html` in the output folder)
