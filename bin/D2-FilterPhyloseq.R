### PRE-PROCESSING ###

# FIRST THINGS FIRST #

# load required packages
library("phyloseq")

errQuit <- function(mesg, status=1) { message("Error: ", mesg); q(status=status) }
getN <- function(x) sum(getUniques(x))
args <- commandArgs(TRUE)
inp.phy     <- args[[1]]  # Input phyloseq rds object (filtered or unfiltered)
out.dir     <- args[[2]]  # output directory
tot.count   <- args[[3]]  # Exclude all samples that have less than X total read counts [default = 10 000]
min.rel     <- args[[4]]  # Remove all taxa that have rel. abundances below X in ALL sampels e.g. 0.05 [default is 0]
count.times <- args[[5]]  # Remove taxa not seen more than X [default 3] times in at least proportion Y [default 0.05] of the samples
coe.var     <- args[[6]]  # Remove taxa with coefficient of variation ≤ X across all samples (optional: only use if you know what you are doing)

# Parse the command line arguments
COUNT_TIMES <- unlist(strsplit(count.times,","))

phy <- file.path(inp.phy)

# Check input dir
if(! (file.exists(phy) && dir.exists( out.dir ))  ) {
  errQuit("Input file or output directory do not exist")
} else {
  cat(" * Input phyloseq pbject: ", phy, "\n")
  cat(" * Output directory:", out.dir, "\n")
}

# import phyloseq object
my_physeq<-readRDS(phy)

##### REPORT DATA #####

cat('\nphyloseq object:\n')
my_physeq

cat('\nnumber of taxa: ')
cat(ntaxa(my_physeq))
ori_ntaxa = ntaxa(my_physeq)
ori_taxanames = taxa_names(my_physeq)

cat('\nnumber of samples: ')
cat(nsamples(my_physeq))
ori_nsamples = nsamples(my_physeq)
ori_samplesums = sample_sums(my_physeq)

cat('\nsample names: ')
cat(sample_names(my_physeq))
ori_samplenames = sample_names(my_physeq)

cat('\nrank names: ')
cat(rank_names(my_physeq))

cat('\n\n*****FILTERING...*****')

#######################

### PRE-PROCESSING ###

# Exclude all samples that have less than 10 000 total read counts
cat(paste0('\n==> 1. Remove samples with fewer total counts of: ', tot.count))
my_physeq = prune_samples(sample_sums(my_physeq)>=tot.count, my_physeq)
cat(paste0('\n       Number of samples removed: ', ori_nsamples - nsamples(my_physeq)))
cat('\n       The removed samples are: \n')
cat(ori_samplenames[-pmatch(sample_names(my_physeq),ori_samplenames)])
cat('\n       The remaining samples used for analyses are: ')
cat(sample_names(my_physeq))

# Remove taxa not seen more than 3 times in at least 5% of the samples.
cat(paste0('\n\n==> 2. Remove taxa not seen more than ', COUNT_TIMES[[1]] ,' times in at least ', as.numeric(COUNT_TIMES[[2]])*100 , '% of the samples'))
my_physeq = filter_taxa(my_physeq, function(OTU) sum(OTU > as.numeric(COUNT_TIMES[[1]])) > (as.numeric(COUNT_TIMES[[2]])*length(OTU)), TRUE)
cat(paste0('\n       Number of taxa removed: ', ori_ntaxa - ntaxa(my_physeq)))
cat('\n       The removed taxa are: ')
cat(ori_taxanames[-pmatch(taxa_names(my_physeq),ori_taxanames)])
cat('\n       The remaining samples used for analyses are: ')
cat(taxa_names(my_physeq))


# Filter the taxa using a cutoff of 3.0 for the Coefficient of Variation
if ( coe.var == 0 ) {
  cat('\n\n==> 3. Skip filtering according to coefficient of variation...\n')
} else {
  prev_ntaxa = ntaxa(my_physeq)
  prev_taxanames = taxa_names(my_physeq)
  cat(paste0('\n==> 3. Remove taxa with coefficient of variation ≤', coe.var, ' (only if you know what you are doing)'))
  my_physeq = filter_taxa(my_physeq, function(x) sd(x)/mean(x) > coe.var, TRUE)
  cat(paste0('\n       Number of taxa removed: ', prev_ntaxa - ntaxa(my_physeq)))
  cat('\n       The removed taxa are: ')
  cat(prev_taxanames[-pmatch(taxa_names(my_physeq),prev_taxanames)])
  cat('\n       The remaining samples used for analyses are: ')
  cat(taxa_names(my_physeq))
  }

# filter all OTUs that have rel. abundances below 0.01 (1%) in ALL sampels
cat(paste0('\n\n==> 4. Remove taxa with rel. abundances below: ', min.rel))
my_physeq_relTMP  = transform_sample_counts(my_physeq, function(OTU) OTU / sum(OTU))
# check if due to the filter 0 taxa will be removed (avoid error)
check0 = filter_taxa(my_physeq_relTMP, function(OTU) max(OTU) <= min.rel)
if ( length(check0[check0 == TRUE]) <= 0 ) {
  cat('\n       Number of taxa removed: 0')
  my_physeq = my_physeq_relTMP
  } else {
  my_low_abundant_OTUs = filter_taxa(my_physeq_relTMP, function(OTU) max(OTU) <= min.rel, TRUE)
  my_rmtaxa = taxa_names(my_low_abundant_OTUs)
  alltaxa = taxa_names(my_physeq)
  myTaxa = alltaxa[!alltaxa %in% my_rmtaxa]
  my_physeq = prune_taxa(myTaxa,my_physeq)
  cat(paste0('\n       Number of taxa removed: ', length(my_rmtaxa)))
  cat('\n       The removed taxa are: ')
  cat(my_rmtaxa)
  my_physeq = transform_sample_counts(my_physeq, function(OTU) OTU / sum(OTU))
  }

cat('\n\nFiltered phyloseq object: \n')
my_physeq
saveRDS(my_physeq, file = "my_physeq_filtered.rds")

#######################