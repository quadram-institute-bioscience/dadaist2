#!/usr/bin/env Rscript
cat(R.version$version.string, "\n")
SAMPLEID=1

errQuit <- function(mesg, status=1) { message("Error: ", mesg); q(status=status) }
getN <- function(x) sum(getUniques(x))
args <- commandArgs(TRUE)
inp.dir     <- args[[1]]  # Input directory (output of basic dadaist2 output)

# Check input dir
ma.dir <- file.path(paste(inp.dir, '/MicrobiomeAnalyst/', sep=''))
out.file <- file.path(paste(inp.dir, '/phyloseq.rds', sep=''))

if (length(args) < 2) {
  inp.mcat = 'Files'
} else {
  inp.mcat    <- args[[2]]  # Comma separated list of categories
}

MCAT = unlist(strsplit(inp.mcat, ","))

if(! (dir.exists(inp.dir) && dir.exists( ma.dir ))  ) {
  errQuit("Input directory does not exist or subdirectory MicrobiomeAnalyst not found.")
} else {
  cat(" * Input: ", inp.dir, "\n")
  cat(" * Categories:", inp.mcat, "\n")
}


library("ape")
library("phyloseq")
library("tibble")
library("microbiome")

# Load OTUs
in_otu = as.matrix(read.table(file.path(paste(inp.dir, 'feature-table.tsv', sep='')), header=TRUE, sep="\t", row.names = 1, comment.char=""))
cat (" * Loading feature table\n")
# Load taxonomy
in_tax = as.matrix(read.table(file.path(paste(ma.dir, 'taxonomy.csv', sep='')), header=TRUE, sep=",", row.names = 1, fill=TRUE, na.strings=c("","NA","d__","p__","c__","o__","f__","g__","s__"), comment.char="#"))
cat (" * Loading taxonomy\n")
# Load tree
in_tree <- read.tree(file = file.path(paste(inp.dir, 'rep-seqs.tree', sep='')))
cat (" * Loading feature tree\n")
# Load metadata
meta_file=file.path(paste(inp.dir, 'metadata.tsv', sep=''))

metaIn = read.table(meta_file, header=TRUE, sep="\t", comment.char="")
metaIn_tibble = tibble(metaIn)
metaIn_tibble = metaIn_tibble %>% filter( !grepl("^#",metaIn_tibble[[1]]))

in_metad = sample_data(metaIn_tibble)

metaIn_tibble$rName = metaIn_tibble[[SAMPLEID]]

metaIn_tibble = metaIn_tibble %>% column_to_rownames('rName')
metaIn_tibble = metaIn_tibble %>% rename(sampleIDs = all_of(SAMPLEID))
metaIn_tibble = metaIn_tibble %>% select(sampleIDs, all_of(MCAT))
in_metad = sample_data(metaIn_tibble)
in_metad
my_OTU = otu_table(in_otu, taxa_are_rows = TRUE)
my_TAX = tax_table(in_tax)
my_physeq = phyloseq(my_OTU, my_TAX, in_metad, in_tree)
saveRDS(my_physeq,out.file)
