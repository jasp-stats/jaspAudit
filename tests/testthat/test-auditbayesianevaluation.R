context("[Audit] Bayesian Evaluation")

### Test 1: Evaluation using summary statistics

options <- jaspTools::analysisOptions("auditBayesianEvaluation")
options$bayesian <- TRUE
options$materiality_test <- TRUE
options$materiality_rel_val <- 0.05
options$n_items <- 3500
options$n_units <- 1200000
options$dataType <- "stats"
options$stats <- TRUE
options$n <- 80
options$x <- 1
options$tablePriorPosterior <- TRUE
options$plotPosterior <- TRUE
options$plotObjectives <- TRUE
options$cr <- "high"
options$expected_rel_val <- 0.0125
options$materiality_type <- "materiality_rel"
options$method <- "binomial"
options$area <- "less"
options$prior_method <- "default"
options$expected_type <- "expected_rel"
options$separateMisstatement <- FALSE
options$critical_negative <- TRUE
options$critical_action <- "inspect"
options$ir <- "high"
options$conf_level <- 0.95
options$min_precision_test <- FALSE
options$min_precision_rel_val <- 0.02
options$explanatoryText <- TRUE
options$id <- ""
options$stratum <- ""
options$tableTaints <- FALSE
options$tableAssumptions <- FALSE
options$plotPosteriorInfo <- TRUE
options$plotPosteriorPredictive <- FALSE
options$plotEstimates <- FALSE
options$plotScatter <- FALSE
options$tableCorrections <- FALSE
options$display <- "number"
set.seed(1)
dataset <- NULL
results <- jaspTools::runAnalysis("auditBayesianEvaluation", dataset, options)


test_that("<b>Table 1.</b> Evaluation Summary results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(211.088638102458, 0.0572299998232917, 0.05, 0.0125, 80, "Value",
			 0.0447299998232917, 1, 1))
})

test_that("Evaluation of Sampling Objectives plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotObjectives"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives-1")
})

test_that("Prior and Posterior Distribution plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotPriorAndPosterior"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "prior-and-posterior-distribution-1")
})

test_that("<b>Table 2.</b> Descriptive Statistics for Prior and Posterior Distribution results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_tablePriorPosterior"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0.95, "beta(<unicode> = 1, <unicode> = 1)", 0.05, 0.95, 0.5, 0.5,
			 "NaN", 0.0526315789473684, "NaN", "Prior", 0.0572299998232917,
			 "beta(<unicode> = 2, <unicode> = 80)", 0.917423128074932, 0.0825768719250681,
			 0.024390243902439, 0.0206338067351869, 0.0125, 11.109928321182,
			 0.0447299998232917, "Posterior", -0.892770000176708, "", 18.3484625614986,
			 0.0869230230790191, -0.475609756097561, -0.479366193264813,
			 "NaN", 211.088638102458, "", "Shift"))
})

### Test 2: Evaluation using correct / incorrect

options <- jaspTools::analysisOptions("auditBayesianEvaluation")
options$bayesian <- TRUE
options$materiality_test <- TRUE
options$materiality_rel_val <- 0.2
options$n_items <- 2000
options$n_units <- 2000
options$dataType <- "data"
options$id <- "ID"
options$values.audit <- "TARGET_Adjusted"
options$tablePriorPosterior <- TRUE
options$plotPosteriorInfo <- TRUE
options$plotPosteriorPredictive <- FALSE
options$plotEstimates <- FALSE
options$plotPosterior <- TRUE
options$min_precision_rel_val <- 0.02
options$plotScatter <- FALSE
options$tableCorrections <- FALSE
options$plotObjectives <- TRUE
options$materiality_type <- "materiality_rel"
options$method <- "binomial"
options$area <- "two.sided"
options$prior_method <- "default"
options$expected_type <- "expected_rel"
options$display <- "number"
options$separateMisstatement <- FALSE
options$critical_negative <- TRUE
options$critical_action <- "inspect"
options$conf_level <- 0.95
options$ir <- "high"
options$cr <- "high"
options$n <- 0
options$x <- 0
options$stratum <- ""
options$tableTaints <- FALSE
options$tableAssumptions <- FALSE
options$expected_rel_val <- 0
options$min_precision_test <- FALSE
options$explanatoryText <- TRUE
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianEvaluation", "auditRattle.csv", options)


test_that("<b>Table 1.</b> Evaluation Summary results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(30323119.9160736, 0.400352837948873, 0.2, 0.506024096385542, 83,
			 "Value", 0.105125433872907, 42, 0.611149530258449, 42))
})

test_that("Evaluation of Sampling Objectives plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotObjectives"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives-2")
})

test_that("Prior and Posterior Distribution plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotPriorAndPosterior"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "prior-and-posterior-distribution-2")
})

test_that("<b>Table 2.</b> Descriptive Statistics for Prior and Posterior Distribution results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_tablePriorPosterior"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0.95, "beta(<unicode> = 1, <unicode> = 1)", 0.5, 0.5, "NaN", "NaN",
			 "Prior", 0.611149530258449, "beta(<unicode> = 43, <unicode> = 42)",
			 0.505882352941176, 0.505928705388406, 0.506024096385542, 0.105125433872907,
			 "Posterior", -0.338850469741551, "", 0.00588235294117645, 0.0059287053884064,
			 "NaN", "", "Shift"))
})

### Test 3: Evaluation using soll values

options <- jaspTools::analysisOptions("auditBayesianEvaluation")
options$bayesian <- TRUE
options$materiality_test <- TRUE
options$materiality_abs_val <- 70161
options$n_items <- 3500
options$n_units <- 1400000
options$id <- "ID"
options$values <- "bookValue"
options$dataType <- "data"
options$values.audit <- "auditValue"
options$times <- "selectionResult"
options$tablePriorPosterior <- TRUE
options$plotPosterior <- TRUE
options$plotObjectives <- TRUE
options$cr <- "medium"
options$expected_rel_val <- 0.005
options$materiality_type <- "materiality_val"
options$method <- "binomial"
options$prior_method <- "default"
options$area <- "less"
options$expected_type <- "expected_rel"
options$display <- "amount"
options$separateMisstatement <- FALSE
options$annotation <- "continuous"
options$critical_negative <- TRUE
options$critical_action <- "inspect"
options$ir <- "high"
options$conf_level <- 0.95
options$min_precision_test <- FALSE
options$min_precision_rel_val <- 0.02
options$explanatoryText <- TRUE
options$stratum <- ""
options$pooling <- FALSE
options$n <- 0
options$x <- 0
options$tableTaints <- FALSE
options$tableAssumptions <- FALSE
options$plotPosteriorInfo <- TRUE
options$plotPosteriorPredictive <- FALSE
options$plotEstimates <- FALSE
options$plotScatter <- FALSE
options$tableCorrections <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianEvaluation", "test-auditClassicalWorkflow.csv", options)


test_that("<b>Table 1.</b> Evaluation Summary results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(8282.04678073276, 45726.6912117069, 70161, 17948.7381467551, 234,
			 "Value", 27777.9530649518, 3.00000337595764, 5))
})

test_that("Evaluation of Sampling Objectives plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotObjectives"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives-3")
})

test_that("Prior and Posterior Distribution plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotPriorAndPosterior"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "prior-and-posterior-distribution-3")
})

test_that("<b>Table 2.</b> Descriptive Statistics for Prior and Posterior Distribution results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_tablePriorPosterior"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0.95, "beta(<unicode> = 1, <unicode> = 1)", 0.050115, 0.949885,
			 0.5, 0.5, "NaN", 0.0527590181969396, "NaN", "Prior", 0.0326619222940764,
			 "beta(<unicode> = 4, <unicode> = 232)", 0.997716648170882, 0.00228335182911776,
			 0.0169491668472781, 0.0156034818108654, 0.0128205272476822,
			 436.952656812585, 0.0198413950463942, "Posterior", -0.917338077705924,
			 "", 19.9085433137959, 0.0024038192298202, -0.483050833152722,
			 -0.484396518189135, "NaN", 8282.04678073276, "", "Shift"))
})
