#!/usr/bin/env python3
import argparse
import re 

def read_clusters(path):
#0       254nt, >dada53_0.28... *
#1       234nt, >qiime56_0.27... at 1:234:11:244/+/100.00%
	import gzip
	clusterName = None
	with (gzip.open if path.endswith('.gz') else open)(path, 'rt') as fasta:
		for line in fasta:
			if line.startswith('>'):
				if clusterName is not None:
					yield clusterName, prefix
				clusterName = line[1:].rstrip()
				prefix = []
			else:
				match = re.findall(r'>(.+?)\d', line)
				prefix.append(match[0])
	yield clusterName, prefix



if __name__ == '__main__':
	parser = argparse.ArgumentParser(description='Produce multiqc report')
	parser.add_argument('-i', '--input', required=True)
	parser.add_argument('-t', '--toptaxa', type=int, default=10)
	parser.add_argument('-l', '--level', type=int, default=3)
	args = parser.parse_args()

	for c, z in read_clusters(args.input):
		z.sort()
		print(c, "\t", len(z),"\t",  ";".join(z))
 
