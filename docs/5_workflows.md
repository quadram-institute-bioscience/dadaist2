---
sort: 5
permalink: /custom-workflows
---
# Dadaist2 as a module provider

Dadaist2 has been released as a set of wrappers to allow implementing some of them
in existing pipelines. 

A minimal example is provided in the `nextflow/simple.nf` Nextflow script, where
we delegate to Nextflow the parallelisation of the input reads trimming with `cutadapt`.

## Example

Running a workflow using Dadaist tools:
```bash
nextflow run simple.nf  -with-singularity dadaist2.simg \
  --reads "data/16S/*_R{1,2}_001.fastq.gz" --ref "refs/SILVA_SSU_r138_2019.RData"  
```

The minimal workflow runs parallelising adaptor trimming and collecting the results
for Dadaist main module:
```text
N E X T F L O W  ~  version 19.10.0
Launching `simple.nf` [angry_celsius] - revision: 053df3283c
Example pipeline
 =======================================
 taxonomy db  : ../refs/SILVA_SSU_r138_2019.RData
 reads        : ../data/16S/*_R{1,2}_001.fastq.gz
 outdir       : dadaist
executor >  slurm (4)
[40/e3e3b7] process > cutadapt (A02_S0_L001) [100%] 3 of 3 ✔
[ef/5bbb6b] process > dada (1)               [  0%] 0 of 1
```

Note that `-with-singularity` makes use of our container that provides:

* All Dadaist wrappers 
* R with commonly used libraries such as DADA2, PhyloSeq, Microbiome, vegan...
* Tools like VSEARCH, cutadapt, fastp, seqfu, multiqc...