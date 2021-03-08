### AUPDATE METADATA ###

# FIRST THINGS FIRST #

# load required packages
library("phyloseq")

errQuit <- function(mesg, status=1) { message("Error: ", mesg); q(status=status) }
getN <- function(x) sum(getUniques(x))
args <- commandArgs(TRUE)
if (length(args) < 3) {
  errQuit("Missing arguments - required: phyloseq rds object, metadata file and output directory\n
Usage: D2-updateMetadataPhyloseq.R phyloseq.rds tab-sep-metadata output_directory [r/e (otional - default: r)]]")
} else if (length(args) == 3) {
  inp.phy     <- args[[1]]  # Input phyloseq rds object
  inp.met     <- args[[2]]  # tab-separated metadata file
  out.dir     <- args[[3]]  # output directory
  rep.ext     <- "r"        # indicate extend (e) or replace (r) metadata: default is replace
} else {
  inp.phy     <- args[[1]]  # Input phyloseq rds object
  inp.met     <- args[[2]]  # tab-separated metadata file
  out.dir     <- args[[3]]  # output directory
  rep.ext     <- args[[4]]  # indicate extend (e) or replace (r)
}

phy <- file.path(inp.phy)
met <- file.path(inp.met)
out.file <- file.path(paste(out.dir, '/phyloseq-new-metadata.rds', sep=''))

# Check input dir and file
if(! (file.exists(phy) && file.exists(met) && dir.exists( out.dir ))  ) {
  errQuit("Input files or output directory do not exist")
} else {
  cat(" * Input phyloseq object: ", phy, "\n")
  cat(" * Input metadata object: ", met, "\n")
  cat(" * Output directory: ", out.dir, "\n")
}

# check if replace or extend metadata
if( rep.ext!="r" && rep.ext !="e" ) {
  errQuit("wrong entry for argument [[4]] - expected 'r' (replace metadata) or 'e' (extend metadata)")
} else if (rep.ext=="r") {
  cat(" * Metadata will be replaced by the provided metadata table (default): \n")
} else {
  cat(" * Metadata will be extended by the provided metadata table: \n")
  }


#######################

##### IMPORT DATA #####

# import phyloseq object
my_physeq<-readRDS(phy)
old_metad<-sample_data(my_physeq) # old metadata

# import metadata
metaIn = read.table(met, header=TRUE, sep="\t", comment.char="") # import metadata table
rownames(metaIn) <- metaIn[,1]
colnames(metaIn)[1] <- 'sampleID' # rename first column to match
in_metad <- sample_data(metaIn) # new metadata

#######################

### MODIFY METADATA ###

# if sampleIDs of old and new metadata match (ignoring order) then replace metadata in new phyloseq object
if (isTRUE(all.equal(sort(old_metad$sampleID),sort(in_metad$sampleID)))) {
  if (rep.ext == "r") {
    cat(" * OK: old and new metada have matching sample IDs\n")
    sample_data(my_physeq)<-in_metad
    cat(" * Replacing old metadata with new metadata - new metadata are: \n\n")
    print(sample_data(my_physeq))
    cat("\n * Overview of new phyloseq object: \n\n")
    print(my_physeq)
    saveRDS(my_physeq, file = out.file)
    cat(paste("\n * New phyloseq object saved as: ",out.file,"\n\n"))
  } else if (rep.ext == "e") {
    cat(" * OK: old and new metada have matching sample IDs\n")
    my_physeq<-merge_phyloseq(my_physeq, in_metad)
    cat(" * Extending old metadata with new metadata - new extended metadata are: \n\n")
    print(sample_data(my_physeq))
    cat("\n * Overview of new phyloseq object: \n\n")
    print(my_physeq)
    saveRDS(my_physeq, file = out.file)
    cat(paste("\n * New phyloseq object saved as: ",out.file,"\n\n"))
  }
} else {
  errQuit("Sample IDs in old and new metadata don't match up - please provide correct metadata file")
}

#######################

