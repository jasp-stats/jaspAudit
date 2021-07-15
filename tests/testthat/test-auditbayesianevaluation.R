context("[Audit] Bayesian Evaluation")

### Test 1: Evaluation using summary statistics

options <- jaspTools::analysisOptions("auditBayesianEvaluation")
options$performanceMateriality <- TRUE
options$materialityPercentage <- 0.05
options$populationSize <- 3500
options$populationValue <- 1200000
options$priorConstructionMethod <- "none"
options$useSumStats <- TRUE
options$nSumStats <- 80
options$kSumStats <- 1
options$expectedPercentage <- 0.0125
options$evidenceRatio <- TRUE
options$bayesFactor <- TRUE
options$priorAndPosteriorStatistics <- TRUE
options$evaluationInformation <- TRUE
options$priorAndPosteriorPlot <- TRUE
options$materiality <- "materialityRelative"
options$variableType <- "variableTypeCorrect"
options$expectedErrors <- "expectedRelative"
options$IR <- "High"
options$CR <- "Medium"
options$estimator <- "betaBound"
options$areaUnderPosterior <- "displayCredibleBound"
options$display <- "displayPercentages"
options$shadePosterior <- "shadePosteriorCredibleRegion"
options$.meta <- list(auditResult = list(containsColumn = TRUE), monetaryVariable = list(
    containsColumn = TRUE), recordNumberVariable = list(containsColumn = TRUE), 
    sampleCounter = list(containsColumn = TRUE))
set.seed(1)
dataset <- NULL
results <- jaspTools::runAnalysis("auditBayesianEvaluation", dataset, options)


test_that("Evaluation of Sampling Objectives plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationInformation"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives")
})

test_that("<b>Table 1.</b> Evaluation Summary results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(211.088638102458, "5.723%", 11.109928321182, 1, "5%", "1.25%",
			 80, "1.25%"))
})

test_that("Prior and Posterior Distribution plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_priorAndPosteriorPlot"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "prior-and-posterior-distribution")
})

test_that("<b>Table 2.</b> Descriptive Statistics for Prior and Posterior Distribution results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_priorAndPosteriorStatistics"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0.95, "beta(<unicode><unicode> = 1, <unicode><unicode> = 1)",
			 0.05, 0.95, 0.5, 0.5, "NaN", 0.0526315789473684, "NaN", "Prior",
			 0.0572299998232917, "beta(<unicode><unicode> = 2, <unicode><unicode> = 80)",
			 0.917423128074932, 0.0825768719250681, 0.024390243902439, 0.0206338067351869,
			 0.0125, 11.109928321182, 0.0447299998232917, "Posterior", -0.892770000176708,
			 "", 18.3484625614986, 0.0869230230790191, -0.475609756097561,
			 -0.479366193264813, "NaN", 211.088638102458, "", "Shift"))
})

### Test 2: Evaluation using correct / incorrect

options <- jaspTools::analysisOptions("auditBayesianEvaluation")
options$performanceMateriality <- TRUE
options$materialityPercentage <- 0.2
options$populationSize <- 2000
options$priorConstructionMethod <- "none"
options$recordNumberVariable <- "ID"
options$auditResult <- "TARGET_Adjusted"
options$evidenceRatio <- TRUE
options$bayesFactor <- TRUE
options$priorAndPosteriorStatistics <- TRUE
options$evaluationInformation <- TRUE
options$priorAndPosteriorPlot <- TRUE
options$priorAndPosteriorPlotLimit <- 1
options$materiality <- "materialityRelative"
options$variableType <- "variableTypeCorrect"
options$expectedErrors <- "expectedRelative"
options$IR <- "High"
options$CR <- "High"
options$estimator <- "betaBound"
options$areaUnderPosterior <- "displayCredibleInterval"
options$display <- "displayPercentages"
options$shadePosterior <- "shadePosteriorCredibleRegion"
options$.meta <- list(auditResult = list(containsColumn = TRUE), monetaryVariable = list(
    containsColumn = TRUE), recordNumberVariable = list(containsColumn = TRUE), 
    sampleCounter = list(containsColumn = TRUE))
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianEvaluation", "auditRattle.csv", options)


test_that("Evaluation of Sampling Objectives plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationInformation"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives-2")
})

test_that("<b>Table 1.</b> Evaluation Summary results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(7.96650501882257e-10, 1.99162625470564e-10, 42, "40.035%", "20%",
			 "50.602%", 83, "50.602%", "61.115%"))
})

test_that("Prior and Posterior Distribution plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_priorAndPosteriorPlot"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "prior-and-posterior-distribution-2")
})

test_that("<b>Table 2.</b> Descriptive Statistics for Prior and Posterior Distribution results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_priorAndPosteriorStatistics"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0.95, "beta(<unicode><unicode> = 1, <unicode><unicode> = 1)",
			 0.2, 0.8, 0.5, 0.5, "NaN", 0.25, "NaN", "Prior", 0.594552348305879,
			 "beta(<unicode><unicode> = 43, <unicode><unicode> = 42)", 1.99162625430898e-10,
			 0.999999999800837, 0.505882352941176, 0.505928705388406, 0.506024096385542,
			 1.99162625470564e-10, 0.0885282519203364, "Posterior", -0.355447651694121,
			 "", 9.95813127154492e-10, 1.24999999975105, 0.00588235294117645,
			 0.0059287053884064, "NaN", 7.96650501882257e-10, "", "Shift"
			))
})

### Test 3: Evaluation using soll values

options <- jaspTools::analysisOptions("auditBayesianEvaluation")
options$performanceMateriality <- TRUE
options$materialityValue <- 70161
options$populationSize <- 3500
options$populationValue <- 1400000
options$priorConstructionMethod <- "none"
options$recordNumberVariable <- "ID"
options$auditResult <- "auditValue"
options$monetaryVariable <- "bookValue"
options$sampleCounter <- "selectionResult"
options$expectedPercentage <- 0.005
options$evidenceRatio <- TRUE
options$bayesFactor <- TRUE
options$priorAndPosteriorStatistics <- TRUE
options$evaluationInformation <- TRUE
options$correlationPlot <- TRUE
options$priorAndPosteriorPlot <- TRUE
options$materiality <- "materialityAbsolute"
options$variableType <- "variableTypeAuditValues"
options$expectedErrors <- "expectedRelative"
options$IR <- "High"
options$CR <- "Medium"
options$estimator <- "betaBound"
options$areaUnderPosterior <- "displayCredibleBound"
options$display <- "displayValues"
options$shadePosterior <- "shadePosteriorHypotheses"
options$.meta <- list(auditResult = list(containsColumn = TRUE), monetaryVariable = list(
    containsColumn = TRUE), recordNumberVariable = list(containsColumn = TRUE), 
    sampleCounter = list(containsColumn = TRUE))
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianEvaluation", "test-auditClassicalWorkflow.csv", options)


test_that("Scatter Plot of Ist and Soll Values matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_correlationPlot"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "scatter-plot-of-ist-and-soll-values")
})

test_that("Evaluation of Sampling Objectives plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationInformation"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives-3")
})

test_that("<b>Table 1.</b> Evaluation Summary results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(8282.04678073276, "$ 45726.69", 436.952656812585, 5, "$ 70161",
			 "$ 17948.74", 234, "$ 3"))
})

test_that("Prior and Posterior Distribution plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_priorAndPosteriorPlot"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "prior-and-posterior-distribution-3")
})

test_that("<b>Table 2.</b> Descriptive Statistics for Prior and Posterior Distribution results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_priorAndPosteriorStatistics"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0.95, "beta(<unicode><unicode> = 1, <unicode><unicode> = 1)",
			 0.050115, 0.949885, 0.5, 0.5, "NaN", 0.0527590181969396, "NaN",
			 "Prior", 0.0326619222940764, "beta(<unicode><unicode> = 4, <unicode><unicode> = 232)",
			 0.997716648170882, 0.00228335182911776, 0.0169491668472781,
			 0.0156034818108654, 0.0128205272476822, 436.952656812585, 0.0198413950463942,
			 "Posterior", -0.917338077705924, "", 19.9085433137959, 0.0024038192298202,
			 -0.483050833152722, -0.484396518189135, "NaN", 8282.04678073276,
			 "", "Shift"))
})
