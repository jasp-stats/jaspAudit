Bayesian Sampling Workflow
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
- Book Values: The variable that contains the book values of the items in the population. Ideally, all book values are positive values, see the <i>Critical Items</i> option for the handling of negative book values.

#### Expected errors in Sample
The expected errors are the tolerable errors that can be found in the sample while still achieving the specified sampling objectives. A sample size is calculated so that, when the number of expected errors is found in the sample, the desired confidence is retained.

*Note:* It is advised to set this value conservatively to minimize the probability of the observed errors exceeding the expected errors, which would imply that insufficient work has been done.

- Relative: Enter your expected errors as a percentage relative to the total size of the selection.
- Absolute: Enter your expected errors as the sum of (proportional) errors.

#### Probability Distribution
- Beta-binomial: The beta-binomial distribution accompanies the hypergeometric likelihood (Dyer & Pierce, 1993). The hypergeometric likelihood assumes a finite population size and is therefore generally used when the population size is small. It is a likelihood that models the number of errors (*K*) in the population as a function of the population size (*N*), the number of observed found errors (*k*) and the number of correct transactions (*n*).
- Beta: The beta distribution accompanies the binomial likelihood. The binomial likelihood assumes an infinite population size and is therefore generally used when the population size is large. It is a likelihood that models the rate of misstatement (*\u03B8*) as a function of the observed number of errors (*k*) and the number of correct transactions (*n - k*). Because the binomial distribution strictly does not accommodate partial errors, it is generally used when you are not planning a monetary unit sample. However, the beta distribution does accommodate partial errors, and may also be used for monetary unit sampling (de Swart, Wille & Majoor, 2013).
- Gamma: The gamma distribution accompanies the Poisson likelihood. The Poisson likelihood assumes an infinite population size and is therefore generally used when the population size is large. It is a likelihood that models the rate of misstatement (*\u03B8*) as a function of the observed sample size (*n*) and the sum of the proportional errors found (*t*). Because the gamma distribution accommodates partial errors it is generally used when you are planning a monetary unit sample (Stewart, 2013).

#### Display
- Explanatory Text: When checked, enables explanatory text in the analysis to help interpret the procedure and the statistical results.

#### Prior
- Default: This option does not incorporate any information into the statistical analysis and therefore assumes a negligible and conservative prior distribution.
- Manual: Provide the parameters of the prior distribution.
- Earlier sample: Create a prior distribution on the basis of an earlier sample.
  - Size: Earlier sample size.
  - Errors: Earlier found errors.
- Impartial: Create a prior distribution that is impartial with respect to the tested hypotheses.
- Risk assessments: Translate information from the audit risk model into a prior distribution.
  - Inherent risk: A category or probability for the inherent risk. Inherent risk is defined as the risk of material misstatement posed by an error or omission in a financial statement due to a factor other than a failure of internal control.
  - Control risk: A category or probability for the internal control risk. Control risk is defined as the risk of a material misstatement in the financial statements arising due to absence or failure in the operation of relevant controls of the auditee.

#### Report
- Tables
  - Descriptive statistics: Produces a table with descriptive statistics of the book values in the population.
  - Equivalent prior sample: Produces a table that displays the implicit sample on which the prior distribution is based.
  - Prior and posterior: Produces a table in which the prior and expected posterior distribution are summarized through several statistics, such as their functional form, their prior and expected posterior probabilities and odds, and the shift between these.

- Plots
  - Prior distribution: Produces a plot that shows the prior distribution.
    - Posterior distribution: Adds the posterior distribution after observing the intended sample to the figure.
  - Prior predictive distribution: Produces a plot of the predictions of the prior distribution.
  - Compare sample sizes: Produces a plot that compares the sample size 1) across probability distributions, and 2) across the number of expected errors in the sample.
  - Distribution of book values: Produces a histogram of the book values in the population.

- Format Output
  - Numbers: Display table output as numbers.
  - Percentages: Display table output as percentages.
  - Monetary units: Display table output as monetary units.

#### Advanced
- Iterations
  - Increment: The increment alows you to limit the possible sample sizes to a multiple of its value. For example, an increment of 5 allows only sample sizes of 5, 10, 15, 20, 25, etc.
  - Maximum: The maximum allows you to limit the sample size with a maximum.

- Critical Items
  - Negative book values: Isolates negative book values from the population.
    - Keep: Keeps negative book values to be inspected in the sample.
    - Remove: Removes negative book values.

- Algorithm
  - Partial projection: Clicking this box will allow you to separate the known and the unknown misstatement in the population to be more efficient. Note that this requires the assumption that the taints in the sample are representative of the taints in the unseen part of the population.
  - Share information: Clicking this box will allow you to share information between strata using a so-called multilevel modeling approach.

#### Assume Homogeneous Taints
Clicking this box will allow you to separate the known and the unknown misstatement in the population to be more efficient. Note that this requires the assumption that the taints in the sample are representative of the taints in the unseen part of the population.

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

#### Prior and Posterior
- Functional form: The functional form of the distribution.
- Support H-: Total probability in the range of H- under the distribution. Only displayes when testing against a performance materiality.
- Support H+: Total probability in the range of H+ under the distribution. Only displayes when testing against a performance materiality.
- Ratio H- / H+: Odds in favor of H- under the distribution. Only displayes when testing against a performance materiality.
- Mean: Mean of the distribution.
- Median: Median of the distribution.
- Mode: Mode of the distribution.
- Upper bound: x-% percentile of the distribution.
- Precision: Difference between the upper bound and the mode of the distribution.

#### Plots
- Prior and posterior: Produces a plot that shows the prior distribution and the posterior distribution after observing the intended sample.
  - Additional info: Annotates the figure with the mode and the credible interval. If a materiality is specified, annotates the figure with the materiality and includes a visualization of the Bayes factor via a proportion wheel.
- Prior predictive: Produces a plot of the predictions of the prior distribution.
- Compare sample sizes: Produces a plot that compares the sample size 1) across probability distributions, and 2) across the number of expected errors in the sample.
- Distribution of book values: Produces a histogram of the book values in the population.

### Input - Selection
---

#### Randomize Item Order
Randomizes the items in the population before selection is performed.

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

#### Report
- Tables
  - Selected items: Produces a table containing the selected transactions along with any additional observations provided in the additional variables field.
  - Descriptive statistics: Produces a table containing descriptive information about numerical variables in the selection. Statistics that are included are the mean, the median, the standard deviation, the variance, the minimum, the maximum, and the range.

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

#### Report
- Tables
  - Misstated items: Produces a table that contains all items that were found to contain a misstatement.
  - Prior and posterior: Produces a table in which the prior and expected posterior distribution are summarized through several statistics, such as their functional form, their prior and expected posterior probabilities and odds, and the shift between these.
  - Corrections to population: Produces a table that contains the required corrections to the population value to achieve the sampling objectives.
  - Assumption checks: Produces a table that displays the correlation between the book values in the sample and their taints.
    - Confidence interval: Width of the confidence interval for the correlation.

- Plots
  - Sampling objectives: Produces a bar chart comparing the materiality, maximum misstatement and most likely error (MLE).
  - Estimates: Produces an interval plot for the population and optionally the stratum estimates of the misstatement.
  - Prior and posterior: Produces a plot that shows the prior distribution and the posterior distribution after observing the intended sample.
    - Additional info: Annotates the figure with the mode and the credible interval. If a materiality is specified, annotates the figure with the materiality and includes a visualization of the Bayes factor via a proportion wheel.

#### Advanced
- Credible interval (Alt. Hypothesis)
  - Upper bound (< materiality): Calculate the upper bound and test the alternative hypothesis that misstatement < materiality.
  - Two-sided (< materiality): Calculate the upper and lower bound and test the alternative hypothesis that misstatement != materiality.
  - Lower bound (< materiality): Calculate the lower bound and test the alternative hypothesis that misstatement > materiality.

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
- BF-+: The Bayes factor for the test.

#### Prior and Posterior
- Functional form: The functional form of the distribution.
- Support H-: Total probability in the range of H- under the distribution. Only displayes when testing against a performance materiality.
- Support H+: Total probability in the range of H+ under the distribution. Only displayes when testing against a performance materiality.
- Ratio H- / H+: Odds in favor of H- under the distribution. Only displayes when testing against a performance materiality.
- Mean: Mean of the distribution.
- Median: Median of the distribution.
- Mode: Mode of the distribution.
- Upper bound: x-% percentile of the distribution.
- Precision: Difference between the upper bound and the mode of the distribution.

#### Corrections to Population
- Correction: The amount or percentage to be deducted from the population.

#### Assumption Checks
- n: Sample size.
- Pearsons r: Pearson correlation coefficient.
- x-% upper bound: Upper bound for correlation coefficient.
- p: p-value for the test.
- BF-0: Bayes factor for the test.

#### Plots
- Prior and posterior: Produces a plot that shows the prior distribution and the posterior distribution after observing the intended sample.
  - Additional info: Annotates the figure with the mode and the credible interval. If a materiality is specified, annotates the figure with the materiality and includes a visualization of the Bayes factor via a proportion wheel.
- Posterior predictive: Produces a plot of the predictions of the posterior distribution.
- Sampling objectives: Produces a bar chart comparing the materiality, upper bound on the misstatement and most likely error (MLE).

### References
---
- AICPA (2017). <i>Audit Guide: Audit Sampling</i>. American Institute of Certified Public Accountants.
- Derks, K. (2023). jfa: Statistical Methods for Auditing. R package version 0.6.5.
- Dyer, D., & Pierce, R. L. (1993). On the choice of the prior distribution in hypergeometric sampling. <i>Communications in Statistics-Theory and Methods</i>, 22(8), 2125-2146.
- Stewart, T. R. (2013). A Bayesian audit assurance model with application to the component materiality problem in group audits (Doctoral dissertation).
- de Swart, J., Wille, J., & Majoor, B. (2013). Het 'Push Left'-Principe als Motor van Data Analytics in de Accountantscontrole [The 'Push-Left'-Principle as a Driver of Data Analytics in Financial Audit]. <i>Maandblad voor Accountancy en Bedrijfseconomie</i>, 87, 425-432.

### R Packages
---
- jfa
