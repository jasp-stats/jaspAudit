Bayesian Evaluation
===

The Bayesian evaluation analysis allows the user to perform inference about the total misstatement in the population on the basis of an audit sample.

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

#### Display
- Explanatory Text: When checked, enables explanatory text in the analysis to help interpret the procedure and the statistical results.

#### Prior
- Distribution
  - Gamma: The gamma distribution accompanies the Poisson likelihood. The Poisson likelihood assumes an infinite population size and is therefore generally used when the population size is large. It is a likelihood that models the rate of misstatement (*\u03B8*) as a function of the observed sample size (*n*) and the sum of the proportional errors found (*t*). Because the gamma distribution accommodates partial errors it is generally used when you are planning a monetary unit sample (Stewart, 2013).
  - Beta: The beta distribution accompanies the binomial likelihood. The binomial likelihood assumes an infinite population size and is therefore generally used when the population size is large. It is a likelihood that models the rate of misstatement (*\u03B8*) as a function of the observed number of errors (*k*) and the number of correct transactions (*n - k*). Because the binomial distribution strictly does not accommodate partial errors, it is generally used when you are not planning a monetary unit sample. However, the beta distribution does accommodate partial errors, and may also be used for monetary unit sampling (de Swart, Wille & Majoor, 2013).
  - Beta-binomial: The beta-binomial distribution accompanies the hypergeometric likelihood (Dyer & Pierce, 1993). The hypergeometric likelihood assumes a finite population size and is therefore generally used when the population size is small. It is a likelihood that models the number of errors (*K*) in the population as a function of the population size (*N*), the number of observed found errors (*k*) and the number of correct transactions (*n*).

- Eliciation: Specify how to construct the prior distribution, or in other words, what type of audit information to incorporate into the prior distribution.
  - Default: This option does not incorporate any information into the statistical analysis and therefore assumes a negligible and conservative prior distribution.
  - Parameters: Provide the parameters of the prior distribution.
  - Earlier sample: Create a prior distribution on the basis of an earlier sample.
    - Size: Earlier sample size.
    - Errors: Earlier found errors.
  - Impartial: Create a prior distribution that is impartial with respect to the tested hypotheses.
  - Risk assessments: Translate information from the audit risk model into a prior distribution.
    - Inherent risk: A category or probability for the inherent risk. Inherent risk is defined as the risk of material misstatement posed by an error or omission in a financial statement due to a factor other than a failure of internal control.
    - Control risk: A category or probability for the internal control risk. Control risk is defined as the risk of a material misstatement in the financial statements arising due to absence or failure in the operation of relevant controls of the auditee.
    - Analytical risk: A category or probability for the analytical risk. Analytical risk is defined as the the risk that a material misstatement will not be discovered by the auditor through analytical procedures.

- Expected Misstatements
The expected errors are the tolerable errors that can be found in the sample while still achieving the specified sampling objectives. A sample size is calculated so that, when the number of expected errors is found in the sample, the desired confidence is retained.

*Note:* It is advised to set this value conservatively to minimize the probability of the observed errors exceeding the expected errors, which would imply that insufficient work has been done.

  - Relative: Enter your expected errors as a percentage relative to the total size of the selection.
  - Absolute: Enter your expected errors as the sum of (proportional) errors.

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

- Format Output
  - Numbers: Display table output as numbers.
  - Percentages: Display table output as percentages.
  - Monetary values: Display table output as monetary values.

#### Advanced
- Critical Items
  - Negative book values: Isolates negative book values from the population.
    - Keep: Keeps negative book values to be inspected in the sample.
    - Remove: Removes negative book values.

- Algorithm
  - Partial projection: Clicking this box will allow you to separate the known and the unknown misstatement in the population to be more efficient. Note that this requires the assumption that the taints in the sample are representative of the taints in the unseen part of the population.
  - Share information: Clicking this box will allow you to share information between strata using a so-called multilevel modeling approach.

- Credible interval (Alt. Hypothesis)
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
- Sampling objectives: Produces a bar chart comparing the materiality, maximum misstatement and most likely error (MLE).

### References
---
- AICPA (2019). <i>Audit Guide: Audit Sampling</i>. American Institute of Certified Public Accountants.
- Derks, K. (2023). jfa: Statistical Methods for Auditing. R package version 0.6.6.
- Dyer, D., & Pierce, R. L. (1993). On the choice of the prior distribution in hypergeometric sampling. <i>Communications in Statistics-Theory and Methods</i>, 22(8), 2125-2146.
- Stewart, T. R. (2013). A Bayesian audit assurance model with application to the component materiality problem in group audits (Doctoral dissertation).
- de Swart, J., Wille, J., & Majoor, B. (2013). Het 'Push Left'-Principe als Motor van Data Analytics in de Accountantscontrole [The 'Push-Left'-Principle as a Driver of Data Analytics in Financial Audit]. <i>Maandblad voor Accountancy en Bedrijfseconomie</i>, 87, 425-432.

### R Packages
---
- jfa
