context("[Audit] Bayesian Evaluation")

### Test 1: Evaluation using summary statistics

options <- jaspTools::analysisOptions("auditBayesianEvaluation")
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
options$cr <- "medium"
options$expected_rel_val <- 0.0125
options$materiality_type <- "materiality_rel"
options$method <- "binomial"
options$area <- "area_bound"
options$prior_method <- "default"
options$expected_type <- "expected_rel"
options$separateMisstatement <- FALSE
options$display <- "number"
set.seed(1)
dataset <- NULL
results <- jaspTools::runAnalysis("auditBayesianEvaluation", dataset, options)


test_that("<b>Table 1.</b> Evaluation Summary results match", {
  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      211.088638102458, 0.05, 0.0125, 80, 0.0447299998232917, 1, 0.0572299998232917,
      1
    )
  )
})

test_that("Evaluation of Sampling Objectives plot matches", {
  plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotObjectives"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives-1")
})

test_that("Prior and Posterior Distribution plot matches", {
  skip("Does not reproduce on Ubuntu and MacOS")
  plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotPriorAndPosterior"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-and-posterior-distribution-1")
})

test_that("<b>Table 2.</b> Descriptive Statistics for Prior and Posterior Distribution results match", {
  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_tablePriorPosterior"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      0.95, "beta(<unicode><unicode> = 1, <unicode><unicode> = 1)",
      0.05, 0.95, 0.5, 0.5, "NaN", 0.0526315789473684, "NaN", "Prior",
      0.0572299998232917, "beta(<unicode><unicode> = 2, <unicode><unicode> = 80)",
      0.917423128074932, 0.0825768719250681, 0.024390243902439, 0.0206338067351869,
      0.0125, 11.109928321182, 0.0447299998232917, "Posterior", -0.892770000176708,
      "", 18.3484625614986, 0.0869230230790191, -0.475609756097561,
      -0.479366193264813, "NaN", 211.088638102458, "", "Shift"
    )
  )
})

### Test 2: Evaluation using correct / incorrect

options <- jaspTools::analysisOptions("auditBayesianEvaluation")
options$materiality_test <- TRUE
options$materiality_rel_val <- 0.2
options$n_items <- 2000
options$n_units <- 2000
options$dataType <- "data"
options$id <- "ID"
options$values.audit <- "TARGET_Adjusted"
options$tablePriorPosterior <- TRUE
options$plotPosterior <- TRUE
options$plotObjectives <- TRUE
options$materiality_type <- "materiality_rel"
options$method <- "binomial"
options$area <- "area_interval"
options$prior_method <- "default"
options$expected_type <- "expected_rel"
options$display <- "percent"
options$separateMisstatement <- FALSE
options$annotation <- "binary"
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianEvaluation", "auditRattle.csv", options)


test_that("<b>Table 1.</b> Evaluation Summary results match", {
  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      7.96650501882257e-10, "40.035%", "20%", "50.602%", 83, "8.853%",
      "50.602%", "61.115%", 42
    )
  )
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
  jaspTools::expect_equal_tables(
    table,
    list(
      0.95, "beta(<unicode><unicode> = 1, <unicode><unicode> = 1)",
      0.2, 0.8, 0.5, 0.5, "NaN", 0.25, "NaN", "Prior", 0.594552348305879,
      "beta(<unicode><unicode> = 43, <unicode><unicode> = 42)", 1.99162625430898e-10,
      0.999999999800837, 0.505882352941176, 0.505928705388406, 0.506024096385542,
      1.99162625470564e-10, 0.0885282519203364, "Posterior", -0.355447651694121,
      "", 9.95813127154492e-10, 1.24999999975105, 0.00588235294117645,
      0.0059287053884064, "NaN", 7.96650501882257e-10, "", "Shift"
    )
  )
})

### Test 3: Evaluation using soll values

options <- jaspTools::analysisOptions("auditBayesianEvaluation")
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
options$plotScatter <- TRUE
options$cr <- "medium"
options$expected_rel_val <- 0.005
options$materiality_type <- "materiality_val"
options$method <- "binomial"
options$prior_method <- "default"
options$area <- "area_bound"
options$expected_type <- "expected_rel"
options$display <- "amount"
options$separateMisstatement <- FALSE
options$annotation <- "continuous"
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianEvaluation", "test-auditClassicalWorkflow.csv", options)


test_that("<b>Table 1.</b> Evaluation Summary results match", {
  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      8282.04678073276, 70161, 17948.7381467551, 234, 27777.9530649518,
      3, 45726.6912117069, 5
    )
  )
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

test_that("Scatter Plot of Book and Audit Values matches", {
  plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotScatter"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "scatter-plot-of-book-and-audit-values")
})

test_that("<b>Table 2.</b> Descriptive Statistics for Prior and Posterior Distribution results match", {
  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_tablePriorPosterior"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      0.95, "beta(<unicode><unicode> = 1, <unicode><unicode> = 1)",
      0.050115, 0.949885, 0.5, 0.5, "NaN", 0.0527590181969396, "NaN",
      "Prior", 0.0326619222940764, "beta(<unicode><unicode> = 4, <unicode><unicode> = 232)",
      0.997716648170882, 0.00228335182911776, 0.0169491668472781,
      0.0156034818108654, 0.0128205272476822, 436.952656812585, 0.0198413950463942,
      "Posterior", -0.917338077705924, "", 19.9085433137959, 0.0024038192298202,
      -0.483050833152722, -0.484396518189135, "NaN", 8282.04678073276,
      "", "Shift"
    )
  )
})
