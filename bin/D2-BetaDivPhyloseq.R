### BETA DIVERSITY ###

# FIRST THINGS FIRST #

# load required packages

library("phyloseq")
library("ggplot2")
library("plyr")


errQuit <- function(mesg, status=1) { message("Error: ", mesg); q(status=status) }
getN <- function(x) sum(getUniques(x))
args <- commandArgs(TRUE)
if (length(args) < 1) {
  errQuit("No arguments provided - required: phyloseq rds object\n
Usage: D2-BetaDivPhyloseq.R phyloseq.rds [output_directory (optional)] [label/nolabel(label ordination points)]")
} else if (length(args) == 1) {
  inp.phy     <- args[[1]]  # Input phyloseq rds object (filtered or unfiltered)
  out.dir     <- "./"  # output directory
  lab.ord     <- "nolabel" # switch to label ordination points; default: no label
} else {
  inp.phy     <- args[[1]]  # Input phyloseq rds object (filtered or unfiltered)
  out.dir     <- args[[2]]  # output directory
  lab.ord     <- args[[3]]  # switch to label ordination points
}

if (lab.ord == "label") {
  label.switch<-2.5
} else {
  label.switch<-0
  }


phy <- file.path(inp.phy)

# Check input dir
if(! (file.exists(phy) && dir.exists( out.dir ))  ) {
  errQuit("Input file or output directory do not exist")
} else {
  cat(" * Input phyloseq pbject: ", phy, "\n")
  cat(" * Output directory:", out.dir, "\n")
}

#######################

##### IMPORT DATA #####

# import phyloseq object with pre-processed / filtered data
my_physeq_filt_rel<-readRDS(phy)

# set plotting theme
theme_set(theme_bw())

##### REPORT DATA #####

cat('\n * phyloseq object: \n')
my_physeq_filt_rel
otu_table(my_physeq_filt_rel)[1:5]

# save variable information into var1, var2,...
i <- 2
while (i > 1 & i <= length(sample_variables(my_physeq_filt_rel))) {
  var <- unlist(sample_variables(my_physeq_filt_rel)[i])
  assign(paste("var", i-1, sep = ""),var)
  i <- i + 1
}
y <- var1
#######################

#### BETA DIVERSITY ####

# check if counts are relative
vec<-rep(1,nsamples(my_physeq_filt_rel))
if (all(colSums(otu_table(my_physeq_filt_rel)) == 1)) {
  cat("\n * Looking good, your counts are already relative\n")
} else {
  cat("\n * Oops, your counts are not relative yet - I'll fix it for you\n")
  my_physeq_filt_rel  = transform_sample_counts(my_physeq_filt_rel, function(OTU) OTU / sum(OTU))
  cat("   There you go: \n")
  otu_table(my_physeq_filt_rel)[1:5]
}

# list distance methods
dist_methods <- unlist(distanceMethodList)

# check if tree was supplied and remove distance methods Unifrac and DPCoA if no tree was provided
#if ( class(phy_tree(my_physeq_filt_rel)) == "phylo" ) {
if ( class(phy_tree(my_physeq_filt_rel, errorIfNULL=FALSE)) == "phylo" ) {
  cat("\n * cool, you provided a tree\n\n")
  # remove use defined method
  dist_methods = dist_methods[-which(dist_methods=="ANY")]
} else {
  cat("\n * you did not provide a tree - excluding unifrac and weighted unifrac\n\n")
}

# select distance methods depending on whether tree provided or not
if ( class(phy_tree(my_physeq_filt_rel, errorIfNULL=FALSE)) == "phylo" ) {
  distlist <- c("bray","jsd", "unifrac", "wunifrac")
} else {
  distlist <- c("bray","jsd")
}

# Ordinations of Bray-Curtis, Unifrac, weighted Unifrac, and JSD. Colored according to every variable
pdf(paste(out.dir,"/my_ordinations.pdf",sep=""))
for ( dist in distlist) {
  ord_meths = c("CCA", "DCA", "RDA", "NMDS", "MDS") # call different ordination methods

# excluded "DPCoA"
# excluded PCoA because it is identical to MDS
 for ( n in 1:(i-2) ) {
    var <- paste("var", n, sep="")
    x <- get(var)
    plist = lapply(as.list(ord_meths), function(y, my_physeq_filt_rel, dist){
      set.seed(2)
      ordi = ordinate(my_physeq_filt_rel, method=y, distance=dist)
      plot_ordination(my_physeq_filt_rel, ordi, "samples",)
    }, my_physeq_filt_rel, dist)
    names(plist) <- ord_meths
    # extract the data from each of those individual plots, and put it back together in one big data.frame
      pdataframe = ldply(plist, function(y){
      df = y$data[, 1:2]
      colnames(df) = c("Axis_1", "Axis_2")
      return(cbind(df, y$data))
    })
    names(pdataframe)[1] = "method"

    if (y == "NoMetadata" | y == "Files") {
      my_ord_combo = ggplot(pdataframe, aes_string("Axis_1", "Axis_2"), alpha = 0.7) +
        geom_point(size=2, alpha = 0.7, aes_string(label="sampleID"))  +
        geom_text(aes(label=sampleID),vjust = "inward", hjust = "inward", size=label.switch) +
        facet_wrap(~method, scales="free") + 
        ggtitle(ggtitle(print(dist)))
      print(my_ord_combo)
    } else {
      if (class(pdataframe[[x]]) == "integer") {
        my_ord_combo = ggplot(pdataframe, aes_string("Axis_1", "Axis_2", color=x, fill=x), alpha = 0.7) +
          geom_point(size=3, alpha = 0.7, aes_string(label="sampleID"))  +
          geom_text(aes(label=sampleID),vjust = "inward", hjust = "inward", size=label.switch) +
          facet_wrap(~method, scales="free")+
          ggtitle(ggtitle(print(dist)))
        print(my_ord_combo)
      } else {
        my_ord_combo = ggplot(pdataframe, aes_string("Axis_1", "Axis_2", color=x, fill=x), alpha = 0.7) +
          geom_point(size=3, alpha = 0.7, aes_string(label="sampleID")) + 
          geom_text(aes(label=sampleID),vjust = "inward", hjust = "inward", size=label.switch) +
          facet_wrap(~method, scales="free") +
          scale_fill_brewer(type="qual", palette="Set2") +
          scale_colour_brewer(type="qual", palette="Set2")+
          ggtitle(ggtitle(print(dist)))
        print(my_ord_combo)
      }
    }
  }
}
dev.off()


########################
