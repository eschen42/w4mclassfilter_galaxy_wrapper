[![DOI](https://zenodo.org/badge/90571457.svg)](https://zenodo.org/badge/latestdoi/90571457)

[Repository 'w4mclassfilter' in Galaxy Toolshed](https://toolshed.g2.bx.psu.edu/repository?repository_id=5f24951d82ab40fa)

# W4m Data Subset

#### A Galaxy tool to select a subset of Workflow4Metabolomics data

*W4m Data Subset* is [Galaxy tool-wrapper](https://docs.galaxyproject.org/en/latest/dev/schema.htm) to wrap the
[w4mclassfilter R package](https://github.com/HegemanLab/w4mclassfilter) for use with the
[Workflow4Metabolomics](http://workflow4metabolomics.org/) flavor of
[Galaxy](https://galaxyproject.org/).
This tool is built with [planemo](http://planemo.readthedocs.io/en/latest/).

#### Author

Arthur Eschenlauer (University of Minnesota, esch0041@umn.edu)

#### R package wrapped by this tool

The *w4mclassfilter* package is available from the Hegeman lab github repository [https://github.com/HegemanLab/w4mclassfilter/releases](https://github.com/HegemanLab/w4mclassfilter/releases).

#### Tool in Galaxy toolshed

The "w4mclassfilter" Galaxy tool, built from this repository, is in the main Galaxy toolshed at [https://toolshed.g2.bx.psu.edu/repository?repository_id=5f24951d82ab40fa](https://toolshed.g2.bx.psu.edu/repository?repository_id=5f24951d82ab40fa)

#### Tool updates

See the **NEWS** section at the bottom of this page

## Motivation

GC-MS and LC-MS experiments seek to resolve chemicals as features that have distinct chromatographic retention time ("rt") and (after ionization) mass-to-charge ratio ("m/z" or "mz"). Data for a sample are collected as MS intensities, each of which is associated with a position on a 2D plane with dimensions of rt and m/z. Ideally, features would be sufficiently reproducible among sample-runs to distinguish features that are commmon among samples from those that differ. However, in practice, the chromatographic retention time for a chemical can vary from one sample-injection to the next.

Workflow4Metabolomics (W4m, [Giacomoni et al., 2014, Guitton et al. 2017]) is a "flavor" of Galaxy that uses the XCMS preprocessing tools [Smith et al., 2006] for "retention time correction" to align features among samples; features may be better aligned if pooled samples and blanks are included.

Multivariate statistical techniques may be used to discover clusters of similar samples [Thévenot et al., 2015]. However, once retention-time alignment of features has been achieved among samples in GC-MS and LC-MS datasets, the presence of pools and blanks may confound identification and separation of clusters. Multivariate statistical algorithms also may be impacted by missing values or dimensions that have zero variance.

## Description

The W4m Data Subset tool selects subsets of samples, features, or data values for further analysis. The tool takes as input the data matrix, sample metadata, and variable metadata datasets produced by Workflow4Metabolomics tools and produces the same trio of datasets with only the selected data, samples, or features.

This tool performs several operations to address several data issues that may impede downstream statistical analysis:

  - Missing values in dataMatrix are imputed to zero.
  - Features and samples that have zero variance are eliminated.
  - Samples and features are sorted alphabetically in rows and columns of variableMetadata, sampleMetadata, and dataMatrix.
  - By default, the names of the first columns of variableMetadata and sampleMetadata are set respectively to "variableMetadata" and "sampleMetadata".

This tool performs several operations to reduce the number samples or features to be analyzed, although **this should be done only after significance tests** (see [Further considerations concerning sample-selection and hypothesis-testing](#further-considerations-concerning-sample-selection-and-hypothesis-testing) below):

  - Samples that are missing from either sampleMetadata or dataMatrix are eliminated.
  - Samples may also be eliminated by a “sample class” column in sampleMetadata.
  - Features that are missing from either variableMetadata or dataMatrix are eliminated.
  - Features may be eliminated by specifying minimum or maximum value (or both) allowable in columns of variableMetadata.
  - Features may be eliminated by specifying minimum or maximum intensity (or both) allowable in columns of dataMatrix for at least one sample for each feature (“range of row-maximum for each feature”).

The W4m Data Subset tool may be applied several times sequentially; for example, this may be useful for clustering progressively smaller subsets of samples until observable separation of clusters is no longer significant.

## Galaxy Workflow Position

  - Upstream tool category: Preprocessing
  - Downstream tool categories: Normalisation, Statistical Analysis, Quality Control

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
* Column that names the sample (default = 'sampleMetadata')
	* name of the column in sample metadata that has the name of the sample
* Column that names the sample-class (default = 'class')
	* name of the column in sample metadata that has the values to be tested against the 'classes' input parameter
* Names of sample classes (default = no names)
	* comma-separated names of sample classes to include or exclude
* Use wild-cards or regular-expressions (default = 'wild-cards')
	* *wild-cards*  use '`*`' and '`?`' to match class names
	* *regular-expressions* - use comma-less regular expressions to match class names
* Include named classes (default = 'filter-out')
	* *filter-in* - include only the named sample classes
	* *filter-out* - exclude only the named sample classes
* Variable range-filters (default = no filters)
	* comma-separated filters, each specified as 'variableMetadataColumnName:min:max'; default is no filters

## Output files

* sampleMetadata
	* (tabular separated values) file identical to the **sampleMetadata** file given as an input argument, excepting lacking rows for samples (xC-MS features) that have been filtered out (by the sample-class filter or because of zero variance)
* variableMetadata
	* (tabular separated values) file identical to the **variableMetadata** file given as an input argument, excepting lacking rows for variables (xC-MS features) that have been filtered out (because of zero variance)
* dataMatrix
	* (tabular separated values) file identical to the **dataMatrix** file given as an input argument, excepting lacking rows for variables (xC-MS features) that have been filtered out (because of zero variance) and columns that have been filtered out (by the sample-class filter or because of zero variance)

## Further considerations concerning sample-selection and hypothesis-testing

In untargeted metabolomic analysis, we collect the many "features" (intensity of the mass spectrum versus the mass-to-charge ratio and the chromatographic retention time).
The data-processing workflow that we follow (from [Thévenot 2015]) performs an univariate test of significance of the variation of features and retains for multivariate analysis only those features found to be significant, with FDR-adjustment of the p-value.

Our understanding is that:
  - A p-value is calculated for each feature for the null hypothesis that the feature does not vary significantly between treatment levels for all samples.
  - The p-value is adjusted according to the number of features analyzed.
  - The p-value needs to be adjusted because, e.g., at the unadjusted 1% level, for 10,000 features, 100 would be expected to appear significant by random chance.
    - Decreasing the number of features would falsely (or at least misleadingly) decrease the FDR-adjusted p-value.
    - Decreasing the number of samples might "reduce the power of the statistical test".

Therefore, we do not recommend eliminating samples or features until after univariate hypothesis testing has been performed.

"False Discovery Rate" [Benjamini, 1995; Yekutieli, 2001] is a less conservative than Bonferroni correction and thus more suitable to the many simultaneous hypothesis testes encountered in metabolomic analysis.  Therefore, "fdr" or "BY" would be the preferable choices for adjusting the p-value when running the W4m Univariate statistics tool.

## NEWS

### Changes in version 0.98.8

#### New features
* The tool now appears in Galaxy with a new, more representative name: "W4m Data Subset"
* Some documentation was updated or clarified.
* There are no functional changes.

#### Internal modifications
* None

### Changes in version 0.98.7

#### New features
* First column of output variableMetadata (that has feature names) now is always named `variableMetadata`
* First column of output sampleMetadata now (that has sample names) is always named `sampleMetadata`

#### Internal modifications

* Now uses w4mclassfilter R package v0.98.7.

### Changes in version 0.98.6

#### New features
* Added support for filtering out features whose attributes fall outside specified ranges. For more detail, see "Variable-range filters" above.

#### Internal modifications
* Now uses w4mclassfilter R package v0.98.6.
* Now sorts sample names and feature names in output files because some statistical tools expect the same order in dataMatrix row and column names as in the corresponding metadata files.

### Changes in version 0.98.3

#### New features
* Improved reference-list.

#### Internal modifications
* Improved input handling.
* Now uses w4mclassfilter R package v0.98.3, although that version has no functional implications for this tool.

### Changes in version 0.98.1

#### New features
* First release - Wrap the w4mclassfilter R package that implements filtering of W4M data matrix, variable metadata, and sample metadata by class of sample.
* *dataMatrix* *is* modified by the tool, so it *does* appear as an output file
* *sampleMetadata* *is* modified by the tool, so it *does* appear as an output file
* *variableMetadata* *is* modified by the tool, so it *does* appear as an output file

#### Internal modifications
* none

## Citations

Benjamini, Yoav and Hochberg, Yosef (1995) **Controlling the False Discovery Rate: A Practical and Powerful Approach to Multiple Testing.** In  Journal of the royal statistical society. Series B (Methodological), 1 (57), pp. pp. 289-300. [http://www.jstor.org/stable/2346101](http://www.jstor.org/stable/2346101)

Giacomoni, F. and Le Corguille, G. and Monsoor, M. and Landi, M. and Pericard, P. and Petera, M. and Duperier, C. and Tremblay-Franco, M. and Martin, J.-F. and Jacob, D. and et al. (2014). **Workflow4Metabolomics: a collaborative research infrastructure for computational metabolomics.** In Bioinformatics, 31 (9), pp. 1493–1495. [doi:10.1093/bioinformatics/btu813](http://dx.doi.org/10.1093/bioinformatics/btu813)

Guitton, Yann and Tremblay-Franco, Marie and Le Corguillé, Gildas and Martin, Jean-François and Pétéra, Mélanie and Roger-Mele, Pierrick and Delabrière, Alexis and Goulitquer, Sophie and Monsoor, Misharl and Duperier, Christophe and et al. (2017). **Create, run, share, publish, and reference your LC–MS, FIA–MS, GC–MS, and NMR data analysis workflows with the Workflow4Metabolomics 3.0 Galaxy online infrastructure for metabolomics.** In The International Journal of Biochemistry & Cell Biology, pp. 89-101. [doi:10.1016/j.biocel.2017.07.002](http://dx.doi.org/10.1016/j.biocel.2017.07.002)

Smith, Colin A. and Want, Elizabeth J. and O’Maille, Grace and Abagyan, Ruben and Siuzdak, Gary (2006). **XCMS: Processing Mass Spectrometry Data for Metabolite Profiling Using Nonlinear Peak Alignment, Matching, and Identification.** In Analytical Chemistry, 78 (3), pp. 779–787. [doi:10.1021/ac051437y](http://dx.doi.org/10.1021/ac051437y)

Thévenot, Etienne A. and Roux, Aurélie and Xu, Ying and Ezan, Eric and Junot, Christophe (2015). **Analysis of the Human Adult Urinary Metabolome Variations with Age, Body Mass Index, and Gender by Implementing a Comprehensive Workflow for Univariate and OPLS Statistical Analyses.** In Journal of Proteome Research, 14 (8), pp. 3322–3335. [doi:10.1021/acs.jproteome.5b00354](http://dx.doi.org/10.1021/acs.jproteome.5b00354)

Yekutieli, Daniel and Benjamini, Yoav (2001) **The control of the false discovery rate in multiple testing under dependency.** In The Annals of Statistics, 29 (4), pp. 1165-1188. [doi:10.1214/aos/1013699998](http://dx.doi.org/10.1214/aos/1013699998) 
