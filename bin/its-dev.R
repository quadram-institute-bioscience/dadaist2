# Options
optTagR1 = "_R1"
optTagR2 = "_R2"
                        #Files to be different before the first underscore
pathInputDir <- "/Users/telatina/git/dadaist2/data/ITS/primed/"
pathInputDir <- "~/MEGA/its-deprim"
unite.ref <- "/Users/telatina/git/dadaist2/refs/uniref.fa.gz"
# Separate by strand
inputReadsR1 <- sort(list.files(pathInputDir, pattern = optTagR1, full.names = TRUE))
inputReadsR2 <- sort(list.files(pathInputDir, pattern = optTagR2, full.names = TRUE))





library(dada2)

plotQualityProfile(inputReadsR2[1:2])

# Set output filtered names
filtR1 <- file.path(pathInputDir, "filtered", basename(inputReadsR1))
filtR2 <- file.path(pathInputDir, "filtered", basename(inputReadsR2))

# Extract sample names, assuming filenames have format:
get.sample.name <- function(inputReadsR1) strsplit(basename(inputReadsR1), "_")[[1]][1]
sample.names <- unname(sapply(inputReadsR1, get.sample.name))
sample.names

filtR1

out <- filterAndTrim(inputReadsR1, filtR1, inputReadsR2, filtR2, 
                     maxN = 0, 
                     maxEE = c(3, 3), 
                     truncQ = 2, 
                     minLen = 30, 
                     rm.phix = TRUE, compress = TRUE, 
                     multithread = TRUE)  # on windows, set multithread = FALSE

# Check for duplicates
# any(duplicated(c(filtR1, filtR2)))
out
which(out[, "reads.out"]==0)

# PROBLEM: What if files are NOT produced because empty?

# Learn the Error Rates
# Please ignore all the “Not all sequences were the same length.” messages in the next couple sections. We know they aren’t, and it’s OK!

errorRateR1 <- learnErrors(filtR1, multithread = TRUE)
errorRateR2 <- learnErrors(filtR2, multithread = TRUE) 
  
##plotErrors(errF, nominalQ = TRUE)  

# Dereplicate identical reads
derepR1 <- derepFastq(filtR1, verbose = TRUE)
derepR2 <- derepFastq(filtR2, verbose = TRUE)

# Name the derep-class objects by the sample names
names(derepR1) <- sample.names
names(derepR2) <- sample.names

# Sample Inference
# At this step, the core sample inference algorithm is applied to the dereplicated data.

dadaR1 <- dada(derepR1, err = errorRateR1, multithread = TRUE)
dadaR2 <- dada(derepR2, err = errorRateR2, multithread = TRUE)

# Merge paired reads
mergers <- mergePairs(dadaR1, derepR1, 
                      dadaR2, derepR2, 
                      verbose=TRUE)

# Construct Sequence Table
# We can now construct an amplicon sequence variant table (ASV) table, a higher-resolution version of the OTU table produced by traditional methods.

seqtab <- makeSequenceTable(mergers)
dim(seqtab)
## [1]  31 549

# Remove chimeras
seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE, verbose=TRUE)

#Inspect distribution of sequence lengths:
  
##:table(nchar(getSequences(seqtab.nochim)))

# Make table of track
getN <- function(x) sum(getUniques(x))
track <- cbind(out, sapply(dadaR1, getN), sapply(dadaR2, getN), sapply(mergers, 
                                                                       getN), rowSums(seqtab.nochim))
# If processing a single sample, remove the sapply calls: e.g. replace
# sapply(dadaFs, getN) with getN(dadaFs)
colnames(track) <- c("input", "filtered", "denoisedF", "denoisedR", "merged", 
                     "nonchim")
rownames(track) <- sample.names
##:track

taxa <- assignTaxonomy(seqtab.nochim, unite.ref, multithread = TRUE, tryRC = TRUE)

View(taxa)
