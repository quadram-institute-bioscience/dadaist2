

args <- commandArgs(TRUE)
if (length(args) != 4) {
  stop(" Arguments: InputDir OutputDir TruncLen1 TruncLen2\n");
}
path      <- args[[1]]
outdir    <- args[[2]]
tl1       <- strtoi(args[[3]])
tl2       <- strtoi(args[[4]])
################### START SOP #####################

cat(" Input:  ", path,"\n")
cat(" Output: ", outdir,"\n")
cat(" Trunc1: ", tl1, "\n")
cat(" Trunc2: ", tl2, "\n")

# Forward and reverse fastq filenames have format: SAMPLENAME_R1_001.fastq and SAMPLENAME_R2_001.fastq
cat("# Retrieving files\n")
fnFs <- sort(list.files(path, pattern="_R1_001.fastq", full.names = TRUE))
fnRs <- sort(list.files(path, pattern="_R2_001.fastq", full.names = TRUE))
# Extract sample names, assuming filenames have format: SAMPLENAME_XXX.fastq
sample.names <- sapply(strsplit(basename(fnFs), "_"), `[`, 1)

library(dada2); packageVersion("dada2")

cat("# Quality plots\n")
pdf("for.pdf")
plotQualityProfile(fnFs[1:2])
dev.off()

pdf("rev.pdf")
plotQualityProfile(fnRs[1:2])
dev.off()

# Place filtered files in filtered/ subdirectory
cat("# Filter and trim\n")
filtFs <- file.path(path, "filtered", paste0(sample.names, "_F_filt.fastq.gz"))
filtRs <- file.path(path, "filtered", paste0(sample.names, "_R_filt.fastq.gz"))
out <- filterAndTrim(fnFs, filtFs, fnRs, filtRs, truncLen=c(tl1,tl2),
              maxN=0, maxEE=c(2,2), truncQ=2, rm.phix=TRUE,
              compress=TRUE, multithread=TRUE) # On Windows set multithread=FALSE

cat("# Learn errors\n")
errF <- learnErrors(filtFs, multithread=TRUE)
errR <- learnErrors(filtRs, multithread=TRUE)

# Derep
cat("# Dereplicate\n")
derepFs <- derepFastq(filtFs, verbose=TRUE)
derepRs <- derepFastq(filtRs, verbose=TRUE)
# Name the derep-class objects by the sample names
names(derepFs) <- sample.names
names(derepRs) <- sample.names

cat("# DADA2\n")
dadaFs <- dada(derepFs, err=errF, multithread=TRUE)
dadaRs <- dada(derepRs, err=errR, multithread=TRUE)

cat("# Merge\n")
mergers <- mergePairs(dadaFs, derepFs, dadaRs, derepRs, verbose=TRUE)
seqtab <- makeSequenceTable(mergers)
cat("# Remove chimeras\n")
seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE, verbose=TRUE)


################### END SOP #####################

seqtab.nochim <- t(seqtab.nochim)

# Track
getN <- function(x) sum(getUniques(x))
track <- cbind(out, sapply(dadaFs, getN), sapply(dadaRs, getN), sapply(mergers, getN), rowSums(seqtab.nochim))
# If processing a single sample, remove the sapply calls: e.g. replace sapply(dadaFs, getN) with getN(dadaFs)
colnames(track) <- c("input", "filtered", "denoisedF", "denoisedR", "merged", "nonchim")
rownames(track) <- sample.names


col.names      <- basename(filtFs)
col.names[[1]] <- paste0("#OTU","\t", col.names[[1]])

write.table(seqtab.nochim, file.path(outdir, "dada2-table.tsv"), sep="\t",
            row.names=TRUE, col.names=col.names, quote=FALSE)
write.table(track, file.path(outdir, "dada2-stats.tsv"), sep="\t", row.names=TRUE, col.names=NA,
	    quote=FALSE)

