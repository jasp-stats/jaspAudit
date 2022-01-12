Bayesian Planning
===

The Bayesian planning analysis allows the user to calculate a minimum sample size given a set of sampling objectives and summary statistics of the population. Note that when you have access to the raw population data you may want to use the audit workflow, an analysis that guides you through the sampling process.

<img src="%HELP_FOLDER%/img/workflowPlanning.png" />

Please see the manual of the Audit module (download [here](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) for more detailed information about this analysis.

### Input
---

#### Sampling Objectives
- Performance materiality: Also called the upper error limit, the tolerable deviation rate, or the tolerable misstatement, the performance materiality is the upper bound of tolerable misstatement in the population to be tested. By testing against a performance materiality, you are able to plan a sample in order to collect evidence for or against the statement that the population as a whole does not contain misstatements that are considered material (i.e., are greater than the upper bound of tolerable misstatement). You should enable this objective when you want to find out whether the population contains misstatement above or below a certain limit (the performance materiality) using a sample of the population. A lower performance materiality will result in a higher required sample size. Vice versa, a higher performance materiality will result in a lower required sample size.
- Minimum precision: The precision is the the difference between the estimated most likely error and the upper bound on the misstatement. By enabling this sampling objective, you are be able to plan a sample so that the difference between the estimated most likely error and the upper bound on the misstatement is reduced to a minimum percentage. You should enable this objective if you are interested in making an estimate of the population misstatement with a certain accuracy. A lower minimum required precision will result in a higher required sample size. Vice versa, a higher minimum required precision will result in a lower required sample size.

#### Population
- No. units: The total number of units in the population. Note that the units can be items (rows) or monetary units (values) depending on the audit question.

#### Confidence
The confidence level used. The confidence level is the complement of the audit risk: the risk that the user is willing to take to give an incorrect judgment about the population. For example, if you want to have an audit risk of 5%, this equals 95% confidence.

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

#### Tables
- Equivalent prior sample: Produces a table that displays the implicit sample on which the prior distribution is based.
- Prior and posterior: Produces a table in which the prior and expected posterior distribution are summarized through several statistics, such as their functional form, their prior and expected posterior probabilities and odds, and the shift between these.

#### Plots
- Prior and posterior: Produces a plot that shows the prior distribution and the posterior distribution after observing the intended sample.
  - Additional info: Produces dots on the materiality.
- Prior predictive: Produces a plot of the predictions of the prior distribution.
- Compare sample sizes: Produces a plot that compares the sample size 1) across probability distributions, and 2) across the number of expected errors in the sample.

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

#### Format Tables
- Numbers: Display table output as numbers.
- Percentages: Display table output as percentages.

#### Iterations
- Increment: The increment alows you to limit the possible sample sizes to a multiple of its value. For example, an increment of 5 allows only sample sizes of 5, 10, 15, 20, 25, etc.
- Maximum: The maximum allows you to limit the sample size with a maximum.

### Output
---

#### Planning Summary
- Performance materiality: When provided, the performance materiality.
- Min. precision: When provided, the minimum precision.
- Expected errors: The number (sum of proportional taints) of expected / tolerable errors in the sample.
- Minimum sample size: The minimum sample size.

#### Equivalent prior sample
- Equivalent sample size: The sample size equivalent to the prior information.
- Equivalent errors: The number of errors equivalent to the prior information.

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
  - Additional info: Produces dots on the materiality.
- Prior predictive: Produces a plot of the predictions of the prior distribution.
- Compare sample sizes: Produces a plot that compares the sample size 1) across probability distributions, and 2) across the number of expected errors in the sample.

### References
---
- AICPA (2017). <i>Audit Guide: Audit Sampling</i>. American Institute of Certified Public Accountants.
- Derks, K (2021). jfa: Bayesian and Classical Audit Sampling. R package version 0.6.2.
- Dyer, D., & Pierce, R. L. (1993). On the choice of the prior distribution in hypergeometric sampling. <i>Communications in Statistics-Theory and Methods</i>, 22(8), 2125-2146.
- Stewart, T. R. (2013). A Bayesian audit assurance model with application to the component materiality problem in group audits (Doctoral dissertation).
- de Swart, J., Wille, J., & Majoor, B. (2013). Het 'Push Left'-Principe als Motor van Data Analytics in de Accountantscontrole [The 'Push-Left'-Principle as a Driver of Data Analytics in Financial Audit]. <i>Maandblad voor Accountancy en Bedrijfseconomie</i>, 87, 425-432.

### R Packages
---
- jfa
