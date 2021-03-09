#!/bin/bash
set -euxo pipefail
THREADS=8
OUT="./output/tests/"

mkdir -p ./refs/
if [ ! -e "./refs/silva_nr_v138_train_set.fa.gz" ];  then ./bin/dadaist2-getdb -d dada2-silva-138 -o ./refs/; fi
if [ ! -e "./refs/SILVA_SSU_r138_2019.RData" ];  then ./bin/dadaist2-getdb -d decipher-silva-138 -o ./refs/; fi

if [ ! -e "./refs/UNITE_v2020_February2020.RData" ];  then ./bin/dadaist2-getdb -d decipher-unite-2020 -o ./refs/; fi
if [ ! -e "./refs/uniref.fa.gz" ];  then ./bin/dadaist2-getdb -d dada2-unitek -o ./refs/; fi

  

if [ -d "$OUT/" ];then
  rm -rf "$OUT/*"
else
  echo "Quitting: no output dir";  exit
fi

for DATASET in 16S ITS;
do
  mkdir -p $OUT/$DATASET;
  if [ $DATASET == '16S' ]; then
   PRIMERS='CCTACGGGNGGCWGCAG:GGACTACHVGGGTATCTAATCC';
   DECIPHER_REF=refs/SILVA_SSU_r138_2019.RData
   DADA_REF=refs/silva_nr_v138_train_set.fa.gz
  else
   PRIMERS='CTTGGTCATTTAGAGGAAGTAA:GCTGCGTTCTTCATCGATGC';
   DECIPHER_REF=refs/UNITE_v2020_February2020.RData
   DADA_REF=refs/uniref.fa.gz
  fi

  # No reference
  ./bin/dadaist2 -i data/$DATASET/ -o $OUT/$DATASET/no-ref -t $THREADS --prefix NoRef
  ./bin/dadaist2 -i data/$DATASET/ -o $OUT/$DATASET/ref-dada -d $DADA_REF -t $THREADS --prefix DadaSimple
  ./bin/dadaist2 -i data/$DATASET/ -o $OUT/$DATASET/ref-decipher -d $DECIPHER_REF -t $THREADS --prefix DecipherSimple
  ./bin/dadaist2 -i data/$DATASET/ -o $OUT/$DATASET/ref-decipher-seqfu --primers $PRIMERS  -d $DECIPHER_REF -t $THREADS   --prefix DecipherPrimers
  ./bin/dadaist2 -i data/$DATASET/ -o $OUT/$DATASET/no-join-decipher -t $THREADS -d $DECIPHER_REF --prefix NoJoinDecipher
  ./bin/dadaist2 -i data/$DATASET/ -o $OUT/$DATASET/no-join-dada -t $THREADS -d $DADA_REF --prefix NoJoinDada

done
