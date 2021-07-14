#!/usr/bin/env python3

import explib
import pandas as pd
import logging

# https://pypi.org/project/newick/
from newick import read

log = logging.getLogger(name = __name__)
logging.basicConfig(
    level=logging.DEBUG,
    format="{asctime} {name:<12} {levelname:<8} {message}",
    style="{"
    # filename= filemode=
)

 

def loadTreeFromFile(filepath):
    try:
        with open(filepath, "r") as file:
            newick = file.read()
        return newick
    except Exception as e:
        log.critical(f"Unable to load tree {file}:\n{e}")

if __name__ == "__main__":
    import argparse

    args = argparse.ArgumentParser(prog = "Microbiome test", description= "Desc")
    args.add_argument('-t', '--tree', help="Tree")
    args.add_argument('-f', '--feature-table', help="OTU")
    args.add_argument('-x', '--taxonomy', help="Tree")
    opts = args.parse_args()

    
    log.info(f"TREE\tLoading tree {opts.tree}")
    tree = loadTreeFromFile(opts.tree)

    log.info(f"TABLE\tLoading feature table {opts.feature_table}")
    feature_table = pd.read_csv(opts.feature_table, sep=",", index_col=0)

    log.info(f"TAXONOMY\tLoading taxonomy {opts.taxonomy}")
    taxonomy = pd.read_csv(opts.taxonomy, sep=",", index_col=0)

    print( feature_table.head() )

    # Merge dataframes on index
    merged = feature_table.join(taxonomy)
    print( merged.head())
    exit()
    log.info(f"MERGE\tMerging features with taxonomy")
    merged = pd.merge(feature_table, taxonomy, how="left")


    log.info(f"MERGE\tCalculating taxonomy for each OTU")
    merged["taxonomy"] = merged.apply(
        lambda row: tree.get_taxa(row["taxon"]), axis=1
    )

    log.info(f"TABLE\tWriting merged table")
    merged.to_csv("merged.csv", index=False)

    log.info(f"Done")

