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
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianWorkflow", "Case2.csv", options)


test_that("<b>Table 7.</b> Corrections to Population results match", {
	table <- results[["results"]][["conclusionContainer"]][["collection"]][["conclusionContainer_tableCorrections"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("17.276%", "No misstatements with 2% precision"))
})

test_that("<b>Table 6.</b> Assumption Checks results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_assumptionTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0.0513247635919807, 0.249333234395933, 68, 0.979839313192907,
			 "Book values - Taints", 0.42904097696463))
})

test_that("<b>Table 5.</b> Evaluation Summary results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("2%", "17.645%", 130, "1.631%", "18.037%", "19.276%", 68))
})

test_that("<b>Table 1.</b> Planning Summary results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("5%", 130, "2%", "0 - 130"))
})

test_that("<b>Table 3.</b> Information about Monetary Interval Selection results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(238, 601293, 122, 130, "71.94%", "Total", 432542.2818, 32, 185700.846,
			 32, 40, "100%", "Top stratum", 185700.846, 206, 415591.212,
			 90, 90, "59.4%", "Bottom stratum", 246841.4358))
})

test_that("<b>Table 4.</b> Raw Sample results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSample"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(5539.722, 1, 1, 82, 5539.722, 2, 1, 205, 5539.722, 3, 1, 67, 1839.722,
			 4, 1, 50, 2678.125, 6, 1, 231, 1377.222, 10, 1, 44, 1223.056,
			 14, 1, 220, 1366.944, 18, 1, 55, 3093.611, 22, 1, 154, 5539.722,
			 23, 1, 66, 5539.722, 26, 1, 76, 610.2966, 27, 1, 173, 931.9159,
			 31, 1, 90, 5539.722, 34, 2, 86, 5539.722, 35, 1, 28, 4316.667,
			 37, 1, 192, 5539.722, 38, 2, 69, 4316.667, 39, 1, 129, 5539.722,
			 40, 1, 71, 560.4174, 42, 1, 162, 4994.073, 43, 1, 27, 3700,
			 45, 1, 202, 3391.667, 46, 1, 39, 2220, 48, 1, 228, 1137.5, 51,
			 1, 7, 4316.667, 53, 1, 195, 7800, 54, 2, 21, 11220, 55, 2, 22,
			 925, 56, 1, 216, 5046.389, 60, 1, 117, 3782.222, 61, 1, 113,
			 1839.722, 63, 1, 105, 5539.722, 64, 1, 26, 3700, 65, 1, 222,
			 5539.722, 66, 1, 235, 5241.667, 69, 1, 101, 3782.222, 70, 1,
			 191, 1839.722, 72, 1, 37, 3278.611, 73, 1, 151, 3782.222, 75,
			 1, 112, 3700, 76, 1, 169, 4141.944, 79, 1, 103, 3905.556, 80,
			 1, 197, 5539.722, 81, 1, 115, 5046.389, 83, 1, 24, 1066.597,
			 85, 1, 225, 5539.722, 88, 2, 93, 3700, 90, 1, 219, 5539.722,
			 91, 1, 94, 5539.722, 93, 1, 72, 1603.333, 94, 1, 48, 4316.667,
			 95, 1, 124, 5539.722, 97, 1, 43, 4306.389, 99, 1, 74, 1921.944,
			 100, 1, 208, 4316.667, 102, 1, 133, 1839.722, 104, 1, 49, 5539.722,
			 105, 1, 91, 3391.667, 106, 1, 156, 3484.167, 108, 1, 142, 4316.667,
			 110, 1, 186, 3103.889, 111, 1, 190, 3700, 114, 1, 143, 1223.056,
			 115, 1, 226, 5539.722, 116, 1, 83, 659.1884, 118, 1, 171, 5539.722,
			 121, 2, 200, 1850, 125, 1, 213, 3278.611, 127, 1, 136, 4950,
			 129, 1, 20, 1377.222, 130, 1, 29, 3689.722, 133, 1, 206, 3391.667,
			 134, 1, 177, 1366.944, 136, 1, 61, 3693.161, 138, 1, 34, 3700,
			 139, 1, 33, 1839.722, 141, 1, 31, 3391.667, 143, 1, 223, 4316.667,
			 147, 1, 140, 1050, 148, 1, 12, 4178.003, 149, 1, 236, 3700,
			 151, 1, 130, 5539.722, 155, 1, 84, 3062.778, 156, 1, 120, 3700,
			 157, 1, 210, 2960, 161, 1, 227, 2775, 163, 1, 148, 931.9159,
			 166, 1, 77, 585.8333, 169, 1, 233, 4563.333, 172, 1, 70, 1887,
			 173, 1, 2, 1901.389, 176, 1, 150, 931.9159, 179, 1, 107, 931.9159,
			 181, 1, 114, 5539.722, 182, 1, 109, 4255, 183, 1, 187, 457.5747,
			 185, 1, 179, 4316.667, 188, 1, 194, 3206.667, 189, 1, 188, 5539.722,
			 190, 1, 106, 1400, 193, 1, 8, 2456.389, 195, 1, 52, 3700, 198,
			 1, 209, 4316.667, 199, 1, 126, 3473.889, 200, 1, 132, 2637.464,
			 203, 1, 146, 4573.611, 204, 1, 35, 931.9159, 206, 1, 68, 1137.5,
			 208, 1, 9, 1839.722, 212, 1, 36, 8449, 213, 2, 1, 5539.722,
			 217, 2, 75, 4316.667, 218, 1, 125, 3700, 221, 1, 89, 931.9159,
			 224, 1, 100, 1850, 227, 1, 203, 3391.667, 229, 1, 137, 3700,
			 231, 1, 78, 5539.722, 233, 1, 88, 3700, 235, 1, 127, 3700, 236,
			 1, 170, 3086, 238, 1, 5))
})

test_that("<b>Table 2.</b> Selection Summary results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("71.94%", 122, 130, 432542.2818))
})