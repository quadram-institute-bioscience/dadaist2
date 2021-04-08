#!/bin/bash
readlinkf(){ perl -MCwd -e 'print Cwd::abs_path shift' "$1";}
TEST_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
BASEDIR=$(readlink -f "$TEST_DIR/.." || readlinkf "$TEST_DIR/..")
SCRIPTS="$BASEDIR/bin"
DATA="$BASEDIR/data/16S/"
INPUT="$DATA/test.fa"
OUT="$BASEDIR/output/"
PASS="\e[32mPASS\e[0m"
FAIL="\e[31m** FAIL **\e[0m"
mkdir -p "$OUT/"

echo '--------------'
echo -e "Test dir:\t$TEST_DIR"
echo -e "Base dir:\t$BASEDIR"
echo -e "Data dir:\t$DATA"
echo -e "Env path:\t$(which env)"
echo -e "Perl path:\t$(which perl)"
echo -e "Perl version:\t$(env perl -v | grep version)"

echo -e "conda_prefix:\t$CONDA_PREFIX"
echo -e "conda_prompt:\t$CONDA_PROMPT_MODIFIER"
echo -e "current_path:\t$PWD"
echo -e "list_binaries:\t"$(ls "$SCRIPTS")
echo '--------------'

set -eux pipefail

# TEST: NO TAXONOMY
echo " [1] Test basic settings"
perl "$SCRIPTS"/dadaist2 -i "$DATA" -o "$OUT"/no-tax --tmp-dir "$BASEDIR" > /dev/null 2>&1 || echo "dadaist failed: debugging"

ERRORS=0
if [[ -d "$OUT"/no-tax ]]; then
	printf  " * $PASS: Output directory created\n";
else
	ERRORS=$((ERRORS+1)); printf  " * $FAIL: Output directory not created\n";
fi

if [[ -e "$OUT"/no-tax/dadaist.log ]]; then
	printf  " * $PASS: Log was produced\n";
else
	ERRORS=$((ERRORS+1)); printf  " * $FAIL: Log file not found\n";
fi


if [[ -e "$OUT"/no-tax/feature-table.tsv ]]; then
	printf  " * $PASS: dada2 output found\n";
else
	ERRORS=$((ERRORS+1))
	printf  " * $FAIL: dada2 output not found\n";
fi

if [[ -e "$OUT"/no-tax/rep-seqs.tree ]]; then
	printf  " * $PASS: tree found\n";
else
	ERRORS=$((ERRORS+1))
	printf  " * $FAIL: tree not found\n";
fi

# --
# TEST: Taxonomy

echo " [2] Test with taxonomy assignments"
if [ -e "$BASEDIR/refs/rdp_train_set_16.fa.gz" ];
	then
	perl "$SCRIPTS"/dadaist2  -d "$BASEDIR/refs/rdp_train_set_16.fa.gz" -i "$DATA" -o "$OUT"/output-dada-taxonomy --tmp-dir "$BASEDIR" > /dev/null  2>&1 || echo "dadaist failed: debugging"

	ERRORS=0
	if [[ -d "$OUT"/output-dada-taxonomy ]];
	then
		printf  " * $PASS: Output directory created\n";
	else
		ERRORS=$((ERRORS+1))
		printf  " * $FAIL: Output directory not created\n";
	fi
	if [ -e "$OUT"/output-dada-taxonomy/dadaist.log ];
	then
		printf  " * $PASS: Log was produced\n";
	else
		ERRORS=$((ERRORS+1))
		printf  " * $FAIL: Log file not found\n";
	fi



	if [ -e "$OUT"/output-dada-taxonomy/feature-table.tsv ];
	then
		printf  " * $PASS: dada2 output found\n";
	else
		ERRORS=$((ERRORS+1))
		printf  " * $FAIL: dada2 output not found\n";
	fi

	if [ -e "$OUT"/output-dada-taxonomy/taxonomy.txt ];
	then
		printf  " * $PASS: dada2 taxonomy found\n";
	else
		ERRORS=$((ERRORS+1))
		printf  " * $FAIL: dada2 taxonomy not found\n";
	fi
fi

# TEST: Assign Taxonomy
echo " [3] Test taxonomy assignment with DADA"
FASTA_INPUT="$BASEDIR/data/repseqs/rep-seqs.fasta"
DADAREF="$BASEDIR"/refs/silva_nr_v138_train_set.fa.gz
DECIREF="$BASEDIR"/refs/SILVA_SSU_r138_2019.RData
if [[ -e "$DADAREF" ]]; then
  perl "$SCRIPTS"/dadaist2-assigntax -r "$DADAREF" -i "$FASTA_INPUT" -o "$OUT"/taxonomy-dada/
fi

echo " [3] Test taxonomy assignment with DECIPHER"

if [[ -e "$DECIREF" ]]; then
  perl "$SCRIPTS"/dadaist2-assigntax -r "$DECIREF" -i "$FASTA_INPUT" -o "$OUT"/taxonomy-decipher/
fi



# END
if [ $ERRORS -gt 0 ]; then
	printf " * $FAIL: $ERRORS ERRORS FOUND\n"
	cat "$BASEDIR/output/dadaist.log"
	exit 1
else
  rm -rf "$BASEDIR"/dadaist2_??????/ || true
fi

#rm -rf "$OUT"/{no-tax,output-taxonomy} || true
