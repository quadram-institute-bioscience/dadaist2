#!/bin/bash

SRC=~/MEGA/bambi/reads_non_casava
mkdir -p ITS

for i in P119P P143V P143Y; 
do 
  for j in 1 2; 
  do 
    OUT=${i}_R${j}.fq
    if [ -e "ITS/$OUT.gz" ]; then
      rm ITS/$OUT.gz
    fi
    echo " Generating $OUT"
    seqfu head -n 2000 -k 97 $SRC/${i}*_R${j}*gz > ITS/$OUT;
    gzip ITS/$OUT
  done;
done
