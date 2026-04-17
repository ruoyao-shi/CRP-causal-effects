# Code for estimating causal effects of C-reactive protein (CRP)

This repository contains code for our study investigating the causal effects of C-reactive protein (CRP) on multiple disease and health-related outcomes using multivariable Mendelian randomization (MVMR) with adjusting for heritable confounding.

The workflow includes extraction of candidate heritable confounders, quality control and filtering of candidate traits, downstream filtering, MVMR analyses, and generation of manuscript figures and supplementary results.

## Overview

The main analysis includes:
- instrument selection for CRP
- extraction of candidate heritable confounders
- quality control and filtering of candidate traits
- string-based deduplication
- downstream filtering using bidirectional Mendelian randomization (MR) / MVMR
- multivariable MR analyses using multiple methods
- generation of summary results, figures, and supplementary outputs

## Relationship to mrScan

This repository is built in part on the `mrScan` framework. For package-level documentation and details of the underlying confounder-selection workflow, please see:

- `mrScan`: `https://github.com/ruoyao-shi/mrScan`

## Repository structure

- `R/`  
  R scripts for the main analysis workflow, including trait extraction, quality control, filtering, MR/MVMR analyses, result summarization, and figure generation.

- `Snakefile`  
  Main Snakemake workflow for the primary analysis.

- `config.yaml`  
  Main configuration file specifying the exposure, outcome, and analysis parameters.

- `cluster.yaml`  
  Cluster resource settings for running the workflow on an HPC system.

- `run-snakemake.sh`  
  Example shell script for launching the workflow with Slurm.

- `stepwise_trait_selection/`  
  Snakemake workflow for stepwise trait selection based on instrument strength.

- `Snakefile_leaveoneout`  
  Workflow for leave-one-out analyses.

- `Snakefile_three_exposure`  
  Workflow for analyses with three exposures.

## Data availability

The workflow relies primarily on publicly available GWAS summary data from MRC-IEU OpenGWAS database.

## Requirements

Suggested software environment:
- R
- Snakemake
- Python
- PLINK
- LDSC
- access to an HPC or Slurm environment for large-scale runs
