context("[Audit] Bayesian Workflow")

options <- jaspTools::analysisOptions("auditBayesianWorkflow")
options$bayesian <- TRUE
options$id <- "ID"
options$values <- "bookValue"
options$samplingChecked <- TRUE
options$executionChecked <- TRUE
options$evaluationChecked <- TRUE
options$values.audit <- "auditValue"
options$dataType <- "data"
options$annotation <- "continuous"
options$method <- "poisson"
options$area <- "less"
options$critical_action <- "inspect"
options$critical_name <- "Critical"
options$display <- "number"
options$randomize <- FALSE
options$expected_rel_val <- 0.025
options$expected_type <- "expected_rel"
options$likelihood <- "poisson"
options$materiality_abs_val <- 70161
options$materiality_test <- TRUE
options$materiality_type <- "materiality_abs"
options$plotBookDist <- TRUE
options$plotObjectives <- TRUE
options$plotPosterior <- TRUE
options$plotPrior <- TRUE
options$plotScatter <- FALSE
options$prior_method <- "default"
options$randomStart <- FALSE
options$start <- 1
options$indicator_col <- "SelectionResult"
options$sampling_method <- "interval"
options$separateMisstatement <- FALSE
options$tableBookDist <- TRUE
options$tablePrior <- TRUE
options$tablePriorPosterior <- TRUE
options$units <- "values"
options$variable_col <- "AuditResult"
options$explanatoryText <- TRUE
options$min_precision_test <- FALSE
options$critical_negative <- TRUE
options$ir <- "high"
options$cr <- "high"
options$conf_level <- 0.95
options$min_precision_rel_val <- 0.02
options$plotSampleSizes <- FALSE
options$max <- 5000
options$by <- 1
options$tableDescriptives <- FALSE
options$tableSample <- FALSE
options$tableTaints <- TRUE
options$tableAssumptions <- FALSE
options$plotPosteriorInfo <- TRUE
options$plotPriorPredictive <- FALSE
options$plotPosteriorPredictive <- FALSE
options$plotEstimates <- FALSE
options$tableCorrections <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianWorkflow", "test-workflow.csv", options)


test_that("<b>Table 6.</b> Evaluation Summary results match", {
  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      6238.28287046482, 0.0334209795030039, 0.0499999707815054, 0.0129310668996017,
      231, "Value", 0.0204899126034022, 3.0000075207076, 5
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

test_that("<b>Table 8.</b> Descriptive Statistics for Prior and Posterior Distribution results match", {
  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_tablePriorPosterior"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      2.99573227355399, "gamma(<unicode> = 1, <unicode> = 1)", 0.0487705477057938,
      0.951229452294206, 1, 0.693147180559945, 0, 0.0512710656594656,
      2.99573227355399, "Prior", 0.0334209795030039, "gamma(<unicode> = 4, <unicode> = 232)",
      0.996883214780812, 0.00311678521918797, 0.0172414117271879,
      0.015827880424827, 0.0129310668996017, 319.843410653921, 0.0204899126034022,
      "Posterior", -2.96231129405099, "", 20.4402710585591, 0.00327658611880741,
      -0.982758588272812, -0.677319300135118, 0.0129310668996017,
      6238.28287046482, "", "Shift"
    )
  )
})

test_that("<b>Table 9.</b> Misstated Items results match", {
  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_tableTaints"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      233.07, 7353, 0.6, "x1", 388.45, 155.38, 413.23, 71371, 0.600005807959809,
      "x1", 688.71, 275.48, 228.98, 13683, 0.599989518918352, "x1",
      381.64, 152.66, 259.18, 32535, 0.600009260116677, "x1", 431.96,
      172.78, 409.04, 26052, 0.60000293371276, "x1", 681.73, 272.69,
      1543.5, "Total", 3.0000075207076, "", "", ""
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
    list(0.05, 0.0499999707815054, 228, "Value", 5.7)
  )
})

test_that("<b>Table 3.</b> Descriptive Statistics for Prior and Expected Posterior Distribution results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_tablePriorPosterior"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      2.99573227355399, "gamma(<unicode> = 1, <unicode> = 1)", 0.0487705477057938,
      0.951229452294206, 1, 0.693147180559945, 0, 0.0512710656594656,
      2.99573227355399, "Prior", 0.0499839156406896, "gamma(<unicode> = 6.7, <unicode> = 229)",
      0.950102799995294, 0.0498972000047063, 0.0292576419213974, 0.0278156203723628,
      0.0248908296943231, 19.0412047150077, 0.0250930859463665, "Posterior",
      -2.9457483579133, "", 19.4810770985544, 0.0524554826223711,
      -0.970742358078603, -0.665331560187582, 0.0248908296943231,
      371.383049485968, "", "Shift"
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

test_that("<b>Table 5.</b> Information about Monetary Interval Selection results match", {
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

test_that("<b>Table 4.</b> Selection Summary results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(228, "8.36%", 228, 117311.64)
  )
})
