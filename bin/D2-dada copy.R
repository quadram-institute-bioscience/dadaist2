#!/usr/bin/env Rscript
# edited after q2-dada plugin

####################################################
#             DESCRIPTION OF ARGUMENTS             #
####################################################
# NOTE: All numeric arguments should be zero or positive.
# NOTE: All numeric arguments save maxEEF/R are expected to be integers.
# NOTE: Currently the filterered_dirF/R must already exist.
# NOTE: ALL ARGUMENTS ARE POSITIONAL!
#
### FILE SYSTEM ARGUMENTS ###
#
# 1) File path to directory with the FORWARD .fastq.gz files to be processed.
#    Ex: path/to/dir/with/FWD_fastqgzs
#
# 2) File path to directory with the REVERSE .fastq.gz files to be processed.
#    Ex: path/to/dir/with/REV_fastqgzs
#
# 3) File path to output tsv file. If already exists, will be overwritten.
#    Ex: path/to/output_file.tsv
#
# 4) File path to tracking tsv file. If already exists, will be overwritte.
#    Ex: path/to/tracking_stats.tsv
#
# 5) File path to directory to write the filtered FORWARD .fastq.gz files. These files are intermediate
#               for the full workflow. Currently they remain after the script finishes. Directory must
#               already exist.
#    Ex: path/to/dir/with/FWD_fastqgzs/filtered
#
# 6) File path to directory to write the filtered REVERSE .fastq.gz files. These files are intermediate
#               for the full workflow. Currently they remain after the script finishes. Directory must
#               already exist.
#    Ex: path/to/dir/with/REV_fastqgzs/filtered
#
### FILTERING ARGUMENTS ###
#
# 7) truncLenF - The position at which to truncate forward reads. Forward reads shorter
#               than truncLenF will be discarded.
#               Special values: 0 - no truncation or length filtering.
#    Ex: 240
#
# 8) truncLenR - The position at which to truncate reverse reads. Reverse reads shorter
#               than truncLenR will be discarded.
#               Special values: 0 - no truncation or length filtering.
#    Ex: 160
#
# 9) trimLeftF - The number of nucleotides to remove from the start of
#               each forward read. Should be less than truncLenF.
#    Ex: 0
#
# 10) trimLeftR - The number of nucleotides to remove from the start of
#               each reverse read. Should be less than truncLenR.
#    Ex: 0
#
# 11) maxEEF - Forward reads with expected errors higher than maxEEF are discarded.
#               Both forward and reverse reads are independently tested.
#    Ex: 2.0
#
# 12) maxEER - Reverse reads with expected errors higher than maxEER are discarded.
#               Both forward and reverse reads are independently tested.
#    Ex: 2.0
#
# 13) truncQ - Reads are truncated at the first instance of quality score truncQ.
#                If the read is then shorter than truncLen, it is discarded.
#    Ex: 2
#
### CHIMERA ARGUMENTS ###
#
# 14) chimeraMethod - The method used to remove chimeras. Valid options are:
#               none: No chimera removal is performed.
#               pooled: All reads are pooled prior to chimera detection.
#               consensus: Chimeras are detect in samples individually, and a consensus decision
#                           is made for each sequence variant.
#    Ex: consensus
#
# 15) minParentFold - The minimum abundance of potential "parents" of a sequence being
#               tested as chimeric, expressed as a fold-change versus the abundance of the sequence being
#               tested. Values should be greater than or equal to 1 (i.e. parents should be more
#               abundant than the sequence being tested).
#    Ex: 1.0
#
### SPEED ARGUMENTS ###
#
# 16) nthreads - The number of threads to use.
#                 Special values: 0 - detect available and use all.
#    Ex: 1
#
# 17) nreads_learn - The minimum number of reads to learn the error model from.
#                 Special values: 0 - Use all input reads.
#    Ex: 1000000
#
#
# 18) Output directory
#
# 19) 'do_plots' to save quality plots
#
# 20) taxonomy DB -or- 'skip'
# 21) save rds
# 22) join paired end
# 23) join samples

cat(R.version$$version.string, "\\n")
errQuit <- function(mesg, status=1) { message("DADAIST2-ERROR: ", mesg); q(status=status) }
getN <- function(x) sum(getUniques(x))
args <- commandArgs(TRUE)

feature_table_header = '#OTU ID';
# Assign each of the arguments, in positional order, to an appropriately named R variable
inp.dirF      <- "$input_dir_1"
inp.dirR      <- "$input_dir_2"
out.path      <- "$output_file"
out.track     <- "$output_track"
filtered_dirF <- "$filtered_dir_1"
filtered_dirR <- "$filtered_dir_2"
truncLenF     <- as.integer($trunc_len_1)
truncLenR     <- as.integer($trunc_len_2)
trimLeftF     <- as.integer($trim_left_1)
trimLeftR     <- as.integer($trim_left_2)
maxEEF        <- as.numeric($max_ee_1)
maxEER        <- as.numeric($max_ee_2)
truncQual     <- as.integer($trunc_qual)
chimeraMethod <- "$chimeraMethod"
minParentFold <- as.numeric(args[[15]])
nthreads      <- as.integer(args[[16]])
nreads.learn  <- as.integer(args[[17]])

outbasepath   <- "$output_base"
make_plots    <- $male_plots_bool
taxonomy_db   <- "$taxonomy_db"
save_rds      <- $save_rds_bool
paramConcat   <- $concat_bool # TRUE or FALSE
processPool   <- $pool_bool   # TRUE or FALSE
 

### VALIDATE ARGUMENTS ###
# Input directory is expected to contain .fastq.gz file(s)
# that have not yet been filtered and globally trimmed
# to the same length.
if(!(dir.exists(inp.dirF) && dir.exists(inp.dirR))) {
  errQuit("Input directory does not exist.")
} else {
  unfiltsF <- list.files(inp.dirF, pattern=".fastq.gz$$", full.names=TRUE)
  unfiltsR <- list.files(inp.dirR, pattern=".fastq.gz$$", full.names=TRUE)
  if(length(unfiltsF) == 0) {
    errQuit("No input forward files with the expected filename format found.")
  }
  if(length(unfiltsR) == 0) {
    errQuit("No input reverse files with the expected filename format found.")
  }
  if(length(unfiltsF) != length(unfiltsR)) {
    errQuit("Different numbers of forward and reverse .fastq.gz files.")
  }
  cat("# Received ", length(unfiltsF), " paired-end samples.\\n")
}

# Output files are to be filenames (not directories) and are to be
# removed and replaced if already present.
for(fn in c(out.path, out.track)) {
  if(dir.exists(fn)) {
    errQuit("Output filename ", fn, " is a directory.")
  } else if(file.exists(fn)) {
    invisible(file.remove(fn))
    cat("# removing: ", fn, "\\n")
  }
}

# Convert nthreads to the logical/numeric expected by dada2
if(nthreads < 0) {
  errQuit("nthreads must be non-negative.")
} else if(nthreads == 0) {
  multithread <- TRUE # detect and use all
} else if(nthreads == 1) {
  multithread <- FALSE
} else {
  multithread <- nthreads
}
cat("# Threads: ", nthreads, "\\n")

### LOAD LIBRARIES ###
suppressWarnings(library(methods))
suppressWarnings(library(dada2))
cat("# DADA2:", as.character(packageVersion("dada2")), "/",
    "Rcpp:", as.character(packageVersion("Rcpp")), "/",
    "RcppParallel:", as.character(packageVersion("RcppParallel")), "\\n")


cat(format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\\t[1] Filtering reads ")
filtsF <- file.path(filtered_dirF, basename(unfiltsF))
filtsR <- file.path(filtered_dirR, basename(unfiltsR))
cat("\\n")


### QUALITY PLOTS
# DADA2:plotQualityProfile
if (make_plots == TRUE) {
  pdf(paste(outbasepath,"/quality_R1.pdf",sep = ""));

  print(plotQualityProfile( unfiltsF, n = 100000, aggregate=TRUE))
  for (p in c(unfiltsF)) {
    print(plotQualityProfile( file.path(p), n = 100000))
  }
  dev.off();

  pdf(paste(outbasepath,"/quality_R2.pdf",sep = ""));
  print(plotQualityProfile( unfiltsR, n = 100000, aggregate=TRUE))
  for (p in c(unfiltsR)) {
    print(plotQualityProfile( file.path(p), n = 100000))
  }
}

# DADA2:filterAndTrim
out <- suppressWarnings(filterAndTrim(unfiltsF, filtsF, unfiltsR, filtsR,
                                      truncLen=c(truncLenF, truncLenR), trimLeft=c(trimLeftF, trimLeftR),
                                      maxEE=c(maxEEF, maxEER), truncQ=truncQual, rm.phix=TRUE,
                                      multithread=multithread))

cat(" Filter and Trim, finished\\n")
cat(ifelse(file.exists(filtsF), ".", "x"), sep="")
filtsF <- list.files(filtered_dirF, pattern=".fastq.gz$$", full.names=TRUE)
filtsR <- list.files(filtered_dirR, pattern=".fastq.gz$$", full.names=TRUE)
cat("\\n")

if(length(filtsF) == 0) { # All reads were filtered out
  errQuit("No reads passed the filter (were truncLenF/R longer than the read lengths?)", status=2)
}

### LEARN ERROR RATES ###
# DADA2:learnErrors
# Dereplicate enough samples to get nreads.learn total reads
cat(format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\\t[2] Learning Error Rates\\n")
errF <- suppressWarnings(learnErrors(filtsF, nreads=nreads.learn, multithread=multithread))
errR <- suppressWarnings(learnErrors(filtsR, nreads=nreads.learn, multithread=multithread))

### PROCESS ALL SAMPLES ###
# Loop over rest in streaming fashion with learned error rates


cat(format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\\t[3] Denoise remaining samples \\n")

if (processPool == FALSE) {
      cat(" * Sample by sample")
      denoisedF <- rep(0, length(filtsF))
      mergers <- vector("list", length(filtsF))

      for(j in seq(length(filtsF))) {
        drpF <- derepFastq(filtsF[[j]])
        ddF <- dada(drpF, err=errF, multithread=multithread, verbose=FALSE)
        drpR <- derepFastq(filtsR[[j]])
        ddR <- dada(drpR, err=errR, multithread=multithread, verbose=FALSE)
        mergers[[j]] <- mergePairs(
                      ddF, drpF, 
                      ddR, drpR,
                      justConcatenate=paramConcat,
                      trimOverhang=TRUE)
        denoisedF[[j]] <- getN(ddF)
       
      }
      # Make sequence table
      seqtab <- makeSequenceTable(mergers)

} else {
      cat(" * Dereplicate all samples\\n")
      derepFs <- derepFastq(filtsF, verbose=TRUE)
      derepRs <- derepFastq(filtsR, verbose=TRUE)

      # Name the derep-class objects by the sample names
      #cat(" * Rename samples\\n")
      #names(derepFs) <- sample.names
      #names(derepRs) <- sample.names

      cat(" * Denoise all samples\\n")
      dadaFs <- dada(derepFs, err=errF, multithread=TRUE)
      dadaRs <- dada(derepRs, err=errR, multithread=TRUE)

      cat(" * Merge all samples\\n")
      mergers <- mergePairs(dadaFs, derepFs, dadaRs, derepRs, verbose=TRUE)

      cat(" * Make feature table\\n")
      seqtab <- makeSequenceTable(mergers)

      denoisedF <-  sapply(dadaFs, getN)
      #seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE, verbose=TRUE)
}

cat("\\n")


# Remove chimeras
cat(format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\\t[4] Remove chimeras (method = ", chimeraMethod, ")\\n", sep="")
if(chimeraMethod %in% c("pooled", "consensus")) {
  seqtab.nochim <- removeBimeraDenovo(seqtab, method=chimeraMethod, minFoldParentOverAbundance=minParentFold, multithread=multithread)
} else { # No chimera removal, copy seqtab to seqtab.nochim
  seqtab.nochim <- seqtab
}

### REPORT READ COUNTS AT EACH PROCESSING STEP ###
# Handle edge cases: Samples lost in filtering; One sample
track <- cbind(out, matrix(0, nrow=nrow(out), ncol=3))
colnames(track) <- c("input", "filtered", "denoised", "merged", "non-chimeric")
passed.filtering <- track[,"filtered"] > 0
track[passed.filtering,"denoised"] <- denoisedF
track[passed.filtering,"merged"] <- rowSums(seqtab)
track[passed.filtering,"non-chimeric"] <- rowSums(seqtab.nochim)
write.table(track, out.track, sep="\\t", row.names=TRUE, col.names=NA,
	    quote=FALSE)


# ### TAXONOMY

if (taxonomy_db != 'skip' && file.exists(taxonomy_db)) {
   cat(format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\\t[5.1] Taxonomy\\n");
   taxa <- assignTaxonomy(seqtab.nochim, file.path(taxonomy_db), multithread=TRUE,tryRC=TRUE)

   taxa.print <- taxa # Removing sequence rownames for display only
   rownames(taxa.print) <- NULL

} else {
  cat(format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\\t[5.1] Taxonomy (SKIPPED)\\n");
}

### WRITE OUTPUT AND QUIT ###
# Formatting as tsv plain-text sequence table table

cat(format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\\t[6] Write output\\n")
seqtab.nochim <- t(seqtab.nochim) # QIIME has OTUs as rows
col.names <- basename(filtsF)
col.names[[1]] <- paste0(feature_table_header,"\\t", col.names[[1]])

cat("\\t * ", out.path, "\\n");
write.table(seqtab.nochim, out.path, sep="\\t",
            row.names=TRUE, col.names=col.names, quote=FALSE)


## If taxonomy required with DADA2
if (taxonomy_db != 'skip' && file.exists(taxonomy_db)) {
  cat("\\t * ", file.path(paste(outbasepath, '/taxonomy.tsv', sep='')), "\\n");
  write.table(taxa.print,
      file.path(paste(outbasepath, '/taxonomy.tsv', sep='')),
      row.names=TRUE,
      quote=FALSE
  )
} else {
  cat("\\t * ", file.path(paste(outbasepath, '/taxonomy.tsv', sep='')), " ", taxonomy_db, "  (SKIPPED)\\n");
}

if (save_rds == TRUE) {
  cat("\\t * Saving RDS: ", gsub("tsv", "rds", out.path))
  saveRDS(seqtab.nochim, gsub("tsv", "rds", out.path)) ### TESTING
} else {
  cat("\\t * Not saving RDS\\n")
}

q(status=0)
