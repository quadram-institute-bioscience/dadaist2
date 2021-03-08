# Install DECIPHER
#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install("DECIPHER")

suppressWarnings(suppressMessages(library("dada2")))
args <- commandArgs(TRUE)

if (length(args) != 3) {
  stop("Arguments: inputList dbPath outputDir [Threads]\n")
}
inputList       <- args[[1]]
dbPath          <- args[[2]]
outputDir       <- args[[3]]
if (length(args) < 4)  {
 THREADS         <- 1
} else {
 THREADS         <- as.integer(args[[4]])
}

# Check parameters
if (! ( file.exists(inputList))) {
  cat("Input sequences file not found: ", inputFasta, "\n")
  stop("Missing input.\n")
}
if (! (  file.exists(dbPath))) {
  cat("Training set file not found: ", dbPath, "\n")
  stop("Missing reference.\n")
}
if (! (  dir.exists(outputDir))){
  dir.create(outputDir,recursive=TRUE)
}
if (! (  endsWith(dbPath, 'gz'))) {
  stop("Taxonomy database not in gz format\n")
}
 
# load input FASTA
sequences = readLines(inputList)

cat(format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\t[1] Taxonomy\n");
taxa <- assignTaxonomy(sequences, file.path(dbPath), multithread=TRUE,tryRC=TRUE)
taxa.print <- taxa # Removing sequence rownames for display only
rownames(taxa.print) <- NULL
write.table(taxa.print,
      file.path(paste(outputDir, '/taxonomy.tsv', sep='')),
      row.names=TRUE,
      quote=FALSE
)