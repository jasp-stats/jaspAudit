context("[Audit] Classical Evaluation")

### Test 1: Evaluation using summary statistics

options <- analysisOptions("auditClassicalEvaluation")
options$performanceMateriality <- TRUE
options$materialityPercentage <- 0.05
options$populationSize <- 3500
options$populationValue <- 1200000
options$useSumStats <- TRUE
options$nSumStats <- 93
options$kSumStats <- 1
options$evaluationInformation <- TRUE
options$priorConstructionMethod <- "arm"
options$materiality <- "materialityRelative"
options$variableType <- "variableTypeCorrect"
options$IR <- "High"
options$CR <- "Medium"
options$estimator <- "stringerBound"
options$estimator2 <- "binomialBound"
options$display <- "displayPercentages"
options$.meta <- list(auditResult = list(containsColumn = TRUE), monetaryVariable = list(
    containsColumn = TRUE), recordNumberVariable = list(containsColumn = TRUE), 
    sampleCounter = list(containsColumn = TRUE))
set.seed(1)
dataset <- NULL
results <- runAnalysis("auditClassicalEvaluation", dataset, options)


test_that("Evaluation of Sampling Objectives plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationInformation"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives-1", dir="auditClassicalEvaluation")
})

test_that("<b>Table 1.</b> Evaluation Summary results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("4.354%", 1, "5%", "1.075%", 93, "1.075%"))
})

### Test 2: Evaluation using correct / incorrect

options <- analysisOptions("auditClassicalEvaluation")
options$performanceMateriality <- TRUE
options$materialityPercentage <- 0.2
options$populationSize <- 2000
options$recordNumberVariable <- "ID"
options$auditResult <- "TARGET_Adjusted"
options$obtainedPrecision <- TRUE
options$evaluationInformation <- TRUE
options$priorConstructionMethod <- "arm"
options$materiality <- "materialityRelative"
options$variableType <- "variableTypeCorrect"
options$IR <- "High"
options$CR <- "High"
options$estimator <- "stringerBound"
options$estimator2 <- "poissonBound"
options$display <- "displayPercentages"
options$.meta <- list(auditResult = list(containsColumn = TRUE), monetaryVariable = list(
    containsColumn = TRUE), recordNumberVariable = list(containsColumn = TRUE), 
    sampleCounter = list(containsColumn = TRUE))
set.seed(1)
results <- runAnalysis("auditClassicalEvaluation", "auditRattle.csv", options)


test_that("Evaluation of Sampling Objectives plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationInformation"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives-2", dir="auditClassicalEvaluation")
})

test_that("<b>Table 1.</b> Evaluation Summary results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("65.451%", 42, "20%", "50.602%", "14.848%", 83, "50.602%"))
})

### Test 3: Evaluation using soll values

options <- analysisOptions("auditClassicalEvaluation")
options$performanceMateriality <- TRUE
options$materialityValue <- 70161
options$populationSize <- 3500
options$populationValue <- 1200000
options$recordNumberVariable <- "ID"
options$auditResult <- "auditValue"
options$monetaryVariable <- "bookValue"
options$sampleCounter <- "selectionResult"
options$evaluationInformation <- TRUE
options$correlationPlot <- TRUE
options$correlationPlotShowCorrelation <- TRUE
options$materiality <- "materialityAbsolute"
options$variableType <- "variableTypeAuditValues"
options$IR <- "High"
options$CR <- "High"
options$estimator <- "stringerBound"
options$estimator2 <- "binomialBound"
options$display <- "displayValues"
options$.meta <- list(auditResult = list(containsColumn = TRUE), monetaryVariable = list(
    containsColumn = TRUE), recordNumberVariable = list(containsColumn = TRUE), 
    sampleCounter = list(containsColumn = TRUE))
set.seed(1)
results <- runAnalysis("auditClassicalEvaluation", "test-auditClassicalWorkflow.csv", options)


test_that("Scatter Plot of Ist and Soll Values matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_correlationPlot"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "scatter-plot-of-ist-and-soll-values", dir="auditClassicalEvaluation")
})

test_that("Evaluation of Sampling Objectives plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationInformation"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives-3", dir="auditClassicalEvaluation")
})

test_that("<b>Table 1.</b> Evaluation Summary results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("$ 38073.9", 5, "$ 70161", "$ 15384.63", 234, "$ 3"))
})
