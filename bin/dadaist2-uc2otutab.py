#!/usr/bin/env python
"""
Convert UC files to otu table
"""

import os, sys
import pandas as pd

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

if __name__ == "__main__":
    import argparse
    args = argparse.ArgumentParser(description="Convert UC files to otu table")
    args.add_argument("-i", "--input",  help="Input UC file", required=True)
    args.add_argument("-o", "--output", help="Output OTU table [default: STDOUT]", required=False)
    args.add_argument("-s", "--sample", help="Sample name split char [default: %(default)s]",  default=".", required=False)
    args.add_argument("-t", "--top",   help="Print only the first TOP records [default: %(default)s]",  default=0, type=int, required=False)
    args.add_argument("-m", "--min-counts", dest="mincounts",   help="Remove OTUs with less than MIN counts [default: %(default)s]",  default=0, type=int, required=False)
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

    # Add zeroes instead of missing values
    otutable = otutable.fillna(0) 

    # Print all the column names
    eprint("Samples: " + str(len(otutable.columns)))
    eprint("N. OTUs: " + str(len(otutable.index)))

    # Add column "sum" to the dataframe
    otutable["sum"] = otutable.sum(axis=1)
    # Sort by sum
    otutable = otutable.sort_values(by="sum", ascending=False)
    # Drop sum column
    otutable = otutable.drop(columns=["sum"])

    # Print the first INT records
    if args.top > 0:
        otutable = otutable.head(args.top)
    
    if args.mincounts > 0:
        # Remove all rows with less than MIN counts
        otutable = otutable[otutable.sum(axis=1) >= args.mincounts]
        
    # Print table
    otutable.to_csv(out, sep="\t", index=True, header=True)