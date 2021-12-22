Selection
===

The selection analysis allows the user to select a number of sampling units from a population using a combination of sampling techniques (record sampling versus monetary unit sampling) and sampling methods (random sampling, cell sampling, fixed interval sampling) that are standard in an audit context.

<img src="%HELP_FOLDER%/img/workflowSelection.png" />

Please see the manual of the Audit module (download [here](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) for more detailed information about this analysis.

### Input
---

#### Assignment Box
- Item ID: A unique non-missing identifier for every item in the population. The row number of the items is sufficient.
- Book Values: The variable that contains the book values of the items in the population.
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

#### Randomize Items
Randomizes the items in the population before selection is performed.

#### Display
- Explanatory Text: When checked, enables explanatory text in the analysis to help interpret the procedure and the statistical results.

#### Column Name Selection Result
When a name is provided, adds the result from the selection analysis in a new column to the data. The new column reflects how many times each transaction is included in the sample.

#### Tables
- Descriptive statistics: Produces a table containing descriptive information about numerical variables in the selection. Statistics that are included are the mean, the median, the standard deviation, the variance, the minimum, the maximum, and the range.
- Raw sample: Produces a table containing the selected transactions along with any additional observations provided in the additional variables field.

### Output
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

#### Raw Sample
- Row: The row number of the item.
- Selected: The number of times (a unit in) the item is selected.

### References
---
- AICPA (2017). <i>Audit Guide: Audit Sampling</i>. American Institute of Certified Public Accountants.
- Derks, K (2021). jfa: Bayesian and Classical Audit Sampling. R package version 0.6.1.

### R Packages
---
- jfa
