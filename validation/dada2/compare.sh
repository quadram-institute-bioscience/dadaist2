set -exuo pipefail

# Script to obtain the venn diagram of common OTUs
# between multiple datasets

PERC=0.05
./bycount.py --minperc $PERC -t qiime2_2021.2-table.tsv -f qiime2_2021.2-seqs.fasta -o test1 -p qiime > qiime_relabel.fasta
./bycount.py --minperc $PERC -t dada2native-table.tsv -f dada2native-seqs.fasta  -o test2 -p dada > dada2_relabel.fasta
./bycount.py --minperc $PERC -t dadaist080_notrim_pool-table.tsv -f dadaist080_notrim_pool-seqs.fasta -o test3 -p dadaist > dadaist080_relabel.fasta

cat *_relabel.fasta > concatenate_rel.fasta

cd-hit-est -i concatenate_rel.fasta -o concatenate -c 0.999 -p 400

./parseclust.py  -i concatenate.clstr | cut -f 3 | sort | uniq -c | sort -n