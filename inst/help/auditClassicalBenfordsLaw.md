Benford's Law
===

Benford's law states that the distribution of leading digits in a population naturally follows a certain distribution. In auditing, assessing whether a distribution of digits in the population conforms to Benford's law may provide additional evidence that the transactions in the population might need further investigation.

*Note:* Non-conformity to Benford's law does not necessarily indicate fraud. A Benford's law analysis should therefore only be used to acquire insight into whether a population might need further investigation.

### Input
---

#### Assignment Box
- Variable: In this box the variable is selected whose digits should be tested against the reference distribution. The value zero (0) will be omitted from the data.

#### Reference
- Benford's law: Test the digits against Benford's law.
- Uniform distribution: Test the digits against the uniform distribution.

#### Digits
- First: Checks only the first digit of the items against the specified distribution.
- First and second: Checks the first and second digit of the items against the specified distribution.
- Last: Checks only the last digit of the items against the specified distribution.

#### Bayes Factor
- BF10 : Bayes factor to quantify evidence for the alternative hypothesis relative to the null hypothesis.
- BF01 : Bayes factor to quantify evidence for the null hypothesis relative to the alternative hypothesis.
- Log(BF10) : Natural logarithm of BF10.

#### Display
- Explanatory Text: When checked, enables explanatory text in the analysis to help interpret the procedure and the statistical results.
  - Confidence: The confidence level used in the explanatory text.

#### Report
- Tables
  - Frequency table: Displays a table of the observed frequencies of the requested digits in the data alongside their expected frequencies under the reference distribution.
  - Matched rows: Shows a table of the rows in the data that match their requested digit(s) to the number in <i>Digit</i>.
    - Digit: Digit(s) to match.

- Plots
  - Observed vs. expected: Produces a plot that shows the observed distribution of digits in the population compared to the expected distribution under the Benford's law or the uniform distribution.  

### Output
---

#### Goodness-of-fit table
- n: The total number of observations in the data set.
- X<sup>2</sup>: The value of the Chi-squared test statistic.
- df: Degrees of freedom associated with the Chi-squared test.
- p: The *p* value associated with the Chi-squared test.
- BF: The Bayes factor resulting from a non-informative prior.

#### Frequency Table
- Leading / Last digit: The digit for which the information in the row applies.
- Count: The observed counts of the digits.
- Relative frequency: The observed relative frequency of the digits.
- Benford's Law / Uniform distribution: The expected relative frequency of the digits.

#### Plots
- Observed vs. expected: A plot that shows the observed distribution of digits in the population compared to the expected distribution under the Benford's law or the uniform distribution.

### References
---
- Derks, K. (2023). jfa: Statistical Methods for Auditing. R package version 0.6.6.

### R Packages
---
- jfa
