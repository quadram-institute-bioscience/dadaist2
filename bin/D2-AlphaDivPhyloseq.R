### ALPHA DIVERSITY ###

# FIRST THINGS FIRST #

# load required packages
library("phyloseq")
library("ggplot2")

errQuit <- function(mesg, status=1) { message("Error: ", mesg); q(status=status) }
getN <- function(x) sum(getUniques(x))
args <- commandArgs(TRUE)
if (length(args) < 1) {
  errQuit("No arguments provided - required: phyloseq rds object\n
Usage: D2-AlphaDivPhyloseq.R phyloseq.rds [output_directory (optional)]")
} else if (length(args) == 1) {
inp.phy     <- args[[1]]  # Input phyloseq rds object (output of dadaist2)
out.dir     <- "./"  # output directory
} else {
inp.phy     <- args[[1]]  # Input phyloseq rds object (output of dadaist2)
out.dir     <- args[[2]]  # output directory
}

phy <- file.path(inp.phy)
odir <- file.path(out.dir)

# Check input dir
if(! (file.exists(phy) && dir.exists( out.dir ))  ) {
  errQuit("Input file or output directory do not exist")
} else {
  cat(" * Input phyloseq object: ", phy, "\n")
  cat(" * Output directory:", odir, "\n")
}

# import phyloseq object
my_physeq<-readRDS(phy)

# set plotting theme
theme_set(theme_bw())

# save variable information into var1, var2,...
i <- 2
while (i > 1 & i <= length(sample_variables(my_physeq))) {
  var <- unlist(sample_variables(my_physeq)[i])
  assign(paste("var", i-1, sep = ""),var)
  i <- i + 1
}

#######################

### ALPHA DIVERSITY ###

my_physeq

# trim OTUs that are not present in any sample
print('==> Remove OTUs that are not present (0 counts) in any sample')
my_0pruned <- prune_taxa(taxa_sums(my_physeq) > 0, my_physeq)

my_alpha_all_plot <- plot_richness(my_physeq, measures = c("Observed", "Chao1", "ACE", "Shannon", "Simpson", "InvSimpson")) + ggtitle("Figure | alpha diversity - overview all measures") + labs(caption = "alpha diversity calculated on unfiltered data (only OTUs with 0 counts in all samples were removed)") +
  theme(strip.text = element_text(face="bold", size=10),
        axis.text.x = element_text(color = "black", size = 7, angle = 90, hjust = 1, vjust = 0.5, face = "plain"),
        axis.text.y = element_text(color = "black", size = 10, angle = 0, hjust = 1, vjust = 0.5, face = "plain"),
        axis.title.x = element_text(color = "black", size = 10, angle = 0, hjust = .5, vjust = 0, face = "plain"),
        axis.title.y = element_text(color = "black", size = 10, angle = 90, hjust = .5, vjust = .5, face = "plain"),
        plot.title = element_text(size = 12))
pdf(file = paste(out.dir,"/my_alpha_all.pdf",sep=''))
  my_alpha_all_plot
dev.off()

# make a graph for every distance measure
my_alpha_comb_list <- NULL
for( alp in c("Observed", "Chao1", "ACE", "Shannon", "Simpson", "InvSimpson") ){
  my_alpha_comb_plot <- NULL
  my_alpha_comb_plot <- plot_richness(my_0pruned, x="sampleID", measures=alp)
  my_alpha_comb_plot <- my_alpha_comb_plot + ggtitle(paste("Figure | alpha diversity* according to the ", alp, " measure", sep="")) +
    labs(caption = "*calculated on unfiltered data; OTUs with 0 counts in all samples were removed")
  my_alpha_comb_plot$layers <- my_alpha_comb_plot$layers[-1]  # remove first layer
  my_alpha_comb_list[[alp]] = my_alpha_comb_plot
}

# Chao into separate plots
pdf(paste(out.dir,"/chao1_alpha_plots.pdf",sep=""))
for ( n in 1:(i-2) ) {
    var <- paste("var", n, sep="")
    x <- get(var)
    pal2 <- my_alpha_comb_list[["Chao1"]] + 
      geom_point(aes_string(color=x), size=3, alpha = 0.7) +
      guides(color=guide_legend(title=x))+
      theme(strip.text = element_text(face="bold", size=10),
          axis.text.x = element_text(color = "black", size = 8, angle = 90, hjust = 1, vjust = 0.5, face = "plain"),
          axis.text.y = element_text(color = "black", size = 8, angle = 0, hjust = 1, vjust = 0.5, face = "plain"),
          axis.title.x = element_text(color = "black", size = 10, angle = 0, hjust = .5, vjust = 0, face = "plain"),
          axis.title.y = element_text(color = "black", size = 10, angle = 90, hjust = .5, vjust = .5, face = "plain"),
          plot.title = element_text(size = 12),
          plot.caption = element_text(size = 6),
          legend.title = element_text(size = 10),
          legend.text = element_text(size = 8)) 
    #file_name = paste(out.dir,"/my_alpha_", var, ".pdf", sep="")
    if (x == "NoMetadata" | x == "Files") {
      pal2nm <- pal2 + guides(color=FALSE)
#      pdf(file = file_name)
      print(pal2nm)
#      dev.off()
    } else {
#      pdf(file = file_name)
      print(pal2)
#      dev.off()
    }
}  
dev.off()
#######################