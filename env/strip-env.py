#!/usr/bin/env python

import argparse
import os, sys
args = argparse.ArgumentParser()
args.add_argument("-i", "--input", help="Input file")
args.add_argument("-o", "--output", help="Output file")
args.add_argument("--replace", help="Replace input file", action="store_true")
args = args.parse_args()

if args.output:
    outfile = args.output
    output = open(outfile, "w")
elif args.replace:
    outfile = args.input + ".new"
    output = open(outfile, "w")
else:
    output = sys.stdout

if os.path.isfile(args.input):
    with open(args.input, "r") as f:
        for line in f:
            if line.startswith("prefix:"):
                continue
            parts = line.strip().split("=")
            if len(parts) == 3:
                print("=".join(parts[:2]), file=output)
            else:
                print(line.strip(), file=output)

if args.replace:
    try:
        print(f"Renaming {args.input} to {args.input}.old", file=sys.stderr)
        os.rename(args.input, args.input + ".old")
        print(f"Renaming {outfile} to {args.input}", file=sys.stderr)
        os.rename(outfile, args.input)
        print(f"Removing {args.input}.old", file=sys.stderr)
        os.remove(args.input + ".old")
        print("Replaced", args.input,  file=sys.stderr)
    except Exception as e:
        print("Error:", e, file=sys.stderr)
        sys.exit(1)