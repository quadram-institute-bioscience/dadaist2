#!/bin/bash
DECIPHER_REF=refs/SILVA_SSU_r138_2019.RData
DADA_REF=refs/silva_nr_v138_train_set.fa.gz
set -euxo pipefail

./bin/dadaist2 -i data/16S/ -o output/tests/no-ref -t 8
./bin/dadaist2 -i data/16S/ -o output/tests/ref-dada -d $DADA_REF -t 8
./bin/dadaist2 -i data/16S/ -o output/tests/ref-decipher -d $DECIPHER_REF -t 8
./bin/dadaist2 -i data/16S/ -o output/tests/no-join-decipher -t 8 -d $DECIPHER_REF
./bin/dadaist2 -i data/16S/ -o output/tests/no-join-dada -t 8 -d $DADA_REF
./bin/dadaist2 -i data/16S/ -o output/tests/ref-dada-skip-qc -t 8 -d $DADA_REF --skip-qc --popup
