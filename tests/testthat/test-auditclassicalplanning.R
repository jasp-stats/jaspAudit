context("[Audit] Classical Planning")

options <- jaspTools::analysisOptions("auditClassicalPlanning")
options$performanceMateriality <- TRUE
options$materialityPercentage <- 0.05
options$populationSize <- 1000
options$decisionPlot <- TRUE
options$samplingDistribution <- TRUE
options$priorConstructionMethod <- "arm"
options$materiality <- "materialityRelative"
options$IR <- "High"
options$CR <- "High"
options$expectedErrors <- "expectedRelative"
options$planningModel <- "binomial"
set.seed(1)
dataset <- NULL
results <- jaspTools::runAnalysis("auditClassicalPlanning", dataset, options)

# Test 1: Plan using binomial distribution

test_that("Across Probability Distributions (Current: Binomial) plot matches", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonDistributions"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "across-probability-distributions-current-binomial-", dir="auditClassicalPlanning")
})

test_that("Across Expected Errors 1 (Current: 0) plot matches", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonErrors"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "across-expected-errors-current-0-1", dir="auditClassicalPlanning")
})

test_that("Implied Binomial Distribution of Errors plot matches", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_samplingDistribution"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "implied-binomial-distribution-of-errors", dir="auditClassicalPlanning")
})

test_that("<b>Table 1.</b> Planning Summary results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("100%", "5%", "100%", 0, "5%", 59))
})

### Test 2: Plan using Poisson distribution

options <- jaspTools::analysisOptions("auditClassicalPlanning")
options$performanceMateriality <- TRUE
options$materialityValue <- 70161
options$populationSize <- 3500
options$populationValue <- 1200000
#options$decisionPlot <- TRUE
options$samplingDistribution <- TRUE
options$priorConstructionMethod <- "arm"
options$materiality <- "materialityAbsolute"
options$IR <- "High"
options$CR <- "Medium"
options$expectedErrors <- "expectedRelative"
options$planningModel <- "Poisson"
options$valuta <- "euroValuta"
set.seed(1)
dataset <- NULL
results <- jaspTools::runAnalysis("auditClassicalPlanning", dataset, options)


# test_that("Across Probability Distributions (Current: Poisson) plot matches", {
# 	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonDistributions"]][["data"]]
# 	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
# 	jaspTools::expect_equal_plots(testPlot, "across-probability-distributions-current-poisson-", dir="auditClassicalPlanning")
# })

# test_that("Across Expected Errors (Current: 0) plot matches 2", {
# 	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonErrors"]][["data"]]
# 	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
# 	jaspTools::expect_equal_plots(testPlot, "across-expected-errors-current-0-2", dir="auditClassicalPlanning")
# })

test_that("Implied Poisson Distribution of Errors plot matches", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_samplingDistribution"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "implied-poisson-distribution-of-errors", dir="auditClassicalPlanning")
})

test_that("<b>Table 1.</b> Planning Summary results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("60%", "8.33%", "100%", 0, "<unicode><unicode><unicode> 70161",
			 43))
})

### Test 3: Plan using hypergeometric distribution

options <- jaspTools::analysisOptions("auditClassicalPlanning")
options$performanceMateriality <- TRUE
options$materialityValue <- 70161
options$populationSize <- 3500
options$populationValue <- 1200000
#options$decisionPlot <- TRUE
options$samplingDistribution <- TRUE
options$priorConstructionMethod <- "arm"
options$materiality <- "materialityAbsolute"
options$IR <- "High"
options$CR <- "Medium"
options$expectedErrors <- "expectedRelative"
options$planningModel <- "hypergeometric"
options$valuta <- "euroValuta"
set.seed(1)
dataset <- NULL
results <- jaspTools::runAnalysis("auditClassicalPlanning", dataset, options)


# test_that("Across Probability Distributions (Current: Hypergeometric) plot matches", {
# 	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonDistributions"]][["data"]]
# 	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
# 	jaspTools::expect_equal_plots(testPlot, "across-probability-distributions-current-hypergeometric-", dir="auditClassicalPlanning")
# })

# test_that("Across Expected Errors (Current: 0) plot matches 3", {
# 	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonErrors"]][["data"]]
# 	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
# 	jaspTools::expect_equal_plots(testPlot, "across-expected-errors-current-0-3", dir="auditClassicalPlanning")
# })

test_that("Implied Hypergeometric Distribution of Errors plot matches", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_samplingDistribution"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "implied-hypergeometric-distribution-of-errors", dir="auditClassicalPlanning")
})

test_that("<b>Table 1.</b> Planning Summary results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("60%", "8.33%", "100%", 0, "<unicode><unicode><unicode> 70161",
			 42))
})
