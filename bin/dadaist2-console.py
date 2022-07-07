#!/usr/bin/env python

import os, sys
import re
import subprocess
from rich.console import Console
from rich import print
from rich.panel import Panel

console = Console()
selfDir = os.path.dirname(os.path.realpath(__file__))

def read_fasta(path, getseq=False):
    import gzip
    seq_name = None
    seq_string = None
    with (gzip.open if path.endswith('.gz') else open)(path, 'rt') as fasta:
        for line in fasta:
            if line.startswith('>'):
                if seq_name is not None:
                    yield seq_name, prefix
                seq_name = line[1:].rstrip()
                seq_string = ''
            else:
                if getseq:
                    seq_string += line.rstrip()
    yield seq_name, seq_string

class DadaistOutputDir:
    def __init__(self, path):
        self.valid = True
        self.path = os.path.abspath(path)
        self.name = os.path.dirname(path)
        self.log  = os.path.join(self.path, "dadaist.log")
        self.version = self.getVersion()

        self.otus, self.table, self.metadata, self.tree = self._files()
        self.num_otus = self._num_otus()
        self.num_samples = self._num_samples()

        self._check_sample_names()

        # Extra analyses
        self.phyloseq, self.has_phyloseq = self.check_phyloseq()
        self.rhea, self.has_rhea = self.check_Rhea()
        self.analyst, self.has_analyst = self.check_analyst()

        if not os.path.isdir(self.path):
            raise Exception("[Dadaist2] Output directory does not exist: " + self.path)
    
    def _files(self):
        files = ["rep-seqs.fasta", "feature-table.tsv", "metadata.tsv", "rep-seqs.tree"]
        files = [os.path.join(self.path, f) for f in files]
        missingfiles = [f for f in files if not os.path.isfile(f)]
        # Check all files
        if len(missingfiles) == 0:
            return files[0], files[1], files[2], files[3]
        else:
            console.log(f"[red]WARNING:[/red] Output directory does not contain all required files: {', '.join(missingfiles)}")
            self.valid = False
            return None, None, None, None

    def _check_sample_names(self):
        sample_names_metadata = []
        sample_names_table = []
        with open(self.metadata, "r") as f:
            for line in f:
                if not line.startswith("#"):
                    sample_names_metadata.append(line.split("\t")[0])
        with open(self.table, "r") as f:
            for line in f:
                fields = line.strip().split("\t")
                sample_names_table = fields[1:]
                break
        
        if len(sample_names_metadata) != len(sample_names_table):
            console.log(f"[red]WARNING:[/red] Number of samples in metadata ({len(sample_names_metadata)}) does not match number of samples in table ({len(sample_names_table)})")
            self.valid = False
            
    def _num_otus(self):
        num_table = 0
        num_fasta = 0
        with open(self.table, "r") as f:
            for line in f:
                if not line.startswith("#"):
                    num_table += 1
        with open(self.otus, "r") as f:
            for line in f:
                if line.startswith(">"):
                    num_fasta += 1
        
        if num_table == num_fasta:
            return num_table
        else:
            console.log(f"[red]WARNING:[/red] Number of OTUs in table ({num_table}) does not match number of OTUs in fasta ({num_fasta})")
            return -1

    def _num_samples(self):
        num_table = 0
        num_metadata = 0
        # Count columns in table
        with open(self.table, "r") as f:
            for line in f:
                if not line.startswith("#"):
                    num_table = len(line.split("\t")) - 1
                    break
        # Count columns in metadata
        with open(self.metadata, "r") as f:
            for line in f:
                if not line.startswith("#"):
                    num_metadata += 1
        
        if num_table == num_metadata:
            return num_table
        else:
            console.log(f"[red]WARNING:[/red] Number of samples in table ({num_table}) does not match number of samples in metadata ({num_metadata})")
            return f"{num_table} == {num_metadata}"


    def check_phyloseq(self):
        phyloseqRds = os.path.join(self.path, "R", "phyloseq.rds")
        if os.path.isfile(phyloseqRds):
            self.phyloseq = phyloseqRds
            return self.phyloseq, True
        else:
            return None, False
    
    def check_Rhea(self):
        required_files = ["OTUs_Table-norm-rel.tab", "OTUs_Table-norm.tab", "alpha-diversity.tab", "RarefactionCurve.tab"]
        rheaDir = os.path.join(self.path, "Rhea")
        if os.path.isdir(rheaDir):
            # comprehension to check if all required files are present
            if all([os.path.isfile(os.path.join(rheaDir, f)) for f in required_files]):
                return rheaDir, True
            else:
                return rheaDir, False
        else:
            return None, False

    def check_analyst(self):
        required_files = ["metadata.csv", "table.csv", "taxonomy.csv", "seqs.fa"]
        maDir = os.path.join(self.path, "MicrobiomeAnalyst")
        if os.path.isdir(maDir):
            # comprehension to check if all required files are present
            if all([os.path.isfile(os.path.join(maDir, f)) for f in required_files]):
                return maDir, True
            else:
                return maDir, False
        else:
            return None, False

    def getVersion(self):
        # Get first line of self.log
        with open(self.log, "r") as f:
            firstLine = f.readline()
        # Get version from first line
        return re.search(r"dadaist2 (.*)", firstLine).group(1)

    def get_otus(self):
        pass
    
    def __repr__(self):
        return f"\{ Dadaist2: {self.path}, {self.valid} \}"
    
    def __str__(self):
        # pretty 
        return f"""[Dadaist2_Output]
- name:  {self.name}
- path:  {self.path}
- vers:  {self.version}
- size:  {self.num_otus} sequences x {self.num_samples} samples
- has_phyloseq:          {self.has_phyloseq}
- has_rhea:              {self.has_rhea}
- has_microb_analyst:    {self.has_analyst}"""

    def print(self):
        text = f"""
path:          [bold]{self.path}[/bold]
version:       [bold]{self.version}[/bold]
valid:         {'[green]Yes[/green]' if self.valid else '[bold red]No[/bold red]'}
num_otus:      [bold]{self.num_otus}[/bold]
num_samples:   [bold]{self.num_samples}[/bold]
base_files:    {os.path.basename(self.otus)}, {os.path.basename(self.table)}, {os.path.basename(self.metadata)}, {os.path.basename(self.tree)}
has_phyloseq:  {f'[green]Yes[/green] {self.phyloseq}' if self.has_phyloseq else '[red]-[/red]'}
has_rhea:      {f'[green]Yes[/green] {self.rhea}' if self.has_rhea else '[red]-[/red]'}
has_analyst:   {f'[green]Yes[/green] {self.analyst}' if self.has_analyst else '[red]-[/red]'}
"""
        console.print(Panel(f"{text}", title=f"Dadaist2: [bold]{self.name}[/bold]"))

def printBox(text, title=""):
    print(Panel(f"[bold]{text}[/bold]", title=title))

def getVersion(default="<dev>"):
    mainScript = os.path.join(selfDir, "dadaist2")
    # read mainScript line by line
    with open(mainScript, "r") as f:
        for line in f:
            RE = re.compile(r"\$VERSION\s+=\s+'(.+)'")
            if RE.search(line):
                return RE.search(line).group(1)
        return default
    
if __name__ == "__main__":
    import argparse
    args = argparse.ArgumentParser(description="Dadaist2 console")
    args.add_argument("-v", "--version", action="store_true", help="Print version")
    args = args.parse_args()

    if args.version:
        sys.stdout.write(getVersion())
        sys.exit(0)