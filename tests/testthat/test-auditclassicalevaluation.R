context("[Audit] Classical Evaluation")

### Test 1: Evaluation using summary statistics

options <- jaspTools::analysisOptions("auditClassicalEvaluation")
options$materiality_test <- TRUE
options$materiality_rel_val <- 0.05
options$n_units <- 1200000
options$dataType <- "stats"
options$stats <- TRUE
options$n <- 93
options$x <- 1
options$cr <- "medium"
options$plotObjectives <- TRUE
options$prior_method <- "arm"
options$materiality_type <- "materiality_rel"
options$method <- "binomial"
options$display <- "percent"
options$annotation <- "binary"
set.seed(1)
dataset <- NULL
results <- jaspTools::runAnalysis("auditClassicalEvaluation", dataset, options)


test_that("<b>Table 1.</b> Evaluation Summary results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("5%", "1.075%", 93, 0.0499757952426165, "3.279%", "1.075%", "4.354%",
			 1))
})

test_that("Evaluation of Sampling Objectives plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotObjectives"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives-1")
})

### Test 2: Evaluation using correct / incorrect

options <- jaspTools::analysisOptions("auditClassicalEvaluation")
options$materiality_test <- TRUE
options$materiality_rel_val <- 0.2
options$n_units <- 2000
options$id <- "ID"
options$values.audit <- "TARGET_Adjusted"
options$dataType <- "data"
options$plotObjectives <- TRUE
options$prior_method <- "arm"
options$materiality_type <- "materiality_rel"
options$method <- "poisson"
options$display <- "percent"
options$annotation <- "binary"
set.seed(1)
results <- jaspTools::runAnalysis("auditClassicalEvaluation", "auditRattle.csv", options)


test_that("<b>Table 1.</b> Evaluation Summary results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("20%", "50.602%", 83, 0.999999952510011, "14.848%", "50.602%",
			 "65.451%", 42))
})

test_that("Evaluation of Sampling Objectives plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotObjectives"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives-2")
})

### Test 3: Evaluation using soll values

options <- jaspTools::analysisOptions("auditClassicalEvaluation")
options$materiality_test <- TRUE
options$materiality_abs_val <- 70161
options$n_items <- 3500
options$n_units <- 1200000
options$id <- "ID"
options$values <- "bookValue"
options$values.audit <- "auditValue"
options$times <- "selectionResult"
options$dataType <- "data"
options$plotObjectives <- TRUE
options$plotScatter <- TRUE
options$plotScatterCorrelation <- TRUE
options$materiality_type <- "materiality_abs"
options$method <- "stringer"
options$display <- "amount"
options$annotation <- "continuous"
set.seed(1)
results <- jaspTools::runAnalysis("auditClassicalEvaluation", "test-auditClassicalWorkflow.csv", options)


test_that("<b>Table 1.</b> Evaluation Summary results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(70161, 15384.6326972187, 234, 22689.2669334712, 3, 38073.8996306899,
			 5))
})

test_that("Evaluation of Sampling Objectives plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotObjectives"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives-3")
})

test_that("Scatter Plot of Book and Audit Values matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotScatter"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "scatter-plot-of-book-and-audit-values")
})