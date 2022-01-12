Evaluation
===

The evaluation analysis allows the user to perform inference about the total misstatement in the population on the basis of an audit sample.

<img src="%HELP_FOLDER%/img/workflowEvaluation.png" />

Please see the manual of the Audit module (download [here](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) for more detailed information about this analysis.

### Input
---

#### Sampling Objectives
- Performance materiality: Also called the upper error limit, the tolerable deviation rate, or the tolerable misstatement, the performance materiality is the upper bound of tolerable misstatement in the population to be tested. By testing against a performance materiality, you are able to plan a sample in order to collect evidence for or against the statement that the population as a whole does not contain misstatements that are considered material (i.e., are greater than the upper bound of tolerable misstatement). You should enable this objective when you want to find out whether the population contains misstatement above or below a certain limit (the performance materiality) using a sample of the population. A lower performance materiality will result in a higher required sample size. Vice versa, a higher performance materiality will result in a lower required sample size.
- Minimum precision: The precision is the the difference between the estimated most likely error and the upper bound on the misstatement. By enabling this sampling objective, you are be able to plan a sample so that the difference between the estimated most likely error and the upper bound on the misstatement is reduced to a minimum percentage. You should enable this objective if you are interested in making an estimate of the population misstatement with a certain accuracy. A lower minimum required precision will result in a higher required sample size. Vice versa, a higher minimum required precision will result in a lower required sample size.

#### Population
- No. items: The total number of items (rows) in the population.
- No. units: The total number of units in the population. Note that the units can be items (rows) or monetary units (values) depending on the audit question.

#### Confidence
The confidence level used. The confidence level is the complement of the audit risk: the risk that the user is willing to take to give an incorrect judgment about the population. For example, if you want to have an audit risk of 5%, this equals 95% confidence.

#### Assignment Box
- Item ID: A unique non-missing identifier for every item in the population. The row number of the items is sufficient.
- Book Values: The variable that contains the book values of the items in the population.
- Audit result / values: The variable that contains the audit (true) values, or the binary classification of correct (0) or incorrect (1).
- Selection counter: The variable that contains how many times each observation should be evaluated.

#### Data
- Raw: Use raw data.
- Summary statistics: Use summary statistics.

#### Audit Risk Model
- Inherent risk: A category or probability for the inherent risk. Inherent risk is defined as the risk of material misstatement posed by an error or omission in a financial statement due to a factor other than a failure of internal control.
- Control risk: A category or probability for the internal control risk. Control risk is defined as the risk of a material misstatement in the financial statements arising due to absence or failure in the operation of relevant controls of the auditee.

When the auditor has information that indicates a low-risk profile on the population, they can use this information to reduce their required sample size via the Audit Risk Model (ARM) provided that there are no errors in the population. According to the ARM, the audit risk (AR) is a function of the inherent risk (IR), the internal control risk (CR), and the detection risk (DR).

*AR = IR x CR x DR*

The auditor assesses inherent risk and internal control risk generally on a 3-point scale to determine the appropriate detection risk. Using the ARM and zero errors the sample size depends on the risk factor *R* and the performance materiality. The risk factor *R* is a function of the detection risk (Stewart 2012).

*R = -ln(DR)*

The following table presents values of *R* as a function of the detection risk, provided that there are zero errors (Touw and Hoogduin 2012).

| Detection risk (%) | 1 | 4 | 5 | 10 | 14 |
| :---: | :---: | :---: | :---: | :---: | :---: |
| R | 4.6 | 3.2 | 3 | 2.3 | 2 |

The risk factor *R* can be adjusted using the assessments of the inherent risk and the internal control risk. By default, the standard method of setting the probabilities of IR and CR is by following the table below for a detection risk of 5%:

|  | High | Medium | Low | 
| :---: | :---: | :---: |
| R | 3 | 2 | 1 |

These values of *R* are used to set default percentages for IR and CR. The Audit module handles the following default values for IR and CR:

- High: 100%
- Medium: 60%
- Low: 36%

You can manually adjust the value of IR and CR by selecting the Custom option under the corresponding risk assessment, thus adjusting the risk factor *R*.

#### Method
- Poisson: Uses the Poisson likelhood to evaluate the sample.
- Binomial: Uses the binomial likelhood to evaluate the sample.
- Hypergeometric: Uses the hypergeometric likelhood to evaluate the sample.
- Stringer: The Stringer bound to evaluate the sample (Stringer, 1963).
  - LTA adjustment: LTA adjustment for the stringer bound to incorporate understatements (Leslie, Teitlebaum, & Anderson, 1979).
- Mean-per-unit estimator: Uses the mean-per-unit estimator.
- Direct estimator: This method uses only the audit values to estimate the misstatement (Touw and Hoogduin, 2011).
- Difference estimator: This method uses the difference between the book values and the audit values to estimate the misstatement (Touw and Hoogduin, 2011).
- Ratio estimator: This method uses the ratio of correctness between the book values and the audit values to estimate the misstatement (Touw and Hoogduin, 2011).
- Regression estimator: This method uses the linear relation between the book values and the audit values to estimate the misstatement (Touw and Hoogduin, 2011).

#### Display
- Explanatory Text: When checked, enables explanatory text in the analysis to help interpret the procedure and the statistical results.

#### Tables
- Corrections to population: Produces a table that contains the required corrections to the population value to achieve the sampling objectives.

#### Plots
- Sampling objectives: Produces a bar chart comparing the materiality, maximum misstatement and most likely error (MLE).
- Scatter plot: Produces a scatter plot comparing book values of the selection against their audit values. Observations that are in error are colored in red.

#### Critical Items
- Negative book values: Isolates negative book values from the population.
  - Keep: Keeps negative book values to be inspected in the sample.
  - Remove: Removes negative book values.

#### Format Tables
- Numbers: Display table output as numbers.
- Percentages: Display table output as percentages.
- Monetary values: Display table output as monetary values.

### Output
---

#### Evaluation summary
- Materiality: When provided, the performance materiality.
- Min. precision: When provided, the minimum precision.
- Sample size: The sample size (number of units).
- Errors: The number of erroneous elements in the selection.
- Taint: The sum of the proportional errors. Audited items can be evaluated while incorporating the magnitude of the misstatement by calculating their taints. The taint of an item *i* is the proportional difference between that item's book value (*y*) and the item's audit (true) value (*x*). Positive taints are associated with overstatements, while negative taints occur when items are understated.
<img src="%HELP_FOLDER%/img/taints.png" />
- Most likely error: The most likely error in the population.
- x-% Confidence bound: Upper bound on the misstatement in the population.
- Precision: Difference between upper bound and most likely error.
- p: The p-value for the test.

#### Corrections to Population
- Correction: The amount or percentage to be deducted from the population.

#### Plots
- Sampling objectives: Produces a bar chart comparing the materiality, upper bound on the misstatement and most likely error (MLE).
- Scatter plot: Produces a scatter plot comparing book values of the selection against their audit values. Observations that are in error are colored in red.
  - Display correlation: Adds the correlation between the book values and the audit values to the plot.
  - Display item ID's: Adds the item ID's to the plot.

### References
---
- AICPA (2017). <i>Audit Guide: Audit Sampling</i>. American Institute of Certified Public Accountants.
- Derks, K (2021). jfa: Bayesian and Classical Audit Sampling. R package version 0.6.2.
- Leslie, D. A., Teitlebaum, A. D., Anderson, R. J. (1979). <i>Dollar-unit Sampling: A Practical Guide for Auditors</i>. Toronto: Copp Clark Pitman.
- Stringer, K.W. (1963) Practical aspects of statistical sampling in auditing. <i>Proceedings of Business and Economic Statistics Section</i>, American Statistical Association.
- Touw, P., & Hoogduin, L. (2011). Statistiek voor audit en controlling.

### R Packages
---
- jfa
