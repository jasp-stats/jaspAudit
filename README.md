<img src="inst/icons/readmeBackground.png" width="100%" />

[![R_build_status](https://github.com/jasp-stats/jaspAudit/workflows/unit-tests/badge.svg)](https://github.com/jasp-stats/jaspAudit/actions)
[![jfa](https://img.shields.io/cran/v/jfa?color=yellow&label=jfa&logo=r)](https://cran.r-project.org/package=jfa)
[![digitTests](https://img.shields.io/cran/v/digitTests?color=yellow&label=digitTests&logo=r)](https://cran.r-project.org/package=digitTests)

# The Audit Module

JASP for Audit (the Audit module) is an add-on module for JASP that facilitates statistical auditing. Among other things, the module provides functionality for planning, performing, evaluating, and reporting a statistical audit sample. More concretely, it contains analyses for calculating sample sizes, selecting itms according to standard audit sampling techniques, and performing inference about the population misstatement on the basis of a data sample or summary statistics of a sample. The module also features Bayesian equivalents of these analyses that enable the user to easily incorporate prior information into the statistical procedure. In all analyses, the Audit module offers explanatory text that helps the auditor in interpreting, explaining, and reporting the analysis.

- [Manual](#manual)
- [Structure](#structure)
- [Analyses](#analyses)
- [Analyses](#analyses)
- [R packages](#r-packages)
- [Translations](#translations)

## Manual

For an introduction to the Audit module, please download the [manual](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf).

## Structure

The analyses in the Audit module are structured in JASP in the following way:

```
--- Audit
    -- Workflow
       - Sampling Workflow
       - Bayesian Sampling Workflow
    -- Planning
       - Classical Planning
       - Bayesian Planning
    -- Selection
       - Selection
    -- Evaluation
       - Classical Evaluation
       - Bayesian Evaluation
    -- Digit Analysis
       - Benford's Law
       - Repeated Values Analysis
    -- Other
       - True Value Estimation
```

## Analyses

### (Bayesian) Sampling Workflow

The sampling workflow is a four-stage analysis that guides the user through the process of planning, selecting, annotating, and evaluating a statistical audit sample. To make this process as easy as possible, the workflow automatically selects the appropriate options according to the type of data and audit question at hand. At the end, the sampling workflow produces a downloadable report containing the statistical results and their interpretation.

<p align="center">
  <img src='https://github.com/jasp-stats/jaspAudit/raw/master/inst/help/img/workflow.png' width='500' height='50'>
</p>

### (Bayesian) Planning

The planning analysis allows the user to, given a set of sampling objectives, calculate the minimum sample size for a statistical audit sample. By specifying a (set of) sampling objective(s), a sample size can be calculated which (when the intende sample goed according to plan) allows for a statement about the population misstatement with a prespecified amount of assurance.

<p align="center">
  <img src='https://github.com/jasp-stats/jaspAudit/raw/master/inst/help/img/workflowPlanning.png' width='500' height='50'>
</p>

### Selection

The selection analysis is an interface for the most commonly used sampling methods in auditing. The analysis allows the user to select a specified number of sampling units from the population according to one of three sampling algorithms: fixed interval sampling, cell sampling, and random sampling. Sampling units can be items (rows) or monetary units. The sample can be saved and exported to a file for futher annotation.

<p align="center">
  <img src='https://github.com/jasp-stats/jaspAudit/raw/master/inst/help/img/workflowSelection.png' width='500' height='50'>
</p>

### (Bayesian) Evaluation

The evaluation analysis allows the user to perform inference about the population misstatement on the basis of a data sample or summary statistics of a sample. The analysis contains a variety of statistical methods to evaluate the misstatement.

<p align="center">
  <img src='https://github.com/jasp-stats/jaspAudit/raw/master/inst/help/img/workflowEvaluation.png' width='500' height='50'>
</p>

### Digit Analysis
The two types of digits analyses (Benford's law and Repeated values) provide functionality for detecting irregular digit patterns in numerical data.

## `R` Packages

The functionality of the Audit module heavily mirrors that of two `R` packages:

- For the sampling analyses, the Audit module uses the [`jfa`](https://cran.r-project.org/package=jfa) package [[package website](https://koenderks.github.io/jfa/)].
- For the digit analyses, the Audit module uses the [`digitTests`](https://cran.r-project.org/package=digitTests) package [[package website](https://koenderks.github.io/digitTests/)].

<p align="center">
  <img src='https://github.com/koenderks/jfa/raw/development/man/figures/logo.png' width='149' height='173'>
  <img src='https://github.com/koenderks/digitTests/raw/development/man/figures/logo.png' width='149' height='173'>
</p>

## Translations

| Interface | Results |
| :---: | :---: |
| [![image](https://hosted.weblate.org/widgets/jasp/-/jaspaudit-qml/multi-auto.svg)](https://hosted.weblate.org/engage/jasp/) | [![image](https://hosted.weblate.org/widgets/jasp/-/jaspaudit-r/multi-auto.svg)](https://hosted.weblate.org/engage/jasp/) |
