# DADA2 validation

DADA2 provides a [tutorial](https://benjjneb.github.io/dada2/tutorial_1_8.html)
based on [Mothur SOP dataset](https://mothur.org/wiki/miseq_sop/).


## Get the reads

We will store the reads in a directory called `subsample`:
```
wget "https://mothur.s3.us-east-2.amazonaws.com/wiki/miseqsopdata.zip"
unzip miseqsopdata.zip
mv MiSeq_SOP subsample/
```

## Run DADA2 natively
```bash
# Set DADAIST as the path to the repository of Dadaist2
Rscript $DADAIST/test/miseq-sop-compare/dada2-sop.R subsample/ dada-subsample/
```

## Run DADA2 via Qiime2 2021.2
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
  --p-trim-left-f 10 \
  --p-trim-left-r 10 \
  --p-trunc-q 2 \
  --o-representative-sequences rep-seqs.qza \
  --o-table table.qza \
  --o-denoising-stats stats-dada2.qza \
  --p-n-threads 32
```

## Run DADA2 via Dadaist2

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