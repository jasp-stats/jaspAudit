context("[Audit] Bayesian Planning")

### Test 1: Plan using the beta distribution

options <- jaspTools::analysisOptions("auditBayesianPlanning")
options$materiality_test <- TRUE
options$materiality_rel_val <- 0.05
options$n_units <- 1000
options$tableImplicitSample <- TRUE
options$tablePrior <- TRUE
options$plotPrior <- TRUE
options$plotSampleSizes <- TRUE
options$beta <- 1
options$materiality_type <- "materiality_rel"
options$expected_type <- "expected_rel"
options$likelihood <- "binomial"
options$prior_method <- "param"
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

test_that("Prior and Expected Posterior Distribution plot matches", {
  plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_plotPriorAndPosterior"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-and-expected-posterior-distribution-1")
})

test_that("<b>Table 2.</b> Equivalent prior sample results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_sampletable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(1, 0)
  )
})

test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(0.05, 0.05, 58, 0)
  )
})

test_that("<b>Table 3.</b> Descriptive Statistics for Prior and Expected Posterior Distribution results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_tablePriorPosterior"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      0.95, "beta(<unicode><unicode> = 1, <unicode><unicode> = 1)",
      0.05, 0.95, 0.5, 0.5, "NaN", 0.0526315789473684, "NaN", "Prior",
      0.0495076098882269, "beta(<unicode><unicode> = 1, <unicode><unicode> = 59)",
      0.951505474750577, 0.0484945252494232, 0.0166666666666667, 0.0116795159830869,
      0, 19.6208844164712, 0.0495076098882269, "Posterior", -0.900492390111773,
      "", 19.0301094950115, 0.0510468686836034, -0.483333333333333,
      -0.488320484016913, "NaN", 372.796803912953, "", "Shift"
    )
  )
})

### Test 2: Plan using the gamma distribution

options <- jaspTools::analysisOptions("auditBayesianPlanning")
options$materiality_test <- TRUE
options$materiality_abs_val <- 70161
options$n_units <- 1400000
options$tableImplicitSample <- TRUE
options$tablePrior <- TRUE
options$plotPrior <- TRUE
options$materiality_type <- "materiality_abs"
options$expected_type <- "expected_rel"
options$likelihood <- "poisson"
options$prior_method <- "arm"
options$CR <- "medium"
set.seed(1)
dataset <- NULL
results <- jaspTools::runAnalysis("auditBayesianPlanning", dataset, options)


test_that("Prior and Expected Posterior Distribution plot matches", {
  plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_plotPriorAndPosterior"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-and-expected-posterior-distribution-2")
})

test_that("<b>Table 2.</b> Equivalent prior sample results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_sampletable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(0, 0)
  )
})

test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(1, 0.05, 1, 0.050115, 60, 0)
  )
})

test_that("<b>Table 3.</b> Descriptive Statistics for Prior and Expected Posterior Distribution results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_tablePriorPosterior"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      "<unicode><unicode><unicode>", "gamma(<unicode><unicode> = 1, <unicode><unicode> = 0)",
      0, 1, "<unicode><unicode><unicode>", "<unicode><unicode><unicode>",
      "NaN", 0, "NaN", "Prior", 0.0499288712258998, "gamma(<unicode><unicode> = 1, <unicode><unicode> = 60)",
      0.950555279943933, 0.0494447200560672, 0.0166666666666667, 0.0115524530093324,
      0, 19.224606365777, 0.0499288712258998, "Posterior", "-<unicode><unicode><unicode>",
      "", "<unicode><unicode><unicode>", 0.0494447200560672, "-<unicode><unicode><unicode>",
      "-<unicode><unicode><unicode>", "NaN", 19.224606365777, "",
      "Shift"
    )
  )
})

### Test 3: Plan using the beta-binomial distribution

options <- jaspTools::analysisOptions("auditBayesianPlanning")
options$materiality_test <- TRUE
options$materiality_abs_val <- 2000
options$n_units <- 10000
options$tableImplicitSample <- TRUE
options$tablePrior <- TRUE
options$plotPrior <- TRUE
options$beta <- 1
options$materiality_type <- "materiality_abs"
options$expected_type <- "expected_rel"
options$likelihood <- "hypergeometric"
options$prior_method <- "param"
set.seed(1)
dataset <- NULL
results <- jaspTools::runAnalysis("auditBayesianPlanning", dataset, options)


test_that("<b>Table 2.</b> Equivalent prior sample results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_sampletable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(1, 0)
  )
})

test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(0.05, 0.2, 13, 0)
  )
})

test_that("<b>Table 3.</b> Descriptive Statistics for Prior and Expected Posterior Distribution results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_tablePriorPosterior"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      9500, "beta-binomial(N = 10000, <unicode><unicode> = 1, <unicode><unicode> = 1)",
      0.199980002031956, 0.800019997968044, 5000, 5000, "", 0.249968753956003,
      "", "Prior", 1925, "beta-binomial(N = 9987, <unicode><unicode> = 1, <unicode><unicode> = 14)",
      0.956104196394013, 0.0438958036059865, 665.8, 482, 0, 21.7812209334657,
      1925, "Posterior", -7575, "", 4.7809990332995, 0.0548683829372724,
      -4334.2, -4518, "", 87.1357743268162, "", "Shift"
    )
  )
})
