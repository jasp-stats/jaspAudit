context("[Audit] Classical Workflow")

options <- jaspTools::analysisOptions("auditClassicalWorkflow")
options$materiality_test <- TRUE
options$materiality_abs_val <- 70161
options$id <- "ID"
options$values <- "bookValue"
options$expected_rel_val <- 0.025
options$tableBookDist <- TRUE
options$plotBookDist <- TRUE
options$samplingChecked <- TRUE
options$randomize <- FALSE
options$executionChecked <- TRUE
options$evaluationChecked <- TRUE
options$values.audit <- "auditValue"
options$plotObjectives <- TRUE
options$plotScatter <- TRUE
options$dataType <- "data"
options$prior_method <- "arm"
options$materiality_type <- "materiality_abs"
options$expected_type <- "expected_rel"
options$likelihood <- "poisson"
options$critical_action <- "inspect"
options$display <- "number"
options$units <- "values"
options$sampling_method <- "interval"
options$annotation <- "continuous"
options$method <- "stringer"
options$critical_name <- "Critical"
options$plotPosterior <- TRUE
options$indicator_col <- "SelectionResult"
options$variable_col <- "AuditResult"
set.seed(1)
results <- jaspTools::runAnalysis("auditClassicalWorkflow", "test-workflow.csv", options)


test_that("<b>Table 5.</b> Evaluation Summary results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0.0499999707815054, 0.0129870455441887, 231, 0.0191487116820916,
			 3, 0.0321357572262803, 5))
})

test_that("Evaluation of Sampling Objectives plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotObjectives"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives")
})

test_that("Scatter Plot of Book and Audit Values matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotScatter"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "scatter-plot-of-book-and-audit-values")
})

test_that("<b>Table 2.</b> Planning Summary results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(1, 0.05, 1, 0.0499999707815054, 231, 5.775))
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
		list(3500, 1403221, 231, 231, "8.2%", "Total", 115090.76, 0, 0, 0,
			 0, "0%", "Top stratum", 0, 3500, 1403220.82, 231, 231, "8.2%",
			 "Bottom stratum", 115090.76))
})

test_that("<b>Table 3.</b> Selection Summary results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("8.2%", 231, 231, 115090.76))
})