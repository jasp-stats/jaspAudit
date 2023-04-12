True Value Estimation
===

The estimation analysis allows the user to estimate the true value of a population on the basis of a sample.

### Input
---

#### Assignment Box
- Book Value: The variable that contains the book values of the items in the population.
- Audit Value: The variable that contains the audit (true) values, or the binary classification of correct (0) or incorrect (1).

#### Population
- No. items: The total number of items (rows) in the population.
- No. units: The total number of units in the population. Note that the units can be items (rows) or monetary units (values) depending on the audit question.

#### Method
- Direct estimator: This method uses only the audit values to estimate the misstatement (Touw and Hoogduin, 2011).
- Difference estimator: This method uses the difference between the book values and the audit values to estimate the misstatement (Touw and Hoogduin, 2011).
- Ratio estimator: This method uses the ratio of correctness between the book values and the audit values to estimate the misstatement (Touw and Hoogduin, 2011).
- Regression estimator: This method uses the linear relation between the book values and the audit values to estimate the misstatement (Touw and Hoogduin, 2011).

#### Display
- Explanatory Text: When checked, enables explanatory text in the analysis to help interpret the procedure and the statistical results.
  Confidence: The confidence level used. The confidence level is the complement of the audit risk: the risk that the user is willing to take to give an incorrect judgment about the population. For example, if you want to have an audit risk of 5%, this equals 95% confidence.

#### Report
- Tables
  - Required sample size: Produces a table that shows, for a given uncertainty, the required sample size.

- Plots
  - Scatter plot: Produces a scatter plot comparing book values of the selection against their audit values. Observations that are in error are colored in red.

### Output
---

#### Estimation Table
- Estimate W: The point estimate of the total error in the population.
- Uncertainty: The uncertainty associated with the confidence interval.
- x-% confidence interval: The confidence interval associated with the estimate.

#### Required Sample Size
- Estimator: The used method.
- Uncertainty: The difference between the most likely value and the bounds.
- Required n: Required sample size.
- Additional n: Additional sample size.

### References
---
- AICPA (2019). <i>Audit Guide: Audit Sampling</i>. American Institute of Certified Public Accountants.
- Touw, P., & Hoogduin, L. (2011). Statistiek voor audit en controlling.

### R Packages
---
- Base R
