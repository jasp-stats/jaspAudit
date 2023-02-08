context("[Audit] Classical Workflow")

options <- jaspTools::analysisOptions("auditClassicalWorkflow")
options$bayesian <- FALSE
options$id <- "ID"
options$values <- "bookValue"
options$samplingChecked <- TRUE
options$executionChecked <- TRUE
options$evaluationChecked <- TRUE
options$values.audit <- "auditValue"
options$dataType <- "data"
options$prior_method <- "arm"
options$annotation <- "continuous"
options$method <- "poisson"
options$area <- "less"
options$critical_action <- "inspect"
options$critical_name <- "Critical"
options$display <- "number"
options$expected_rel_val <- 0.025
options$expected_type <- "expected_rel"
options$likelihood <- "poisson"
options$materiality_abs_val <- 70161
options$materiality_test <- TRUE
options$materiality_type <- "materiality_abs"
options$plotBookDist <- TRUE
options$plotObjectives <- TRUE
options$plotScatter <- FALSE
options$randomStart <- FALSE
options$start <- 1
options$indicator_col <- "SelectionResult"
options$sampling_method <- "interval"
options$tableBookDist <- TRUE
options$units <- "values"
options$variable_col <- "AuditResult"
options$explanatoryText <- TRUE
options$min_precision_test <- FALSE
options$critical_negative <- TRUE
options$ir <- "high"
options$cr <- "high"
options$conf_level <- 0.95
options$min_precision_rel_val <- 0.02
options$plotSampleSizes <- FALSE
options$max <- 5000
options$by <- 1
options$tableDescriptives <- FALSE
options$tableSample <- FALSE
options$tableTaints <- TRUE
options$tableAssumptions <- FALSE
options$plotEstimates <- FALSE
options$tableCorrections <- FALSE
options$plotErrorDist <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditClassicalWorkflow", "test-workflow.csv", options)


test_that("<b>Table 5.</b> Evaluation Summary results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0.0499999707815054, 0.0129870455441887, 231, "Value", 0.00323825066754866,
			 0.0205786135237632, 3.0000075207076, 0.033565659067952, 5))
})

test_that("Evaluation of Sampling Objectives plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotObjectives"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives")
})

test_that("<b>Table 7.</b> Misstated Items results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_tableTaints"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(233.07, 7353, 0.6, "x1", 388.45, 155.38, 413.23, 71371, 0.600005807959809,
			 "x1", 688.71, 275.48, 228.98, 13683, 0.599989518918352, "x1",
			 381.64, 152.66, 259.18, 32535, 0.600009260116677, "x1", 431.96,
			 172.78, 409.04, 26052, 0.60000293371276, "x1", 681.73, 272.69,
			 1543.5, "Total", 3.0000075207076, "", "", ""))
})

test_that("<b>Table 2.</b> Planning Summary results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(1, 0.05, 1, 0.0499999707815054, 231, "Value", 5.775))
})

test_that("Distribution of Book Values plot matches", {
	plotName <- results[["results"]][["procedureContainer"]][["collection"]][["procedureContainer_plotBookDist"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "distribution-of-book-values")
})

test_that("<b>Table 1.</b> Descriptive Statistics for Book Values results match", {
	table <- results[["results"]][["procedureContainer"]][["collection"]][["procedureContainer_tableBookDist"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(3500, 1403220.82, 400.920234285714, 254.3825, 364.11, 513.26,
			 200.782613001148, 1403220.82))
})

test_that("<b>Table 4.</b> Information about Monetary Interval Selection results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(3500, 1403220.82, 231, 231, "8.2%", "Total", 115090.76, 0, 0,
			 0, 0, "0%", "Top stratum", 0, 3500, 1403220.82, 231, 231, "8.2%",
			 "Bottom stratum", 115090.76))
})

test_that("<b>Table 3.</b> Selection Summary results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(231, "8.2%", 231, 115090.76))
})
