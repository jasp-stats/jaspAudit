context("[Audit] UVB functionality")

# Reproduce results from manual

options <- jaspTools::analysisOptions("auditBayesianWorkflow")
options$bayesian <- TRUE
options$min_precision_test <- TRUE
options$materiality_type <- "relative"
options$materiality_rel_val <- 0.02
options$tableBookDist <- FALSE
options$plotBookDist <- FALSE
options$min_precision_rel_val <- 0.02
options$critical_negative <- TRUE
options$ir <- "high"
options$cr <- "high"
options$conf_level <- 0.95
options$max <- 5000
options$tablePrior <- FALSE
options$plotSampleSizes <- FALSE
options$randomStart <- FALSE
options$plotPrior <- FALSE
options$start <- 1
options$tableTaints <- FALSE
options$plotPriorPredictive <- FALSE
options$tableDescriptives <- FALSE
options$materiality_test <- FALSE
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
options$area <- "two.sided"
options$tableAssumptionsConfidence <- 0.95
options$critical_name <- "Critical"
options$plotPosterior <- FALSE
options$plotPrior <- FALSE
options$plotPosteriorPredictive <- FALSE
options$plotObjectives <- FALSE
options$plotEstimates <- FALSE
options$plotScatter <- FALSE
options$tablePriorPosterior <- FALSE
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
    list(
      "%", "2%", "17.645%", 130, "Value", "1.631%", "18.037%", "19.276%",
      68
    )
  )
})

test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list("5%", 130, "Value", "2%", "0 - 130")
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

test_that("<b>Table 4.</b> Selected Items results match", {
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

# Reproduce test case 1 from Excel

options <- jaspTools::analysisOptions("auditBayesianWorkflow")
options$bayesian <- TRUE
options$min_precision_test <- TRUE
options$materiality_type <- "relative"
options$materiality_rel_val <- 0.02
options$tableBookDist <- FALSE
options$plotBookDist <- FALSE
options$min_precision_rel_val <- 0.02
options$critical_negative <- TRUE
options$ir <- "high"
options$cr <- "high"
options$conf_level <- 0.95
options$max <- 5000
options$tablePrior <- FALSE
options$plotSampleSizes <- FALSE
options$randomStart <- FALSE
options$plotPrior <- FALSE
options$start <- 1
options$tableTaints <- FALSE
options$plotPriorPredictive <- FALSE
options$tableDescriptives <- FALSE
options$materiality_test <- FALSE
options$id <- "ID"
options$values <- "IST"
options$explanatoryText <- FALSE
options$by <- 5
options$separateMisstatement <- TRUE
options$samplingChecked <- TRUE
options$tableSample <- TRUE
options$evaluationChecked <- FALSE
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
options$area <- "two.sided"
options$tableAssumptionsConfidence <- 0.95
options$critical_name <- "Critical"
options$plotPosterior <- FALSE
options$plotPrior <- FALSE
options$plotPosteriorPredictive <- FALSE
options$plotObjectives <- FALSE
options$plotEstimates <- FALSE
options$plotScatter <- FALSE
options$tablePriorPosterior <- FALSE
options$indicator_col <- "selected"
options$variable_col <- "auditResult"
options$annotation <- "continuous"
options$randomize <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianWorkflow", "uvb-testcase1.csv", options)


test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list("5%", 75, "Value", "2%", "0 - 75")
  )
})

test_that("<b>Table 3.</b> Information about Monetary Interval Selection results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      120, 443865.098571, 64, 75, "79.13%", "Total", 351213.1, 23, 206189.14,
      23, 34, "100%", "Top stratum", 206189.14, 97, 237675.958571,
      41, 41, "61.02%", "Bottom stratum", 145023.96
    )
  )
})

test_that("<b>Table 4.</b> Selected Items results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSample"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      3, 17000, 3, 3, 4, 2550, 4, 1, 6, 3825, 6, 1, 7, 11060, 7, 2,
      9, 5250, 9, 1, 12, 3825, 12, 1, 14, 2450, 14, 1, 15, 3825, 15,
      1, 17, 5200, 17, 1, 19, 3060, 19, 1, 21, 15250, 21, 3, 23, 5737.5,
      23, 1, 25, 2550, 25, 1, 27, 3825, 27, 1, 29, 637.5, 29, 1, 33,
      3825, 33, 1, 34, 9000, 34, 2, 36, 4160, 36, 1, 37, 5250, 37,
      1, 39, 3937.5, 39, 1, 41, 30000, 41, 5, 42, 3818, 42, 1, 43,
      6900, 43, 1, 46, 2100, 46, 1, 48, 3150, 48, 1, 50, 3750, 50,
      1, 52, 4254.89, 52, 1, 53, 5366.1, 53, 1, 54, 5625, 54, 1, 57,
      1633.5, 57, 1, 59, 6161.32, 59, 1, 60, 6161.32, 60, 1, 61, 6485.6,
      61, 1, 62, 7782.72, 62, 1, 63, 5188.48, 63, 1, 64, 6485.6, 64,
      1, 65, 8611.54, 65, 2, 70, 1633.5, 70, 1, 72, 6161.32, 72, 1,
      73, 6809.88, 73, 1, 74, 5837.04, 74, 1, 75, 4605.62, 75, 1,
      78, 4864.2, 78, 1, 79, 6485.6, 79, 1, 80, 6485.6, 80, 1, 82,
      815.58, 82, 1, 86, 1633.5, 86, 1, 87, 7134.16, 87, 1, 88, 6391.22,
      88, 1, 89, 5706.36, 89, 1, 90, 7925.5, 90, 1, 91, 1633.5, 91,
      1, 97, 1585.1, 97, 1, 98, 6974.44, 98, 1, 99, 7291.46, 99, 1,
      101, 1633.5, 101, 1, 103, 2821.72, 103, 1, 106, 2821.72, 106,
      1, 107, 6023.38, 107, 1, 108, 7608.48, 108, 1, 109, 3078.24,
      109, 1, 112, 5451.05, 112, 1, 113, 4617.36, 113, 1, 117, 1492.5,
      117, 1
    )
  )
})

test_that("<b>Table 2.</b> Selection Summary results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(64, "79.13%", 75, 351213.1)
  )
})

# Reproduce test case 2 from Excel

options <- analysisOptions("auditBayesianWorkflow")
options$bayesian <- TRUE
options$min_precision_test <- TRUE
options$materiality_type <- "relative"
options$materiality_rel_val <- 0.02
options$tableBookDist <- FALSE
options$plotBookDist <- FALSE
options$min_precision_rel_val <- 0.02
options$critical_negative <- TRUE
options$ir <- "high"
options$cr <- "high"
options$conf_level <- 0.95
options$max <- 5000
options$tablePrior <- FALSE
options$plotSampleSizes <- FALSE
options$randomStart <- FALSE
options$plotPrior <- FALSE
options$start <- 1
options$tableTaints <- FALSE
options$plotPriorPredictive <- FALSE
options$tableDescriptives <- FALSE
options$materiality_test <- FALSE
options$id <- "ID"
options$values <- "IST"
options$explanatoryText <- FALSE
options$by <- 5
options$separateMisstatement <- TRUE
options$samplingChecked <- TRUE
options$tableSample <- TRUE
options$evaluationChecked <- FALSE
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
options$area <- "two.sided"
options$tableAssumptionsConfidence <- 0.95
options$critical_name <- "Critical"
options$plotPosterior <- FALSE
options$plotPrior <- FALSE
options$plotPosteriorPredictive <- FALSE
options$plotObjectives <- FALSE
options$plotEstimates <- FALSE
options$plotScatter <- FALSE
options$tablePriorPosterior <- FALSE
options$indicator_col <- "selected"
options$variable_col <- "auditResult"
options$annotation <- "continuous"
options$randomize <- FALSE
set.seed(1)
results <- runAnalysis("auditBayesianWorkflow", "uvb-testcase2.csv", options)

test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list("5%", 25, "Value", "2%", "0 - 25")
  )
})

test_that("<b>Table 3.</b> Information about Monetary Interval Selection results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      17, 102270.276135, 8, 25, "97.13%", "Total", 99336.784375, 3,
      84030.93125, 3, 20, "100%", "Top stratum", 84030.93125, 14,
      18239.344885, 5, 5, "83.92%", "Bottom stratum", 15305.853125
    )
  )
})

test_that("<b>Table 4.</b> Selected Items results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSample"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      4, 4098.78975, 4, 1, 6, 2972.52, 6, 1, 8, 2979.167, 8, 1, 9, 3176.665125,
      9, 1, 10, 29988.5615, 10, 7, 11, 4047.8275, 11, 1, 13, 2129.6735,
      13, 1, 17, 49943.58, 17, 12
    )
  )
})

test_that("<b>Table 2.</b> Selection Summary results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(8, "97.13%", 25, 99336.784375)
  )
})

# Reproduce test case 3 from Excel

options <- jaspTools::analysisOptions("auditBayesianWorkflow")
options$bayesian <- TRUE
options$min_precision_test <- TRUE
options$materiality_type <- "relative"
options$materiality_rel_val <- 0.02
options$tableBookDist <- FALSE
options$plotBookDist <- FALSE
options$min_precision_rel_val <- 0.02
options$critical_negative <- TRUE
options$ir <- "high"
options$cr <- "high"
options$conf_level <- 0.95
options$max <- 5000
options$tablePrior <- FALSE
options$plotSampleSizes <- FALSE
options$randomStart <- FALSE
options$plotPrior <- FALSE
options$start <- 1
options$tableTaints <- FALSE
options$plotPriorPredictive <- FALSE
options$tableDescriptives <- FALSE
options$materiality_test <- FALSE
options$id <- "TransactionID"
options$values <- "Ist"
options$explanatoryText <- FALSE
options$by <- 15
options$separateMisstatement <- TRUE
options$samplingChecked <- TRUE
options$tableSample <- TRUE
options$evaluationChecked <- FALSE
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
options$area <- "two.sided"
options$tableAssumptionsConfidence <- 0.85
options$critical_name <- "Critical"
options$plotPosterior <- FALSE
options$plotPrior <- FALSE
options$plotPosteriorPredictive <- FALSE
options$plotObjectives <- FALSE
options$plotEstimates <- FALSE
options$plotScatter <- FALSE
options$tablePriorPosterior <- FALSE
options$indicator_col <- "selected"
options$variable_col <- "auditResult"
options$annotation <- "continuous"
options$randomize <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianWorkflow", "uvb-testcase3.csv", options)


test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list("5%", 60, "Value", "2%", "0 - 60")
  )
})

test_that("<b>Table 3.</b> Information about Monetary Interval Selection results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      95, 617839.407382, 51, 60, "81.41%", "Total", 502960.443217, 24,
      347324.50499, 24, 33, "100%", "Top stratum", 347324.50499, 71,
      270514.902392, 27, 27, "57.53%", "Bottom stratum", 155635.938227
    )
  )
})

test_that("<b>Table 4.</b> Selected Items results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSample"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      20172.4425, 5, 2, 5, 12601.5505, 6, 1, 6, 15091.9755, 7, 2, 7,
      3338.566, 10, 1, 10, 3287.361, 13, 1, 13, 19325.698, 15, 2,
      15, 8437.4668, 16, 1, 16, 4283.531, 18, 1, 18, 3487.26, 20,
      1, 20, 3935.8956, 24, 1, 24, 11622.34161, 26, 1, 26, 10279.7695,
      27, 1, 27, 3320.208395, 29, 1, 29, 9563.232, 33, 1, 33, 9563.232,
      34, 1, 34, 7136.913, 36, 1, 36, 6425.2965, 37, 1, 37, 5977.02,
      39, 1, 39, 4041.072, 41, 1, 41, 13031.5395, 43, 1, 43, 13099.46925,
      45, 1, 45, 11661.02438, 46, 2, 46, 12337.9578, 48, 1, 48, 5362.26075,
      49, 1, 49, 15989.2866, 50, 1, 50, 10888.66013, 51, 1, 51, 4003.66575,
      52, 1, 52, 11258.2638, 53, 1, 53, 7291.1265, 55, 1, 55, 3236.38875,
      58, 1, 58, 5769.988875, 60, 1, 60, 11394.80018, 64, 1, 64, 15166.68825,
      66, 2, 66, 14216.28581, 67, 1, 67, 5427.496452, 69, 1, 69, 5424.804,
      71, 1, 71, 10858.74643, 73, 1, 73, 7187.450655, 74, 1, 74, 5799.53815,
      76, 1, 76, 10396.84275, 80, 1, 80, 17110.5165, 81, 2, 81, 4528.2909,
      84, 1, 84, 14406.43365, 85, 1, 85, 17570.763, 86, 2, 86, 9861.5244,
      87, 1, 87, 19404.4872, 88, 2, 88, 21902.40675, 89, 2, 89, 7614.81525,
      91, 1, 91, 14320.2696, 92, 1, 92, 13496.0553, 93, 1, 93, 1051.764,
      94, 1, 94
    )
  )
})

test_that("<b>Table 2.</b> Selection Summary results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(51, "81.41%", 60, 502960.443217)
  )
})

# Reproduce test case 4 from Excel

options <- jaspTools::analysisOptions("auditBayesianWorkflow")
options$bayesian <- TRUE
options$min_precision_test <- TRUE
options$materiality_type <- "relative"
options$materiality_rel_val <- 0.02
options$tableBookDist <- FALSE
options$plotBookDist <- FALSE
options$min_precision_rel_val <- 0.02
options$critical_negative <- TRUE
options$ir <- "high"
options$cr <- "high"
options$conf_level <- 0.95
options$max <- 5000
options$tablePrior <- FALSE
options$plotSampleSizes <- FALSE
options$randomStart <- FALSE
options$plotPrior <- FALSE
options$start <- 1
options$tableTaints <- FALSE
options$plotPriorPredictive <- FALSE
options$tableDescriptives <- FALSE
options$materiality_test <- FALSE
options$id <- "Transaction.ID"
options$values <- "Ist"
options$explanatoryText <- FALSE
options$by <- 5
options$separateMisstatement <- TRUE
options$samplingChecked <- TRUE
options$tableSample <- TRUE
options$evaluationChecked <- FALSE
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
options$area <- "two.sided"
options$tableAssumptionsConfidence <- 0.95
options$critical_name <- "Critical"
options$plotPosterior <- FALSE
options$plotPrior <- FALSE
options$plotPosteriorPredictive <- FALSE
options$plotObjectives <- FALSE
options$plotEstimates <- FALSE
options$plotScatter <- FALSE
options$tablePriorPosterior <- FALSE
options$indicator_col <- "selected"
options$variable_col <- "auditResult"
options$annotation <- "continuous"
options$randomize <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianWorkflow", "uvb-testcase4.csv", options)


test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list("5%", 25, "Value", "2%", "0 - 25")
  )
})

test_that("<b>Table 3.</b> Information about Monetary Interval Selection results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      20, 148905.79, 10, 25, "90.09%", "Total", 134145.85, 3, 107900,
      3, 18, "100%", "Top stratum", 107900, 17, 41005.79, 7, 7, "64.01%",
      "Bottom stratum", 26245.85
    )
  )
})

test_that("<b>Table 4.</b> Selected Items results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSample"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      4600, 1, 1, 1, 77900, 2, 13, 2, 15000, 3, 2, 3, 5838.66, 4, 1,
      4, 3500, 5, 1, 5, 1880.44, 7, 1, 7, 1642.75, 11, 1, 11, 15000,
      14, 3, 14, 3600, 16, 1, 16, 5184, 19, 1, 19
    )
  )
})

test_that("<b>Table 2.</b> Selection Summary results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(10, "90.09%", 25, 134145.85)
  )
})

# Reproduce test case 5 from Excel

options <- jaspTools::analysisOptions("auditBayesianWorkflow")
options$bayesian <- TRUE
options$min_precision_test <- TRUE
options$materiality_type <- "relative"
options$materiality_rel_val <- 0.02
options$tableBookDist <- FALSE
options$plotBookDist <- FALSE
options$min_precision_rel_val <- 0.02
options$critical_negative <- TRUE
options$ir <- "high"
options$cr <- "high"
options$conf_level <- 0.95
options$max <- 5000
options$tablePrior <- FALSE
options$plotSampleSizes <- FALSE
options$randomStart <- FALSE
options$plotPrior <- FALSE
options$start <- 1
options$tableTaints <- FALSE
options$plotPriorPredictive <- FALSE
options$tableDescriptives <- FALSE
options$materiality_test <- FALSE
options$id <- "Transaction.ID"
options$values <- "Ist"
options$explanatoryText <- FALSE
options$by <- 5
options$separateMisstatement <- TRUE
options$samplingChecked <- TRUE
options$tableSample <- TRUE
options$evaluationChecked <- FALSE
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
options$area <- "two.sided"
options$tableAssumptionsConfidence <- 0.95
options$critical_name <- "Critical"
options$plotPosterior <- FALSE
options$plotPrior <- FALSE
options$plotPosteriorPredictive <- FALSE
options$plotObjectives <- FALSE
options$plotEstimates <- FALSE
options$plotScatter <- FALSE
options$tablePriorPosterior <- FALSE
options$indicator_col <- "selected"
options$variable_col <- "auditResult"
options$annotation <- "continuous"
options$randomize <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianWorkflow", "uvb-testcase5.csv", options)


test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list("5%", 45, "Value", "2%", "0 - 45")
  )
})

test_that("<b>Table 3.</b> Information about Monetary Interval Selection results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      38, 157198.31, 23, 45, "84.03%", "Total", 132101.57, 8, 107542.71,
      8, 30, "100%", "Top stratum", 107542.71, 30, 49655.6, 15, 15,
      "49.46%", "Bottom stratum", 24558.86
    )
  )
})

test_that("<b>Table 4.</b> Selected Items results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSample"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      9561.12, 1, 3, 1, 11100.38, 2, 3, 2, 1700.2, 3, 1, 3, 1707.6,
      5, 1, 5, 1694.4, 7, 1, 7, 1627.2, 9, 1, 9, 4260.33, 10, 1, 10,
      1658.04, 12, 1, 12, 1784.4, 14, 1, 14, 1587, 16, 1, 16, 1581.54,
      18, 1, 18, 1503.8, 20, 1, 20, 1609.02, 22, 1, 22, 1479.02, 25,
      1, 25, 1518.2, 27, 1, 27, 1451.54, 29, 1, 29, 1654.4, 31, 1,
      31, 5155, 32, 1, 32, 17413.46, 33, 5, 33, 25257.39, 34, 7, 34,
      24876.93, 35, 7, 35, 9918.1, 36, 3, 36, 2002.5, 37, 1, 37
    )
  )
})

test_that("<b>Table 2.</b> Selection Summary results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(23, "84.03%", 45, 132101.57)
  )
})

# Reproduce test case 6 from Excel

options <- jaspTools::analysisOptions("auditBayesianWorkflow")
options$bayesian <- TRUE
options$min_precision_test <- TRUE
options$materiality_type <- "relative"
options$materiality_rel_val <- 0.02
options$tableBookDist <- FALSE
options$plotBookDist <- FALSE
options$min_precision_rel_val <- 0.02
options$critical_negative <- TRUE
options$ir <- "high"
options$cr <- "high"
options$conf_level <- 0.95
options$max <- 5000
options$tablePrior <- FALSE
options$plotSampleSizes <- FALSE
options$randomStart <- FALSE
options$plotPrior <- FALSE
options$start <- 1
options$tableTaints <- FALSE
options$plotPriorPredictive <- FALSE
options$tableDescriptives <- FALSE
options$materiality_test <- FALSE
options$id <- "Transaction.ID"
options$values <- "Ist"
options$explanatoryText <- FALSE
options$by <- 5
options$separateMisstatement <- TRUE
options$samplingChecked <- TRUE
options$tableSample <- TRUE
options$evaluationChecked <- FALSE
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
options$area <- "two.sided"
options$tableAssumptionsConfidence <- 0.95
options$critical_name <- "Critical"
options$plotPosterior <- FALSE
options$plotPrior <- FALSE
options$plotPosteriorPredictive <- FALSE
options$plotObjectives <- FALSE
options$variables <- list("steek")
options$plotEstimates <- FALSE
options$plotScatter <- FALSE
options$tablePriorPosterior <- FALSE
options$indicator_col <- "selected"
options$variable_col <- "auditResult"
options$annotation <- "continuous"
options$randomize <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianWorkflow", "uvb-testcase6.csv", options)


test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list("5%", 25, "Value", "2%", "0 - 25")
  )
})

test_that("<b>Table 3.</b> Information about Monetary Interval Selection results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      20, 148905.79, 10, 25, "90.09%", "Total", 134145.85, 3, 107900,
      3, 18, "100%", "Top stratum", 107900, 17, 41005.79, 7, 7, "64.01%",
      "Bottom stratum", 26245.85
    )
  )
})

test_that("<b>Table 4.</b> Selected Items results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSample"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      4600, 1, 1, 1, 1, 77900, 2, 13, 13, 2, 15000, 3, 2, 2, 3, 5838.66,
      4, 1, 1, 4, 3500, 5, 1, 1, 5, 1880.44, 7, 1, 1, 7, 1642.75,
      11, 1, 1, 11, 15000, 14, 3, 3, 14, 3600, 16, 1, 1, 16, 5184,
      19, 1, 1, 19
    )
  )
})

test_that("<b>Table 2.</b> Selection Summary results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(10, "90.09%", 25, 134145.85)
  )
})
