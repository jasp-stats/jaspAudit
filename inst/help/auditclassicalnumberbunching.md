Repeated Value Analysis
==========================

This analysis analyzes the frequency with which values get repeated within a dataset (called “number-bunching”) to statistically identify whether the data were likely tampered with. Unlike Benford’s law this approach examines the entire number at once, not only the first or last digit (Simonsohn, 2019). 

To determine whether the data show an excessive amount of bunching, the null hypothesis that the data do not contain an unexpected amount of repeated values is tested. To quantify what is expected, this test requires the assumption that the integer portions of the numbers are not associated with their decimal portions.

----

Default input options
-------

#### Variable
Here you can provide a variable containing the numbers that will be analyzed for repeated values.

#### Shuffle
This option allows you to select whether to shuffle the first two decimal numbers in the simulation runs, or only the second decimal number. Using different decimal numbers to shuffle you can make sure that there is no correlation between the integer portions of the number and the decimal portions, an assumption of this procedure.

----

Advanced input options
-------

#### Confidence
The confidence is related to the audit risk. The audit risk determines the risk that the auditor is willing to take to give an incorrect based on this analysis. More specifically, the audit risk is the inverse of the confidence of the analysis (audit risk = 1 - confidence).

#### Bootstrap Options
Here you can set options related to the simulation runs, like the number of samples to draw and the random number generator seed (for reproducibility).

#### Explanatory text
When checked, enables explanatory text in the analysis to help you interpret the procedure and the statistical results.

----

Default output
-------

#### Repeated Values Test
This table is the default output for the repeated value analysis. It reports the average frequency in the number in the data set alongside the entropy of these numbers. Average frequency and entropy are highly correlated, but the average frequency is often more interpretable. For example, an average frequency of 2.5 means that, on average, your observations contain a value that appears 2.5 times in the data set. 

- n: The number of observations in the data.
- Frequency: The average frequency with which numbers are repeated in the data. The formula for the average frequency is *AF = &#8721; f&#7522;&#178; / &#8721; f&#7522;* where f&#7522; is the frequency of each unique value *i* in the data set.
- Entropy: The entropy is the average level of information inherent in the variable's outcomes. The entropy is calculated as *S = - &#8721; (p&#7522; &#215; log(p&#7522;))* where p&#7522; is the proportion of observations with each value (so *p&#7522; = f&#7522; / N*).

----

Advanced output (tables)
-------

#### Assumption checks
This table shows the correlation between the integer portions of the numbers and their decimal counterparts. To meet the required assumptions for this procedure, this correlation must be non-existent. This table also displays the correlation between the samples of the two simulation runs (average frequency and entropy).

#### Frequency table
Produces a table containing the count and the percentage for every unique value in the data set.

----

Advanced output (plots)
-------

#### Observed vs. expected average frequency
Produces a histogram of the expected average frequencies vs. the observed average frequency.

#### Observed vs. expected entropy
Produces a histogram of the expected entropy vs. the observed entropy.

#### Histogram of individual values
Produces a histogram with a single bin for each observed value.

----

R Packages
-------

- base R

----

References

- Simohnsohn, U. (2019, May 25). Number-Bunching: A New Tool for Forensic Data Analysis. Retrieved from http://datacolada.org/77

-------
