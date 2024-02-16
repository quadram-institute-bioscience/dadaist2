#!/usr/bin/env python
"""
USAGE: transpose.py [options] Table.tsv

INPUT (percentages, but this is not assumed):
Family                  NHP6    NHP18   NHP15   NHP11   All
"Prevotellaceae"        19.5    0.0106  58.4    41.4    24.4
(Unassigned)            14.1    3.69    5.64    11.4    21.5
Ruminococcaceae         14.8    0       7.33    12      15.2
Lachnospiraceae         31      0.201   11.7    14.5    14.6
Veillonellaceae         5.16    0.0053  3.77    7.02    4.0
"Porphyromonadaceae"    0.469   18.6    0.587   0.6     2.6

Import a TSV table (taxonomy summary by USEARCH), having samples in columns and OTU/ASVs in rows
 - use first column as index key (feature name), 
 - remove rows where the sum is below a threshold,
 - transpose (samples as rows)
 - sort rows by names (sample name)

 
"""
import numpy as np
import pandas
import sys
import argparse

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

if __name__ == "__main__":

  parser = argparse.ArgumentParser(description='Transpose table for MultiQC')
  parser.add_argument('-m', '--minsum', help="Minimum sum of abundances of a taxon rank", default=0.0)
  parser.add_argument('-t', '--toptaxa', help="Print top N taxa in each sample, and collapse the others in 'Other'.", default=0)
  parser.add_argument('-g', '--global-top', help="When using toptaxa, print the global top N taxa", action="store_true")
  parser.add_argument('-l', '--other-label', help="Name for the new category for unclassified counts", default="Other")
  parser.add_argument('TABLE',  help='Input file name')
  args = parser.parse_args()

  try:
    # Import TSV, use first column as index, remove column "All"
    # note: To set rownames posteriori: set_index(list(table)[0]), or by name set_index('Column_name')
    table = pandas.read_csv(args.TABLE,delimiter='\t',encoding='utf-8', index_col=0).drop(labels='All', axis=1)
    eprint(f" * Imported {args.TABLE}: {table.shape}")
  except Exception as e:
    eprint(f"Error trying to import {args.TABLE}:\n{e}")
    exit()

  
  if (float(args.minsum) > 0.0) and (int(args.toptaxa) > 0):
    eprint("Please, specify either --minsum MIN or --toptaxa NUM")
    exit()
  elif float(args.minsum) > 0.0:
    eprint(f" * Min sum filter (min: {args.minsum})")
    other = table.where( table.lt(float(args.minsum) )  ).sum(axis=0)
    table[table.lt(float(args.minsum))] = 0  
    table = table.transpose()
    table[args.other_label] = other
  elif int(args.toptaxa) > 0:
    if args.global_top:
      eprint(f" * Global top taxa filter (top: {args.toptaxa})")
      table["sums"]=table.sum(axis=1)
      table=table.sort_values(by=["sums"],ascending=False)
      other=table.iloc[int(args.toptaxa):len(table.index)].sum()
      toptaxa_table=table.iloc[0:int(args.toptaxa)]
      table = toptaxa_table.transpose().drop("sums", axis=0)
      table[args.other_label] = other
    else:
      eprint(f" * Top taxa per sample filter (top: {args.toptaxa})")
      m = np.argsort(np.argsort(-table, axis=0), axis=0) < int(args.toptaxa)
      new = table.where(m, 0)
      new.loc[args.other_label] = table.mask(m).sum()
      table = new.transpose()
  else:
    table = table.transpose()
 
  print(table.to_csv(sep='\t'), end='')
