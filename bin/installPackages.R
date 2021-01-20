#' This script installs all required libraries automatically
#' Please install libraries manually if it was not possible to install an library automatically
#' Missing libraries are listed in missing_packages.txt
#' To install an library please use following two command:
#' install.packages("name of the missing library")
#' library("name of the missing library)

# Check if required packages are already installed, and install if missing
args <- commandArgs(TRUE)
packages <-c("methods", "dada2", "argparser",
            "phyloseq", "ape", "gtools", "plyr", "dplyr","tibble", "microbiome")

# Function to check whether the package is installed
InsPack <- function(pack)
{

  if ((pack %in% installed.packages()) == FALSE) {
    cat( " * attempting to install ", pack, "\n")
    install.packages(pack,repos = "http://cloud.r-project.org/")
  } else {
    cat (" * OK: ", pack, "\n")
  }
}



# Applying the installation on the list of packages
out <- capture.output( suppressMessages( lapply(packages, InsPack) ))

# Make the libraries
lib <- lapply(packages, require, character.only = TRUE)
not_installed <- which(lib==FALSE)
missing_packages <- lapply(not_installed, function(x) print(packages[x]))


# Adding log file in analysis
if (args[[1]] == 'save') {
  sink(file = "missing_packages.txt")
  cat (as.character(missing_packages))
  sink()
}
