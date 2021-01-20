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

## Provided scripts

**dadaist2** will install the following programs:

* `dadaist2`, the main program
* `dadaist2-getdb`, a helper to download reference databases
* `makeSampleSheet`, a helper tool to draft a sample sheet
