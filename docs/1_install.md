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
## Developmental snapshot

We recomment to use Miniconda also to test the last developmental snapshot, as Miniconda
can create an environment with all the required dependencies, then the binaries from the
repository can be used instead:

```bash
conda create -n dadaist-last -c conda-forge -c bioconda --only-deps dadaist2 multiqc
git clone https://github.com/quadram-institute-bioscience/dadaist2
export PATH=$PWD/dadaist2/bin:$PATH
```

## Provided scripts

**dadaist2** will install the following programs:

* `dadaist2`, the main program
* `makeSampleSheet`, a helper tool to draft a sample sheet
* `dadaist2-...`, a set of wrappers and tools all using the _dadaist2-_ prefix to make them easy to find (using [TAB](https://www.howtogeek.com/195207/use-tab-completion-to-type-commands-faster-on-any-operating-system/))
