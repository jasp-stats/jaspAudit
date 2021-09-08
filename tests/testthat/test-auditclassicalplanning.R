context("[Audit] Classical Planning")

options <- jaspTools::analysisOptions("auditClassicalPlanning")
options$materiality_test <- TRUE
options$materiality_rel_val <- 0.05
options$n_units <- 1000
options$plotSampleSizes <- TRUE
options$plotErrorDist <- TRUE
options$prior_method <- "arm"
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

test_that("Assumed Binomial Distribution of Errors plot matches", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_samplingDistribution"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "assumed-binomial-distribution-of-errors")
})

test_that("<b>Table 1.</b> Planning Summary results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(1, 0.05, 1, 0.05, 59, 0))
})

### Test 2: Plan using Poisson distribution

options <- jaspTools::analysisOptions("auditClassicalPlanning")
options$materiality_test <- TRUE
options$materiality_abs_val <- 70161
options$n_units <- 1200000
options$cr <- "medium"
options$plotErrorDist <- TRUE
options$prior_method <- "arm"
options$materiality_type <- "materiality_abs"
options$expected_type <- "expected_rel"
options$likelihood <- "poisson"
set.seed(1)
dataset <- NULL
results <- jaspTools::runAnalysis("auditClassicalPlanning", dataset, options)


test_that("Assumed Poisson Distribution of Errors plot matches", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_samplingDistribution"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "assumed-poisson-distribution-of-errors")
})

test_that("<b>Table 1.</b> Planning Summary results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0.6, 0.0833333333333334, 1, 0.0584675, 43, 0))
})

### Test 3: Plan using hypergeometric distribution

options <- jaspTools::analysisOptions("auditClassicalPlanning")
options$materiality_test <- TRUE
options$materiality_abs_val <- 7016
options$n_units <- 120000
options$cr <- "medium"
options$plotErrorDist <- TRUE
options$prior_method <- "arm"
options$materiality_type <- "materiality_abs"
options$expected_type <- "expected_rel"
options$likelihood <- "hypergeometric"
set.seed(1)
dataset <- NULL
results <- jaspTools::runAnalysis("auditClassicalPlanning", dataset, options)


test_that("Assumed Hypergeometric Distribution of Errors plot matches", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_samplingDistribution"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "assumed-hypergeometric-distribution-of-errors")
})

test_that("<b>Table 1.</b> Planning Summary results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0.6, 0.0833333333333334, 1, 0.0584666666666667, 42, 0))
})
