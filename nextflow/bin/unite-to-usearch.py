#!/usr/bin/python
import argparse
import pyfastx
import sys


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def toUnite(header, field):
	fields = header.split("|")
	taxonomy = fields[4].replace("__", ":")
	
	#k__Fungi;p__unidentified;c__unidentified;o__unidentified;f__unidentified;g__unidentified;s__Fungi_sp
	return '>' + fields[field-1] + ';tax=' + taxonomy 
if __name__ == "__main__":
		
	parser = argparse.ArgumentParser(description='Rename UNITE FASTA to USEARCH')
	parser.add_argument('-f', '--field', help='Header field, pipe separated', default=3)
	parser.add_argument('FASTA',  help='Input file name')

	args = parser.parse_args()
	if args.FASTA is None:
		exit()
	eprint(f"Reading {args.FASTA}")

	for name, seq in pyfastx.Fasta(args.FASTA, build_index=False):
		#Glomeromycota_sp|KJ484724|SH523877.07FU|reps|k__Fungi;p__Glomeromycota;c__unidentified;o__unidentified;f__unidentified;g__unidentified;s__Glomeromycota_sp
		#>AB008314;tax=d:Bacteria,p:Firmicutes,c:Bacilli,o:Lactobacillales,f:Streptococcaceae,g:Streptococcus;
		print(toUnite(name, args.field) + "\n" + seq)
