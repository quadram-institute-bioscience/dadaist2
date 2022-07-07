---
sort: 18
---
## dadaist2-mergeseqs
This tool merges the two paired end denoised sequences as they appear in 
a DADA2 feature table when asking DADA2 not to join the reads.

## Synopsis

     Combine pairs in DADA2 unmerged tables

     Usage: 
     dadaist2-mergeseqs [options] -i dada2.tsv 

     Options:
       -i, --input-file FILE      FASTA or FASTQ file
       -f, --fasta FILE           Write new sequences to FASTA
       -p, --pair-spacer STRING   Pairs separator [default: NNNNNNNNNN]
       -s, --strip STRING         Remove this string from sample names
       -n, --seq-name STRING      Sequence string name [default: MD5]
       -m, --max-mismatches INT   Maximum allowed mismatches [default: 0]
       --id STRING                Features column name [default: #OTU ID]
       --verbose                  Print verbose output
    

## Input

The TSV table produced by DADA2 (first column with the actual representative sequence, each following column
with the counts per sample). 
Here a truncated example:

    #OTU ID       A01_R1.fastq.gz A02_R1.fastq.gz F99_R1.fastq.gz
    GGAATTTTG[..]GGGCTTAACCTNNNNNNNNNNGCGCTTA [..]AAACAG  1263    1544    1341
    GGAATCTTC[..]TTGGCTCAACCNNNNNNNNNNAGCGCAGG[..]AAACAG  100     21      19
    GGAATTTTGG[..]CTTAACCTNNNNNNNNNNGCGCAGGCGG[..]AAACAG  490 24  296

A stretch of **Ns** separates the denoised `_R1` sequence and the denoise `_R2`.

## Output

The output is a similar table after joining the reads, when possible.
If using `--verbose` a summary will be printed to the standard error at
the end.

    Total:8;Split:8;Joined:8
