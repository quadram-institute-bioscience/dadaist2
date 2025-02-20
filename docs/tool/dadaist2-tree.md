# Dadaist2-tree

A phylogenetic tree generation tool optimized for metabarcoding data (16S rRNA and ITS sequences),
that takes **representative-sequences.fasta** and generates a **tree.nwk** file (Newick format).

```text
usage: dadaist2-tree [-h] -i INPUT -o OUTPUT [-t THREADS] [--marker {16S,ITS}] [--fast]

Generate phylogenetic tree from metabarcoding (16S/ITS) sequences

options:
  -h, --help            show this help message and exit
  -i INPUT, --input INPUT
                        Input FASTA file containing ASVs/OTUs (default: None)
  -o OUTPUT, --output OUTPUT
                        Output tree file (Newick format) (default: None)
  -t THREADS, --threads THREADS
                        Number of threads to use (default: 1)
  --marker {16S,ITS}    Marker gene type (affects alignment parameters) (default: 16S)
  --fast                Use fast mode (Clustal Omega + FastTree) instead of MAFFT + IQ-TREE (default: False)
```

## Features

- Multiple sequence alignment using either MAFFT (standard mode) or Clustal Omega (fast mode)
- Phylogenetic tree construction using either IQ-TREE (standard mode) or FastTree (fast mode)
- Optimized parameters for both 16S rRNA and ITS marker genes
- Multi-threaded operations for faster processing
- Rich logging with progress indicators

## Installation

### Dependencies

The program requires the following external tools to be installed and available in your PATH:

Standard mode:
- MAFFT
- IQ-TREE

Fast mode:
- Clustal Omega
- FastTree

### Python Dependencies

```bash
pip install rich
```

## Usage

Basic usage:

```bash
python dadaist2-tree.py -i input.fasta -o output.tree -t 4
```

All options:

```bash
python dadaist2-tree.py [-h] -i INPUT -o OUTPUT [-t THREADS] [--marker {16S,ITS}] [--fast]
```

### Arguments

- `-i, --input`: Input FASTA file containing ASVs/OTUs (required)
- `-o, --output`: Output tree file in Newick format (required)
- `-t, --threads`: Number of threads to use (default: 1)
- `--marker`: Marker gene type, either '16S' or 'ITS' (default: 16S)
- `--fast`: Use fast mode (Clustal Omega + FastTree) instead of MAFFT + IQ-TREE

## Marker Type Selection (--marker)

The `--marker` option optimizes the alignment parameters based on the type of sequences being analyzed:

### 16S rRNA (--marker 16S)

For 16S rRNA sequences, the program uses:
- MAFFT with FFT-NS-2 algorithm
- Adjusted gap penalties (op = 1.53, ep = 0.123)
- Lower number of iterations
- Suitable for sequences with high similarity and conserved structure

This configuration is optimized for:
- Shorter sequences (typically ~1500 bp)
- More conserved regions
- Lower gap frequency
- Higher sequence similarity

### ITS (--marker ITS)

For ITS (Internal Transcribed Spacer) sequences, the program uses:
- MAFFT with E-INS-i algorithm
- Increased number of iterations (up to 1000)
- Better handling of multiple conserved domains
- More sensitive gap handling

This configuration is optimized for:
- More variable sequence lengths
- Higher sequence divergence
- Multiple conserved domains interrupted by variable regions
- Higher gap frequency

## Modes of Operation

### Standard Mode (Default)

Uses MAFFT for alignment and IQ-TREE for phylogenetic inference:
- More accurate but slower
- Includes statistical support values (ultra-fast bootstrap)
- Automatically selects best evolutionary model
- Recommended for publication-quality trees

```bash
# Standard mode example
python dadaist2-tree.py -i input.fasta -o output.tree -t 4 --marker 16S
```

### Fast Mode

Uses Clustal Omega for alignment and FastTree for phylogenetic inference:
- Faster but potentially less accurate
- Good for quick exploratory analysis
- Uses GTR model with optimization
- Suitable for large datasets where computational time is a concern

```bash
# Fast mode example
python dadaist2-tree.py -i input.fasta -o output.tree -t 4 --fast
```

## Output

The program generates a phylogenetic tree in Newick format. In standard mode, the tree includes:
- Branch lengths
- Ultra-fast bootstrap support values (standard mode only)
- SH-aLRT test values (standard mode only)

## Error Handling

The program includes:
- Dependency checking
- Input file validation
- Rich error messaging
- Temporary file cleanup
- Progress logging

## Contributing

Feel free to submit issues and enhancement requests!