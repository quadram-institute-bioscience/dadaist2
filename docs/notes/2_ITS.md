---
sort: 2
---

# ITS analysis

Dadaist2 has been designed to fully support variable lenght amplicons, including fungal ITS.

This is possible with:
* a primer removal tool that will detect and discard concatamers (fu-primers)
* the possibility to skip pair-end merging (with `--just-concat`, or `-j` for short) and to re-join when possible using `dadaist2-mergeseqs`, that takes DADA2 feature table as input.
* support for taxonomy assignment in non contiguous sequences

## Why are ITS amplicons different?

They are not.

**16S rDNA** is the most common target for metabarcoding, and while there are several possible primer-pairs available, the commonly accepted 
_rule of the thumb_ is to choose a primer pair that will produce and amplicon shorter than the length of the two paired end sequences
(if adopting paired-end), to ensure that the two fragments will be merged. This is possible because 16S rDNA is highly conserved in length
and the majority of the variation observed in the commonly sequenced areas is mostly due to sequence alterations, not insertions and deletions.

**ITS amplicons** (and other targets) have a wider variability in length. This has a very annoying effect immediately when preparing the libraries:
the shorter targets will be amplified with higher efficiency, making the amplification bias worse than it already is with less variable targets.

In short: with "ITS protocol" here we refer to "amplicons highly variable in length".

## How to analyse ITS amplicons

*TLDR*: simply add the `-j` flag (or `--just-concat`) when running the analysis.

Dadaist2 provides support for the denoising mode of DADA2 where the two pairs are not merged. This mode is not supported - for example - in the
Qiime2 plugin.

DADA2 itself can either merge or [not](https://github.com/benjjneb/dada2/issues/279), while Dadaist2 will merge the representative sequences
that overlap, leaving unmerged those which don't.

## Increased sensitivity: a simulation

We downloaded the [UNITE database](https://unite.ut.ee/repository.php) (95,481 sequence) and performed
an _in silico_ PCR using ITS1 and ITS4 primers as follows:
```
seqkit amplicon -F CTTGGTCATTTAGAGGAAGTAA -R GCTGCGTTCTTCATCGATGC unite.fasta > unite-amplicons.fa
```

this generated  2,833 sequences (of which 2,629 unique), with the following metrics:

```text
seqfu stats --nice --basename unite.fa unite-amplicons.fa
┌─────────────────┬────────┬────────────┬───────┬─────┬─────┬─────┬────────┬─────┬──────┐
│ File            │ #Seq   │ Total bp   │ Avg   │ N50 │ N75 │ N90 │ auN    │ Min │ Max  │
├─────────────────┼────────┼────────────┼───────┼─────┼─────┼─────┼────────┼─────┼──────┤
│ unite           │ 95,481 │ 59,469,042 │ 622.8 │ 595 │ 522 │ 479 │ 73.827 │ 141 │ 7491 │
│ unite-amplicons │ 2,833  │ 842,403    │ 297.4 │ 295 │ 266 │ 235 │ 63.436 │ 171 │ 1159 │
└─────────────────┴────────┴────────────┴───────┴─────┴─────┴─────┴────────┴─────┴──────┘
```

As we can see, there are sequences larger than 600 bp, so without any overlap in MiSeq 2x300 sequencing.
Considering at least 20 bases of overlap, there are 53 unique sequences longer than 550 bases.

```bash
seqfu derep unite-amplicons.fa --min-length 580  | seqfu stats
```

### Results

The resulting file was re-classified using DECIPHER (via `dadaist2-assigntax`) to check how the sequences would be classified if provided in full (only unique classifiactions are kept here):
```text
Fungi Ascomycota Dothideomycetes Asterinales Asterinaceae Blastacervulus
Fungi Ascomycota Dothideomycetes Capnodiales Mycosphaerellaceae Scleroramularia
Fungi Ascomycota Eurotiomycetes Chaetothyriales Herpotrichiellaceae Cladophialophora
Fungi Ascomycota Eurotiomycetes Chaetothyriales Herpotrichiellaceae Exophiala
Fungi Ascomycota Eurotiomycetes Chaetothyriales unidentified_434 unidentified_304
Fungi Ascomycota Eurotiomycetes Eurotiales Trichocomaceae Rasamsonia
Fungi Ascomycota Eurotiomycetes Phaeomoniellales Phaeomoniellaceae Pseudophaeomoniella
Fungi Ascomycota Geoglossomycetes Geoglossales Geoglossaceae Geoglossum
Fungi Ascomycota Lecanoromycetes Lecanorales Cladoniaceae Cladonia
Fungi Ascomycota Leotiomycetes Helotiales Chrysodiscaceae Chrysodisca
Fungi Ascomycota Leotiomycetes Helotiales Dermateaceae Calloria
Fungi Ascomycota Leotiomycetes Helotiales Dermateaceae Parafabraea
Fungi Ascomycota Leotiomycetes Helotiales Dermateaceae Pseudofabraea
Fungi Ascomycota Leotiomycetes Helotiales Helotiaceae Hymenoscyphus
Fungi Ascomycota Leotiomycetes Helotiales Helotiaceae Phaeohelotium
Fungi Ascomycota Leotiomycetes Helotiales Helotiales_fam_Incertae_sedis Chalara
Fungi Ascomycota Leotiomycetes Helotiales Helotiales_fam_Incertae_sedis Vestigium
Fungi Ascomycota Leotiomycetes Helotiales Hyaloscyphaceae Capitotricha
Fungi Ascomycota Leotiomycetes Helotiales Hyaloscyphaceae Incrucipulum
Fungi Ascomycota Leotiomycetes Helotiales Hyaloscyphaceae Lachnum
Fungi Ascomycota Leotiomycetes Helotiales Hyaloscyphaceae unidentified_191
Fungi Ascomycota Leotiomycetes Helotiales Leotiaceae Pezoloma
Fungi Ascomycota Leotiomycetes Helotiales Myxotrichaceae Oidiodendron
Fungi Ascomycota Leotiomycetes Helotiales unidentified_8 unidentified_5
Fungi Ascomycota Orbiliomycetes Orbiliales Orbiliaceae Dactylella
Fungi Ascomycota Orbiliomycetes Orbiliales Orbiliaceae Hyalorbilia
Fungi Ascomycota Orbiliomycetes Orbiliales Orbiliaceae Orbilia
Fungi Ascomycota Orbiliomycetes Orbiliales Orbiliaceae unidentified_448
Fungi Ascomycota Pezizomycetes Pezizales Sarcosomataceae Donadinia
Fungi Ascomycota Saccharomycetes Saccharomycetales unidentified_72 unidentified_51
Fungi Ascomycota Sordariomycetes Chaetosphaeriales Chaetosphaeriaceae Chloridium
Fungi Ascomycota Sordariomycetes Xylariales Xylariaceae Annulohypoxylon
Fungi Ascomycota unidentified unidentified unidentified unidentified
Fungi Basidiomycota Agaricomycetes Hymenochaetales Hymenochaetaceae Coltricia
Fungi Basidiomycota Agaricomycetes Polyporales unidentified_544 unidentified_376
Fungi Basidiomycota Agaricomycetes Russulales Lachnocladiaceae Dichostereum
Fungi Basidiomycota Cystobasidiomycetes Erythrobasidiales Erythrobasidiaceae Bannoa
Fungi Mucoromycota Endogonomycetes GS22 unidentified_1771 unidentified_1228
```

Then the same fasta FILE has been processed to simulate a joining of paired end, so the first and last 300 bp
have been kept while replacing the middle part with Ns.

Taxonomy classification didnt change.

The files are in `./test/its` in the repository:
* `taxonomy.tsv` is the classification of unique amplicons > 550bp
* `join/taxonomy.tsv` is the classification of amplicons after joining the first and the last 300 bp
