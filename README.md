<img src="inst/icons/readmeBackground.png" width="100%" />

[![R_build_status](https://github.com/jasp-stats/jaspAudit/workflows/unit-tests/badge.svg)](https://github.com/jasp-stats/jaspAudit/actions)

# The Audit Module

JASP for Audit (the Audit module) is an officially supported add-on module for JASP that is designed specifically with the auditor in mind. The audit module helps the auditor in interpreting, explaining, and reporting the analyses and leaves a transparent audit trail. The Audit module provides analyses for planning, performing, evaluating, and reporting an audit sample. Specifically, it contains analyses for calculating sample sizes, selecting the transactions according to standard audit sampling techniques, and calculating various upper limits for the misstatement from the sample or from summary statistics. The Bayesian analyses allow the user to create a prior probability distribution to perform Bayesian audit sampling.

## Manual

For an introduction to JASP for Audit, please download the [manual](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf).

## Core Functionality

The functionality of the Audit module heavily mirrors that of two R packages:

- For the sampling analyses, the Audit module uses the [`jfa`](https://cran.r-project.org/package=jfa) R package [[package website](https://koenderks.github.io/jfa/)].
- For the digit analyses, the Audit module uses the [`digitTests`](https://cran.r-project.org/package=digitTests) R package [[package website](https://koenderks.github.io/digitTests/)].

<p align="center">
  <img src='https://github.com/koenderks/jfa/raw/development/man/figures/logo.png' width='149' height='173'>
  <img src='https://github.com/koenderks/digitTests/raw/development/man/figures/logo.png' width='149' height='173'>
</p>

## Module Structure

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