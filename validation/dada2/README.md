# DADA2 validation

DADA2 provides a [tutorial](https://benjjneb.github.io/dada2/tutorial_1_8.html)
based on [Mothur SOP dataset](https://mothur.org/wiki/miseq_sop/).


### Get the reads

We will store the reads in a directory called `subsample`:
```
wget "https://mothur.s3.us-east-2.amazonaws.com/wiki/miseqsopdata.zip"
unzip miseqsopdata.zip
mv MiSeq_SOP subsample/
```

### Run DADA2 natively
```bash
# Set DADAIST as the path to the repository of Dadaist2
mkdir -p dada-subsample
Rscript $DADAIST/test/miseq-sop-compare/dada2-sop.R subsample/ dada-subsample/
```

### Run DADA2 via Qiime2 2021.2
```
qiime tools import \
  --type SampleData[PairedEndSequencesWithQuality] \
  --input-path subsample-for-qiime/ \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path demux-paired-end.qza

qiime dada2 denoise-paired \
  --i-demultiplexed-seqs demux-paired-end.qza \
  --p-trunc-len-f 230 \
  --p-trunc-len-r 154 \
  --p-trim-left-f 0 \
  --p-trim-left-r 0 \
  --p-trunc-q 2 \
  --o-representative-sequences rep-seqs.qza \
  --o-table table.qza \
  --o-denoising-stats stats-dada2.qza \
  --p-n-threads 32
```

### Run DADA2 via Dadaist2

The initial test has been done with version **0.8.0**.

```bash
# Default parameters (fastp)
dadaist2 -r $DADAIST/refs/silva_v138.fa.gz \
  -i subsample/ \
  -o dadaist_0.8.0/subsample-silva-default \
  -m metadata.tsv \
  -t 32

# Skip primer trimming and pool samples for DADA (as DADA2 workflow does)
dadaist2 -r $DADAIST/refs/silva_v138.fa.gz \
  -i subsample/ \
  -o dadaist_0.8.0/subsample-silva-notrim-pool \
  --no-trim --dada-pool \
  -m metadata.tsv \
  -t 32
```


## Comparison of the results

The three pipelines produced similar feature tables
and representative sequences. The FASTA file stats are:

```text
┌────────────────────┬──────┬──────────┬───────┬─────┬─────┬─────┬──── ───┬─────┬─────┐
│ File               │ #Seq │ Total bp │ Avg   │ N50 │ N75 │ N90 │ auN    │ Min │ Max │
├────────────────────┼──────┼──────────┼───────┼─────┼─────┼─────┼────────┼─────┼─────┤
│ dada2_relabel      │ 137  │ 34644    │ 252.9 │ 253 │ 253 │ 252 │ 9.2383 │ 251 │ 255 │
│ dadaist080_relabel │ 138  │ 34902    │ 252.9 │ 253 │ 253 │ 252 │ 9.1701 │ 251 │ 255 │
│ qiime_relabel      │ 136  │ 31671    │ 232.9 │ 233 │ 233 │ 232 │ 8.5710 │ 231 │ 235 │
└────────────────────┴──────┴──────────┴───────┴─────┴─────┴─────┴────────┴─────┴─────┘
```

Qiime2 produced slighly shorter sequences because of trimming.

The files are merged and clustered using the `compare.sh` script.

The output is:
```text
      1   dada
      2   dada;dadaist
      2   dadaist;qiime
     11   dadaist
     15   dada;qiime
    119   dada;dadaist;qiime
```

80% of the sequences are identical among the samples