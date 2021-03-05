### ABUNDANCE PLOTS ###

# FIRST THINGS FIRST #

# load required packages
library("phyloseq")
library("ggplot2")

errQuit <- function(mesg, status=1) { message("Error: ", mesg); q(status=status) }
getN <- function(x) sum(getUniques(x))
args <- commandArgs(TRUE)
if (length(args) < 1) {
  errQuit("No arguments provided - required: phyloseq rds object\n
Usage: D2-04_abundance_plots.R phyloseq.rds [output_directory (optional)]")
} else if (length(args) == 1) {
  inp.phy     <- args[[1]]  # Input phyloseq rds object (filtered or unfiltered)
  out.dir     <- "./"  # output directory
} else {
  inp.phy     <- args[[1]]  # Input phyloseq rds object (filtered or unfiltered)
  out.dir     <- args[[2]]  # output directory
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

# import phyloseq object with raw or pre-processed / filtered data
my_physeq_filt_rel<-readRDS(phy)

# set plotting theme
theme_set(theme_bw())

##### REPORT DATA #####

print('phyloseq object:')
my_physeq_filt_rel
otu_table(my_physeq_filt_rel)[1:5]

# save variable information into var1, var2,...
i <- 2
while (i > 1 & i <= length(sample_variables(my_physeq_filt_rel))) {
  var <- unlist(sample_variables(my_physeq_filt_rel)[i])
  assign(paste("var", i-1, sep = ""),var)
  i <- i + 1
}

#######################

### PLOT ABUNDANCES ###

# Family colored but OTU level separation
my_barPhyl_pure <- plot_bar(my_physeq_filt_rel, fill="Phylum") + scale_fill_discrete(na.value="grey90") + ggtitle("Relative abundances at Phylum level") # color by Phylum
my_barClass_pure <- plot_bar(my_physeq_filt_rel, fill="Class") + scale_fill_discrete(na.value="grey90") + ggtitle("Relative abundances at Class level") # color by Class
my_barFam_pure <- plot_bar(my_physeq_filt_rel, fill="Family") + scale_fill_discrete(na.value="grey90") + ggtitle("Relative abundances at Family level")# color by Family
my_barGen_pure <- plot_bar(my_physeq_filt_rel, fill="Genus") + scale_fill_discrete(na.value="grey90") + ggtitle("Relative abundances at Genus level")# color by Genus

# show bar plots
pdf(paste(out.dir,"/abundance_bar_plots.pdf",sep=''))
  my_barPhyl_pure 
  my_barClass_pure
  my_barFam_pure
  my_barGen_pure
dev.off()

## Create bubble plots

pdf((paste(out.dir,"/my_bubble_plots.pdf",sep='')))
# bubble Class
my_physeq_filt_rel_Class = tax_glom(my_physeq_filt_rel, "Class")
my_barClass <- plot_bar(my_physeq_filt_rel_Class) 
my_barClass$layers <- my_barClass$layers[-1]
maxC<-max(otu_table(my_physeq_filt_rel_Class))
for ( n in 1:(i-2) ) {
  var <- paste("var", n, sep="")
  x <- get(var)
  my_bubbleClass <- my_barClass + 
    geom_point(aes_string(x="Sample", y="Class", size="Abundance", color = x ), alpha = 0.7 ) +
    scale_size_continuous(limits = c(0.001,maxC)) +
    xlab("Sample") +
    ylab("Class") +
    ggtitle("Relative abundances at Class level") + 
    labs(caption = "Abundances below 0.001 were considered absent") + 
    theme(strip.text = element_text(face="bold", size=14),
          axis.text.x = element_text(color = "black", size = 8, angle = 90, hjust = 1, vjust = 0.5, face = "plain"),
          axis.text.y = element_text(color = "black", size = 8, angle = 0, hjust = 1, vjust = 0.5, face = "plain"),
          axis.title.x = element_text(color = "black", size = 10, angle = 0, hjust = .5, vjust = 0, face = "plain"),
          axis.title.y = element_text(color = "black", size = 10, angle = 90, hjust = .5, vjust = .5, face = "plain"),
          plot.title = element_text(size = 12),
          plot.caption = element_text(size = 6),
          legend.title = element_text(size = 10),
          legend.text = element_text(size = 8))
  if (x == "NoMetadata" | x =="Files") {
    my_bubbleClassnm <- my_bubbleClass + guides(color=FALSE)
    print(my_bubbleClassnm)
  } else {
    print(my_bubbleClass)
  }  
}


# bubble Family
my_physeq_filt_rel_Fam = tax_glom(my_physeq_filt_rel, "Family")
my_barFam <- plot_bar(my_physeq_filt_rel_Fam) 
my_barFam$layers <- my_barFam$layers[-1]
maxC<-max(otu_table(my_physeq_filt_rel_Fam))
for ( n in 1:(i-2) ) {
  var <- paste("var", n, sep="")
  x <- get(var)
  my_bubbleFam <- my_barFam + 
    geom_point(aes_string(x="Sample", y="Family", size="Abundance", color = x ), alpha = 0.7) +
    scale_size_continuous(limits = c(0.001,maxC)) +
    xlab("Sample") +
    ylab("Family") +
    ggtitle("Relative abundances at Family level") + 
    labs(caption = "Abundances below 0.001 were considered absent") + 
    theme(strip.text = element_text(face="bold", size=14),
          axis.text.x = element_text(color = "black", size = 8, angle = 90, hjust = 1, vjust = 0.5, face = "plain"),
          axis.text.y = element_text(color = "black", size = 8, angle = 0, hjust = 1, vjust = 0.5, face = "plain"),
          axis.title.x = element_text(color = "black", size = 10, angle = 0, hjust = .5, vjust = 0, face = "plain"),
          axis.title.y = element_text(color = "black", size = 10, angle = 90, hjust = .5, vjust = .5, face = "plain"),
          plot.title = element_text(size = 12),
          plot.caption = element_text(size = 6),
          legend.title = element_text(size = 10),
          legend.text = element_text(size = 8))
  if (x == "NoMetadata" | x =="Files") {
    my_bubbleFamnm <- my_bubbleFam + guides(color=FALSE)
    print(my_bubbleFamnm)
  } else {    
  print(my_bubbleFam)
  }
}

# bubble Genus
my_physeq_filt_rel_Gen = tax_glom(my_physeq_filt_rel, "Genus")
my_barGen <- plot_bar(my_physeq_filt_rel_Gen) 
my_barGen$layers <- my_barGen$layers[-1]
maxC<-max(otu_table(my_physeq_filt_rel_Gen))
for ( n in 1:(i-2) ) {
  var <- paste("var", n, sep="")
  x <- get(var)
  my_bubbleGen <- my_barGen + 
    geom_point(aes_string(x="Sample", y="Genus", size="Abundance", color = x ), alpha = 0.7) +
    scale_size_continuous(limits = c(0.001,maxC)) +
    xlab("Sample") +
    ylab("Genus") +
    ggtitle("Relative abundances at Genus level") + 
    labs(caption = "Abundances below 0.001 were considered absent") + 
    theme(strip.text = element_text(face="bold", size=14),
          axis.text.x = element_text(color = "black", size = 8, angle = 90, hjust = 1, vjust = 0.5, face = "plain"),
          axis.text.y = element_text(color = "black", size = 8, angle = 0, hjust = 1, vjust = 0.5, face = "plain"),
          axis.title.x = element_text(color = "black", size = 10, angle = 0, hjust = .5, vjust = 0, face = "plain"),
          axis.title.y = element_text(color = "black", size = 10, angle = 90, hjust = .5, vjust = .5, face = "plain"),
          plot.title = element_text(size = 12),
          plot.caption = element_text(size = 6),
          legend.title = element_text(size = 10),
          legend.text = element_text(size = 8))
  if (x == "NoMetadata" | x =="Files") {
    my_bubbleGennm <- my_bubbleGen + guides(color=FALSE)
    print(my_bubbleGennm)
  } else {
    print(my_bubbleGen)
  }
}


# bubble Species
# test if species exist
bla <- as.vector(tax_table(my_physeq_filt_rel)[,"Species"])
if ( sum(grep('*', bla)) == 0 ) {
  print("no Species level affiliation")
} else {
  my_physeq_filt_rel_Spec = tax_glom(my_physeq_filt_rel, "Species")
  my_barSpec <- plot_bar(my_physeq_filt_rel_Spec) 
  my_barSpec$layers <- my_barSpec$layers[-1]
  maxC<-max(otu_table(my_physeq_filt_rel_Spec))
  for ( n in 1:(i-2) ) {
    var <- paste("var", n, sep="")
    x <- get(var)
    my_bubbleSpec <- my_barSpec + 
      geom_point(aes_string(x="Sample", y="Species", size="Abundance", color = x ), alpha = 0.7) +
      scale_size_continuous(limits = c(0.001,maxC)) +
      xlab("Sample") +
      ylab("Species") +
      ggtitle("Relative abundances at Species level") + 
      labs(caption = "Abundances below 0.001 were considered absent") + 
      theme(strip.text = element_text(face="bold", size=14),
            axis.text.x = element_text(color = "black", size = 8, angle = 90, hjust = 1, vjust = 0.5, face = "plain"),
            axis.text.y = element_text(color = "black", size = 8, angle = 0, hjust = 1, vjust = 0.5, face = "plain"),
            axis.title.x = element_text(color = "black", size = 10, angle = 0, hjust = .5, vjust = 0, face = "plain"),
            axis.title.y = element_text(color = "black", size = 10, angle = 90, hjust = .5, vjust = .5, face = "plain"),
            plot.title = element_text(size = 12),
            plot.caption = element_text(size = 6),
            legend.title = element_text(size = 10),
            legend.text = element_text(size = 8))
    if (x == "NoMetadata" | x =="Files") {
      my_bubbleSpecnm <- my_bubbleSpec + guides(color=FALSE)
      print(my_bubbleSpecnm)
    } else {
      print(my_bubbleSpec)
    }
  }
}
dev.off()

#######################