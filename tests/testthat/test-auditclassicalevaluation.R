context("[Audit] Classical Evaluation")

### Test 1: Evaluation using summary statistics

options <- jaspTools::analysisOptions("auditClassicalEvaluation")
options$bayesian <- FALSE
options$prior_method <- "arm"
options$method <- "binomial"
options$materiality_test <- TRUE
options$materiality_rel_val <- 0.05
options$n_units <- 1200000
options$dataType <- "stats"
options$stats <- TRUE
options$n <- 93
options$x <- 1
options$cr <- "medium"
options$plotObjectives <- TRUE
options$area <- "less"
options$materiality_type <- "materiality_rel"
options$display <- "number"
options$critical_negative <- TRUE
options$critical_action <- "inspect"
options$ir <- "high"
options$car <- "high"
options$id <- ""
options$stratum <- ""
options$conf_level <- 0.95
options$n_items <- 1000
options$min_precision_test <- FALSE
options$min_precision_rel_val <- 0.02
options$explanatoryText <- TRUE
options$tableTaints <- FALSE
options$tableCorrections <- FALSE
options$plotEstimates <- FALSE
options$plotScatter <- FALSE
set.seed(1)
dataset <- NULL
results <- jaspTools::runAnalysis("auditClassicalEvaluation", dataset, options)


test_that("<b>Table 1.</b> Evaluation Summary results match", {
  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      0.05, 0.010752688172043, 93, "Value", 0.0499757952426165, 0.0309381127535062,
      1, 0.0416908009255492, 1
    )
  )
})

test_that("Evaluation of Sampling Objectives plot matches", {
  plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotObjectives"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives-1")
})

### Test 2: Evaluation using correct / incorrect

options <- jaspTools::analysisOptions("auditClassicalEvaluation")
options$bayesian <- FALSE
options$materiality_test <- TRUE
options$materiality_rel_val <- 0.2
options$n_items <- 2000
options$n_units <- 2000
options$dataType <- "data"
options$id <- "ID"
options$values.audit <- "TARGET_Adjusted"
options$plotEstimates <- FALSE
options$min_precision_rel_val <- 0.02
options$plotScatter <- FALSE
options$tableCorrections <- FALSE
options$plotObjectives <- TRUE
options$materiality_type <- "materiality_rel"
options$method <- "binomial"
options$area <- "two.sided"
options$prior_method <- "arm"
options$expected_type <- "expected_rel"
options$display <- "number"
options$separateMisstatement <- FALSE
options$critical_negative <- TRUE
options$critical_action <- "inspect"
options$conf_level <- 0.95
options$ir <- "high"
options$car <- "high"
options$cr <- "high"
options$n <- 0
options$x <- 0
options$stratum <- ""
options$tableTaints <- FALSE
options$expected_rel_val <- 0
options$min_precision_test <- FALSE
options$explanatoryText <- TRUE
set.seed(1)
results <- jaspTools::runAnalysis("auditClassicalEvaluation", "auditRattle.csv", options)


test_that("<b>Table 1.</b> Evaluation Summary results match", {
  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      0.393979377546691, 0.2, 0.506024096385542, 83, "Value", 5.1324011977083e-10,
      0.111602364625586, 42, 0.617626461011128, 42
    )
  )
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
options$n_units <- 1400000
options$id <- "ID"
options$values <- "bookValue"
options$dataType <- "data"
options$values.audit <- "auditValue"
options$times <- "selectionResult"
options$plotObjectives <- TRUE
options$cr <- "medium"
options$expected_rel_val <- 0.005
options$materiality_type <- "materiality_val"
options$method <- "binomial"
options$prior_method <- "arm"
options$area <- "less"
options$expected_type <- "expected_rel"
options$display <- "number"
options$critical_negative <- TRUE
options$critical_action <- "inspect"
options$ir <- "high"
options$car <- "high"
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
options$plotEstimates <- FALSE
options$plotScatter <- FALSE
options$tableCorrections <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditClassicalEvaluation", "test-auditClassicalWorkflow.csv", options)


test_that("<b>Table 1.</b> Evaluation Summary results match", {
  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      0.050115, 0.0128205272476822, 234, "Value", 0.00237577675705908,
      0.0157681172942989, 3.00000337595764, 0.0285886445419811, 5
    )
  )
})

test_that("Evaluation of Sampling Objectives plot matches", {
  plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotObjectives"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives-3")
})
