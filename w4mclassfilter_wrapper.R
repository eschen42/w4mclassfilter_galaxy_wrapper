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

sampleclassNames <- as.character(argVc["sampleclassNames"])
# if (sampleclassNames == "NONE_SPECIFIED") {
#     sampleclassNames <- as.character(c())
# 
# } else {
#     sampleclassNames <- strsplit(x = sampleclassNames, split = ",", fixed = TRUE)[[1]]
# }
sampleclassNames <- strsplit(x = sampleclassNames, split = ",", fixed = TRUE)[[1]]
inclusive <- as.logical(argVc["inclusive"])
# print(sprintf("inclusive = '%s'", as.character(inclusive)))
classnameColumn <- as.character(argVc["classnameColumn"])
samplenameColumn <- as.character(argVc["samplenameColumn"])

##------------------------------
## Computation
##------------------------------

result <- w4m_filter_by_sample_class(
  dataMatrix_in        = dataMatrix_in
, sampleMetadata_in    = sampleMetadata_in
, variableMetadata_in  = variableMetadata_in
, dataMatrix_out       = dataMatrix_out
, sampleMetadata_out   = sampleMetadata_out
, variableMetadata_out = variableMetadata_out
, classes              = sampleclassNames
, include              = inclusive
, class_column         = classnameColumn
, samplename_column    = samplenameColumn
, failure_action       = my_print
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
