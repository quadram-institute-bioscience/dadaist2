#!/bin/bash

TEST_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
BASEDIR="$TEST_DIR/.."
SCRIPTS="$BASEDIR/bin"
DATA="$TEST_DIR/../data/"
INPUT="$DATA/test.fa"
PASS="\e[32mPASS\e[0m"
FAIL="\e[31m** FAIL **\e[0m"

echo -e "Env path:\t$(which env)"
echo -e "Perl path:\t$(which perl)"
echo -e "Perl version:\t$(env perl -v | grep version)"

echo -e "conda_prefix:\t$CONDA_PREFIX"
echo -e "conda_prompt:\t$CONDA_PROMPT_MODIFIER"
echo -e "current_path:\t$PWD"
echo -e "list_binaries:\n"$(ls "$SCRIPTS")
echo ''

set -x pipefail

perl "$SCRIPTS"/dadaist2 -i "$BASEDIR"/data -o "$BASEDIR"/output --tmp-dir "$BASEDIR" || echo "dadaist failed: debugging"

ERRORS=0
if [ -d "$BASEDIR/output/" ];
then
	printf  " * $PASS: Output directory created\n";
else
	ERRORS=$((ERRORS+1))
	printf  " * $FAIL: Output directory not created\n";
fi
if [ -e "$BASEDIR/output/dadaist.log" ];
then
	printf  " * $PASS: Log was produced\n";
else
	ERRORS=$((ERRORS+1))
	printf  " * $FAIL: Log file not found\n";
fi

if [ -e "$BASEDIR/output/A01.json" ];
then
	printf  " * $PASS: fastp output found\n";
else
	ERRORS=$((ERRORS+1))
	printf  " * $FAIL: fastp output not found\n";
fi

if [ -e "$BASEDIR/output/feature-table.tsv" ];
then
	printf  " * $PASS: dada2 output found\n";
else
	ERRORS=$((ERRORS+1))
	printf  " * $FAIL: dada2 output not found\n";
fi
if [ $ERRORS -gt 0 ]; then
	printf " * $FAIL: $ERRORS ERRORS FOUND\n"
	cat "$BASEDIR/output/dadaist.log"
	exit 1
fi