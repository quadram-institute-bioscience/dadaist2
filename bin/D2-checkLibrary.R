#!/usr/bin/env Rstudio --vanilla

# Print a two columns (packagename, version) list of 
# the loaded packages after loading a library (ARG1)

args <- commandArgs(TRUE)
if (length(args) == 0) {
    stop("Missing argument: library-name\n")
}
libName     <- args[[1]]  


cat("# Checking library: ", libName, "\n---\n")
# Messages from libray loading are between the --- lines
library(libName,character.only = TRUE)
cat("---\n")
si <- sessionInfo()
si[] <- lapply(si, function(x) if (is.list(x)) x[sort(names(x))] else sort(x))


listToDataframe <- function(list) {
  versionsList <- lapply(list, function(x) x$Version)
  packages <- data.frame(matrix(unlist(versionsList), nrow=length(versionsList), byrow=TRUE))
  rownames(packages) <- names(versionsList)
  colnames(packages) <- c('version')
  return(packages)
}
# Base packages are a list without versions
cat(" * Attached Base Packages")
base <- data.frame(matrix(unlist(si$basePkgs)))
colnames(base) <- c('Base_Package')
base

# Attached and loaded packages printed as dataframe 
cat(" * Attached Packages")
listToDataframe(si$otherPkgs)
cat(" * Only Loaded")
listToDataframe(si$loadedOnly)
