---
sort: 5
permalink: /custom-workflows
---

# Advanced usage 

## Use in HPC clusters

The supported installation of _Dadaist2_ is via Bioconda:
* The package can be natively installed via `conda` in the user's home
* A singularity (or Docker) image can be generated as suggested in the [installation page](../installation).
  

## Dadaist2 as a module provider

Dadaist2 has been released as a set of wrappers to allow implementing some of them
in existing pipelines. 

A minimal example is provided in the `nextflow/simple.nf` Nextflow script 
([link](https://github.com/quadram-institute-bioscience/dadaist2/tree/master/nextflow)), where
we delegate to Nextflow the parallelisation of the input reads trimming with `cutadapt`.

### Example

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
 taxonomy db  : refs/SILVA_SSU_r138_2019.RData
 reads        : data/16S/*_R{1,2}_001.fastq.gz
 outdir       : dadaist
executor >  slurm (4)
[81/39e622] process > cutadapt (F99_S0_L001) [100%] 3 of 3, cached: 3 ✔
[19/e589db] process > dada (1)               [100%] 1 of 1, cached: 1 ✔
[5a/893a7d] process > phyloseq (1)           [100%] 1 of 1 ✔
[ae/bd2ecb] process > normalize-alpha (1)    [100%] 1 of 1 ✔
```

Note that `-with-singularity` makes use of our container that provides:

* All Dadaist wrappers 
* R with commonly used libraries such as DADA2, PhyloSeq, Microbiome, vegan...
* Tools like VSEARCH, cutadapt, fastp, seqfu, multiqc...