<img src="inst/icons/readmeBackground.png" width="100%" />

[![DOI](https://joss.theoj.org/papers/10.21105/joss.02733/status.svg)](https://doi.org/10.21105/joss.02733)
[![R_build_status](https://github.com/jasp-stats/jaspAudit/workflows/unit-tests/badge.svg)](https://github.com/jasp-stats/jaspAudit/actions)
[![jfa](https://img.shields.io/cran/v/jfa?color=yellow&label=jfa&logo=r)](https://cran.r-project.org/package=jfa)

# The Audit Module <img src='https://github.com/jasp-stats/jaspAudit/raw/master/inst/icons/audit-module.svg' width='149' height='173' align='right'/>

**JASP for Audit** (also known as to as the Audit module) is an add-on module for JASP that streamlines the process of statistical auditing. The Audit module offers a wide range of functionalities, including (but not limited to) planning, executing, evaluating, and documenting statistical audit samples. Specifically, it comprises analysis tools for determining sample sizes, selecting items using standard audit sampling methododology, and inferring the population misstatement based on the sample data or the summary statistics of the sample. Furthermore, the Audit module also includes tools for data auditing. The module provides Bayesian equivalents of most analyses, enabling users to incorporate pre-existing audit information into the statistical procedure. In all analyses, the Audit module provides comprehensive explanatory text that assists the auditor in understanding, documenting and communicating the statistical results.

## Articles

In order to familiarize oneself with the Audit module, it is recommended to obtain and read the manual via this [download link](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf), or to view it online through this [link](https://github.com/jasp-stats/jaspAudit/blob/master/man/manual.pdf). A reference for the Audit module can be obtained from the accompanying academic article published in the *Journal of Open-Source Software*, which can be accessed through the following permanent link [https://doi.org/10.21105/joss.02733](https://doi.org/10.21105/joss.02733).

## Blog posts

- 05/07/2019 - [JASP for Audit: Bayesian Tools for the Auditing Practice](https://jasp-stats.org/2019/07/25/jasp-for-audit-bayesian-tools-for-the-auditing-practice/)

## R Package

The Audit Module is a graphical user interface that has been constructed to integrate with the **jfa** R package available on [CRAN](https://cran.r-project.org/package=jfa), which offers a comprehensive set of statistical methods for auditing. To obtain a deeper understanding of the underlying statistical principles and implementation details of the **jfa** package, interested parties are encouraged to consult the [package website](https://koenderks.github.io/jfa/).

## Module

The organization of the analyses within the Audit module in JASP is as follows:

```
--- Audit
    -- Workflow
       - Sampling Workflow
       - Bayesian Sampling Workflow
    -- Planning
       - Planning
       - Bayesian Planning
    -- Selection
       - Selection
    -- Evaluation
       - Evaluation
       - Bayesian Evaluation
    -- Digit Analysis
       - Benford's Law
       - Repeated Values Analysis
    -- Other
       - True Value Estimation
```

### Changelog

Please find the module's changelog by clicking [here](https://github.com/jasp-stats/jaspAudit/blob/master/NEWS.md). This changelog provides a detailed record of all the modifications and updates made to the module. It can be useful to stay up-to-date with the latest changes and bug fixes, or to check if a particular issue has been addressed.

### Analyses

#### (Bayesian) Sampling Workflow

The sampling workflow is a four-stage procedure that facilitates the process of planning, selecting, annotating,and evaluating statistical audit samples. To enhance ease of use, the workflow employs automated selection of the most suitable options based on the nature of the data and the audit question being addressed. The final outcome of the Sampling Workflow is a report that can be downloaded and that comprises statistical results along with their corresponding interpretation.

<p align="center">
  <img src='https://github.com/jasp-stats/jaspAudit/raw/master/inst/help/img/workflow.png' width='500' height='50'>
</p>

#### (Bayesian) Planning

The planning analysis enables the user to determine the minimum sample size required for a statistical audit sample, based on a set of specified sampling objectives. By defining one or multiple objectives, the minimum sample size can be calculated to provide a specified level of assurance about the population misstatement, assuming that the actual sample follows the intended sampling plan.

<p align="center">
  <img src='https://github.com/jasp-stats/jaspAudit/raw/master/inst/help/img/workflowPlanning.png' width='500' height='50'>
</p>

#### Selection

The selection analysis facilitates the utilization of the most frequently employed sampling techniques in auditing. This analysis provides the user with the capability to choose a specified number of sampling units from the population through the implementation of one of three available sampling algorithms: fixed interval sampling, cell sampling, and random sampling. The sampling units can be in the form of items (rows) or monetary units, and the generated sample can be saved and exported to a file for additional annotation and documentation.

<p align="center">
  <img src='https://github.com/jasp-stats/jaspAudit/raw/master/inst/help/img/workflowSelection.png' width='500' height='50'>
</p>

#### (Bayesian) Evaluation

The evaluation analysis facilitates inference about the misstatement based on a sample data or summary statistics of the sample. The analysis incorporates a plethora of statistical techniques to estimate or test the population misstatement.

<p align="center">
  <img src='https://github.com/jasp-stats/jaspAudit/raw/master/inst/help/img/workflowEvaluation.png' width='500' height='50'>
</p>

#### Digit Analysis

The two forms of digit analysis, namely Benford's law and repeated values, furnish the capability for identifying irregular digit patterns within numerical data.

### Translations

The JASP translation project is located at the following [link](https://hosted.weblate.org/projects/jasp/). The Audit module is referred to as `jaspAudit` and consists of two distinct components: `jaspAudit-QML` and `jaspAudit-R`, both of which require translation. The participation of any individual who is interested would be highly valued. As demonstrated below, we have made substantial progress in the translation of the Audit module.

| Interface | Results |
| :---: | :---: |
| [![image](https://hosted.weblate.org/widgets/jasp/-/jaspaudit-qml/multi-auto.svg)](https://hosted.weblate.org/engage/jasp/) | [![image](https://hosted.weblate.org/widgets/jasp/-/jaspaudit-r/multi-auto.svg)](https://hosted.weblate.org/engage/jasp/) |
