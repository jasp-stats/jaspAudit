context("[Audit] Bayesian Workflow")

options <- jaspTools::analysisOptions("auditBayesianWorkflow")
options$annotation <- "continuous"
options$area <- "area_bound"
options$critical_action <- "inspect"
options$critical_name <- "Critical"
options$dataType <- "data"
options$display <- "number"
options$evaluationChecked <- TRUE
options$executionChecked <- TRUE
options$expected_rel_val <- 0.025
options$expected_type <- "expected_rel"
options$id <- "ID"
options$likelihood <- "poisson"
options$materiality_abs_val <- 70161
options$materiality_test <- TRUE
options$materiality_type <- "materiality_abs"
options$method <- "poisson"
options$plotBookDist <- TRUE
options$plotObjectives <- TRUE
options$plotPosterior <- TRUE
options$plotPrior <- TRUE
options$plotScatter <- TRUE
options$prior_method <- "default"
options$randomize <- FALSE
options$indicator_col <- "SelectionResult"
options$samplingChecked <- TRUE
options$sampling_method <- "interval"
options$separateMisstatement <- FALSE
options$tableBookDist <- TRUE
options$tablePrior <- TRUE
options$tablePriorPosterior <- TRUE
options$units <- "values"
options$values <- "bookValue"
options$values.audit <- "auditValue"
options$variable_col <- "AuditResult"
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianWorkflow", "test-workflow.csv", options)


test_that("<b>Table 7.</b> Evaluation Summary results match", {
  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      6238.28287046477, 0.0499999707815054, 0.0129310668996017, 231,
      0.0204899126034022, 3.0000075207076, 0.0334209795030039, 5
    )
  )
})

test_that("Evaluation of Sampling Objectives plot matches", {
  plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotObjectives"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives")
})

test_that("Prior and Posterior Distribution plot matches", {
  plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotPriorAndPosterior"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-and-posterior-distribution")
})

test_that("Scatter Plot of Book and Audit Values matches", {
  plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotScatter"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "scatter-plot-of-book-and-audit-values")
})

test_that("<b>Table 8.</b> Descriptive Statistics for Prior and Posterior Distribution results match", {
  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_tablePriorPosterior"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      2.99573227355399, "gamma(<unicode><unicode> = 1, <unicode><unicode> = 1)",
      0.0487705477057937, 0.951229452294206, 1, 0.693147180559945,
      0, 0.0512710656594656, 2.99573227355399, "Prior", 0.0334209795030039,
      "gamma(<unicode><unicode> = 4, <unicode><unicode> = 232)", 0.996883214780812,
      0.003116785219188, 0.0172414117271879, 0.015827880424827, 0.0129310668996017,
      319.843410653919, 0.0204899126034022, "Posterior", -2.96231129405099,
      "", 20.4402710585591, 0.00327658611880744, -0.982758588272812,
      -0.677319300135118, 0.0129310668996017, 6238.28287046477, "",
      "Shift"
    )
  )
})

test_that("Prior and Expected Posterior Distribution plot matches", {
  plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_plotPriorAndPosterior"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-and-expected-posterior-distribution")
})

test_that("<b>Table 2.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(0.05, 0.0499999707815054, 228, 5.7)
  )
})

test_that("<b>Table 4.</b> Descriptive Statistics for Prior and Expected Posterior Distribution results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_tablePriorPosterior"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      2.99573227355399, "gamma(<unicode><unicode> = 1, <unicode><unicode> = 1)",
      0.0487705477057937, 0.951229452294206, 1, 0.693147180559945,
      0, 0.0512710656594656, 2.99573227355399, "Prior", 0.0499839156406896,
      "gamma(<unicode><unicode> = 6.7, <unicode><unicode> = 229)",
      0.950102799995293, 0.0498972000047066, 0.0292576419213974, 0.0278156203723628,
      0.0248908296943231, 19.0412047150075, 0.0250930859463665, "Posterior",
      -2.9457483579133, "", 19.4810770985544, 0.0524554826223714,
      -0.970742358078603, -0.665331560187582, 0.0248908296943231,
      371.383049485966, "", "Shift"
    )
  )
})

test_that("Distribution of Book Values plot matches", {
  plotName <- results[["results"]][["procedureContainer"]][["collection"]][["procedureContainer_plotBookDist"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "distribution-of-book-values")
})

test_that("<b>Table 1.</b> Descriptive Statistics for Book Values results match", {
  table <- results[["results"]][["procedureContainer"]][["collection"]][["procedureContainer_tableBookDist"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      3500, 1403220.82, 400.920234285714, 254.3825, 364.11, 513.26,
      200.782613001148, 1403220.82
    )
  )
})

test_that("<b>Table 6.</b> Information about Monetary Interval Selection results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      3500, 1403220.82, 228, 228, "8.36%", "Total", 117311.64, 0, 0,
      0, 0, "0%", "Top stratum", 0, 3500, 1403220.82, 228, 228, "8.36%",
      "Bottom stratum", 117311.64
    )
  )
})

test_that("<b>Table 5.</b> Selection Summary results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list("8.36%", 228, 228, 117311.64)
  )
})
