#!/usr/bin/env python
"""
Convert UC files to otu table

Example:
H   
5193   
402    
97.5    
+   
0  
0 
377I402M729I 
ERR2730202.5 
Bacteria;Firmicutes;Clostridia;Clostridiales;Lachnospiraceae;
"""

import os, sys
import pandas as pd

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)
    py
if __name__ == "__main__":
    import argparse
    args = argparse.ArgumentParser(description="Convert UC files to otu table")
    args.add_argument("-i", "--input", help="Input UC file", required=True)
    args.add_argument("-o", "--output", help="Output otu table", required=False)
    args.add_argument("-s", "--sample", help="Sample name split char (default: %(default)s)",  default=".", required=False)
    args = args.parse_args()

    # Output file
    if args.output is None:
        out = sys.stdout
    else:
        out = open(args.output, "w")

    # Parse UC file line by line
    f = open(args.input)

    nohits = 0
    otutable = pd.DataFrame(columns=[])
    sample = "Sample"
    for line in f:
        line = line.strip()
        rectype, clust_id, seqlen, perc, strand, _, _, aln, query, target = line.split("\t")
        if rectype == "N":
            nohits += 1
            continue
        if rectype == "H":
            
            if args.sample in query:
                # If read name is in the format SAMPLENAME.ID then split and get samplename (for multisamples)
                sample, readnumber = query.split(args.sample)
            
            # Check if sample is one of the columns else add it
            if sample not in otutable.columns:
                # Add a new column: sample
                otutable[sample] = 0
                
            # check if target is one of the rows else add it
            if target not in otutable.index:
                # Add a new row: target
                otutable.loc[target] = 0
         
            # if sample, target is in otutable, add 1 to the value
            # else initialize to 0

            if sample in otutable.columns and target in otutable.index:
                otutable.loc[target, sample] += 1
            else:
                otutable.loc[target, sample] = 1


    # Print table
    otutable.to_csv(out, sep="\t", index=True, header=True)