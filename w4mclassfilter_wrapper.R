#!/usr/bin/env Rscript

library(batch) ## parseCommandArgs

########
# MAIN #
########

argVc <- unlist(parseCommandArgs(evaluate=FALSE))

##------------------------------
## Initializing
##------------------------------

## options
##--------

strAsFacL <- options()$stringsAsFactors
options(stringsAsFactors = FALSE)

## libraries
##----------

suppressMessages(library(w4mclassfilter))

if(packageVersion("w4mclassfilter") < "0.98.0")
    stop("Please use 'w4mclassfilter' versions of 0.98.0 and above")

## constants
##----------

modNamC <- "w4mclassfilter" ## module name

topEnvC <- environment()
flgC <- "\n"

## functions
##----------

flgF <- function(tesC,
                 envC = topEnvC,
                 txtC = NA) { ## management of warning and error messages

    tesL <- eval(parse(text = tesC), envir = envC)

    if(!tesL) {

        #sink(NULL)
        stpTxtC <- ifelse(is.na(txtC),
                          paste0(tesC, " is FALSE"),
                          txtC)

        stop(stpTxtC,
             call. = FALSE)

    }

} ## flgF


## log file
##---------

my_print <- function(x, ...) { cat(c(x, ...))}

my_print("\nStart of the '", modNamC, "' Galaxy module call: ",
    format(Sys.time(), "%a %d %b %Y %X"), "\n", sep="")

## arguments
##----------

# files

dataMatrix_in <- as.character(argVc["dataMatrix_in"])
dataMatrix_out <- as.character(argVc["dataMatrix_out"])

sampleMetadata_in <- as.character(argVc["sampleMetadata_in"])
sampleMetadata_out <- as.character(argVc["sampleMetadata_out"])

variableMetadata_in <- as.character(argVc["variableMetadata_in"])
variableMetadata_out <- as.character(argVc["variableMetadata_out"])

# other parameters

transformation <- as.character(argVc["transformation"])
wildcards <- as.logical(argVc["wildcards"])
sampleclassNames <- as.character(argVc["sampleclassNames"])
sampleclassNames <- strsplit(x = sampleclassNames, split = ",", fixed = TRUE)[[1]]
if (wildcards) {
  sampleclassNames <- gsub("[.]", "[.]", sampleclassNames)
  sampleclassNames <- utils::glob2rx(sampleclassNames, trim.tail = FALSE)
}
inclusive <- as.logical(argVc["inclusive"])
classnameColumn <- as.character(argVc["classnameColumn"])
samplenameColumn <- as.character(argVc["samplenameColumn"])

variable_range_filter <- as.character(argVc["variable_range_filter"])
variable_range_filter <- strsplit(x = variable_range_filter, split = ",", fixed = TRUE)[[1]]

## -----------------------------
## Transformation and imputation
## -----------------------------
my_w4m_filter_imputation <- if (transformation == "log10") {
  function(m) {
    if (!is.matrix(m))
      stop("Cannot impute and transform data - the supplied data is not in matrix form")
    if (nrow(m) == 0)
      stop("Cannot impute and transform data - data matrix has no rows")
    if (ncol(m) == 0)
      stop("Cannot impute and transform data - data matrix has no columns")
    suppressWarnings(
      # suppress warnings here since non-positive values will produce NaN's that will be fixed in the next step
      m <- log10(m)
    )
    return ( w4m_filter_imputation(m) )
  }
} else if (transformation == "log2") {
  function(m) {
    if (!is.matrix(m))
      stop("Cannot impute and transform data - the supplied data is not in matrix form")
    if (nrow(m) == 0)
      stop("Cannot impute and transform data - data matrix has no rows")
    if (ncol(m) == 0)
      stop("Cannot impute and transform data - data matrix has no columns")
    suppressWarnings(
      # suppress warnings here since non-positive values will produce NaN's that will be fixed in the next step
      m <- log2(m)
    )
    return ( w4m_filter_imputation(m) )
  }
} else {
  # use the method from the w4mclassfilter class
  w4m_filter_imputation
}

##------------------------------
## Computation
##------------------------------

result <- w4m_filter_by_sample_class(
  dataMatrix_in         = dataMatrix_in
, sampleMetadata_in     = sampleMetadata_in
, variableMetadata_in   = variableMetadata_in
, dataMatrix_out        = dataMatrix_out
, sampleMetadata_out    = sampleMetadata_out
, variableMetadata_out  = variableMetadata_out
, classes               = sampleclassNames
, include               = inclusive
, class_column          = classnameColumn
, samplename_column     = samplenameColumn
, variable_range_filter = variable_range_filter
, failure_action        = my_print
, data_imputation       = my_w4m_filter_imputation
)

my_print("\nResult of '", modNamC, "' Galaxy module call to 'w4mclassfilter::w4m_filter_by_sample_class' R function: ",
    as.character(result), "\n", sep = "")

##--------
## Closing
##--------

my_print("\nEnd of '", modNamC, "' Galaxy module call: ",
    as.character(Sys.time()), "\n", sep = "")

#sink()

if (!file.exists(dataMatrix_out)) {
  print(sprintf("ERROR %s::w4m_filter_by_sample_class - file '%s' was not created", modNamC, dataMatrix_out))
}# else { print(sprintf("INFO %s::w4m_filter_by_sample_class - file '%s' was exists", modNamC, dataMatrix_out)) }

if (!file.exists(variableMetadata_out)) {
  print(sprintf("ERROR %s::w4m_filter_by_sample_class - file '%s' was not created", modNamC, variableMetadata_out))
} # else { print(sprintf("INFO %s::w4m_filter_by_sample_class - file '%s' was exists", modNamC, variableMetadata_out)) }

if (!file.exists(sampleMetadata_out)) {
  print(sprintf("ERROR %s::w4m_filter_by_sample_class - file '%s' was not created", modNamC, sampleMetadata_out))
} # else { print(sprintf("INFO %s::w4m_filter_by_sample_class - file '%s' was exists", modNamC, sampleMetadata_out)) }

if( !result ) {
  stop(sprintf("ERROR %s::w4m_filter_by_sample_class - method failed", modNamC))
}

rm(list = ls())
