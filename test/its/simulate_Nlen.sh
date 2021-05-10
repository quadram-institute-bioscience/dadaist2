set -euxo pipefail 

DB=../../refs/uniref.fa.gz
IN=unite-long550-unique.fa
LEN=300
T=8

if [[ ! -e $DB ]]; then
   echo Missing database $DB. Download it first.
   exit 1
fi

if [[ ! -e $IN ]]; then
    echo Missing input files: $IN
    exit 1
fi


mkdir -p ref
~/volume/dadaist2/bin/dadaist2-assigntax  -t $T -i $IN -o ref/ -r $DB
for N in  0 1 6 12 100;
do
 OUT="${N}Ns"
 if [ ! -d "$OUT" ]; then
   mkdir -p $OUT
   perl ~/volume/dadaist2/test/its/simulate-joined.pl $IN -n $N > $OUT/data.fa
   ~/volume/dadaist2/bin/dadaist2-assigntax -r $DB -o $OUT  -i $OUT/data.fa -t $T
 fi
done

paste 0Ns/*tsv  1Ns/*tsv 6Ns/*tsv 12Ns/*tsv 100Ns/*tsv | ~/volume/dadaist2/test/its/compare-tax.pl
