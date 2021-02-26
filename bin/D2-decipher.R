# Install DECIPHER
#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install("DECIPHER")

suppressWarnings(suppressMessages(library("DECIPHER")))
args <- commandArgs(TRUE)
inputFasta      <- args[[1]]
dbPath          <- args[[2]]
outputDir       <- args[[3]]
THREADS         <- as.integer(args[[4]])


# Check parameters
if (! ( file.exists(inputFasta))) {
  cat("Input FASTA file not found: ", inputFasta, "\n")
  stop("Missing input.\n")
}
if (! (  file.exists(dbPath))) {
  cat("Training set file not found: ", dbPath, "\n")
  stop("Missing reference.\n")
}
if (! (  dir.exists(outputDir))){
  dir.create(outputDir,recursive=TRUE)
}
if (! (  endsWith(dbPath, 'RData'))) {
  stop("Taxonomy database not in RData format\n")
}

cat("Starting assigntax with ", THREADS, " threads.\n")
# load 'trainingSet'
load(dbPath)

# load input FASTA
inputFasta <- readDNAStringSet(inputFasta)
inputFasta <- RemoveGaps(inputFasta)


ids <- IdTaxa(inputFasta,
              trainingSet,
              type="collapsed",  # extended / collapsed
              strand="both",     # ot "top" for + strand
              threshold=60,
              processors=THREADS)

cat("Done.\n")
#print(ids)
#plot(ids)

# Extended?
# assignment <- sapply(ids, function(x) paste(x$taxon, collapse=";"))

write.table(ids, file=file.path(outputDir, "taxonomy.decipher"), quote=FALSE, sep='\t')

plot <- tryCatch(
    {
      png(file = file.path(outputDir, "taxonomy_summary.png"))
      plot(ids)
      dev.off()
    },
    error = function(e){
      cat("Skipping plot.\n")
    }
)
