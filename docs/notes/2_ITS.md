---
sort: 2
---

# ITS analysis

Dadaist2 has been designed to fully support variable lenght amplicons, including fungal ITS.

This is possible with:
* a primer removal tool that will detect and discard concatamers (fu-primers)
* the possibility to skip pair-end merging (with `--just-concat`, or `-j` for short) and to re-join when possible
* support for taxonomy assignment in non contiguous sequences
