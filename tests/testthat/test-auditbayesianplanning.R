context("[Audit] Bayesian Planning")

### Test 1: Plan using the beta distribution

options <- analysisOptions("auditBayesianPlanning")
options$performanceMateriality <- TRUE
options$materialityPercentage <- 0.05
options$populationSize <- 1000
options$expectedEvidenceRatio <- TRUE
options$expectedBayesFactor <- TRUE
options$implicitSampleTable <- TRUE
options$priorStatistics <- TRUE
options$decisionPlot <- TRUE
options$priorPlot <- TRUE
options$priorPlotExpectedPosterior <- TRUE
options$materiality <- "materialityRelative"
options$expectedErrors <- "expectedRelative"
options$IR <- "High"
options$CR <- "High"
options$planningModel <- "binomial"
options$valuta <- "euroValuta"
options$shadePrior <- "shadePriorCredibleRegion"
options$.meta <- list()
set.seed(1)
dataset <- NULL
results <- runAnalysis("auditBayesianPlanning", dataset, options)


test_that("Across Probability Distributions (Current: Beta) plot matches", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonDistributions"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "across-probability-distributions-current-beta-", dir="auditBayesianPlanning")
})

test_that("Across Expected Errors (Current: 0) plot matches 1", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonErrors"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "across-expected-errors-current-0-1", dir="auditBayesianPlanning")
})

test_that("<b>Table 3.</b> Descriptive Statistics for Prior and Expected Posterior Distribution results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_priorAndPosteriorStatistics"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0.95, "beta(<unicode><unicode> = 1, <unicode><unicode> = 1)",
			 0.05, 0.95, "NaN", 0.0526315789473684, "NaN", "Prior", 0.0495076098882269,
			 "beta(<unicode><unicode> = 1, <unicode><unicode> = 59)", 0.951505474750577,
			 0.0484945252494232, 0, 19.6208844164712, 0.0495076098882269,
			 "Expected posterior", -0.900492390111773, "", 19.0301094950115,
			 0.0510468686836034, "NaN", 372.796803912953, "", "Expected shift"
			))
})

test_that("Implied Prior Distribution plot matches 1", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_priorPlot"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "implied-prior-distribution-1", dir="auditBayesianPlanning")
})

test_that("<b>Table 2.</b> Implicit Sample results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_sampletable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0, 0))
})

test_that("<b>Table 1.</b> Planning Summary results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("5%", 372.796803912953, 19.6208844164712, 0, "5%", 58))
})

### Test 2: Plan using the gamma distribution

options <- analysisOptions("auditBayesianPlanning")
options$performanceMateriality <- TRUE
options$materialityValue <- 70161
options$populationSize <- 3500
options$populationValue <- 1400000
options$priorConstructionMethod <- "arm"
options$expectedEvidenceRatio <- TRUE
options$expectedBayesFactor <- TRUE
options$implicitSampleTable <- TRUE
options$priorStatistics <- TRUE
options$decisionPlot <- TRUE
options$priorPlot <- TRUE
options$priorPlotExpectedPosterior <- TRUE
options$materiality <- "materialityAbsolute"
options$expectedErrors <- "expectedRelative"
options$IR <- "High"
options$CR <- "Medium"
options$planningModel <- "Poisson"
options$valuta <- "dollarValuta"
options$shadePrior <- "shadePriorCredibleRegion"
options$.meta <- list()
set.seed(1)
dataset <- NULL
results <- runAnalysis("auditBayesianPlanning", dataset, options)


test_that("Across Probability Distributions (Current: Gamma) plot matches", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonDistributions"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "across-probability-distributions-current-gamma-", dir="auditBayesianPlanning")
})

test_that("Across Expected Errors (Current: 0) plot matches 2", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonErrors"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "across-expected-errors-current-0-2", dir="auditBayesianPlanning")
})

test_that("<b>Table 3.</b> Descriptive Statistics for Prior and Expected Posterior Distribution results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_priorAndPosteriorStatistics"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0.299573227355399, "gamma(<unicode><unicode> = 1, <unicode><unicode> = 10)",
			 0.394166449631336, 0.605833550368664, 0, 0.65061839079641, 0.299573227355399,
			 "Prior", 0.0499288712258998, "gamma(<unicode><unicode> = 1, <unicode><unicode> = 60)",
			 0.950555279943933, 0.0494447200560673, 0, 19.224606365777, 0.0499288712258998,
			 "Expected posterior", -0.249644356129499, "", 2.41155806343484,
			 0.0816143642523247, 0, 29.5482061954082, "", "Expected shift"
			))
})

test_that("Implied Prior Distribution plot matches 2", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_priorPlot"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "implied-prior-distribution-2", dir="auditBayesianPlanning")
})

test_that("<b>Table 2.</b> Implicit Sample results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_sampletable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0, 10))
})

test_that("<b>Table 1.</b> Planning Summary results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("60%", "8.33%", "100%", 29.5482061954082, 19.224606365777, 0,
			 "$ 70161", 50))
})

### Test 3: Plan using the beta-binomial distribution

options <- analysisOptions("auditBayesianPlanning")
options$performanceMateriality <- TRUE
options$materialityValue <- 2000
options$populationSize <- 3500
options$populationValue <- 10000
options$expectedEvidenceRatio <- TRUE
options$expectedBayesFactor <- TRUE
options$implicitSampleTable <- TRUE
options$priorStatistics <- TRUE
options$decisionPlot <- TRUE
options$priorPlot <- TRUE
options$priorPlotExpectedPosterior <- TRUE
options$materiality <- "materialityAbsolute"
options$expectedErrors <- "expectedRelative"
options$IR <- "High"
options$CR <- "High"
options$planningModel <- "hypergeometric"
options$valuta <- "dollarValuta"
options$shadePrior <- "shadePriorCredibleRegion"
options$.meta <- list()
set.seed(1)
dataset <- NULL
results <- runAnalysis("auditBayesianPlanning", dataset, options)


test_that("Across Probability Distributions (Current: Beta-binomial) plot matches", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonDistributions"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "across-probability-distributions-current-beta-binomial-", dir="auditBayesianPlanning")
})

test_that("Across Expected Errors (Current: 0) plot matches 3", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonErrors"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "across-expected-errors-current-0-3", dir="auditBayesianPlanning")
})

test_that("<b>Table 3.</b> Descriptive Statistics for Prior and Expected Posterior Distribution results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_priorAndPosteriorStatistics"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(9500, "beta-binomial(N = 9987, <unicode><unicode> = 1, <unicode><unicode> = 1)",
			 0.200079992000814, 0.799920007999186, 523, 0.250125000000022,
			 0.8977, "Prior", 1927, "beta-binomial(N = 9987, <unicode><unicode> = 1, <unicode><unicode> = 14)",
			 0.955981093321683, 0.0440189066783169, 0, 21.7175110755894,
			 0.1927, "Expected posterior", -7573, "", 4.77799445992478, 0.0550291357112318,
			 -523, 86.8266309868567, "", "Expected shift"))
})

test_that("Implied Prior Distribution plot matches 3", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_priorPlot"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "implied-prior-distribution-3", dir="auditBayesianPlanning")
})

test_that("<b>Table 2.</b> Implicit Sample results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_sampletable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0, 0))
})

test_that("<b>Table 1.</b> Planning Summary results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("5%", 86.8266309868567, 21.7175110755894, 0, "$ 2000", 13))
})