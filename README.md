README

# Analysis code for a gestational diabetes mellitus study

**Title of project:** Metabolic status in mothers with gestational diabetes mellitus and the effects on fetal and neonatal outcomes – a cohort study

**Version:** 1.0.0

**Date:** 13.04.2026

**Authors:** Helene Højbjerre, Sine Knorr, Lene Ring Madsen, Magnus Leth-Møller, Pernille Bundgaard Grinderslev, Amalie Nørkjær Svendsen, Laura Løftgaard Knudsen, Lene Sundahl Mortensen, Lars Peter Sørensen, Henrik Holm Thomsen, Per Glud Ovesen, Jens Fuglsang, Ulla Kampmann

**Repository DOI**: DOI: 10.5281/zenodo.19559697

**License**: MIT

## Overview
This code repository contains the analysis code for the study of maternal metabolic status in women with gestational diabetes mellitus (GDM) and its associations with obstetric and neonatal outcomes. It includes data cleaning, variable construction, and statistical analyses for the study cohort from the Central Denmark Region GDM follow-up program (2019–2022). The repository is provided to support the transparency and reproducibility of the analyses presented in the manuscript. Clinical data are not publicly available, as data access is subject to legal and ethical restrictions.

## Repository structure

\- \`GDM_analysis.do\`

Stata do-file reproducing the analyses reported in the manuscript.

\- \`README.md\`

Documentation of repository contents and workflow.

\- \`DATA_DICTIONARY\`

Data dictionary describing variables used in the analyses.

\- \`MIT LICENSE\`

License for reuse of the code.

\- \` synthetic_demo_data_international.dta\`  
Synthetic dataset with 150 artificial observations illustrating the expected structure of the analysis dataset.

## Software requirements

\- Operating system tested on: macOS 26.4

\- Statistical software: Stata 18.0

\- Additional user-written Stata packages: none

\- Installation time: no additional installation is required beyond access to Stata 18.0

\- Typical runtime: approximately 3 minutes on a current desktop computer

## Input data

The analyses were conducted using clinical research data from a GDM follow-up program (2019–2022) in Central Denmark. The original individual-level data contain sensitive health information and are therefore not publicly available.

To support transparency and reproducibility, this repository provides:

\- the full analysis code used in the study.

\- a data dictionary describing variables used in the analyses.

\- a synthetic dataset demonstrating the expected data structure.

The synthetic example dataset is provided only to illustrate the expected structure of the analysis dataset and to allow testing of the code workflow. It does not contain real participant data and cannot reproduce the published results.

\## How to run the code

1\. Open Stata.

2\. Set the working directory to the repository folder.

3\. Ensure that the selected dataset is available in the expected format before running the code. The synthetic example dataset synthetic_demo_data_international.dta can be used to verify the workflow structure and expected outputs.

4\. Run \`GDM_analysis.do\`.

## Analytical workflow

The do-file is organized into five sections:

1\. Data preparation

This section recodes categorical variables, applies variable and value labels, and prepares the dataset for derivation of study variables and subsequent analyses.

2\. Derived variables  
This section defines derived maternal and neonatal variables used in the analyses  
<br/>3\. Descriptive analyses  
This section reproduces descriptive tables of maternal, obstetric, and neonatal characteristics. Continuous variables are assessed for approximate normality using histograms and Q-Q plots in order to guide summary statistics and choice of group comparison tests.  
<br/>4\. Main analyses  
This section reproduces the main logistic and linear regression analyses reported in the manuscript.  
<br/>5\. Sensitivity analyses

This section includes correlation analyses between glycaemic and lipid parameters and sensitivity analyses with mutual adjustment of selected correlated metabolic variables.

## Data availability
The original clinical data underlying this study are not publicly available because they contain sensitive participant information and are subject to ethical and legal restrictions.

## Code availability
The version of the code used in the manuscript is publicly available in Zenodo and is available at DOI: 10.5281/zenodo.19559697. This repository contains original analysis code written by the authors. The code is distributed under the MIT License. Use of the code does not provide access to the underlying clinical data or to Stata software, which requires a separate licensed installation.

\## Contact

For questions regarding the code or repository, please contact: Helene Højbjerre, Steno Diabetes Center Aarhus, [helhoj@rm.dk](mailto:helhoj@rm.dk)
