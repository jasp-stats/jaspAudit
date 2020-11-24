context("[Audit] Classical Workflow")

options <- analysisOptions("auditClassicalWorkflow")
options$performanceMateriality <- TRUE
options$materialityValue <- 70161
options$recordNumberVariable <- "ID"
options$monetaryVariable <- "bookValue"
options$expectedPercentage <- 0.025
options$bookValueDescriptives <- TRUE
options$bookValueDistribution <- TRUE
options$decisionPlot <- TRUE
options$samplingDistribution <- TRUE
options$samplingChecked <- TRUE
options$displaySample <- TRUE
options$sampleDescriptives <- TRUE
options$range <- FALSE
options$evaluationChecked <- TRUE
options$auditResult <- "auditValue"
options$evaluationInformation <- TRUE
options$priorConstructionMethod <- "arm"
options$materiality <- "materialityAbsolute"
options$handleCriticalTransactions <- "inspect"
options$IR <- "High"
options$CR <- "High"
options$expectedErrors <- "expectedRelative"
options$planningModel <- "Poisson"
options$valuta <- "dollarValuta"
options$selectionType <- "musSampling"
options$selectionMethod <- "systematicSampling"
options$variableType <- "variableTypeAuditValues"
options$estimator <- "stringerBound"
options$display <- "displayPercentages"
options$.meta <- list(additionalVariables = list(containsColumn = TRUE), auditResult = list(
    containsColumn = TRUE), monetaryVariable = list(containsColumn = TRUE), 
    performAudit = list(list(dataCols = list(containsColumn = TRUE), 
        extraCol = list(containsColumn = TRUE))), rankingVariable = list(
        containsColumn = TRUE), recordNumberVariable = list(containsColumn = TRUE), 
    sampleFilter = list(containsColumn = TRUE), variableName = list(
        containsColumn = TRUE))
options$criticalTransactions <- "Critical"
options$sampleFilter <- "SelectionResult"
options$variableName <- "AuditResult"
set.seed(1)
results <- runAnalysis("auditClassicalWorkflow", "test-workflow.csv", options)


test_that("Evaluation of Sampling Objectives plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationInformation"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives", dir="auditClassicalWorkflow")
})

test_that("<b>Table 7.</b> Evaluation Summary results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("1.288%", 0, "5%", "0%", 231, "0%"))
})

test_that("Across Probability Distributions (Current: Poisson) plot matches", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonDistributions"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "across-probability-distributions-current-poisson-", dir="auditClassicalWorkflow")
})

test_that("Across Expected Errors (Current: 5.78) plot matches", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonErrors"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "across-expected-errors-current-5-78-", dir="auditClassicalWorkflow")
})

test_that("Implied Poisson Distribution of Errors plot matches", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_samplingDistribution"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "implied-poisson-distribution-of-errors", dir="auditClassicalWorkflow")
})

test_that("<b>Table 2.</b> Planning Summary results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("100%", "5%", "100%", 5.78, "$ 70161", 231))
})

test_that("<b>Table 1.</b> Descriptive Statistics for Ist Position results match", {
	table <- results[["results"]][["procedureContainer"]][["collection"]][["procedureContainer_bookValueDescriptives"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(3500, "$ 1403220.82", "$ 400.92", "$ 254.38", "$ 364.11", "$ 513.26",
			 "$ 200.78", "$ 1403220.82"))
})

test_that("Distribution of Ist Values plot matches", {
	plotName <- results[["results"]][["procedureContainer"]][["collection"]][["procedureContainer_bookValueDistribution"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "distribution-of-ist-values", dir="auditClassicalWorkflow")
})

test_that("<b>Table 5.</b> Descriptive Statistics for Selected Transactions results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_sampleDescriptivesTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(498.228398268398, 468.1, 244.090089823475, 231, "bookValue"))
})

test_that("<b>Table 6.</b> Selected Transactions results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_sampleTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(1, 13, 1, 242.61, 1, 217, 15, 469.93, 1, 701, 32, 319.9, 1, 1369,
			 49, 490.93, 1, 1756, 65, 509.36, 1, 2169, 78, 151.91, 1, 2651,
			 92, 355.16, 1, 3508, 112, 339.44, 1, 4034, 128, 734.93, 1, 4354,
			 141, 568.6, 1, 4838, 158, 430.78, 1, 5219, 173, 112.07, 1, 5732,
			 189, 393.06, 1, 6152, 206, 528.79, 1, 6481, 220, 428.45, 1,
			 7018, 235, 340.6, 1, 7398, 249, 327.73, 1, 7714, 264, 500.51,
			 1, 8068, 280, 462.58, 1, 8487, 297, 634.05, 1, 8983, 312, 329.69,
			 1, 9542, 329, 645.87, 1, 9940, 344, 536.77, 1, 10332, 357, 880.81,
			 1, 10895, 372, 597.44, 1, 11143, 386, 1425.79, 1, 11563, 400,
			 497.5, 1, 11978, 419, 630.86, 1, 12319, 436, 478.83, 1, 12604,
			 449, 879.91, 1, 12877, 461, 690.06, 1, 13316, 474, 414.99, 1,
			 13735, 491, 301.26, 1, 14093, 506, 846.85, 1, 14649, 524, 580.69,
			 1, 14979, 542, 347.38, 1, 15626, 557, 219.45, 1, 16148, 575,
			 606.48, 1, 16442, 587, 759.15, 1, 16970, 603, 536.63, 1, 17547,
			 620, 268.9, 1, 18123, 634, 244.31, 1, 18662, 647, 388.45, 1,
			 19085, 664, 354.77, 1, 19732, 681, 300.11, 1, 20189, 698, 384.1,
			 1, 20537, 711, 832.79, 1, 21032, 728, 328.56, 1, 21503, 744,
			 450.87, 1, 21935, 760, 577.92, 1, 22651, 778, 291.58, 1, 23308,
			 797, 858.29, 1, 23795, 814, 381.27, 1, 24188, 827, 381.48, 1,
			 24427, 843, 415.47, 1, 25063, 860, 785.95, 1, 25529, 878, 325.65,
			 1, 25900, 893, 1171.55, 1, 26155, 908, 802.25, 1, 26525, 922,
			 672.47, 1, 27129, 939, 684.79, 1, 27340, 953, 337.06, 1, 27769,
			 969, 320.19, 1, 27921, 981, 235.45, 1, 28508, 999, 553.65, 1,
			 29045, 1017, 618.24, 1, 29396, 1035, 163.46, 1, 30188, 1050,
			 796.94, 1, 30593, 1066, 363.79, 1, 30774, 1076, 489.4, 1, 31315,
			 1090, 650.75, 1, 31839, 1104, 527.82, 1, 32339, 1119, 610.25,
			 1, 32760, 1136, 642.84, 1, 33331, 1152, 766.24, 1, 33776, 1163,
			 402.29, 1, 34382, 1179, 719.44, 1, 34926, 1192, 603.58, 1, 35369,
			 1207, 491.74, 1, 35768, 1224, 290.06, 1, 36214, 1237, 891.39,
			 1, 36587, 1250, 419.85, 1, 37042, 1267, 351.53, 1, 37508, 1284,
			 742.4, 1, 37961, 1297, 471.04, 1, 38316, 1311, 398.96, 1, 38576,
			 1324, 200.7, 1, 38946, 1342, 688.71, 1, 39391, 1356, 518.82,
			 1, 39672, 1369, 278.62, 1, 40066, 1382, 524.91, 1, 40708, 1399,
			 253.31, 1, 41278, 1415, 356.03, 1, 41679, 1429, 329.49, 1, 42100,
			 1444, 163.6, 1, 42567, 1459, 537.18, 1, 42859, 1475, 726.26,
			 1, 43352, 1491, 591.02, 1, 43681, 1503, 498.97, 1, 44016, 1515,
			 753.11, 1, 44286, 1528, 240.01, 1, 44804, 1541, 340.02, 1, 45342,
			 1557, 666.61, 1, 45828, 1574, 622.61, 1, 46224, 1591, 632.11,
			 1, 46711, 1605, 360.13, 1, 47306, 1622, 480.79, 1, 47728, 1639,
			 307.54, 1, 48046, 1657, 551, 1, 48532, 1673, 646.61, 1, 49120,
			 1689, 329.11, 1, 49578, 1704, 427.71, 1, 49910, 1721, 829.17,
			 1, 50338, 1735, 620.45, 1, 50755, 1749, 359.42, 1, 51100, 1764,
			 365.65, 1, 51733, 1783, 682.41, 1, 52103, 1796, 587.46, 1, 52300,
			 1811, 516.94, 1, 52619, 1822, 484.13, 1, 53133, 1837, 116.68,
			 1, 53480, 1853, 312.87, 1, 53945, 1871, 468.1, 1, 54401, 1885,
			 474.71, 1, 54895, 1903, 363.44, 1, 55292, 1915, 533.44, 1, 55575,
			 1928, 592.51, 1, 56077, 1941, 526.21, 1, 56532, 1955, 512.69,
			 1, 56912, 1971, 377.46, 1, 57174, 1987, 425.57, 1, 57542, 2001,
			 711.79, 1, 57870, 2014, 331.87, 1, 58475, 2028, 529.97, 1, 58850,
			 2041, 381.64, 1, 59274, 2056, 389.09, 1, 59734, 2070, 357.5,
			 1, 60224, 2085, 392.71, 1, 60604, 2096, 876.04, 1, 60863, 2108,
			 821.93, 1, 61088, 2120, 821.17, 1, 61629, 2136, 560.45, 1, 61977,
			 2148, 341.1, 1, 62691, 2166, 511.7, 1, 63176, 2178, 839.21,
			 1, 63497, 2191, 304.8, 1, 63954, 2208, 963.53, 1, 64344, 2225,
			 481.16, 1, 64683, 2241, 459.71, 1, 65236, 2257, 553.69, 1, 65768,
			 2272, 593.5, 1, 66156, 2287, 364.88, 1, 66666, 2300, 349.99,
			 1, 67078, 2314, 306.91, 1, 67488, 2330, 220.59, 1, 67886, 2345,
			 243.26, 1, 68187, 2355, 514.31, 1, 68583, 2369, 911.21, 1, 69011,
			 2384, 247.62, 1, 69379, 2396, 847.81, 1, 70010, 2411, 583.79,
			 1, 70378, 2424, 454.5, 1, 70991, 2439, 321.86, 1, 71325, 2455,
			 467.72, 1, 71607, 2469, 420.54, 1, 71864, 2484, 132.9, 1, 72235,
			 2500, 431.96, 1, 72585, 2517, 281.38, 1, 72963, 2531, 455.5,
			 1, 73731, 2548, 509.94, 1, 74227, 2562, 599.29, 1, 74725, 2575,
			 378.66, 1, 75034, 2588, 874.85, 1, 75329, 2601, 646.36, 1, 75648,
			 2613, 207.04, 1, 76131, 2627, 312.41, 1, 76571, 2643, 632.34,
			 1, 76950, 2660, 454.81, 1, 77480, 2683, 561.68, 1, 77782, 2698,
			 507.18, 1, 78144, 2717, 725.78, 1, 78666, 2731, 848.72, 1, 78972,
			 2746, 491.6, 1, 79252, 2761, 423.66, 1, 79638, 2774, 367.43,
			 1, 80079, 2790, 404.98, 1, 80465, 2807, 262.94, 1, 80910, 2822,
			 255.6, 1, 81268, 2838, 227.04, 1, 81641, 2854, 626.21, 1, 82071,
			 2869, 124.27, 1, 82536, 2886, 236.3, 1, 82826, 2906, 401.02,
			 1, 83189, 2924, 791.64, 1, 83557, 2940, 392.01, 1, 84305, 2959,
			 374.39, 1, 84686, 2975, 521.33, 1, 85195, 2990, 360.94, 1, 85522,
			 3006, 406.14, 1, 85834, 3018, 863.27, 1, 86118, 3033, 623.56,
			 1, 86540, 3047, 1262.85, 1, 87258, 3063, 508.14, 1, 87688, 3077,
			 183.14, 1, 88247, 3092, 598.33, 1, 89149, 3110, 226.66, 1, 89484,
			 3125, 974.81, 1, 89893, 3142, 578.36, 1, 90091, 3154, 450.14,
			 1, 90331, 3169, 907.06, 1, 90821, 3183, 421.5, 1, 91342, 3200,
			 412.18, 1, 91787, 3214, 421.73, 1, 92246, 3229, 241.69, 1, 92684,
			 3242, 252.76, 1, 92979, 3257, 587.66, 1, 93299, 3273, 136.1,
			 1, 93840, 3290, 525.08, 1, 94368, 3307, 182.85, 1, 94783, 3323,
			 310.99, 1, 95339, 3340, 85.57, 1, 95965, 3356, 402.11, 1, 96315,
			 3371, 718.06, 1, 96669, 3383, 681.73, 1, 96972, 3394, 2244.4,
			 1, 97281, 3407, 558.69, 1, 97996, 3422, 144.6, 1, 98531, 3437,
			 554.25, 1, 98955, 3454, 199.39, 1, 99239, 3469, 252.45, 1, 99531,
			 3485, 392.82))
})

test_that("<b>Table 3.</b> Selection Summary results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_selectionInformationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("$ 6074.55", "8.2%", 231, 231, "$ 115090.76"))
})

test_that("<b>Table 4.</b> Information about Monetary Interval Selection results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_stratumTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(231, "$ 115090.76", 3500, "Total population", "8.2%", 231, "$ 1403220.82",
			 0, "$ 0", 0, "Ist value &gt; Interval", "100%", 0, "$ 0", 231,
			 "$ 115090.76", 3500, "Ist value &lt; Interval", "8.2%", 231,
			 "$ 1403220.82"))
})