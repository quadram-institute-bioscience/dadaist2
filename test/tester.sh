#!/bin/bash
set -euxo pipefail
DB=$HOME/refs/silva_nr_v138_train_set.fa.gz
THREADS=32
mkdir -p output/tmp/
OPTS=" --verbose --debug --tmp-dir output/tmp --fastp --s1 20 --s2 20"
./bin/dadaist2 -r $DB -i data/16S -o output/16S -t $THREADS $OPTS
./bin/dadaist2 -r $DB -i ../dada-test/MiSeq_SOP -o output/miseq -t $THREADS $OPTS

