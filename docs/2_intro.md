---
sort: 2
permalink: /introduction
---

# Dadaist2 features

## Fast track to R and numerical ecology

Dadaist is a simple and modular toolkit to streamline the generation of
plots and analyses for microbiome studies, based on the popular DADA2
algorithm for reads denoising.

What makes Dadaist an interesting alternative to other suites is the focus on reproducible downstream analyses (thanks to the automatic generation of a PhyloSeq object and the preparation of files ready to be analysed with MicrobiomeAnalyst or Rhea)

<img src="img/scheme_small.png">

## Advanced logs and notifications

Dadaist2 is both a collection of tools (to create your own pipeline, for example using NextFlow) and a standalone 
pipeline designed to be easy to run from a local computer. 


![Popup](img/popup.png)

* Colored terminal output to follow the progress of the pipeline
* Optional notification popups to follow the progress of the major steps while doing something else
* Regular text logs are also collected in an [easy to browse HTML report](example-log.html). 

## Long amplicons workflow

A custom DADA2 workflow that does not rely on read merging to identify molecular species
longer than the sequencing reads lenght.