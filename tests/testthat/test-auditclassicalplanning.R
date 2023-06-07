context("[Audit] Classical Planning")

options <- jaspTools::analysisOptions("auditClassicalPlanning")
options$bayesian <- FALSE
options$area <- "less"
options$prior_method <- "arm"
options$explanatoryText <- TRUE
options$materiality_test <- TRUE
options$min_precision_test <- FALSE
options$materiality_rel_val <- 0.05
options$n_units <- 1000
options$ir <- "high"
options$cr <- "high"
options$car <- "high"
options$conf_level <- 0.95
options$expected_rel_val <- 0
options$max <- 5000
options$by <- 1
options$plotSampleSizes <- TRUE
options$display <- "number"
options$plotErrorDist <- TRUE
options$materiality_type <- "materiality_rel"
options$expected_type <- "expected_rel"
options$likelihood <- "binomial"
set.seed(1)
dataset <- NULL
results <- jaspTools::runAnalysis("auditClassicalPlanning", dataset, options)


test_that("Across Probability Distributions (Current: Binomial) plot matches", {
  plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonDistributions"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "across-probability-distributions-current-binomial-")
})

test_that("Across Expected Errors (Current: 0) plot matches", {
  plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonErrors"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "across-expected-errors-current-0-")
})

test_that("Presumed Binomial Distribution plot matches", {
  plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_samplingDistribution"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "presumed-binomial-distribution")
})

test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(1, 0.05, 1, 0.05, 59, "Value", 0)
  )
})

### Test 2: Plan using Poisson distribution

options <- jaspTools::analysisOptions("auditClassicalPlanning")
options$bayesian <- FALSE
options$area <- "less"
options$prior_method <- "arm"
options$explanatoryText <- TRUE
options$materiality_test <- TRUE
options$min_precision_test <- FALSE
options$materiality_abs_val <- 70161
options$n_units <- 1200000
options$cr <- "medium"
options$plotErrorDist <- TRUE
options$materiality_type <- "materiality_abs"
options$ir <- "high"
options$car <- "high"
options$conf_level <- 0.95
options$expected_rel_val <- 0
options$max <- 5000
options$by <- 1
options$plotSampleSizes <- FALSE
options$display <- "number"
options$expected_type <- "expected_rel"
options$likelihood <- "poisson"
set.seed(1)
dataset <- NULL
results <- jaspTools::runAnalysis("auditClassicalPlanning", dataset, options)


test_that("Presumed Poisson Distribution plot matches", {
  plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_samplingDistribution"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "presumed-poisson-distribution")
})

test_that("<b>Table 2.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(0.52, 0.0961538461538462, 1, 0.0584675, 41, "Value", 0)
  )
})

### Test 3: Plan using hypergeometric distribution

options <- jaspTools::analysisOptions("auditClassicalPlanning")
options$bayesian <- FALSE
options$area <- "less"
options$prior_method <- "arm"
options$explanatoryText <- TRUE
options$materiality_test <- TRUE
options$materiality_abs_val <- 7016
options$min_precision_test <- FALSE
options$n_units <- 120000
options$display <- "number"
options$cr <- "medium"
options$plotErrorDist <- TRUE
options$plotSampleSizes <- FALSE
options$materiality_type <- "materiality_abs"
options$ir <- "high"
options$car <- "high"
options$conf_level <- 0.95
options$expected_rel_val <- 0
options$max <- 5000
options$by <- 1
options$expected_type <- "expected_rel"
options$likelihood <- "hypergeometric"
set.seed(1)
dataset <- NULL
results <- jaspTools::runAnalysis("auditClassicalPlanning", dataset, options)


test_that("Presumed Hypergeometric Distribution plot matches", {
  plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_samplingDistribution"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "presumed-hypergeometric-distribution")
})

test_that("<b>Table 2.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      0.52, 0.0961538461538462, 1, 0.0584666666666667, 39, "Value",
      0
    )
  )
})
