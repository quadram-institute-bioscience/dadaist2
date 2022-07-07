#!/bin/bash

if [[ -z ${1+x} ]]; then
  VER=1.2.4
else
  VER=$1
fi

echo $VER

mamba create  -n dadaist2-${VER} -y  -c conda-forge -c bioconda dadaist2=1.2.4 seqfu=1.12.0 \
 fastp=0.23.1 cutadapt=3.5 fasttree=2.1.10 bioconductor-dada2=1.18.0 \
 bioconductor-decipher=2.18.1 bioconductor-phyloseq=1.34.0 bioconductor-microbiome=1.12.0 \
 biom-format=2.1.10  pandas=1.3.4 wget

echo Exporting to dadaist2-${VER}-$(uname).yaml
conda env export -n dadaist2-${VER} --no-builds | grep -v ^prefix: > dadaist2-${VER}-$(uname).yaml
conda env remove -n dadaist2-${VER}
