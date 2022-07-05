#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
bash Miniconda3-latest-MacOSX-x86_64 -b -p $HOME/miniconda
echo $(date) > $SCRIPT_DIR/stamp.txt
ls -l  $HOME/miniconda >> $SCRIPT_DIR/stamp.txt
