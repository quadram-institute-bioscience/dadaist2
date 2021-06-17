#!/usr/bin/env Rstudio --vanilla

args <- commandArgs(TRUE)
if (length(args) == 0) {
    stop("Missing argument: library-name\n")
}
libName     <- args[[1]]  


cat(" * Checking library: ", libName, "\n")
library(libName,character.only = TRUE)
cat(" * System info\n")
si <- sessionInfo()
si[] <- lapply(si, function(x) if (is.list(x)) x[sort(names(x))] else sort(x))


listToDataframe <- function(list) {
  versionsList <- lapply(list, function(x) x$Version)
  packages <- data.frame(matrix(unlist(versionsList), nrow=length(versionsList), byrow=TRUE))
  rownames(packages) <- names(versionsList)
  colnames(packages) <- c('version')
  return(packages)
}

cat("Packages")
listToDataframe(si$otherPkgs)
cat("Loaded")
listToDataframe(si$loadedOnly)
 
