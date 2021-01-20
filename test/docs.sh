#!/bin/bash

TEST_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
set -exuo pipefail
eval "echo | pod2markdown"
if [[ $? == 0 ]];
then
	echo "Trying to make docs"
  for script in dadaist2 makeSampleSheet dadaist2-getdb;
  do
    echo " * $script -> $TEST_DIR/../docs/pages/$script.md"
    pod2markdown < "$TEST_DIR"/../bin/$script > "$TEST_DIR"/../docs/pages/$script.md
    #sed -i ".bak" 's/^# /## /g'  "$TEST_DIR/../docs/pages/$script.md"
    cat "$TEST_DIR/../docs/pages/$script.md" | perl -ne  'if ($_=~/^#\s+(\S)(.+)/) {print "## ", $1,lc($2);} else {print "$_"} '  > "$TEST_DIR"/../docs/pages/$script.x
    mv $TEST_DIR/../docs/pages/$script.x "$TEST_DIR"/../docs/pages/$script.md
    sed -i ".bak" "s/Name/$script/" "$TEST_DIR"/../docs/pages/$script.md
    rm "$TEST_DIR/../docs/pages/$script.md.bak"
  done
else
  echo pod2markdown returned $?
fi
