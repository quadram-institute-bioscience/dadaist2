#' Version 2.0
#' Last modified on 20/01/2020
#' Script Task: Calculate alpha-diversity
#' Author: Ilias Lagkouvardos
#' Contributions by: Thomas Clavel, Sandra Reitmeier
#'
#' For meaningful comparisons of species richness across samples, 
#' use of normalized sequence counts is expected.
#' For normalized richness calculation, only OTUs that are above 0.5 normalized counts are considered.
#' For comparisons across studies the notions of "Normalized" and "Effective" richness are being used.
#' Effective Richness is the number of OTUs occurring above the relative abundance of 0.25% in a given sample.
#' This threshold was experimentally determined using Mock communities in vitro and in vivo and 
#' is efficient in removing spurious taxa from amplicon sequencing data.
#' Normalized Richness is the number of OTUs above 0.5 counts in a sample when normalized to a fixed depth (1000)
#' 
#' Note:
#' Files are stored in the current folder 
#' If a file is needed for downstream analysis, it is also automatically added to the appropriate next folder
#' under the condition that the original folder structure of Rhea is maintained.

##################################################################################
######             Set parameters in this section manually                  ######
##################################################################################

args <- commandArgs(TRUE)
if ( length(args) != 4 ) {
  stop("Use 'dadaist2-alpha' instead!\n")
}
opt_wd         <- args[[1]] 
opt_normtab    <- args[[2]] 
opt_eff        <- args[[3]] # Effective Richness; 0.0025
opt_norm       <- args[[4]] # Standard Richness; 1000 

if (dir.exists(opt_wd) ) {
  cat("Directory found: ", opt_wd, "\n")
}
if (file.exists(opt_normtab)){
  cat("Otutab file found: ", opt_normtab, "\n")
}


#' Please set the directory of the script as working folder (e.g D:/MyStudy/NGS/Rhea/alpha-diversity)
#' Note: the path is denoted by forward slash "/"
setwd(file.path(opt_wd))                           #<--- CHANGE ACCORDINGLY

#' Please give the file name of the normalized OTU-table (without taxonomic classification)
file_name <- opt_normtab                #<--- CHANGE ACCORDINGLY

#' The abundance filtering cutoff 
eff.cutoff <- opt_eff # this is the default value for Effective Richness (0.25%)

#' The normalized depth cutoff
norm.cutoff <- opt_norm # this is the default value for Standard Richness (1000)

cat("1. Output dir: ", opt_wd, "\n")
cat("2. Input file: ", opt_normtab, "\n")
cat("3. Effective:  ", opt_eff, "\n")
cat("4. Standard:   ", opt_norm, "\n")
######                  NO CHANGES ARE NEEDED BELOW THIS LINE               ######

##################################################################################
######                        Diversity Functions                           ###### 
##################################################################################

# Calculate the species richness in a sample
Species.richness <- function(x)
{
  # Count only the OTUs that are present >0.5 normalized counts (normalization produces real values for counts)
  count=sum(x[x>0.5]^0)
  return(count)
}

# Calculate the Effective species richness in each individual sample
Eff.Species.richness <- function(x)
{
  # Count only the OTUs that are present more than the set proportion
  total=sum(x)
  count=sum(x[x/total>eff.cutoff]^0)
  return(count)
}

# Calculate the Normalized species richness in each individual sample
Norm.Species.richness <- function(x)
{
  # Count only the OTUs that are present >0.5 normalized counts (normalization produces real values for counts)
  # Given a fixed Normalization reads depth
  
  total=sum(x)
 
  count=sum(x[norm.cutoff*x/total>0.5]^0)
  return(count)
}


# Calculate the Shannon diversity index
Shannon.entropy <- function(x)
{
  total=sum(x)
  se=-sum(x[x>0]/total*log(x[x>0]/total))
  return(se)
}

# Calculate the effective number of species for Shannon
Shannon.effective <- function(x)
{
  total=sum(x)
  se=round(exp(-sum(x[x>0]/total*log(x[x>0]/total))),digits =2)
  return(se)
}

# Calculate the Simpson diversity index
Simpson.concentration <- function(x)
{
  total=sum(x)
  si=sum((x[x>0]/total)^2)
  return(si)
}

# Calculate the effective number of species for Simpson
Simpson.effective <- function(x)
{
  total=sum(x)
  si=round(1/sum((x[x>0]/total)^2),digits =2)
  return(si)
}

##################################################################################
######                             Main Script                              ###### 
##################################################################################

# Read a normalized OTU-table without taxonomy  
otu_table <- read.table (file_name, 
                       check.names = FALSE, 
                       header=TRUE, 
                       dec=".", 
                       sep = "\t",
                       row.names = 1)

# Clean table from empty lines
otu_table <- otu_table[!apply(is.na(otu_table) | otu_table=="",1,all),]

# Order and transpose OTU-table
my_otu_table <- otu_table[,order(names(otu_table))] 
my_otu_table <-data.frame(t(my_otu_table))

# Apply diversity functions to table
cat("1.\n")
otus_div_stats<-data.frame(my_otu_table[,0])
cat("2.\n")
otus_div_stats$Richness<-apply(my_otu_table,1,Species.richness)
cat("3. <skipped>\n")
#otus_div_stats$Normalized.Richness<-apply(my_otu_table,1,Norm.Species.richness)
cat("4.\n")
otus_div_stats$Effective.Richness<-apply(my_otu_table,1,Eff.Species.richness)
cat("5.\n")
otus_div_stats$Shannon.Index<-apply(my_otu_table,1,Shannon.entropy)
cat("6.\n")
otus_div_stats$Shannon.Effective<-apply(my_otu_table,1,Shannon.effective)
otus_div_stats$Simpson.Index<-apply(my_otu_table,1,Simpson.concentration)
otus_div_stats$Simpson.Effective<-apply(my_otu_table,1,Simpson.effective)
otus_div_stats$Evenness <- otus_div_stats$Shannon.Index/log(otus_div_stats$Richness,2)

# Write the results in a file and copy in directory "Serial-Group-Comparisons" if existing
write.table(otus_div_stats, file.path(opt_wd, "alpha-diversity.tab"), sep="\t", col.names=NA, quote=FALSE)

##################################################################################
######                          End of Script                               ###### 
##################################################################################
