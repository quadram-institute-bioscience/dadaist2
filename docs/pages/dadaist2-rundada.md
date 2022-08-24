---
sort: 20
---

# dadaist2-rundada

```note
This is a new wrapper, introduced in 1.2.0, and experimental
```

Wrapper for DADA2 without any modification of the input reads.
The input can be supplied either:

* As a single directory containing the reads (`-i DIRECTORY`), or
* As two separate directory, one for the forward reads (`-f FOR_DIR`) and one for the reverse reads (`-r REV_DIR`).

The latter is used as a compatibility layer and will be used by _dadaist2_ itself to invoke the wrapper.

## Synopsis

```text
usage: dadaist2-rundada [-h] [-i INPUT_DIR] [-f FOR_DIR] [-r REV_DIR] -o OUTPUT_DIR [--tmp TMP] [--fortag FORTAG] [--revertag REVERTAG] [--sample-separator SAMPLE_SEPARATOR]
                        [--sample-extension SAMPLE_EXTENSION] [-q TRUNC_QUAL] [-j] [-p] [--trunc-len-1 TRUNC_LEN_1] [--trunc-len-2 TRUNC_LEN_2] [--trim-left-1 TRIM_LEFT_1] [--trim-left-2 TRIM_LEFT_2]
                        [--maxee-1 MAXEE_1] [--maxee-2 MAXEE_2] [--chimera {none,pooled,consensus}] [--min-parent-fold MIN_PARENT_FOLD] [--n-learn N_LEARN] [-t THREADS] [--keep-temp] [--save-rds]
                        [--save-plots] [--log LOG] [--copy] [--skip-checks] [--verbose]

Run DADA2

optional arguments:
  -h, --help            show this help message and exit

Main:
  -i INPUT_DIR, --input-dir INPUT_DIR
                        Input directory with both R1 and R2
  -f FOR_DIR, --for-dir FOR_DIR
                        Input directory with R1 reads
  -r REV_DIR, --rev-dir REV_DIR
                        Input directory with R2 reads
  -o OUTPUT_DIR, --output-dir OUTPUT_DIR
                        Output directory
  --tmp TMP             Temporary directory

Input filtering:
  --fortag FORTAG       String defining a file as forward [default: _R1]
  --revertag REVERTAG   String defining a file as reverse [default: _R2]
  --sample-separator SAMPLE_SEPARATOR
                        String acting as samplename separator [default: _]
  --sample-extension SAMPLE_EXTENSION
                        String acting as samplename extension [default: .fastq.gz]

DADA2 parameters:
  -q TRUNC_QUAL, --trunc-qual TRUNC_QUAL
                        Truncate at the first occurrence of a base with Q lower [default: 8]
  -j, --join            Join without merging
  -p, --pool            Pool samples
  --trunc-len-1 TRUNC_LEN_1
                        Position at which to truncate forward reads [default: 0]
  --trunc-len-2 TRUNC_LEN_2
                        Position at which to truncate reverse reads [default: 0]
  --trim-left-1 TRIM_LEFT_1
                        Number of nucleotide to trim from the beginning of forward reads [default: 0]
  --trim-left-2 TRIM_LEFT_2
                        Number of nucleotide to trim from the beginning of reverse reads [default: 0]
  --maxee-1 MAXEE_1     Maximum expected errors in forward reads [default: 1.0]
  --maxee-2 MAXEE_2     Maximum expected errors in reverse reads [default: 1.00]
  --chimera {none,pooled,consensus}
                        Chimera handling can be none, pooled or consensus [default: pooled]
  --min-parent-fold MIN_PARENT_FOLD
                        Minimum abundance of parents of a chimeric sequence (>1.0) [default: 1.0]
  --n-learn N_LEARN     Number of reads to learn the model, 0 for all [default: 0]

Other parameters:
  -t THREADS, --threads THREADS
                        Number of threads
  --keep-temp           Keep temporary files
  --save-rds            Save RDS file with DADA2 output
  --save-plots          Save Quality plots of the input reads (PDF)
  --log LOG             Log file
  --copy                Copy input files instead of symbolic linking
  --skip-checks         Do not check installation of dependencies
  --verbose             Verbose mode
```

## Output files

The output directory will contain:

* dada2.stats (table with the statistics of reads loss)
* dada2.tsv (main feature table)
* dada2.rds (R object with the table. if `--save-rds` is specified)
* quality_R1.pdf, quality_R2.pdf (quality plots, if `--save-plots` is specified)
* dada2.execution.log, dada2.execution.txt (wrapper log files)
