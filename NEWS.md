# Version 0.17.3

**New features**

- Added analytical risk as a constituent of the audit risk model.

# Version 0.17.2

**New features**

- Stratification has been implemented in the Bayesian evaluation analysis, enabling users to assess stratified audit samples using the techniques outlined in https://psyarxiv.com/byj2a/.
- Default percentages associated with risk categories for the Audit Risk Model are displayed as a table in the output.
- A table is now available in the Benford's law analysis that matches the first digit to its corresponding row.

**Bug fixes**

- None.

**Major changes**

- Changed the default percentages for inherent risk from `medium: 60%` to `medium: 63%` and `low: 36%` to `low: 40%`.
- Changed the default percentages for control risk from `medium: 60%` to `medium: 52%` and `low: 36%` to `low: 34%`.

**Minor changes**

- It is now possible to specify values below 25% for the `Manual` categories in the Audit Risk Model.
