#!/usr/bin/env python3
"""
Load a FASTA rep-seq file and a feature table (firt colun is  #OTU ID)
and reprint the FASTA file adding the percentage of the OTU/ASV in the
total dataset (sum of all samples).
"""

import pandas


def read_fasta(path):
	import gzip
	name = None
	with (gzip.open if path.endswith('.gz') else open)(path, 'rt') as fasta:
		for line in fasta:
			if line.startswith('>'):
				if name is not None:
					yield name, seq
				name = line[1:].rstrip()
				seq = ''
			else:
				seq += line.rstrip()
	yield name, seq
 

if __name__ == "__main__":
  import argparse
  opt_parser = argparse.ArgumentParser(description='Top otus')
  opt_parser.add_argument('-t', '--table',help='OTU table filename', 	required=True)
  opt_parser.add_argument('-f', '--fasta',help='OTU fasta', 	required=True)
  opt_parser.add_argument('-o', '--output', help='output file', required=True)
  opt_parser.add_argument('-m', '--minperc', help='minimum percentage', default=1.0)
  opt_parser.add_argument('-p', '--prefix', help='sequence prefix')
  opt_parser.add_argument('--id', help='Header id', default='#OTU ID')
  opt = opt_parser.parse_args()
  try:
    data = pandas.read_csv(opt.table, sep='\t', header=0, index_col=0)
    data = (data.assign(sum=data.sum(axis=1))  # Add temporary 'sum' column to sum rows.
        .sort_values(by='sum', ascending=False)  # Sort by row sum descending order.
        ) 

 
    otuSize=data['sum'].div(data['sum'].sum() ).multiply(100)
    otuSize.to_csv(opt.output,sep='\t')
  except Exception as e:
    print("FATAL ERROR: Unable to open {}. {}".format(opt.table, e))
    exit(1)
  
  counter = 0
  for name,seq in read_fasta(opt.fasta):
    
    if otuSize[name] >= float(opt.minperc):
      counter += 1
      seqname = name
      if opt.prefix:
        seqname = opt.prefix + str(counter)
      print(">" + seqname + "_" + str("{:.2f}".format(otuSize[name]) ) + "\n" + seq)
