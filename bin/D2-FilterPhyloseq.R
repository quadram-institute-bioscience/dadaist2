### PRE-PROCESSING ###

# FIRST THINGS FIRST #

# load required packages
library("phyloseq")
library("argparser")

errQuit <- function(mesg, status=1) { message("Error: ", mesg); q(status=status) }
getN <- function(x) sum(getUniques(x))

# Create a parser
par <- arg_parser("pre-processing")
# Add command line arguments
par <- add_argument(par, "--phyloseq", help="RDS file of phyloseq object", default="my_physeq.rds")
par <- add_argument(par, "--total_count", help="Exclude all samples that have less than X total read counts [default = 10 000]", default = "10000")
par <- add_argument(par, "--min", help="Remove all taxa that have rel. abundances below X in ALL sampels e.g. 0.05 [default is 0]", default = "0")
par <- add_argument(par, "--count_times", help="Remove taxa not seen more than X [default 3] times in at least proportion Y [default 0.05] of the samples", default = "0,0", nargs = 2)
par <- add_argument(par, "--cov", help="Remove taxa with coefficient of variation ≤ X across all samples (optional: only use if you know what you are doing)", default = 0)

# Parse the command line arguments
argv <- parse_args(par)
COUNT_TIMES <- unlist(strsplit(argv$count_times,","))

# import phyloseq object
if(! (file.exists(argv$phyloseq))  ) {
  errQuit("Input file does not exist")
} else {
  cat(" * Input phyloseq object: ", argv$phyloseq, "\n")
}

# import phyloseq object
my_physeq<-readRDS(argv$phyloseq)

##### REPORT DATA #####

print('phyloseq object:')
my_physeq

print('number of taxa:')
ntaxa(my_physeq)
ori_ntaxa = ntaxa(my_physeq)
ori_taxanames = taxa_names(my_physeq)

print('number of samples:')
nsamples(my_physeq)
ori_nsamples = nsamples(my_physeq)
ori_samplesums = sample_sums(my_physeq)
  
print('sample names:')
sample_names(my_physeq)
ori_samplenames = sample_names(my_physeq)

print('rank names:')
rank_names(my_physeq)

print('sample variables:')
sample_variables(my_physeq)

print('checking taxonomy table')
tax_table(my_physeq)[1:5]

print('*****FILTERING...*****')

#######################

### PRE-PROCESSING ###

# Exclude all samples that have less than 10 000 total read counts
print(paste0('==> 1. Remove samples with fewer total counts of: ', argv$total_count))
my_physeq = prune_samples(sample_sums(my_physeq)>=argv$total_count, my_physeq)
print(paste0('       Number of samples removed: ', ori_nsamples - nsamples(my_physeq)))
print('       The removed samples are: ')
print(ori_samplenames[-pmatch(sample_names(my_physeq),ori_samplenames)])
print('       The remaining samples used for analyses are: ')
sample_names(my_physeq)

# Remove taxa not seen more than 3 times in at least 5% of the samples.
print(paste0('==> 2. Remove taxa not seen more than ', COUNT_TIMES[[1]] ,' times in at least ', as.numeric(COUNT_TIMES[[2]])*100 , '% of the samples'))
my_physeq = filter_taxa(my_physeq, function(OTU) sum(OTU > as.numeric(COUNT_TIMES[[1]])) > (as.numeric(COUNT_TIMES[[2]])*length(OTU)), TRUE)
print(paste0('       Number of taxa removed: ', ori_ntaxa - ntaxa(my_physeq)))
print('       The removed taxa are: ')
print(ori_taxanames[-pmatch(taxa_names(my_physeq),ori_taxanames)])
print('       The remaining samples used for analyses are: ')
taxa_names(my_physeq)


# Filter the taxa using a cutoff of 3.0 for the Coefficient of Variation
if ( argv$cov == 0 ) {
  print('==> 3. Skip filtering according to coefficient of variation...')
} else {
  prev_ntaxa = ntaxa(my_physeq)
  prev_taxanames = taxa_names(my_physeq)
  print(paste0('==> 3. Remove taxa with coefficient of variation ≤', argv$cov, ' (only if you know what you are doing)'))
  my_physeq = filter_taxa(my_physeq, function(x) sd(x)/mean(x) > argv$cov, TRUE)
  print(paste0('       Number of taxa removed: ', prev_ntaxa - ntaxa(my_physeq)))
  print('       The removed taxa are: ')
  print(prev_taxanames[-pmatch(taxa_names(my_physeq),prev_taxanames)])
  print('       The remaining samples used for analyses are: ')
  taxa_names(my_physeq)
  }

# filter all OTUs that have rel. abundances below 0.01 (1%) in ALL sampels
print(paste0('==> 4. Remove taxa with rel. abundances below: ', argv$min))
my_physeq_relTMP  = transform_sample_counts(my_physeq, function(OTU) OTU / sum(OTU))
# check if due to the filter 0 taxa will be removed (avoid error)
check0 = filter_taxa(my_physeq_relTMP, function(OTU) max(OTU) <= argv$min)
if ( length(check0[check0 == TRUE]) <= 0 ) {
  print('       Number of taxa removed: 0')
  my_physeq = my_physeq_relTMP
  } else {
  my_low_abundant_OTUs = filter_taxa(my_physeq_relTMP, function(OTU) max(OTU) <= argv$min, TRUE)
  my_rmtaxa = taxa_names(my_low_abundant_OTUs)
  alltaxa = taxa_names(my_physeq)
  myTaxa = alltaxa[!alltaxa %in% my_rmtaxa]
  my_physeq = prune_taxa(myTaxa,my_physeq)
  print(paste0('       Number of taxa removed: ', length(my_rmtaxa)))
  print('       The removed taxa are: ')
  print(my_rmtaxa)
  my_physeq = transform_sample_counts(my_physeq, function(OTU) OTU / sum(OTU))
  }

my_physeq
saveRDS(my_physeq, file = "my_physeq_filtered.rds")

#######################