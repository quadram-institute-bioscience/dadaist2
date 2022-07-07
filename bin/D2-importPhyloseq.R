#!/usr/bin/env Rscript
cat(R.version$version.string, "\n")
SAMPLEID=1

# Requires MA output:
#  * table.csv
#  * taxonomy.csv
#  * rep-seqs.tree
#  * metadata.csv

errQuit <- function(mesg, status=1) { message("Error: ", mesg); q(status=status) }
getN <- function(x) sum(getUniques(x))
args <- commandArgs(TRUE)
inp.dir     <- args[[1]]  # Input directory (output of basic dadaist2 output)

# Check input dir
ma.dir <- file.path(paste(inp.dir, '/MicrobiomeAnalyst/', sep=''))
out.file <- file.path(paste(inp.dir, '/phyloseq.rds', sep=''))


if(! (dir.exists(inp.dir) && dir.exists( ma.dir ))  ) {
  errQuit("Input directory does not exist or subdirectory MicrobiomeAnalyst not found.")
} else {
  cat(" * Input: ", inp.dir, "\n")
}

library("phyloseq")
library("ape")

# Load OTUs
in_otu = as.matrix(read.table(file.path(paste(ma.dir, 'table.csv', sep='')), header=TRUE, sep=",", row.names = 1, comment.char=""))
cat (" * Loading feature table\n")

# Load taxonomy
in_tax = read.table(
  file.path(paste(ma.dir, 'taxonomy.csv', sep='')),
  header=TRUE, sep=",",
  row.names = 1,
  fill=TRUE,
  na.strings=c("","NA","k__", "d__","p__","c__","o__","f__","g__","s__"),
  comment.char="") 
in_tax$sequenceID<-row.names(in_tax)
in_tax <- as.matrix(in_tax)
cat (" * Taxonomy loaded\n")

# Load tree if available
if(! file.exists(file.path(paste(inp.dir, '/rep-seqs.tree', sep='')) )) {
  cat(" * Tree file does not exist - proceeding without tree\n")
} else {
  in_tree <- read.tree(file = file.path(paste(inp.dir, '/rep-seqs.tree', sep='')))
  cat (" * Tree loaded\n")
}

# Load metadata
meta_file=file.path(paste(inp.dir, '/metadata.tsv', sep=''))

# import metadata
# check if metadata file was provided 
if (file.exists(meta_file)){        
  metaIn = read.table(meta_file, header=TRUE, sep="\t", comment.char="") # import metadata table
  rownames(metaIn) <- metaIn[,1]
  colnames(metaIn)[1] <- 'sampleID'
  cat(" * Metadata loaded\n")
} else {
  cat(" * No metadata provided - proceeding without\n")
  SampleName<-colnames(in_otu)
  metaIn<-data.frame(SampleName)
  SAMPLEID = 1 # overwrite sample name column if no metadata are provided
  rownames(metaIn) <- metaIn[,1]
  colnames(metaIn)[1] <- 'sampleID'
  metaIn$NoMetadata<-"0" # if no metadata 'categories' are specified, then metadata only contain sample names and NoMetadata column for downstream plotting purposes
} 
in_metad = sample_data(metaIn)

# Generate phyloseq (with or without tree depending on whether a tree file was provided)
my_OTU = otu_table(in_otu, taxa_are_rows = TRUE)
cat(" * PhyloSeq: Feature table done\n")
my_TAX = tax_table(in_tax)
cat(" * PhyloSeq: Taxonomy table done\n")
if (exists("in_tree")) {
  cat(" * PhyloSeq: adding tree\n")
  sample_names(in_metad)
  my_physeq = phyloseq(my_OTU, my_TAX, in_metad, in_tree)
  
  cat(" * PhyloSeq: Tree done\n")
} else {
  cat(" * PhyloSeq: skipping tree\n")
  my_physeq = phyloseq(my_OTU, my_TAX, in_metad)
  cat(" * PhyloSeq: Tree done\n")
}

saveRDS(my_physeq,out.file)
