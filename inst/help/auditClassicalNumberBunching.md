Repeated Value Analysis
===

This analysis analyzes the frequency with which values get repeated within a dataset (called “number-bunching”) to statistically identify whether the data were likely tampered with. Unlike Benford’s law this approach examines the entire number at once, not only the first or last digit (Simonsohn, 2019).

To determine whether the data show an excessive amount of bunching, the null hypothesis that the data do not contain an unexpected amount of repeated values is tested. To quantify what is expected, this test requires the assumption that the integer portions of the numbers are not associated with their decimal portions.

### Input
---

#### Assignment Box
- Variable: In this box the variable is selected whose digits should be analyzed for repeated values.

#### Tests
- Average frequency: Compute the average frequency of the data.
- Entropy: Compute the entropy of the data.

#### Shuffle Decimal Digits
- Last: Last decimal digit is shuffled.
- Last two: Last two decimal digits are shuffled.
- All: All decimal digits are shuffled.

#### Display
- Explanatory Text: When checked, enables explanatory text in the analysis to help interpret the procedure and the statistical results.
  - Confidence: The confidence level used in the explanatory text.

#### Report
- Tables
  - Assumption checks: This table shows the correlation between the integer portions of the numbers and their decimal counterparts. To meet the required assumptions for this procedure, this correlation must be non-existent. This table also displays the correlation between the samples of the two simulation runs (average frequency and entropy).
  - Frequency table: Produces a table containing the count and the percentage for every unique value in the data set.

- Plots
  - Observed vs. expected: Produces a histogram of the expected average frequencies and / or entropy vs. the observed average frequency and / or entropy.
  - Histogram: Produces a histogram with a single bin for each observed value.

#### Advanced
- Number of samples: The number of samples to use for simulating the p value.
- Seed: Selects the seed for the random number generator in order to reproduce results.

### Output
---

#### Repeated Values Test
- n: The number of observations in the data.
- Frequency: The average frequency with which numbers are repeated in the data. The formula for the average frequency is *AF = &#8721; f&#7522;&#178; / &#8721; f&#7522;* where f&#7522; is the frequency of each unique value *i* in the data set.
- Entropy: The entropy is the average level of information inherent in the variable's outcomes. The entropy is calculated as *S = - &#8721; (p&#7522; &#215; log(p&#7522;))* where p&#7522; is the proportion of observations with each value (so *p&#7522; = f&#7522; / N*).

#### Assumption Checks
- n: Sample size.
- r: Pearson correlation coefficient.
- t: t-value.
- df: Degrees of freedom.
- p: p-value.

#### Frequency Table
- Value: The value in the row.
- Count: The number of times the value is observed.
- Percentage: The percentage of times the value is observed.

#### Plots
- Observed vs. expected: Displays the observed vs. the simulated value(s).
- Histogram: Displays a histogram with a single bin for each observed value.

### References
---
- Derks, K. (2023). jfa: Statistical Methods for Auditing. R package version 0.7.0.
- Simohnsohn, U. (2019, May 25). Number-Bunching: A New Tool for Forensic Data Analysis. Retrieved from [http://datacolada.org/77](http://datacolada.org/77).

### R Packages
---
- jfa
