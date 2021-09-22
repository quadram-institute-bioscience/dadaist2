#!/usr/bin/env python3

import logging
import sys, os
import argparse
import rich
import configparser
import dadaister
"""
[Dadaist]
defaultdir = dadaist/dadaist2/
refdir = ~/refs/

[refs]
defaultdb = SILVA_128_SSURef_Nr99_tax_silva.fa.gz

[protocol.16S]
primerFor = CCTACGGGNGGCWGCAG
primerRev = GGACTACHVGGGTATCTAATCC

[protocol.ITS2]
primerFor = CTTGGTCATTTAGAGGAAGTAA
primerRev = GCTGCGTTCTTCATCGATGC
"""



if __name__ == "__main__":
    homedir = os.path.expanduser('~')
    scriptdir = os.path.dirname(os.path.realpath(__file__))
    defaultConfig = os.path.join(homedir, '.dadaist.ini')

    parser = argparse.ArgumentParser(description='Dadaist2: a script that does not so much')
    parser.add_argument('--debug', action='store_true', help='Enable debug mode')
    parser.add_argument('--config', default=defaultConfig, help=f'Config file to use [default: {defaultConfig}]')
    args = parser.parse_args()

    if args.debug:
        logging.basicConfig(level=logging.DEBUG)
    else:
        logging.basicConfig(level=logging.INFO)

    logging.info("Starting Dadaist2")
 
    config = dadaister.DadaistConfig(args.config)
    print(config.defaultdb)
    print(dadaister.version())