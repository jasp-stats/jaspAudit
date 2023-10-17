Planning
===

The planning analysis allows the user to calculate a minimum sample size given a set of sampling objectives and summary statistics of the population. Note that, when you have access to the raw population data, you may want to use the audit workflow, an analysis that guides you through the sampling process.

<img src="%HELP_FOLDER%/img/workflowPlanning.png" />

Please see the manual of the Audit module (download [here](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) for more detailed information about this analysis.

### Input
---

#### Sampling Objectives
- Performance materiality: Also called the upper error limit, the tolerable deviation rate, or the tolerable misstatement, the performance materiality is the upper bound of tolerable misstatement in the population to be tested. By testing against a performance materiality, you are able to plan a sample in order to collect evidence for or against the statement that the population as a whole does not contain misstatements that are considered material (i.e., are greater than the upper bound of tolerable misstatement). You should enable this objective when you want to find out whether the population contains misstatement above or below a certain limit (the performance materiality) using a sample of the population. A lower performance materiality will result in a higher required sample size. Vice versa, a higher performance materiality will result in a lower required sample size.
- Minimum precision: The precision is the the difference between the estimated most likely error and the upper bound on the misstatement. By enabling this sampling objective, you are be able to plan a sample so that the difference between the estimated most likely error and the upper bound on the misstatement is reduced to a minimum percentage. You should enable this objective if you are interested in making an estimate of the population misstatement with a certain accuracy. A lower minimum required precision will result in a higher required sample size. Vice versa, a higher minimum required precision will result in a lower required sample size.

#### Confidence
The confidence level used. The confidence level is the complement of the audit risk: the risk that the user is willing to take to give an incorrect judgment about the population. For example, if you want to have an audit risk of 5%, this equals 95% confidence.

#### Expected Misstatements
The expected errors are the tolerable errors that can be found in the sample while still achieving the specified sampling objectives. A sample size is calculated so that, when the number of expected errors is found in the sample, the desired confidence is retained.

*Note:* It is advised to set this value conservatively to minimize the probability of the observed errors exceeding the expected errors, which would imply that insufficient work has been done.

- Relative: Enter your expected errors as a percentage relative to the total size of the selection.
- Absolute: Enter your expected errors as the sum of (proportional) errors.

#### Population
- No. units: The total number of units in the population. Note that the units can be items (rows) or monetary units (values) depending on the audit question.

#### Audit Risk Model
- Inherent risk: A category or probability for the inherent risk. Inherent risk is defined as the risk of material misstatement posed by an error or omission in a financial statement due to a factor other than a failure of internal control.
- Control risk: A category or probability for the internal control risk. Control risk is defined as the risk of a material misstatement in the financial statements arising due to absence or failure in the operation of relevant controls of the auditee.
- Analytical risk: A category or probability for the analytical risk. Analytical risk is defined as the the risk that a material misstatement will not be discovered by the auditor through analytical procedures.

When the auditor has information that indicates a low-risk profile on the population, they can use this information to reduce their required sample size via the Audit Risk Model (ARM) provided that there are no errors in the population. According to the ARM, the audit risk (AR) is a function of the inherent risk (IR), the internal control risk (CR), the analytical risk (CAR) and the detection risk (DR).

*AR = IR x CR x CAR x DR*

The auditor assesses inherent risk, internal control risk and analytical risk generally on a 3-point scale consisting of high, medium and low to determine the appropriate detection risk. To use the ARM, these categorical risk assessments must be mapped to probabilities. By default, the Audit module uses the percentages shown in the table below, which are inspired by the <i>Handboek Auditing Rijksoverheid</i>. You can manually adjust the percentages associated with one or all of the risks by selecting the Custom option in the drop-down list under the corresponding risk assessment.

|  | Inherent risk (IR) | Control risk (CR) | Analytical risk (CAR) |
| ---: | :---: | :---: | :---: |
| High | 100% | 100% | 100% |
| Medium | 63% | 52% | 50% |
| Low | 40% | 34% | 25% |

#### Display
- Explanatory Text: When checked, enables explanatory text in the analysis to help interpret the procedure and the statistical results.

#### Report
- Plots
  - Compare sample sizes: Produces a plot that compares the sample size 1) across probability distributions, and 2) across the number of expected errors in the sample.
  - Presumed data distribution: Produces a plot that displays the probability distribution implied by the input options and the calculated sample size.

- Format Output
  - Numbers: Display table output as numbers.
  - Percentages: Display table output as percentages.

#### Advanced
- Likelihood
  - Hypergeometric: The hypergeometric distribution assumes a finite population size and is therefore generally used when the population size is small. It is a probability distribution that models the number of errors (*K*) in the population as a function of the population size (*N*), the number of observed found errors (*k*) and the number of correct transactions (*n*).
  - Binomial: The binomial distribution assumes an infinite population size and is therefore generally used when the population size is large. It is a probability distribution that models the rate of misstatement (*\u03B8*) as a function of the observed number of errors (*k*) and the number of correct transactions (*n - k*). Because the binomial distribution strictly does not accommodate partial errors, it is generally used when you are not planning a monetary unit sample.
  - Poisson: The Poisson distribution assumes an infinite population size and is therefore generally used when the population size is large. It is a probability distribution that models the rate of misstatement (*\u03B8*) as a function of the observed sample size (*n*) and the sum of the proportional errors (*t*). Because the Poisson distribution accommodates partial errors it is generally used when you are planning a monetary unit sample.

- Iterations
  - Increment: The increment alows you to limit the possible sample sizes to a multiple of its value. For example, an increment of 5 allows only sample sizes of 5, 10, 15, 20, 25, etc.
  - Maximum: The maximum allows you to limit the sample size with a maximum.

### Output
---

#### Planning Summary
- Performance materiality: When provided, the performance materiality.
- Min. precision: When provided, the minimum precision.
- Expected errors: The number (sum of proportional taints) of expected / tolerable errors in the sample.
- Minimum sample size: The minimum sample size.

#### Plots
- Compare sample sizes: Produces a plot that compares the sample size 1) across probability distributions, and 2) across the number of expected errors in the sample.
- Presumed data distribution: Produces a plot that displays the probability distribution implied by the input options and the calculated sample size.

### References
---
- AICPA (2019). <i>Audit Guide: Audit Sampling</i>. American Institute of Certified Public Accountants.
- Derks, K. (2023). jfa: Statistical Methods for Auditing. R package (latest version). https://cran.r-project.org/package=jfa
- Stewart, T. (2012). <i>Technical notes on the AICPA audit guide Audit Sampling</i>. American Institute of Certified Public Accountants, New York.

### R Packages
---
- jfa
