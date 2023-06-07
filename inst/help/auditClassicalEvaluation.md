Evaluation
===

The evaluation analysis allows the user to perform inference about the total misstatement in the population on the basis of an audit sample.

<img src="%HELP_FOLDER%/img/workflowEvaluation.png" />

Please see the manual of the Audit module (download [here](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) for more detailed information about this analysis.

### Input
---

#### Assignment Box
- Item ID: A unique non-missing identifier for every item in the population. The row number of the items is sufficient.
- Book Values: The variable that contains the book values of the items in the population. Ideally, all book values are positive values, see the <i>Critical Items</i> option for the handling of negative book values.
- Audit result / values: The variable that contains the audit (true) values, or the binary classification of correct (0) or incorrect (1).
- Selection counter: The variable that contains how many times each observation should be evaluated.
- Stratum: An optional variable that contains, for each item, which stratum an item belong to in the population. Providing a stratum variable indicates to the analysis that the population is split into several subgroups, and that an estimate must be made for each of these subgroups.

#### Sampling Objectives
- Performance materiality: Also called the upper error limit, the tolerable deviation rate, or the tolerable misstatement, the performance materiality is the upper bound of tolerable misstatement in the population to be tested. By testing against a performance materiality, you are able to plan a sample in order to collect evidence for or against the statement that the population as a whole does not contain misstatements that are considered material (i.e., are greater than the upper bound of tolerable misstatement). You should enable this objective when you want to find out whether the population contains misstatement above or below a certain limit (the performance materiality) using a sample of the population. A lower performance materiality will result in a higher required sample size. Vice versa, a higher performance materiality will result in a lower required sample size.
- Minimum precision: The precision is the the difference between the estimated most likely error and the upper bound on the misstatement. By enabling this sampling objective, you are be able to plan a sample so that the difference between the estimated most likely error and the upper bound on the misstatement is reduced to a minimum percentage. You should enable this objective if you are interested in making an estimate of the population misstatement with a certain accuracy. A lower minimum required precision will result in a higher required sample size. Vice versa, a higher minimum required precision will result in a lower required sample size.

#### Confidence
The confidence level used. The confidence level is the complement of the audit risk: the risk that the user is willing to take to give an incorrect judgment about the population. For example, if you want to have an audit risk of 5%, this equals 95% confidence.

#### Data Type
- Population: Specify that you are using a data file representing the population. This requires that you use a <i>Selection Counter</i> variable indicating how many times each item is selected for the sample.
- Sample: Specify that you are using a data file representing only sample data.
- Summary statistics: Do not require data input and only require summary statistics of the sample.

#### Population
- No. items: The total number of items (rows) in the population.
- No. units: The total number of units in the population. Note that the units can be items (rows) or monetary units (values) depending on the audit question.

#### Audit Risk Model
- Inherent risk: A category or probability for the inherent risk. Inherent risk is defined as the risk of material misstatement posed by an error or omission in a financial statement due to a factor other than a failure of internal control.
- Control risk: A category or probability for the internal control risk. Control risk is defined as the risk of a material misstatement in the financial statements arising due to absence or failure in the operation of relevant controls of the auditee.
- Analytical risk: A category or probability for the analytical risk. Analytical risk is defined as the the risk that a material misstatement will not be discovered by the auditor through analytical procedures.

When the auditor has information that indicates a low-risk profile on the population, they can use this information to reduce their required sample size via the Audit Risk Model (ARM) provided that there are no errors in the population. According to the ARM, the audit risk (AR) is a function of the inherent risk (IR), the internal control risk (CR), the analytical risk (CAR) and the detection risk (DR).

*AR = IR x CR x CAR x DR*

The auditor assesses inherent risk, internal control risk and analytical risk generally on a 3-point scale consisting of high, medium and low to determine the appropriate detection risk. To use the ARM, these categorical risk assessments must be mapped to probabilities. By default, the Audit module uses the percentages shown in the table below, which are inspired by the <i>Handboek Auditing Rijksoverheid</i>. You can manually adjust the percentages associated with one or all of the risks by selecting the Custom option in the drop-down list under the corresponding risk assessment.

|  | Inherent risk (IR) | Control risk (CR) | Analytical Risk (CAR) |
| ---: | :---: | :---: | :---: |
| High | 100% | 100% | 100% |
| Medium | 63% | 52% | 50% |
| Low | 40% | 34% | 25% |

#### Display
- Explanatory Text: When checked, enables explanatory text in the analysis to help interpret the procedure and the statistical results.

#### Report
- Tables
  - Misstated items: Produces a table that contains all items that were found to contain a misstatement.
  - Corrections to population: Produces a table that contains the required corrections to the population value to achieve the sampling objectives.

- Plots
  - Sampling objectives: Produces a bar chart comparing the materiality, maximum misstatement and most likely error (MLE).
  - Estimates: Produces an interval plot for the population and optionally the stratum estimates of the misstatement.

- Format Output
  - Numbers: Display table output as numbers.
  - Percentages: Display table output as percentages.
  - Monetary values: Display table output as monetary values.

#### Advanced
- Method
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

- Critical Items
  - Negative book values: Isolates negative book values from the population.
    - Keep: Keeps negative book values to be inspected in the sample.
    - Remove: Removes negative book values.

- Confidence interval (Alt. Hypothesis)
  - Upper bound (< materiality): Calculate the upper bound and test the alternative hypothesis that misstatement < materiality.
  - Two-sided (< materiality): Calculate the upper and lower bound and test the alternative hypothesis that misstatement != materiality.
  - Lower bound (< materiality): Calculate the lower bound and test the alternative hypothesis that misstatement > materiality.

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
- AICPA (2019). <i>Audit Guide: Audit Sampling</i>. American Institute of Certified Public Accountants.
- Derks, K. (2023). jfa: Statistical Methods for Auditing. R package version 0.6.6.
- Leslie, D. A., Teitlebaum, A. D., Anderson, R. J. (1979). <i>Dollar-unit Sampling: A Practical Guide for Auditors</i>. Toronto: Copp Clark Pitman.
- Stringer, K. W. (1963) Practical aspects of statistical sampling in auditing. <i>Proceedings of Business and Economic Statistics Section</i>, American Statistical Association.
- Touw, P., & Hoogduin, L. (2011). Statistiek voor audit en controlling.

### R Packages
---
- jfa
