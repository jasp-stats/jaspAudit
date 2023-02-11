context("[Audit] Bayesian Planning")

### Test 1: Plan using the beta distribution

options <- jaspTools::analysisOptions("auditBayesianPlanning")
options$bayesian <- TRUE
options$area <- "less"
options$separateMisstatement <- FALSE
options$explanatoryText <- TRUE
options$materiality_test <- TRUE
options$materiality_rel_val <- 0.05
options$min_precision_test <- FALSE
options$ir <- "high"
options$plotPriorPredictive <- TRUE
options$cr <- "high"
options$n_units <- 1000
options$tablePrior <- TRUE
options$plotPriorWithPosterior <- TRUE
options$plotPrior <- TRUE
options$plotSampleSizes <- TRUE
options$alpha <- 1
options$beta <- 1
options$max <- 5000
options$by <- 1
options$conf_level <- 0.95
options$expected_rel_val <- 0
options$materiality_type <- "materiality_rel"
options$expected_type <- "expected_rel"
options$likelihood <- "binomial"
options$prior_method <- "param"
options$display <- "number"
options$armpreset <- "jasp"
set.seed(1)
dataset <- NULL
results <- jaspTools::runAnalysis("auditBayesianPlanning", dataset, options)


test_that("Across Probability Distributions (Current: Beta) plot matches", {
  plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonDistributions"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "across-probability-distributions-current-beta-")
})

test_that("Across Expected Errors (Current: 0) plot matches", {
  plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonErrors"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "across-expected-errors-current-0-")
})

test_that("Prior Predictive Distribution plot matches", {
  plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_plotPredictive"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-predictive-distribution-1")
})

test_that("Prior and Expected Posterior Distribution plot matches", {
  plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_plotPriorAndPosterior"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-and-expected-posterior-distribution")
})

test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(0.05, 0.05, 58, "Value", 0)
  )
})

test_that("<b>Table 2.</b> Descriptive Statistics for Prior and Expected Posterior Distribution results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_tablePriorPosterior"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      0.95, "beta(<unicode> = 1, <unicode> = 1)", 0.05, 0.95, 0.5, 0.5,
      "NaN", 0.0526315789473684, "NaN", "Prior", 0.0495076098882269,
      "beta(<unicode> = 1, <unicode> = 59)", 0.951505474750577, 0.0484945252494232,
      0.0166666666666667, 0.0116795159830869, 0, 19.6208844164712,
      0.0495076098882269, "Posterior", -0.900492390111773, "", 19.0301094950115,
      0.0510468686836034, -0.483333333333333, -0.488320484016913,
      "NaN", 372.796803912953, "", "Shift"
    )
  )
})

### Test 2: Plan using the gamma distribution

options <- jaspTools::analysisOptions("auditBayesianPlanning")
options$bayesian <- TRUE
options$area <- "less"
options$separateMisstatement <- FALSE
options$materiality_test <- TRUE
options$materiality_abs_val <- 70161
options$n_units <- 1400000
options$tablePrior <- TRUE
options$plotPrior <- TRUE
options$plotSampleSizes <- FALSE
options$plotPriorWithPosterior <- TRUE
options$materiality_type <- "materiality_abs"
options$expected_type <- "expected_rel"
options$likelihood <- "poisson"
options$prior_method <- "arm"
options$cr <- "medium"
options$ir <- "high"
options$conf_level <- 0.95
options$expected_rel_val <- 0
options$explanatoryText <- TRUE
options$display <- "number"
options$max <- 5000
options$by <- 1
options$plotPriorPredictive <- FALSE
options$min_precision_test <- FALSE
options$armpreset <- "jasp"
set.seed(1)
dataset <- NULL
results <- jaspTools::runAnalysis("auditBayesianPlanning", dataset, options)


test_that("Prior and Expected Posterior Distribution plot matches", {
  plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_plotPriorAndPosterior"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-and-expected-posterior-distribution-2")
})

test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(0.6, 0.0833333333333334, 1, 0.050115, 50, "Value", 0)
  )
})

test_that("<b>Table 2.</b> Descriptive Statistics for Prior and Expected Posterior Distribution results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_tablePriorPosterior"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      0.299573227355399, "gamma(<unicode> = 1, <unicode> = 10)", 0.394166449631336,
      0.605833550368664, 0.1, 0.0693147180559945, 0, 0.65061839079641,
      0.299573227355399, "Prior", 0.0499288712258998, "gamma(<unicode> = 1, <unicode> = 60)",
      0.950555279943933, 0.0494447200560672, 0.0166666666666667, 0.0115524530093324,
      0, 19.224606365777, 0.0499288712258998, "Posterior", -0.249644356129499,
      "", 2.41155806343484, 0.0816143642523247, -0.0833333333333333,
      -0.0577622650466621, 0, 29.5482061954082, "", "Shift"
    )
  )
})

### Test 3: Plan using the beta-binomial distribution

options <- jaspTools::analysisOptions("auditBayesianPlanning")
options$bayesian <- TRUE
options$area <- "less"
options$separateMisstatement <- FALSE
options$materiality_test <- TRUE
options$materiality_abs_val <- 20
options$n_units <- 100
options$tablePrior <- TRUE
options$plotPrior <- TRUE
options$plotPriorWithPosterior <- TRUE
options$materiality_type <- "materiality_abs"
options$expected_type <- "expected_rel"
options$likelihood <- "hypergeometric"
options$prior_method <- "param"
options$conf_level <- 0.95
options$expected_rel_val <- 0
options$explanatoryText <- TRUE
options$display <- "number"
options$max <- 5000
options$by <- 1
options$alpha <- 1
options$beta <- 1
options$ir <- "high"
options$cr <- "high"
options$plotSampleSizes <- FALSE
options$plotPriorPredictive <- FALSE
options$min_precision_test <- FALSE
options$armpreset <- "jasp"
set.seed(1)
dataset <- NULL
results <- jaspTools::runAnalysis("auditBayesianPlanning", dataset, options)


test_that("Prior and Expected Posterior Distribution plot matches", {
  plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_plotPriorAndPosterior"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-and-expected-posterior-distribution-3")
})

test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(0.05, 0.2, 12, "Value", 0)
  )
})

test_that("<b>Table 2.</b> Descriptive Statistics for Prior and Expected Posterior Distribution results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_tablePriorPosterior"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      95, "beta-binomial(N = 100, <unicode> = 1, <unicode> = 1)", 0.1980198019802,
      0.8019801980198, 50, 50, "", 0.246913580246916, "", "Prior",
      19, "beta-binomial(N = 88, <unicode> = 1, <unicode> = 13)",
      0.954002621397657, 0.0459973786023425, 6.28571428571429, 4,
      0, 20.7403693511585, 19, "Posterior", -76, "", 4.81771323805813,
      0.0573547560350198, -43.7142857142857, -46, "", 83.9984958721908,
      "", "Shift"
    )
  )
})
