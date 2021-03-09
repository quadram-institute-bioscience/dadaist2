#!/bin/bash

TEST_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
set -euo pipefail
eval "echo | pod2markdown"

COUNT=0
if [[ $? == 0 ]];
then
  echo "Trying to make docs"
  for script in $(grep "=head." $TEST_DIR/../bin/* $TEST_DIR/docs/*.pod | cut -d: -f1 | sort | uniq);#dadaist2 makeSampleSheet dadaist2-getdb dadaist2-exporter;
  do
    COUNT=$((COUNT+1))
    basename=$(basename $script  |cut -f1 -d.)
    echo "> $basename"
    echo " * $script -> $TEST_DIR/../docs/pages/$basename.md"
    echo "---"                > "$TEST_DIR"/../docs/pages/$basename.md
    echo "sort: $COUNT"      >> "$TEST_DIR"/../docs/pages/$basename.md
    echo "---"               >> "$TEST_DIR"/../docs/pages/$basename.md
    pod2markdown < "$script" >> "$TEST_DIR"/../docs/pages/$basename.md
    #sed -i ".bak" 's/^# /## /g'  "$TEST_DIR/../docs/pages/$script.md"
    cat "$TEST_DIR"/../docs/pages/$basename.md | \
       perl -ne  'if ($_=~/^#\s+(\S)(.+)/) {print "## ", $1,lc($2);} else {print "$_"} ' \
       > "$TEST_DIR"/../docs/pages/$basename.x
    mv  "$TEST_DIR"/../docs/pages/$basename.x "$TEST_DIR"/../docs/pages/$basename.md
    sed -i ".bak" "s/Name/$basename/" "$TEST_DIR"/../docs/pages/$basename.md
    rm "$TEST_DIR/../docs/pages/$basename.md.bak"
  done
else
  echo pod2markdown returned $?
fi


