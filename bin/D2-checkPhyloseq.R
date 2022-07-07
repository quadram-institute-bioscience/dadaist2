### CHECK CONTENTS OF A PHYLOSEQ OBJECTS ###

# FIRST THINGS FIRST #

# load required packages
library("phyloseq")

errQuit <- function(mesg, status=1) { message("Error: ", mesg); q(status=status) }
getN <- function(x) sum(getUniques(x))
args <- commandArgs(TRUE)
inp.phy     <- args[[1]]  # Input phyloseq rds object (output of dadaist2)

phy <- file.path(inp.phy)

# Check input dir
if(! (file.exists(phy))  ) {
  errQuit("Input file does not exist")
} else {
  cat("Input file: ", phy, "\n")
}

# import phyloseq object
my_physeq<-readRDS(phy)

if(class(my_physeq) == "phyloseq"){
  cat("Input file class: correct - phyloseq object \n")
} else {
  errQuit("Input file is not a phyloseq object")
}

vars<-sample_variables(my_physeq)
metaD<-sample_variables(my_physeq)
if ("sampleID" %in% vars & "NoMetadata" %in% vars){
  cat("Metadata: No metadata supplied - phyloseq object includes default categories: ",metaD,"\n")
} else if ("sampleID" %in% vars & "Files" %in% vars) {
  cat("Metadata: No metadata supplied - phyloseq object includes dadaist default categories: ",metaD,"\n")
} else {
  cat("Metadata: ",metaD,"\n")
}

if ( try(class(phy_tree(my_physeq)), silent=TRUE) == "phylo") {
  cat("Tree: Phyloseq object includes tree with following stats:\n")
  phy_tree(my_physeq)
} else {
  cat("Tree: Phyloseq object does not include tree\n")
}

# number of taxa
taxN<-ntaxa(my_physeq)
cat("Number of OTUs/ASVs: ",taxN,"\n")

# number of samples
sampN<-nsamples(my_physeq)
cat("Number of samples: ",sampN,"\n")

# maximum counts oer sample
maxC<-max(colSums(otu_table(my_physeq)))
cat("Maximum sum of counts per samples: ",maxC,"\n")

#minimum counts per sample
minC<-min(colSums(otu_table(my_physeq)))
cat("Minimum sum of counts per samples: ",minC,"\n")

