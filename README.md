# w4mclassfilter_galaxy_wrapper

#### A Galaxy tool to filter Workflow4Metabolomics data matrix files

[planemo](http://planemo.readthedocs.io/en/latest/)-oriented
[galaxy-tool-wrapper](https://docs.galaxyproject.org/en/latest/dev/schema.htm) to wrap the
[w4mclassfilter R package](https://github.com/HegemanLab/w4mclassfilter) for use with the
[Workflow4Metabolomics](http://workflow4metabolomics.org/) flavor of
[Galaxy](https://galaxyproject.org/)

#### Author

Arthur Eschenlauer (University of Minnesota, esch0041@umn.edu)

#### R package

The *w4mclassfilter* package is available from the Hegeman lab github repository (https://github.com/HegemanLab/w4mclassfilter/releases).

#### Tool updates

See the **NEWS** section at the bottom of this page

## Description

Filter a set of retention-corrected W4M files (dataMatrix, sampleMetadata, variableMetadata) by sample-class

## Galaxy Workflow Position

  - Upstream tool category: Preprocessing
  - Downstream tool categories: Normalisation, Statistical Analysis, Quality Control

## Motivation

GC-MS1 and LC-MS1 experiments seek to resolve chemicals as features that have distinct chromatographic behavior and (after ionization) mass-to-charge ratio. 
Data for a sample are collected as MS intensities, each of which is associated with a position on a 2D plane with dimensions of m/z ratio and chromatographic retention time.
Ideally, features would be sufficiently reproducible from sample-run to sample-run to identify features that are commmon among samples and those that differ. 
However, the chromatographic retention time for a chemical can vary from one run to another.
In the Workflow4Metabolomics (W4M, [Giacomoni *et al.*, 2014]) "flavor" of Galaxy, the XCMS [Smith *et al.*, 2006] preprocessing tools provide for "retention time correction" to align features among samples, but features may be better aligned if pooled samples and blanks are included.

Multivariate statistical techniques may be used to discover clusters of similar samples, and sometimes it is desirable to apply clustering iteratively to smaller and smaller subsets of samples until observable separation of clusters is no longer significant.
Once feature-alignment has been achieved among samples in GC-MS and LC-MS datasets, however, the presence of pools and blanks may confound identification and separation of clusters.
Multivariate statistical algorithms also may be impacted by missing values or dimensions that have zero variance.

The w4mclassfilter tool provides a way to choose subsets of samples for further analysis.
The tool takes as input the data matrix, sample metadata, and variable metadata Galaxy datasets produced by W4M and produces the same trio of datasets with data only for the selected samples.
The tool uses a "sample-class" column in the sample metadata as the basis for including or eliminating samples for further analysis.
Class-values to be considered are provided by the user as a comma-separated list.
The user also provides an indication whether the list specifies classes to be included in further analysis ("filter-in") or rather to be excluded from it ("filter-out").
Next, missing and negative intensites for features of the remaining samples are imputed to zero.
Finally, samples or features with zero variance are eliminated.

## Input files


| **File**                  | **Format** |
|:-------------------------:|:----------:|
|     Data matrix           |   tabular  |
|     Sample metadata       |   tabular  |
|     Variable metadata     |   tabular  |

## Parameters

* Data matrix file
  * variable x sample **dataMatrix** (tabular separated values) file of the numeric data matrix, with . as decimal, and NA for missing values; the table must not contain metadata apart from row and column names; the row and column names must be identical to the rownames of the sample and variable metadata, respectively (see below)
* Sample metadata file
  * sample x metadata **sampleMetadata** (tabular separated values) file of the numeric and/or character sample metadata, with . as decimal and NA for missing values
* Variable metadata file
	* variable x metadata **variableMetadata** (tabular separated values) file of the numeric and/or character variable metadata, with . as decimal and NA for missing values
* Names of sample classes (default = no names)
	* comma-separated names of sample classes to include or exclude
* Include named classes (default = filter-out)
	* *filter-in* - include only the named sample classes
	* *filter-out* - exclude only the named sample classes
* Column that names the sample-class (default = 'class')
	* name of the column in sample metadata that has the values to be tested against the 'classes' input parameter
* Column that names the sample (default = 'sampleMetadata')
	* name of the column in sample metadata that has the name of the sample

## Output files

* sampleMetadata
	* (tabular separated values) file identical to the **sampleMetadata** file given as an input argument, excepting lacking rows for samples (xC-MS features) that have been filtered out (by the sample-class filter or because of zero variance)
* variableMetadata
	* (tabular separated values) file identical to the **variableMetadata** file given as an input argument, excepting lacking rows for variables (xC-MS features) that have been filtered out (because of zero variance)
* dataMatrix
	* (tabular separated values) file identical to the **dataMatrix** file given as an input argument, excepting lacking rows for variables (xC-MS features) that have been filtered out (because of zero variance) and columns that have been filtered out (by the sample-class filter or because of zero variance)

## Working example

### Input files

| Input File        | Download from URL                                                                                            |
| ----------------- | ------------------------------------------------------------------------------------------------------------ |
| Data matrix       | https://raw.githubusercontent.com/HegemanLab/w4mclassfilter/master/tests/testthat/input_dataMatrix.tsv       |
| Sample metadata   | https://raw.githubusercontent.com/HegemanLab/w4mclassfilter/master/tests/testthat/input_sampleMetadata.tsv   |
| Variable metadata | https://raw.githubusercontent.com/HegemanLab/w4mclassfilter/master/tests/testthat/input_variableMetadata.tsv |

### Other input parameters

| Input Parameter                    | Value           |
| ---------------------------------- | --------------- |
| Names of sample classes            | M               |
| Include named classes              | filter-in       |
| Column that names the sample-class | gender          |
| Column that names the sample       | sampleMetadata  |

### Expected outputs

| Expected Output   | Download from URL                                                                                               |
| ----------------- | --------------------------------------------------------------------------------------------------------------- |
| Data matrix       | https://raw.githubusercontent.com/HegemanLab/w4mclassfilter/master/tests/testthat/expected_dataMatrix.tsv       |
| Sample metadata   | https://raw.githubusercontent.com/HegemanLab/w4mclassfilter/master/tests/testthat/expected_sampleMetadata.tsv   |
| Variable metadata | https://raw.githubusercontent.com/HegemanLab/w4mclassfilter/master/tests/testthat/expected_variableMetadata.tsv |

## NEWS

### CHANGES IN VERSION 0.98.1
#### NEW FEATURES
* First release - Wrap the w4mclassfilter R package that implements filtering of W4M data matrix, variable metadata, and sample metadata by class of sample.
* *dataMatrix* *is* modified by the tool, so it *does* appear as an output file
* *sampleMetadata* *is* modified by the tool, so it *does* appear as an output file
* *variableMetadata* *is* modified by the tool, so it *does* appear as an output file
#### INTERNAL MODIFICATIONS
* none
