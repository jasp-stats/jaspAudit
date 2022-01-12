Sampling Workflow
===

The task of an auditor is to make a judgment regarding the fairness of the presented transactions in a population. When the auditor has access to the raw population data, they can use the *audit workflow* to calculate how many samples need to be evaluated in order to meet a certain confidence in their judgment. The user can then sample these items from the population, inspect and audit these items, and perform statistical inference about the misstatement in the population. The sampling workflow guides the auditor through the audit process, making the correct choices of calculations along the way.

Please see the manual of the Audit module (download [here](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) for more detailed information about this analysis.

### Workflow
---

- Planning: Calculate the minimum sample size to achieve your sampling objectives with the specified confidence.
- Selection: Select the required sampling units from the population.
- Execution: Annotate the selection with your assessment of the fairness of the selected items.
- Evaluation: Make a population statement based on your annotated selection.

<img src="%HELP_FOLDER%/img/workflow.png" />

### Input - Planning
---

#### Sampling Objectives
- Performance materiality: Also called the upper error limit, the tolerable deviation rate, or the tolerable misstatement, the performance materiality is the upper bound of tolerable misstatement in the population to be tested. By testing against a performance materiality, you are able to plan a sample in order to collect evidence for or against the statement that the population as a whole does not contain misstatements that are considered material (i.e., are greater than the upper bound of tolerable misstatement). You should enable this objective when you want to find out whether the population contains misstatement above or below a certain limit (the performance materiality) using a sample of the population. A lower performance materiality will result in a higher required sample size. Vice versa, a higher performance materiality will result in a lower required sample size.
- Minimum precision: The precision is the the difference between the estimated most likely error and the upper bound on the misstatement. By enabling this sampling objective, you are be able to plan a sample so that the difference between the estimated most likely error and the upper bound on the misstatement is reduced to a minimum percentage. You should enable this objective if you are interested in making an estimate of the population misstatement with a certain accuracy. A lower minimum required precision will result in a higher required sample size. Vice versa, a higher minimum required precision will result in a lower required sample size.

#### Confidence
The confidence level used. The confidence level is the complement of the audit risk: the risk that the user is willing to take to give an incorrect judgment about the population. For example, if you want to have an audit risk of 5%, this equals 95% confidence.

#### Assignment Box
- Item ID: A unique non-missing identifier for every item in the population. The row number of the items is sufficient.
- Book Values: The variable that contains the book values of the items in the population.

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

#### Expected errors in Sample
The expected errors are the tolerable errors that can be found in the sample while still achieving the specified sampling objectives. A sample size is calculated so that, when the number of expected errors is found in the sample, the desired confidence is retained.

*Note:* It is advised to set this value conservatively to minimize the probability of the observed errors exceeding the expected errors, which would imply that insufficient work has been done.

- Relative: Enter your expected errors as a percentage relative to the total size of the selection.
- Absolute: Enter your expected errors as the sum of (proportional) errors.

#### Probability distribution
- Hypergeometric: The hypergeometric distribution assumes a finite population size and is therefore generally used when the population size is small. It is a probability distribution that models the number of errors (*K*) in the population as a function of the population size (*N*), the number of observed found errors (*k*) and the number of correct transactions (*n*).
- Binomial: The binomial distribution assumes an infinite population size and is therefore generally used when the population size is large. It is a probability distribution that models the rate of misstatement (*\u03B8*) as a function of the observed number of errors (*k*) and the number of correct transactions (*n - k*). Because the binomial distribution strictly does not accommodate partial errors, it is generally used when you are not planning a monetary unit sample.
- Poisson: The Poisson distribution assumes an infinite population size and is therefore generally used when the population size is large. It is a probability distribution that models the rate of misstatement (*\u03B8*) as a function of the observed sample size (*n*) and the sum of the proportional errors (*t*). Because the Poisson distribution accommodates partial errors it is generally used when you are planning a monetary unit sample.

#### Display
- Explanatory Text: When checked, enables explanatory text in the analysis to help interpret the procedure and the statistical results.

#### Tables
- Descriptive statistics: Produces a table with descriptive statistics of the book values in the population.

#### Plots
- Distribution of book values: Produces a histogram of the book values in the population.
- Compare sample sizes: Produces a plot that compares the sample size 1) across probability distributions, and 2) across the number of expected errors in the sample.
- Assumed error distribution: Produces a plot that displays the probability distribution implied by the input options and the calculated sample size.

#### Critical Items
- Negative book values: Isolates negative book values from the population.
  - Keep: Keeps negative book values to be inspected in the sample.
  - Remove: Removes negative book values.

#### Format Tables
- Numbers: Display table output as numbers.
- Percentages: Display table output as percentages.

#### Iterations
- Increment: The increment alows you to limit the possible sample sizes to a multiple of its value. For example, an increment of 5 allows only sample sizes of 5, 10, 15, 20, 25, etc.
- Maximum: The maximum allows you to limit the sample size with a maximum.

### Ouput - Planning
---

#### Planning Summary
- Performance materiality: When provided, the performance materiality.
- Min. precision: When provided, the minimum precision.
- Expected errors: The number (sum of proportional taints) of expected / tolerable errors in the sample.
- Minimum sample size: The minimum sample size.

#### Descriptive Statistics
- Population size: Number of items in the population.
- Value: Total value of the book values.
- Absolute value: Absolute value of the book values.
- Mean: Mean of the book values.
- Std. deviation: Standard deviation of the book values.
- Quartile: Quartiles of the book values.

#### Plots
- Distribution of book values: Produces a histogram of the book values in the population.
- Compare sample sizes: Produces a plot that compares the sample size 1) across probability distributions, and 2) across the number of expected errors in the sample.
- Assumed error distribution: Produces a plot that displays the probability distribution implied by the input options and the calculated sample size.

### Input - Selection
---

#### Assignment Box
- Ranking Variable: When provided, the population is first ranked in ascending order with respect to the values of this variable.
- Additional Variables: Any other variables that should be included in the sample.

#### Sample Size
The required number of sampling units that should be selected from the population. Be aware that the sampling units are determined by the *units* option. By default, when no book values are provided, the sampling units are items (rows). When book values are provided, the ideal sampling units to use are monetary units.

#### Sampling Units
- Items: Performs selection using the items in the population as sampling units.
- Monetary units: Performs selection using the monetary units in the population as sampling units. This method is preferred when you want to include more items with a high value in the sample.

#### Method
- Fixed interval sampling: Performs selection by dividing the population in equal intervals and selecting a fixed unit in each interval. Any item with a value larger than the interval will always be included in the sample.
  - Starting point: Selects which sampling unit is selected from each interval.
- Cell sampling: Performs selection by dividing the population in equal intervals and selecting a variable unit in each interval. Any item with a value larger than twice the interval will always be included in the sample.
  - Seed: Selects the seed for the random number generator in order to reproduce results.
- Random sampling: Performs random selection in which each sampling unit has an equal chance of being selected.
  - Seed: Selects the seed for the random number generator in order to reproduce results.

#### Randomize Item Order
Randomizes the items in the population before selection is performed.

#### Tables
- Descriptive statistics: Produces a table containing descriptive information about numerical variables in the selection. Statistics that are included are the mean, the median, the standard deviation, the variance, the minimum, the maximum, and the range.
- Selected items: Produces a table containing the selected transactions along with any additional observations provided in the additional variables field.

### Output - Selection
---

#### Selection Summary
- No. units: The number of selected sampling units from the population.
- No. items: The number of selected items from the population.
- Selection value: The total value of the selected items. Only displayed when monetary unit sampling is used.
- % of population size / value: The selected proportion of the total size or value of the population.

#### Information about Monetary Interval Selection
- Items: The number of items in the population.
- Value: The value of the items in the population.
- Selected items: The number of items in the sample.
- Selected units: The number of selected units from the population.
- Selection value: The value of the items in the sample.
- % of total value: The selected proportion of the total value of the items compared to the items in the population.

#### Descriptive Statistics
- Valid: Number of valid cases.
- Mean: Arithmetic mean of the data points.
- Median: Median of the data points.
- Std. deviation: Standard deviation of the data points.
- Variance: Variance of the data points.
- Range: Range of the data points.
- Minimum: Minimum of the data points.
- Maximum: Maximum of the data points.

#### Selected Items
- Row: The row number of the item.
- Selected: The number of times (a unit in) the item is selected.

### Input - Execution
---

#### Annotation
- Audit value: Annotate the items in the selection with their audit (true) values. This approach is recommended (and automatically selected) when the items have a monetary value.
- Correct / Incorrect: Annotate the items in the selection with correct (0) or incorrect (1). This approach is recommended (and automatically selected) when your items do not have a monetary value.

### Input - Evaluation
---

#### Assignment Box
- Audit result / values: The variable that contains the audit (true) values, or the binary classification of correct (0) or incorrect (1).

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

#### Tables
- Corrections to population: Produces a table that contains the required corrections to the population value to achieve the sampling objectives.

#### Plots
- Sampling objectives: Produces a bar chart comparing the materiality, maximum misstatement and most likely error (MLE).
- Scatter plot: Produces a scatter plot comparing book values of the selection against their audit values. Observations that are in error are colored in red.

### Output - Evaluation
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
