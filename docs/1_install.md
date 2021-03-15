---
sort: 1
permalink: /installation
---

# Installation

## Install via Miniconda

The easiest (and recommended) way to install **dadaist2** is from the BioConda repository.
This requires  _Miniconda_ installed ([how to install it](https://docs.conda.io/en/latest/miniconda.html)):

```
conda install -c bioconda dadaist2
```

If you want to keep dadaist2 and its dependencies in a separate environment:

```
conda create -n dadaist -c bioconda dadaist2
# Then type `conda activate dadaist` to use it
```

:warning: Dadaist2 requires a lot of dependencies, and conda is sometimes very slow.
Our recommended procedure is to install _mamba_ first:
```
conda install -c conda-forge -y mamba
mamba create -n dadaist -c bioconda dadaist2
```

### Developmental snapshot

We recomment to use Miniconda also to test the last developmental snapshot, as Miniconda
can create an environment with all the required dependencies, then the binaries from the
repository can be used instead:

```bash
conda create -n dadaist-last -c conda-forge -c bioconda --only-deps dadaist2 multiqc
git clone https://github.com/quadram-institute-bioscience/dadaist2
export PATH=$PWD/dadaist2/bin:$PATH
```

## Singularity definition
To build an image with the latest version from Bioconda the following definition file can be saved as `dadaist-stable.def`:
```
Bootstrap: docker
From: centos:centos7.6.1810

%environment
    source /opt/software/conda/bin/activate /opt/software/conda_env
    export PATH=/opt/software/dadaist2/bin:$PATH
    PERL5LIB=''
    LANG=C
         
%post
    yum -y install epel-release wget which nano curl zlib-devel git free
    yum -y groupinstall "Development Tools"
    mkdir -p /opt/software
    cd /opt/software    
    curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
    sh ./Miniconda3-latest-Linux-x86_64.sh -p /opt/software/conda -b
    /opt/software/conda/bin/conda install -y mamba
    /opt/software/conda/bin/mamba create -c conda-forge -c bioconda  -c aghozlane -p /opt/software/conda_env -y dadaist2-full cutadapt=3.3 qax  r-gunifrac 

%runscript
    exec dadaist2 "$@"
```

and the image built as:
```bash
sudo singularity build dadaist2.simg dadaist2-stable.def
```

### Developmental snapshot
To get the latest code from the repository (and also some databases) here we share a `dadaist2-dev.def` file:
```
Bootstrap: docker
From: centos:centos7.6.1810

%environment
    source /opt/software/conda/bin/activate /opt/software/conda_env
    export PATH=/opt/software/dadaist2/bin:$PATH
    PERL5LIB=''
    LANG=C
         
%post
    yum -y install epel-release wget which nano curl zlib-devel git free
    yum -y groupinstall "Development Tools"
    mkdir -p /dadaist_databases/
    mkdir -p /opt/software
    cd /opt/software  
    curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
    sh ./Miniconda3-latest-Linux-x86_64.sh -p /opt/software/conda -b
    /opt/software/conda/bin/conda config --add channels defaults
    /opt/software/conda/bin/conda config --add channels conda-forge
    /opt/software/conda/bin/conda config --add channels bioconda
    /opt/software/conda/bin/conda install -y mamba
    /opt/software/conda/bin/mamba create  -c aghozlane -p /opt/software/conda_env -y dadaist2-full cutadapt=3.3 qax  r-gunifrac 
    source /opt/software/conda/bin/activate /opt/software/conda_env
    cd /opt/software
    git clone https://github.com/quadram-institute-bioscience/dadaist2
    ./dadaist2/bin/dadaist2-getdb -d "dada2-unite" -o /dadaist_databases/
    ./dadaist2/bin/dadaist2-getdb -d "dada2-unite" -o /dadaist_databases/
    ./dadaist2/bin/dadaist2-getdb -d "decipher-silva-138" -o /dadaist_databases/

%runscript
    exec dadaist2 "$@"
```
and the image built as:
```bash
sudo singularity build dadaist2-dev.simg dadaist2-dev.def
```

## Docker file 
To build an image with the latest version from Bioconda the following definition file can be saved as `Dockerfile`:
```
Bootstrap: docker
From: centos:centos7.6.1810

%environment
    source /opt/software/conda/bin/activate /opt/software/conda_env
    export PATH=/opt/software/dadaist2/bin:$PATH
    PERL5LIB=''
    LANG=C
         
%post
    yum -y install epel-release wget which nano curl zlib-devel git free
    yum -y groupinstall "Development Tools"
    mkdir -p /opt/software
    cd /opt/software    
    curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
    sh ./Miniconda3-latest-Linux-x86_64.sh -p /opt/software/conda -b
    /opt/software/conda/bin/conda install -y mamba
    /opt/software/conda/bin/mamba create -c conda-forge -c bioconda  -c aghozlane -p /opt/software/conda_env -y dadaist2-full cutadapt=3.3 qax  r-gunifrac 

%runscript
    exec dadaist2 "$@"
```

and the image built as:
```bash
sudo singularity build dadaist2.simg dadaist2-stable.def
```

### Developmental snapshot
To get the latest code from the repository (and also some databases) here we share a `dadaist2-dev.def` file:
```
Bootstrap: docker
From: centos:centos7.6.1810

%environment
    source /opt/software/conda/bin/activate /opt/software/conda_env
    export PATH=/opt/software/dadaist2/bin:$PATH
    PERL5LIB=''
    LANG=C
         
%post
    yum -y install epel-release wget which nano curl zlib-devel git free
    yum -y groupinstall "Development Tools"
    mkdir -p /dadaist_databases/
    mkdir -p /opt/software
    cd /opt/software  
    curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
    sh ./Miniconda3-latest-Linux-x86_64.sh -p /opt/software/conda -b
    /opt/software/conda/bin/conda config --add channels defaults
    /opt/software/conda/bin/conda config --add channels conda-forge
    /opt/software/conda/bin/conda config --add channels bioconda
    /opt/software/conda/bin/conda install -y mamba
    /opt/software/conda/bin/mamba create  -c aghozlane -p /opt/software/conda_env -y dadaist2-full cutadapt=3.3 qax  r-gunifrac 
    source /opt/software/conda/bin/activate /opt/software/conda_env
    cd /opt/software
    git clone https://github.com/quadram-institute-bioscience/dadaist2
    ./dadaist2/bin/dadaist2-getdb -d "dada2-unite" -o /dadaist_databases/
    ./dadaist2/bin/dadaist2-getdb -d "dada2-unite" -o /dadaist_databases/
    ./dadaist2/bin/dadaist2-getdb -d "decipher-silva-138" -o /dadaist_databases/

%runscript
    exec dadaist2 "$@"
```
and the image built as:
```bash
sudo singularity build dadaist2-dev.simg dadaist2-dev.def
```

## Provided scripts

**dadaist2** will install the following programs:

* `dadaist2`, the main program
* `makeSampleSheet`, a helper tool to draft a sample sheet
* `dadaist2-...`, a set of wrappers and tools all using the _dadaist2-_ prefix to make them easy to find (using [TAB](https://www.howtogeek.com/195207/use-tab-completion-to-type-commands-faster-on-any-operating-system/))
