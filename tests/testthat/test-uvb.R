context("[Audit] UVB functionality")

# Reproduce results from manual

options <- jaspTools::analysisOptions("auditBayesianWorkflow")
options$bayesian <- TRUE
options$rank <- ""
options$min_precision_test <- TRUE
options$materiality_rel_val <- 0.02
options$tableBookDist <- FALSE
options$plotBookDist <- FALSE
options$min_precision_rel_val <- 0.02
options$critical_negative <- TRUE
options$ir <- "high"
options$cr <- "high"
options$car <- "high"
options$conf_level <- 0.95
options$max <- 5000
options$tablePrior <- FALSE
options$plotSampleSizes <- FALSE
options$startMethod <- "fixedStart"
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
options$tableSampleSort <- FALSE
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
options$workflow <- TRUE
options$overallMateriality <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianWorkflow", "Case2.csv", options)


test_that("<b>Table 7.</b> Corrections to Population results match", {
  table <- results[["results"]][["conclusionContainer"]][["collection"]][["conclusionContainer_tableCorrections"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(0.172763886786691, "No misstatements with 2% precision")
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
      0, 0.02, 0.176454604800287, 130, "Value", 0.0163092819864046,
      0.180372217416923, 0.192763886786691, 68
    )
  )
})

test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(0.05, 130, "Value", 0.02, "0 - 130")
  )
})

test_that("<b>Table 3.</b> Information about Monetary Interval Selection results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      238, 601292.058, 125, 130, 0.735596730432784, "Total", 442308.4719, 32,
      185700.846, 32, 37, 1, "Top stratum", 185700.846, 206, 415591.212, 93, 93,
      0.617452002089014, "Bottom stratum", 256607.6259
    )
  )
})

test_that("<b>Table 4.</b> Selected Items results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSample"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      8449, 1, 1, 1, 1887, 2, 1, 2, 3086, 5, 1, 5, 1400, 8, 1, 8, 1050, 12, 1,
      12, 1575, 15, 1, 15, 2062, 19, 1, 19, 4950, 20, 1, 20, 7800, 21, 2, 21,
      11220, 22, 2, 22, 5046.389, 24, 1, 24, 1839.722, 25, 1, 25, 5539.722, 26,
      1, 26, 4994.073, 27, 1, 27, 5539.722, 28, 1, 28, 1839.722, 31, 1, 31,
      3700, 33, 1, 33, 3693.161, 34, 1, 34, 4573.611, 35, 1, 35, 1839.722, 37,
      1, 37, 3391.667, 39, 1, 39, 931.9159, 42, 1, 42, 5539.722, 43, 1, 43,
      1654.722, 46, 1, 46, 1603.333, 48, 1, 48, 1839.722, 51, 1, 51, 1839.722,
      53, 1, 53, 1531.389, 56, 1, 56, 1839.722, 59, 1, 59, 1839.722, 62, 1, 62,
      1839.722, 65, 1, 65, 5539.722, 66, 1, 66, 5539.722, 67, 1, 67, 5539.722,
      69, 2, 69, 4563.333, 70, 1, 70, 5539.722, 71, 1, 71, 5539.722, 72, 1, 72,
      3196.389, 73, 1, 73, 4306.389, 74, 1, 74, 5539.722, 75, 1, 75, 5539.722,
      76, 1, 76, 3700, 78, 1, 78, 3327.531, 80, 1, 80, 3782.222, 81, 1, 81,
      5539.722, 82, 1, 82, 5539.722, 83, 1, 83, 5539.722, 84, 2, 84, 5539.722,
      86, 1, 86, 5539.722, 88, 2, 88, 931.9159, 90, 1, 90, 5539.722, 91, 1, 91,
      5539.722, 93, 1, 93, 5539.722, 94, 1, 94, 1839.722, 95, 1, 95, 754.1249,
      98, 1, 98, 5241.667, 101, 1, 101, 4141.944, 103, 1, 103, 1839.722, 104, 1,
      104, 5539.722, 106, 1, 106, 931.9159, 108, 1, 108, 5539.722, 109, 1, 109,
      2590, 111, 1, 111, 3782.222, 112, 1, 112, 931.9159, 114, 1, 114, 5539.722,
      115, 1, 115, 5046.389, 117, 1, 117, 1839.722, 119, 1, 119, 1839.722, 121,
      1, 121, 4316.667, 124, 1, 124, 4316.667, 125, 1, 125, 4316.667, 126, 1,
      126, 3700, 127, 1, 127, 4316.667, 129, 1, 129, 3700, 130, 1, 130,
      3473.889, 132, 1, 132, 4316.667, 133, 1, 133, 3083.333, 135, 1, 135,
      3391.667, 137, 1, 137, 4316.667, 140, 1, 140, 3700, 141, 1, 141, 3484.167,
      142, 1, 142, 3700, 143, 1, 143, 659.1884, 147, 1, 147, 1901.389, 150, 1,
      150, 659.1884, 152, 1, 152, 543.5663, 155, 1, 155, 543.5663, 158, 1, 158,
      2980.556, 163, 1, 163, 659.1884, 165, 1, 165, 3700, 169, 1, 169, 659.1884,
      171, 1, 171, 3391.667, 177, 1, 177, 1850, 178, 1, 178, 3700, 181, 1, 181,
      3391.667, 182, 1, 182, 3350.556, 184, 1, 184, 4316.667, 186, 1, 186, 4255,
      187, 1, 187, 3206.667, 188, 1, 188, 3103.889, 190, 1, 190, 3782.222, 191,
      1, 191, 4316.667, 192, 1, 192, 4316.667, 194, 1, 194, 4316.667, 195, 1,
      195, 3905.556, 197, 1, 197, 1839.722, 199, 1, 199, 5539.722, 200, 1, 200,
      3700, 202, 1, 202, 602.0527, 204, 1, 204, 5539.722, 205, 1, 205, 3689.722,
      206, 1, 206, 3700, 209, 1, 209, 3700, 210, 1, 210, 1850, 213, 1, 213, 925,
      216, 1, 216, 3700, 219, 1, 219, 2960, 221, 1, 221, 3700, 222, 1, 222,
      3391.667, 223, 1, 223, 2960, 227, 1, 227, 3700, 229, 1, 229, 2678.125,
      231, 1, 231, 5539.722, 235, 1, 235, 4178.003, 236, 1, 236, 534.1875, 238,
      1, 238
    )
  )
})

test_that("<b>Table 2.</b> Selection Summary results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      125, 0.735596730432784, 130, 442308.4719
    )
  )
})

# Reproduce test case 1 from Excel

options <- jaspTools::analysisOptions("auditBayesianWorkflow")
options$bayesian <- TRUE
options$rank <- ""
options$min_precision_test <- TRUE
options$materiality_rel_val <- 0.02
options$tableBookDist <- FALSE
options$plotBookDist <- FALSE
options$min_precision_rel_val <- 0.02
options$critical_negative <- TRUE
options$ir <- "high"
options$cr <- "high"
options$car <- "high"
options$conf_level <- 0.95
options$max <- 5000
options$tablePrior <- FALSE
options$plotSampleSizes <- FALSE
options$startMethod <- "fixedStart"
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
options$tableSampleSort <- FALSE
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
options$workflow <- TRUE
options$overallMateriality <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianWorkflow", "uvb-testcase1.csv", options)


test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      0.05, 85, "Value", 0.02, "0 - 85"
    )
  )
})

test_that("<b>Table 3.</b> Information about Monetary Interval Selection results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      120, 443865.098571, 66, 85, 0.820561314110036, "Total", 364218.528571, 31,
      250412.19, 31, 50, 1, "Top stratum", 250412.19, 89, 193452.908571, 35, 35,
      0.588289622583945, "Bottom stratum", 113806.338571
    )
  )
})

test_that("<b>Table 4.</b> Selected Items results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSample"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      3, 17000, 3, 4, 5, 2868.75, 5, 1, 6, 3825, 6, 1, 7, 11060, 7, 2, 9, 5250,
      9, 1, 11, 3825, 11, 1, 12, 3825, 12, 1, 15, 3825, 15, 1, 16, 2868.75, 16,
      1, 17, 5200, 17, 1, 19, 3060, 19, 1, 21, 15250, 21, 3, 23, 5737.5, 23, 1,
      24, 2550, 24, 1, 26, 3825, 26, 1, 27, 3825, 27, 1, 30, 2550, 30, 1, 33,
      3825, 33, 1, 34, 9000, 34, 2, 36, 4160, 36, 1, 37, 5250, 37, 1, 38,
      4371.428571, 38, 1, 39, 3937.5, 39, 1, 41, 30000, 41, 6, 42, 3818, 42, 1,
      43, 6900, 43, 1, 47, 3750, 47, 1, 48, 3150, 48, 1, 50, 3750, 50, 1, 52,
      4254.89, 52, 1, 53, 5366.1, 53, 1, 54, 5625, 54, 1, 55, 1766.47, 55, 1,
      59, 6161.32, 59, 2, 60, 6161.32, 60, 1, 61, 6485.6, 61, 1, 62, 7782.72,
      62, 1, 63, 5188.48, 63, 1, 64, 6485.6, 64, 2, 65, 8611.54, 65, 1, 66,
      1295.34, 66, 1, 72, 6161.32, 72, 2, 73, 6809.88, 73, 1, 74, 5837.04, 74,
      1, 75, 4605.62, 75, 1, 77, 1633.5, 77, 1, 79, 6485.6, 79, 2, 80, 6485.6,
      80, 1, 83, 1942.99, 83, 1, 86, 1633.5, 86, 1, 87, 7134.16, 87, 1, 88,
      6391.22, 88, 1, 89, 5706.36, 89, 1, 90, 7925.5, 90, 2, 93, 1703.11, 93, 1,
      98, 6974.44, 98, 2, 99, 7291.46, 99, 1, 100, 2756, 100, 1, 103, 2821.72,
      103, 1, 105, 2308.68, 105, 1, 107, 6023.38, 107, 1, 108, 7608.48, 108, 2,
      110, 1633.5, 110, 1, 112, 5451.05, 112, 1, 113, 4617.36, 113, 1, 116,
      2835.75, 116, 1
    )
  )
})

test_that("<b>Table 2.</b> Selection Summary results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      66, 0.820561314110035, 85, 364218.528571
    )
  )
})

# Reproduce test case 2 from Excel

options <- analysisOptions("auditBayesianWorkflow")
options$bayesian <- TRUE
options$rank <- ""
options$min_precision_test <- TRUE
options$materiality_rel_val <- 0.02
options$tableBookDist <- FALSE
options$plotBookDist <- FALSE
options$min_precision_rel_val <- 0.02
options$critical_negative <- TRUE
options$ir <- "high"
options$cr <- "high"
options$car <- "high"
options$conf_level <- 0.95
options$max <- 5000
options$tablePrior <- FALSE
options$plotSampleSizes <- FALSE
options$startMethod <- "fixedStart"
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
options$tableSampleSort <- FALSE
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
options$workflow <- TRUE
options$overallMateriality <- FALSE
set.seed(1)
results <- runAnalysis("auditBayesianWorkflow", "uvb-testcase2.csv", options)

test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      0.05, 20, "Value", 0.02, "0 - 20"
    )
  )
})

test_that("<b>Table 3.</b> Information about Monetary Interval Selection results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      17, 102270.276135, 6, 20, 0.921361977654349, "Total", 94227.943875, 2,
      79932.1415, 2, 16, 1, "Top stratum", 79932.1415, 15, 22338.134635, 4, 4,
      0.639972970375107, "Bottom stratum", 14295.802375
    )
  )
})

test_that("<b>Table 4.</b> Selected Items results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSample"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      4, 4098.78975, 4, 1, 6, 2972.52, 6, 1, 9, 3176.665125, 9, 1, 10,
      29988.5615, 10, 6, 11, 4047.8275, 11, 1, 17, 49943.58, 17, 10
    )
  )
})

test_that("<b>Table 2.</b> Selection Summary results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      6, 0.921361977654349, 20, 94227.943875
    )
  )
})

# Reproduce test case 3 from Excel

options <- jaspTools::analysisOptions("auditBayesianWorkflow")
options$bayesian <- TRUE
options$rank <- ""
options$min_precision_test <- TRUE
options$materiality_rel_val <- 0.02
options$tableBookDist <- FALSE
options$plotBookDist <- FALSE
options$min_precision_rel_val <- 0.02
options$critical_negative <- TRUE
options$ir <- "high"
options$cr <- "high"
options$car <- "high"
options$conf_level <- 0.95
options$max <- 5000
options$tablePrior <- FALSE
options$plotSampleSizes <- FALSE
options$startMethod <- "fixedStart"
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
options$tableSampleSort <- FALSE
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
options$workflow <- TRUE
options$overallMateriality <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianWorkflow", "uvb-testcase3.csv", options)


test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(0.05, 60, "Value", 0.02, "0 - 60")
  )
})

test_that("<b>Table 3.</b> Information about Monetary Interval Selection results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      95, 617839.407382, 51, 60, 0.812839125077847, "Total", 502204.043335, 24,
      347324.50499, 24, 33, 1, "Top stratum", 347324.50499, 71, 270514.902392,
      27, 27, 0.572536067238787, "Bottom stratum", 154879.538345
    )
  )
})

test_that("<b>Table 4.</b> Selected Items results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSample"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      20172.4425, 5, 2, 5, 12601.5505, 6, 2, 6, 15091.9755, 7, 1, 7, 2091.957,
      9, 1, 9, 2061.6596, 12, 1, 12, 19325.698, 15, 2, 15, 8437.4668, 16, 1, 16,
      7670.509, 17, 1, 17, 6375.488, 19, 1, 19, 1686.8124, 23, 1, 23,
      11622.34161, 26, 1, 26, 10279.7695, 27, 1, 27, 3320.208395, 29, 1, 29,
      9563.232, 33, 1, 33, 9563.232, 34, 1, 34, 7136.913, 36, 1, 36, 6425.2965,
      37, 1, 37, 5977.02, 39, 1, 39, 4041.072, 41, 1, 41, 13031.5395, 43, 1, 43,
      13099.46925, 45, 2, 45, 11661.02438, 46, 1, 46, 12337.9578, 48, 1, 48,
      5362.26075, 49, 1, 49, 15989.2866, 50, 1, 50, 10888.66013, 51, 1, 51,
      4003.66575, 52, 1, 52, 11258.2638, 53, 1, 53, 7291.1265, 55, 1, 55,
      3236.38875, 58, 1, 58, 5769.988875, 60, 1, 60, 11394.80018, 64, 1, 64,
      2890.853665, 65, 1, 65, 15166.68825, 66, 1, 66, 14216.28581, 67, 1, 67,
      1417.78, 68, 1, 68, 5424.804, 71, 1, 71, 10858.74643, 73, 1, 73,
      7187.450655, 74, 1, 74, 5321.042055, 75, 1, 75, 10396.84275, 80, 1, 80,
      17110.5165, 81, 2, 81, 4867.2015, 83, 1, 83, 14406.43365, 85, 1, 85,
      17570.763, 86, 2, 86, 9861.5244, 87, 1, 87, 19404.4872, 88, 2, 88,
      21902.40675, 89, 2, 89, 7614.81525, 91, 1, 91, 14320.2696, 92, 1, 92,
      13496.0553, 93, 2, 93
    )
  )
})

test_that("<b>Table 2.</b> Selection Summary results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      51, 0.812839125077847, 60, 502204.043335
    )
  )
})

# Reproduce test case 4 from Excel

options <- jaspTools::analysisOptions("auditBayesianWorkflow")
options$bayesian <- TRUE
options$rank <- ""
options$min_precision_test <- TRUE
options$materiality_rel_val <- 0.02
options$tableBookDist <- FALSE
options$plotBookDist <- FALSE
options$min_precision_rel_val <- 0.02
options$critical_negative <- TRUE
options$ir <- "high"
options$cr <- "high"
options$car <- "high"
options$conf_level <- 0.95
options$max <- 5000
options$tablePrior <- FALSE
options$plotSampleSizes <- FALSE
options$startMethod <- "fixedStart"
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
options$tableSampleSort <- FALSE
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
options$workflow <- TRUE
options$overallMateriality <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianWorkflow", "uvb-testcase4.csv", options)


test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(0.05, 25, "Value", 0.02, "0 - 25")
  )
})

test_that("<b>Table 3.</b> Information about Monetary Interval Selection results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      20, 148905.79, 10, 25, 0.884572990748043, "Total", 131718.04, 3, 107900,
      3, 18, 1, "Top stratum", 107900, 17, 41005.79, 7, 7, 0.580845778120602,
      "Bottom stratum", 23818.04
    )
  )
})

test_that("<b>Table 4.</b> Selected Items results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSample"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      4600, 1, 1, 1, 77900, 2, 13, 2, 15000, 3, 3, 3, 5838.66, 4, 1, 4, 1880.44,
      7, 1, 7, 1642.75, 11, 1, 11, 1072.19, 13, 1, 13, 15000, 14, 2, 14, 3600,
      16, 1, 16, 5184, 19, 1, 19
    )
  )
})

test_that("<b>Table 2.</b> Selection Summary results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      10, 0.884572990748043, 25, 131718.04
    )
  )
})

# Reproduce test case 5 from Excel

options <- jaspTools::analysisOptions("auditBayesianWorkflow")
options$bayesian <- TRUE
options$rank <- ""
options$min_precision_test <- TRUE
options$materiality_rel_val <- 0.02
options$tableBookDist <- FALSE
options$plotBookDist <- FALSE
options$min_precision_rel_val <- 0.02
options$critical_negative <- TRUE
options$ir <- "high"
options$cr <- "high"
options$car <- "high"
options$conf_level <- 0.95
options$max <- 5000
options$tablePrior <- FALSE
options$plotSampleSizes <- FALSE
options$startMethod <- "fixedStart"
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
options$tableSampleSort <- FALSE
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
options$workflow <- TRUE
options$overallMateriality <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianWorkflow", "uvb-testcase5.csv", options)


test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      0.05, 50, "Value", 0.02, "0 - 50"
    )
  )
})

test_that("<b>Table 3.</b> Information about Monetary Interval Selection results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      38, 157198.31, 24, 50, 0.852383273077173, "Total", 133993.21, 8,
      107542.71, 8, 34, 1, "Top stratum", 107542.71, 30, 49655.6, 16, 16,
      0.532679093596694, "Bottom stratum", 26450.5
    )
  )
})

test_that("<b>Table 4.</b> Selected Items results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSample"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      9561.12, 1, 3, 1, 11100.38, 2, 3, 2, 1700.2, 3, 1, 3, 1581.54, 4, 1, 4,
      1587, 6, 1, 6, 1633.8, 8, 1, 8, 4260.33, 10, 1, 10, 1587, 11, 1, 11,
      1658.04, 12, 1, 12, 1784.4, 14, 1, 14, 1587, 16, 1, 16, 1581.54, 18, 1,
      18, 1503.8, 20, 1, 20, 1609.02, 22, 1, 22, 1596.72, 24, 1, 24, 1672.2, 26,
      1, 26, 1488.4, 28, 1, 28, 1478.84, 30, 1, 30, 5155, 32, 2, 32, 17413.46,
      33, 5, 33, 25257.39, 34, 8, 34, 24876.93, 35, 8, 35, 9918.1, 36, 4, 36,
      2401, 38, 1, 38
    )
  )
})

test_that("<b>Table 2.</b> Selection Summary results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      24, 0.852383273077173, 50, 133993.21
    )
  )
})

# Reproduce test case 6 from Excel

options <- jaspTools::analysisOptions("auditBayesianWorkflow")
options$bayesian <- TRUE
options$rank <- ""
options$min_precision_test <- TRUE
options$materiality_rel_val <- 0.02
options$tableBookDist <- FALSE
options$plotBookDist <- FALSE
options$min_precision_rel_val <- 0.02
options$critical_negative <- TRUE
options$ir <- "high"
options$cr <- "high"
options$car <- "high"
options$conf_level <- 0.95
options$max <- 5000
options$tablePrior <- FALSE
options$plotSampleSizes <- FALSE
options$startMethod <- "fixedStart"
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
options$tableSampleSort <- FALSE
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
options$workflow <- TRUE
options$overallMateriality <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianWorkflow", "uvb-testcase6.csv", options)


test_that("<b>Table 1.</b> Planning Summary results match", {
  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(0.05, 25, "Value", 0.02, "0 - 25")
  )
})

test_that("<b>Table 3.</b> Information about Monetary Interval Selection results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      20, 148905.79, 10, 25, 0.884572990748043, "Total", 131718.04, 3, 107900,
      3, 18, 1, "Top stratum", 107900, 17, 41005.79, 7, 7, 0.580845778120602,
      "Bottom stratum", 23818.04
    )
  )
})

test_that("<b>Table 4.</b> Selected Items results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSample"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      4600, 1, 1, 1, 1, 77900, 2, 13, 2, 13, 15000, 3, 3, 3, 2, 5838.66, 4, 1,
      4, 1, 1880.44, 7, 1, 7, 1, 1642.75, 11, 1, 11, 1, 1072.19, 13, 1, 13, 0,
      15000, 14, 2, 14, 3, 3600, 16, 1, 16, 1, 5184, 19, 1, 19, 1
    )
  )
})

test_that("<b>Table 2.</b> Selection Summary results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      10, 0.884572990748043, 25, 131718.04
    )
  )
})
