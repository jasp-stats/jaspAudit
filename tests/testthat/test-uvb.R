context("[Audit] UVB functionality")

options <- jaspTools::analysisOptions("auditBayesianWorkflow")
options$min_precision_test <- TRUE
options$id <- "Transaction"
options$values <- "Ist"
options$explanatoryText <- FALSE
options$by <- 5
options$separateMisstatement <- TRUE
options$samplingChecked <- TRUE
options$tableSample <- TRUE
options$evaluationChecked <- TRUE
options$values.audit <- "Soll"
options$tableCorrections <- TRUE
options$tableAssumptions <- TRUE
options$materiality_type <- "materiality_rel"
options$expected_type <- "expected_all"
options$likelihood <- "binomial"
options$prior_method <- "default"
options$critical_action <- "inspect"
options$display <- "percent"
options$units <- "values"
options$sampling_method <- "interval"
options$method <- "binomial"
options$area <- "area_bound"
options$critical_name <- "Critical"
options$indicator_col <- "SelectionResult"
options$variable_col <- "AuditResult"
options$annotation <- "continuous"
options$randomize <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianWorkflow", "Case2.csv", options)


test_that("<b>Table 7.</b> Corrections to Population results match", {
  table <- results[["results"]][["conclusionContainer"]][["collection"]][["conclusionContainer_tableCorrections"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list("17.276%", "No misstatements with 2% precision")
  )
})

test_that("<b>Table 6.</b> Assumption Checks results match", {
  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_assumptionTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      0.0513247635919807, 0.249333234395933, 68, 0.979839313192907,
      "Book values - Taints", 0.42904097696463
    )
  )
})

test_that("<b>Table 5.</b> Evaluation Summary results match", {
  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list("2%", "17.645%", 130, "1.631%", "18.037%", "19.276%", 68)
  )
})

test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list("5%", 130, "2%", "0 - 130")
  )
})

test_that("<b>Table 3.</b> Information about Monetary Interval Selection results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      238, 601292.058, 123, 130, "74.06%", "Total", 445302.2378, 32,
      185700.846, 32, 39, "100%", "Top stratum", 185700.846, 206,
      415591.212, 91, 91, "62.47%", "Bottom stratum", 259601.3918
    )
  )
})

test_that("<b>Table 4.</b> Raw Sample results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSample"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      8449, 1, 2, 1, 3086, 5, 1, 5, 1400, 8, 1, 8, 962.5, 11, 1, 11,
      1837.5, 14, 1, 14, 2062, 19, 1, 19, 4950, 20, 1, 20, 7800, 21,
      2, 21, 11220, 22, 2, 22, 5046.389, 24, 1, 24, 1839.722, 25,
      1, 25, 5539.722, 26, 1, 26, 4994.073, 27, 1, 27, 5539.722, 28,
      1, 28, 1839.722, 31, 1, 31, 3237.5, 32, 1, 32, 3693.161, 34,
      1, 34, 4573.611, 35, 1, 35, 1839.722, 36, 1, 36, 3391.667, 39,
      1, 39, 1839.722, 41, 1, 41, 5539.722, 43, 1, 43, 1366.944, 45,
      1, 45, 1603.333, 48, 1, 48, 1839.722, 51, 1, 51, 1839.722, 53,
      1, 53, 1531.389, 56, 1, 56, 1839.722, 59, 1, 59, 1839.722, 62,
      1, 62, 1839.722, 65, 1, 65, 5539.722, 66, 1, 66, 5539.722, 67,
      1, 67, 5539.722, 69, 2, 69, 4563.333, 70, 1, 70, 5539.722, 71,
      1, 71, 5539.722, 72, 1, 72, 3196.389, 73, 1, 73, 4306.389, 74,
      1, 74, 5539.722, 75, 1, 75, 5539.722, 76, 1, 76, 3700, 78, 1,
      78, 2158.333, 79, 1, 79, 3782.222, 81, 1, 81, 5539.722, 82,
      1, 82, 5539.722, 83, 1, 83, 5539.722, 84, 2, 84, 5539.722, 86,
      1, 86, 5539.722, 88, 2, 88, 931.9159, 90, 1, 90, 5539.722, 91,
      1, 91, 5539.722, 93, 1, 93, 5539.722, 94, 1, 94, 1839.722, 95,
      1, 95, 1377.222, 97, 1, 97, 5241.667, 101, 1, 101, 4141.944,
      103, 1, 103, 1839.722, 104, 1, 104, 5539.722, 106, 1, 106, 931.9159,
      107, 1, 107, 5539.722, 109, 1, 109, 2590, 111, 1, 111, 3782.222,
      112, 1, 112, 3782.222, 113, 1, 113, 5539.722, 115, 1, 115, 5046.389,
      117, 1, 117, 1839.722, 119, 1, 119, 1839.722, 121, 1, 121, 4316.667,
      124, 1, 124, 4316.667, 125, 1, 125, 4316.667, 126, 1, 126, 3700,
      127, 1, 127, 4316.667, 129, 1, 129, 3700, 130, 1, 130, 3473.889,
      132, 1, 132, 4316.667, 133, 1, 133, 3083.333, 135, 1, 135, 3391.667,
      137, 1, 137, 4316.667, 140, 1, 140, 3700, 141, 1, 141, 3484.167,
      142, 1, 142, 3700, 143, 1, 143, 2637.464, 146, 1, 146, 1901.389,
      150, 1, 150, 3278.611, 151, 1, 151, 3093.611, 154, 1, 154, 543.5663,
      157, 1, 157, 2980.556, 163, 1, 163, 659.1884, 165, 1, 165, 3700,
      169, 1, 169, 3700, 170, 1, 170, 659.1884, 176, 1, 176, 1850,
      178, 1, 178, 3700, 181, 1, 181, 3391.667, 182, 1, 182, 3350.556,
      184, 1, 184, 4316.667, 186, 1, 186, 4255, 187, 1, 187, 3206.667,
      188, 1, 188, 3391.667, 189, 1, 189, 3782.222, 191, 1, 191, 4316.667,
      192, 1, 192, 4316.667, 194, 1, 194, 4316.667, 195, 1, 195, 3905.556,
      197, 1, 197, 1839.722, 199, 1, 199, 5539.722, 200, 1, 200, 3700,
      202, 1, 202, 1850, 203, 1, 203, 5539.722, 205, 1, 205, 3689.722,
      206, 1, 206, 3700, 209, 1, 209, 3700, 210, 1, 210, 1850, 213,
      1, 213, 1850, 215, 1, 215, 3700, 219, 1, 219, 2960, 221, 1,
      221, 3700, 222, 1, 222, 3391.667, 223, 1, 223, 2960, 227, 1,
      227, 2220, 228, 1, 228, 815.3495, 230, 1, 230, 5539.722, 235,
      2, 235, 382.1974, 237, 1, 237
    )
  )
})

test_that("<b>Table 2.</b> Selection Summary results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(123, "74.06%", 130, 445302.2378)
  )
})
