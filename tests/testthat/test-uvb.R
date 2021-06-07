context("[Audit] UVB functionality")

options <- jaspTools::analysisOptions("auditBayesianWorkflow")
options$CR <- "High"
options$IR <- "High"
options$areaUnderPosterior <- "displayCredibleBound"
options$auditResult <- "Soll"
options$correctionsTable <- TRUE
options$criticalTransactionTable <- list(list(dataCols = c("Transaction", "Ist"), extraCol = "Critical", 
    filter = "Critical > 0", rowIndices = list(), values = list()))
options$criticalTransactions <- "Critical"
options$display <- "displayPercentages"
options$displaySample <- TRUE
options$estimator <- "betaBound"
options$evaluationAssumptionChecks <- TRUE
options$evaluationChecked <- TRUE
options$expectedErrors <- "expectedAllPossible"
options$flagCriticalTransactions <- TRUE
options$handleCriticalTransactions <- "inspect"
options$materiality <- "materialityRelative"
options$minimumPrecision <- TRUE
options$monetaryVariable <- "Ist"
options$obtainedPrecision <- TRUE
options$performAudit <- list(list(colName = "AuditResult", dataCols = c("Transaction", 
"Ist"), extraCol = "SelectionResult", filter = "SelectionResult > 0 | Critical > 0", 
    rowIndices = c(1, 5, 8, 11, 14, 19, 20, 21, 22, 24, 25, 26, 
    27, 28, 31, 32, 34, 35, 36, 39, 41, 43, 45, 48, 51, 53, 56, 
    59, 62, 65, 66, 67, 69, 70, 71, 72, 73, 74, 75, 76, 78, 79, 
    81, 82, 83, 84, 86, 88, 90, 91, 93, 94, 95, 97, 101, 103, 
    104, 106, 107, 109, 111, 112, 113, 115, 117, 119, 121, 124, 
    125, 126, 127, 129, 130, 132, 133, 135, 137, 140, 141, 142, 
    143, 146, 150, 151, 154, 157, 163, 165, 169, 170, 176, 178, 
    181, 182, 184, 186, 187, 188, 189, 191, 192, 194, 195, 197, 
    199, 200, 202, 203, 205, 206, 209, 210, 213, 215, 219, 221, 
    222, 223, 227, 228, 230, 235, 237), values = c(8449, 3086, 
    1400, 962.5, 1837.5, 2062, 4950, 7800, 11220, 5046.389, 1839.722, 
    5539.722, 4994.073, 5539.722, 1839.722, 3237.5, 3693.161, 
    4573.611, 1839.722, 3391.667, 1839.722, 5539.722, 1366.944, 
    1603.333, 1839.722, 1839.722, 1531.389, 1839.722, 1839.722, 
    1839.722, 5539.722, 5539.722, 5539.722, 4563.333, 5539.722, 
    5539.722, 3196.389, 4306.389, 5539.722, 5539.722, 3700, 2158.333, 
    3782.222, 5539.722, 5539.722, 5539.722, 5539.722, 5539.722, 
    931.9159, 5539.722, 5539.722, 5539.722, 1839.722, 1377.222, 
    5241.667, 4141.944, 1839.722, 5539.722, 931.9159, 5539.722, 
    2590, 3782.222, 3782.222, 5539.722, 5046.389, 1839.722, 1839.722, 
    4316.667, 4316.667, 4316.667, 3700, 4316.667, 3700, 3473.889, 
    4316.667, 3083.333, 3391.667, 4316.667, 3700, 3484.167, 3700, 
    2637.464, 1901.389, 3278.611, 3093.611, 543.5663, 2980.556, 
    659.1884, 3700, 3700, 659.1884, 1850, 3700, 3391.667, 3350.556, 
    4316.667, 4255, 3206.667, 3391.667, 3782.222, 4316.667, 4316.667, 
    4316.667, 3905.556, 1839.722, 5539.722, 3700, 1850, 5539.722, 
    3689.722, 3700, 3700, 1850, 1850, 3700, 2960, 3700, 3391.667, 
    2960, 2220, 815.3495, 5539.722, 382.1974)))
options$planningModel <- "binomial"
options$priorConstructionMethod <- "none"
options$range <- FALSE
options$recordNumberVariable <- "Transaction"
options$sampleFilter <- "SelectionResult"
options$sampleSizeIncrease <- 5
options$samplingChecked <- TRUE
options$selectionMethod <- "systematicSampling"
options$selectionType <- "musSampling"
options$separateKnownAndUnknownMisstatement <- TRUE
options$shadePosterior <- "shadePosteriorCredibleRegion"
options$shadePrior <- "shadePriorCredibleRegion"
options$valuta <- "euroValuta"
options$variableName <- "AuditResult"
options$variableType <- "variableTypeAuditValues"
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianWorkflow", "Case2.csv", options)


test_that("<b>Table 7.</b> Post-Hoc Corrections to Population Value results match", {
	table <- results[["results"]][["conclusionContainer"]][["collection"]][["conclusionContainer_correctionsTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("17.276%", "No misstatements with 2% precision"))
})

test_that("<b>Table 6.</b> Assumption Checks results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_assumptionTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0.0513247635919807, 0.249333234395933, 68, 0.979839313192907,
			 "The population taints are homogeneous", 0.42904097696463))
})

test_that("<b>Table 5.</b> Evaluation Summary results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("19.276%", 68, "2%", "17.645%", "1.631%", 130, "18.037%"))
})

test_that("<b>Table 1.</b> Planning Summary results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("5%", "0 - 130", 130, "2%"))
})

test_that("<b>Table 4.</b> Selected Transactions results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_sampleTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(2, 8449, 1, 1, 1, 3086, 5, 5, 1, 1400, 8, 8, 1, 962.5, 11, 11,
			 1, 1837.5, 14, 14, 1, 2062, 19, 19, 1, 4950, 20, 20, 2, 7800,
			 21, 21, 2, 11220, 22, 22, 1, 5046.389, 24, 24, 1, 1839.722,
			 25, 25, 1, 5539.722, 26, 26, 1, 4994.073, 27, 27, 1, 5539.722,
			 28, 28, 1, 1839.722, 31, 31, 1, 3237.5, 32, 32, 1, 3693.161,
			 34, 34, 1, 4573.611, 35, 35, 1, 1839.722, 36, 36, 1, 3391.667,
			 39, 39, 1, 1839.722, 41, 41, 1, 5539.722, 43, 43, 1, 1366.944,
			 45, 45, 1, 1603.333, 48, 48, 1, 1839.722, 51, 51, 1, 1839.722,
			 53, 53, 1, 1531.389, 56, 56, 1, 1839.722, 59, 59, 1, 1839.722,
			 62, 62, 1, 1839.722, 65, 65, 1, 5539.722, 66, 66, 1, 5539.722,
			 67, 67, 2, 5539.722, 69, 69, 1, 4563.333, 70, 70, 1, 5539.722,
			 71, 71, 1, 5539.722, 72, 72, 1, 3196.389, 73, 73, 1, 4306.389,
			 74, 74, 1, 5539.722, 75, 75, 1, 5539.722, 76, 76, 1, 3700, 78,
			 78, 1, 2158.333, 79, 79, 1, 3782.222, 81, 81, 1, 5539.722, 82,
			 82, 1, 5539.722, 83, 83, 2, 5539.722, 84, 84, 1, 5539.722, 86,
			 86, 2, 5539.722, 88, 88, 1, 931.9159, 90, 90, 1, 5539.722, 91,
			 91, 1, 5539.722, 93, 93, 1, 5539.722, 94, 94, 1, 1839.722, 95,
			 95, 1, 1377.222, 97, 97, 1, 5241.667, 101, 101, 1, 4141.944,
			 103, 103, 1, 1839.722, 104, 104, 1, 5539.722, 106, 106, 1, 931.9159,
			 107, 107, 1, 5539.722, 109, 109, 1, 2590, 111, 111, 1, 3782.222,
			 112, 112, 1, 3782.222, 113, 113, 1, 5539.722, 115, 115, 1, 5046.389,
			 117, 117, 1, 1839.722, 119, 119, 1, 1839.722, 121, 121, 1, 4316.667,
			 124, 124, 1, 4316.667, 125, 125, 1, 4316.667, 126, 126, 1, 3700,
			 127, 127, 1, 4316.667, 129, 129, 1, 3700, 130, 130, 1, 3473.889,
			 132, 132, 1, 4316.667, 133, 133, 1, 3083.333, 135, 135, 1, 3391.667,
			 137, 137, 1, 4316.667, 140, 140, 1, 3700, 141, 141, 1, 3484.167,
			 142, 142, 1, 3700, 143, 143, 1, 2637.464, 146, 146, 1, 1901.389,
			 150, 150, 1, 3278.611, 151, 151, 1, 3093.611, 154, 154, 1, 543.5663,
			 157, 157, 1, 2980.556, 163, 163, 1, 659.1884, 165, 165, 1, 3700,
			 169, 169, 1, 3700, 170, 170, 1, 659.1884, 176, 176, 1, 1850,
			 178, 178, 1, 3700, 181, 181, 1, 3391.667, 182, 182, 1, 3350.556,
			 184, 184, 1, 4316.667, 186, 186, 1, 4255, 187, 187, 1, 3206.667,
			 188, 188, 1, 3391.667, 189, 189, 1, 3782.222, 191, 191, 1, 4316.667,
			 192, 192, 1, 4316.667, 194, 194, 1, 4316.667, 195, 195, 1, 3905.556,
			 197, 197, 1, 1839.722, 199, 199, 1, 5539.722, 200, 200, 1, 3700,
			 202, 202, 1, 1850, 203, 203, 1, 5539.722, 205, 205, 1, 3689.722,
			 206, 206, 1, 3700, 209, 209, 1, 3700, 210, 210, 1, 1850, 213,
			 213, 1, 1850, 215, 215, 1, 3700, 219, 219, 1, 2960, 221, 221,
			 1, 3700, 222, 222, 1, 3391.667, 223, 223, 1, 2960, 227, 227,
			 1, 2220, 228, 228, 1, 815.3495, 230, 230, 2, 5539.722, 235,
			 235, 1, 382.1974, 237, 237))
})

test_that("<b>Table 2.</b> Selection Summary results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_selectionInformationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("<unicode><unicode><unicode> 4625.32", "74.06%", 130, 123, "<unicode><unicode><unicode> 445302.24"
			))
})

test_that("<b>Table 3.</b> Information about Monetary Interval Selection results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_stratumTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(123, "<unicode><unicode><unicode> 445302.24", 238, "Total population",
			 "74.06%", 130, "<unicode><unicode><unicode> 601292.06", 32,
			 "<unicode><unicode><unicode> 185700.85", 32, "Ist value &gt; Interval",
			 "100%", 39, "<unicode><unicode><unicode> 185700.85", 91, "<unicode><unicode><unicode> 259601.39",
			 206, "Ist value &lt; Interval", "62.47%", 91, "<unicode><unicode><unicode> 415591.21"
			))
})