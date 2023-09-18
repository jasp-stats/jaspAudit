<img src="inst/icons/readmeBackground.png" width="100%" />

[![DOI](https://joss.theoj.org/papers/10.21105/joss.02733/status.svg)](https://doi.org/10.21105/joss.02733)
[![R_build_status](https://github.com/jasp-stats/jaspAudit/workflows/unit-tests/badge.svg)](https://github.com/jasp-stats/jaspAudit/actions)
[![jfa](https://img.shields.io/cran/v/jfa?color=yellow&label=jfa&logo=r)](https://cran.r-project.org/package=jfa)

# The Audit Module <img src='https://github.com/jasp-stats/jaspAudit/raw/master/inst/icons/audit-module.svg' width='149' height='173' align='right'/>

**JASP for Audit** (also known as the Audit module) is an add-on module for JASP that streamlines the process of statistical auditing. The Audit module offers a wide range of functionalities, including (but not limited to) planning, executing, evaluating, and documenting statistical audit samples. Specifically, it comprises analysis tools for determining sample sizes, selecting items using standard audit sampling methododology, and inferring the population misstatement based on the sample data or the summary statistics of the sample. Furthermore, the Audit module also includes tools for data auditing. The module provides Bayesian equivalents of most analyses, enabling users to incorporate pre-existing audit information into the statistical procedure. In all analyses, the Audit module provides comprehensive explanatory text that assists the auditor in understanding, documenting and communicating the statistical results.

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
    -- Audit Sampling
       - Sampling Workflow
       - Bayesian Sampling Workflow
       - Planning
       - Bayesian Planning
       - Selection
       - Evaluation
       - Bayesian Evaluation
       - True Value Estimation
    -- Data Auditing
       - Benford's Law
       - Repeated Values
    -- Algorithm Auditing
       - Fairness Metrics
```

### Changelog

Please find the module's changelog by clicking [here](https://github.com/jasp-stats/jaspAudit/blob/master/NEWS.md). This changelog provides a detailed record of all the modifications and updates made to the module. It can be useful to stay up-to-date with the latest changes and bug fixes, or to check if a particular issue has been addressed.

### Sections

#### Audit Sampling <img src='https://github.com/jasp-desktop/jaspAudit/raw/master/inst/icons/audit-sampling.svg' width='149' height='173' align='right'/>

The **Audit Sampling** section of the module makes it easy for an auditor to plan a statistical sample, select the sample from the population, and evaluate the misstatement in the sample compliant with international auditing standards. The analyses also provide auditors with easy documentation of their sampling procedure and statistical results. This comprehensive approach not only streamlines the audit process but also enhances transparency and efficiency.

#### Data Auditing <img src='https://github.com/jasp-desktop/jaspAudit/raw/master/inst/icons/audit-data.svg' width='149' height='173' align='right'/>

The **Data Auditing** section of the module provides statistical methods for auditing data, including (Bayesian) tests of digit distributions and tests for repeated values. These methods can be used to identify anomalies in a set of numbers, but do not provide conclusive results in terms of whether a data set is likely tampered with. For instance, non-conformance to Benford's law can only be seen as an indication of possible data manupulation. Unlike Benford's law, the other analysis is this section examines the entire number at once, not only the first or last digit(s).

#### Algorithmic Auditing <img src='https://github.com/jasp-desktop/jaspAudit/raw/master/inst/icons/audit-algorithms.svg' width='149' height='173' align='right'/>

The **Algorithm Auditing** section of the module includes methods for auditing algorithms on the aspect of fairness and discrimination. For instance, the fairness metrics analysis aims to assess fairness in algorithmic decision-making systems by computing and testing the equality of one of several model-agnostic fairness metrics between protected classes. The metrics are computed based on a set of true labels and the predictions of an algorithm.

### Translations

The JASP translation project is located at the following [link](https://hosted.weblate.org/projects/jasp/). The Audit module is referred to as `jaspAudit` and consists of two distinct components: `jaspAudit-QML` and `jaspAudit-R`, both of which require translation. The participation of any individual who is interested would be highly valued. As demonstrated below, we have made substantial progress in the translation of the Audit module.

| Interface | Results |
| :---: | :---: |
| [![image](https://hosted.weblate.org/widgets/jasp/-/jaspaudit-qml/multi-auto.svg)](https://hosted.weblate.org/engage/jasp/) | [![image](https://hosted.weblate.org/widgets/jasp/-/jaspaudit-r/multi-auto.svg)](https://hosted.weblate.org/engage/jasp/) |
