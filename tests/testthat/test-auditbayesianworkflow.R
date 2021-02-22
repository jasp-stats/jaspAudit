context("[Audit] Bayesian Workflow")

options <- analysisOptions("auditBayesianWorkflow")
options$performanceMateriality <- TRUE
options$materialityValue <- 70161
options$recordNumberVariable <- "ID"
options$monetaryVariable <- "bookValue"
options$expectedPercentage <- 0.025
options$expectedEvidenceRatio <- TRUE
options$expectedBayesFactor <- TRUE
options$bookValueDescriptives <- TRUE
options$implicitSampleTable <- TRUE
options$priorStatistics <- TRUE
options$bookValueDistribution <- TRUE
options$decisionPlot <- TRUE
options$priorConstructionMethod <- "none"
options$priorPlot <- TRUE
options$priorPlotExpectedPosterior <- TRUE
options$samplingChecked <- TRUE
options$displaySample <- TRUE
options$sampleDescriptives <- TRUE
options$range <- FALSE
options$evaluationChecked <- TRUE
options$auditResult <- "auditValue"
options$evidenceRatio <- TRUE
options$bayesFactor <- TRUE
options$priorAndPosteriorStatistics <- TRUE
options$evaluationInformation <- TRUE
options$correlationPlot <- TRUE
options$priorAndPosteriorPlot <- TRUE
options$priorAndPosteriorPlotExpectedPosterior <- TRUE
options$materiality <- "materialityAbsolute"
options$handleCriticalTransactions <- "inspect"
options$expectedErrors <- "expectedRelative"
options$IR <- "High"
options$CR <- "High"
options$planningModel <- "Poisson"
options$valuta <- "dollarValuta"
options$shadePrior <- "shadePriorCredibleRegion"
options$selectionType <- "musSampling"
options$selectionMethod <- "systematicSampling"
options$variableType <- "variableTypeAuditValues"
options$estimator <- "gammaBound"
options$areaUnderPosterior <- "displayCredibleBound"
options$display <- "displayPercentages"
options$shadePosterior <- "shadePosteriorCredibleRegion"
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
results <- runAnalysis("auditBayesianWorkflow", "test-workflow.csv", options)


test_that("Scatter Plot of Ist and Soll Values matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_correlationPlot"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "scatter-plot-of-ist-and-soll-values", dir="auditBayesianWorkflow")
})

test_that("Evaluation of Sampling Objectives plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationInformation"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "evaluation-of-sampling-objectives", dir="auditBayesianWorkflow")
})

test_that("<b>Table 9.</b> Evaluation Summary results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("<unicode><unicode><unicode>", "1.291%", 103775.336382219, 0,
			 "5%", "0%", 231, "0%"))
})

test_that("Prior and Posterior Distribution plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_priorAndPosteriorPlot"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "prior-and-posterior-distribution", dir="auditBayesianWorkflow")
})

test_that("<b>Table 10.</b> Descriptive Statistics for Prior and Posterior Distribution results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_priorAndPosteriorStatistics"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("<unicode><unicode><unicode>", "gamma(<unicode><unicode> = 1, <unicode><unicode> = 0)",
			 0, 1, "NaN", 0, "NaN", "Prior", 0.0129685379807532, "gamma(<unicode><unicode> = 1, <unicode><unicode> = 231)",
			 0.999990363891858, 9.63610814238898e-06, 0, 103775.336382219,
			 0.0129685379807532, "Posterior", "-<unicode><unicode><unicode>",
			 "", "<unicode><unicode><unicode>", 9.63610814238898e-06, "NaN",
			 "<unicode><unicode><unicode>", "", "Shift"))
})

test_that("Across Probability Distributions (Current: Gamma) plot matches", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonDistributions"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "across-probability-distributions-current-gamma-", dir="auditBayesianWorkflow")
})

test_that("Across Expected Errors (Current: 5.78) plot matches", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_decisionPlot"]][["collection"]][["planningContainer_decisionPlot_comparisonErrors"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "across-expected-errors-current-5-78-", dir="auditBayesianWorkflow")
})

test_that("<b>Table 4.</b> Descriptive Statistics for Prior and Expected Posterior Distribution results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_priorAndPosteriorStatistics"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("<unicode><unicode><unicode>", "gamma(<unicode><unicode> = 1, <unicode><unicode> = 0)",
			 0, 1, "NaN", 0, "NaN", "Prior", 0.0499807036221922, "gamma(<unicode><unicode> = 6.775, <unicode><unicode> = 231)",
			 0.950123932551299, 0.0498760674487009, 0.025, 19.0496962000569,
			 0.0249807036221922, "Expected posterior", "-<unicode><unicode><unicode>",
			 "", "<unicode><unicode><unicode>", 0.0498760674487009, "NaN",
			 "<unicode><unicode><unicode>", "", "Expected shift"))
})

test_that("Implied Prior Distribution plot matches", {
	plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_priorPlot"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "implied-prior-distribution", dir="auditBayesianWorkflow")
})

test_that("<b>Table 3.</b> Implicit Sample results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_sampletable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0, 0))
})

test_that("<b>Table 2.</b> Planning Summary results match", {
	table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("5%", "<unicode><unicode><unicode>", 19.0496962000569, 5.775,
			 "$ 70161", 231))
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
	jaspTools::expect_equal_plots(testPlot, "distribution-of-ist-values", dir="auditBayesianWorkflow")
})

test_that("<b>Table 7.</b> Descriptive Statistics for Selected Transactions results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_sampleDescriptivesTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(498.228398268398, 468.1, 244.090089823475, 231, "bookValue"))
})

test_that("<b>Table 8.</b> Selected Transactions results match", {
  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_sampleTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                                 list(1, 82884, 1, 242.61, 1, 76073, 15, 469.93, 1, 19996, 32, 319.9,
                                      1, 28052, 49, 490.93, 1, 74733, 65, 509.36, 1, 23467, 78, 151.91,
                                      1, 75133, 92, 355.16, 1, 63432, 112, 339.44, 1, 13081, 128,
                                      734.93, 1, 58999, 141, 568.6, 1, 54435, 158, 430.78, 1, 32752,
                                      173, 112.07, 1, 89893, 189, 393.06, 1, 93529, 206, 528.79, 1,
                                      4260, 220, 428.45, 1, 98624, 235, 340.6, 1, 90733, 249, 327.73,
                                      1, 92751, 264, 500.51, 1, 45174, 280, 462.58, 1, 11643, 297,
                                      634.05, 1, 49209, 312, 329.69, 1, 68330, 329, 645.87, 1, 15197,
                                      344, 536.77, 1, 40165, 357, 880.81, 1, 29133, 372, 597.44, 1,
                                      7650, 386, 1425.79, 1, 43184, 400, 497.5, 1, 3922, 419, 630.86,
                                      1, 45851, 436, 478.83, 1, 52055, 449, 879.91, 1, 51855, 461,
                                      690.06, 1, 44650, 474, 414.99, 1, 19346, 491, 301.26, 1, 53945,
                                      506, 846.85, 1, 12052, 524, 580.69, 1, 63010, 542, 347.38, 1,
                                      87955, 557, 219.45, 1, 32406, 575, 606.48, 1, 83304, 587, 759.15,
                                      1, 77057, 603, 536.63, 1, 56532, 620, 268.9, 1, 92541, 634,
                                      244.31, 1, 7353, 647, 388.45, 1, 32486, 664, 354.77, 1, 75644,
                                      681, 300.11, 1, 98713, 698, 384.1, 1, 79101, 711, 832.79, 1,
                                      34803, 728, 328.56, 1, 65857, 744, 450.87, 1, 36468, 760, 577.92,
                                      1, 35085, 778, 291.58, 1, 73255, 797, 858.29, 1, 78958, 814,
                                      381.27, 1, 21123, 827, 381.48, 1, 92415, 843, 415.47, 1, 9542,
                                      860, 785.95, 1, 54916, 878, 325.65, 1, 94753, 893, 1171.55,
                                      1, 64505, 908, 802.25, 1, 19706, 922, 672.47, 1, 68039, 939,
                                      684.79, 1, 42099, 953, 337.06, 1, 29132, 969, 320.19, 1, 91097,
                                      981, 235.45, 1, 42875, 999, 553.65, 1, 50755, 1017, 618.24,
                                      1, 54637, 1035, 163.46, 1, 59197, 1050, 796.94, 1, 36214, 1066,
                                      363.79, 1, 78091, 1076, 489.4, 1, 77111, 1090, 650.75, 1, 18923,
                                      1104, 527.82, 1, 96557, 1119, 610.25, 1, 79238, 1136, 642.84,
                                      1, 30188, 1152, 766.24, 1, 77743, 1163, 402.29, 1, 92595, 1179,
                                      719.44, 1, 37062, 1192, 603.58, 1, 36993, 1207, 491.74, 1, 42095,
                                      1224, 290.06, 1, 73288, 1237, 891.39, 1, 38972, 1250, 419.85,
                                      1, 6771, 1267, 351.53, 1, 6548, 1284, 742.4, 1, 11343, 1297,
                                      471.04, 1, 91955, 1311, 398.96, 1, 85806, 1324, 200.7, 1, 71371,
                                      1342, 688.71, 1, 68454, 1356, 518.82, 1, 80158, 1369, 278.62,
                                      1, 57302, 1382, 524.91, 1, 38653, 1399, 253.31, 1, 65540, 1415,
                                      356.03, 1, 33455, 1429, 329.49, 1, 80192, 1444, 163.6, 1, 53147,
                                      1459, 537.18, 1, 41974, 1475, 726.26, 1, 85526, 1491, 591.02,
                                      1, 26904, 1503, 498.97, 1, 38713, 1515, 753.11, 1, 6481, 1528,
                                      240.01, 1, 21839, 1541, 340.02, 1, 50237, 1557, 666.61, 1, 39905,
                                      1574, 622.61, 1, 27986, 1591, 632.11, 1, 9296, 1605, 360.13,
                                      1, 48921, 1622, 480.79, 1, 39570, 1639, 307.54, 1, 49285, 1657,
                                      551, 1, 1679, 1673, 646.61, 1, 62668, 1689, 329.11, 1, 52191,
                                      1704, 427.71, 1, 35982, 1721, 829.17, 1, 85129, 1735, 620.45,
                                      1, 3959, 1749, 359.42, 1, 33315, 1764, 365.65, 1, 78307, 1783,
                                      682.41, 1, 7557, 1796, 587.46, 1, 23904, 1811, 516.94, 1, 65326,
                                      1822, 484.13, 1, 80187, 1837, 116.68, 1, 85193, 1853, 312.87,
                                      1, 49457, 1871, 468.1, 1, 37358, 1885, 474.71, 1, 74570, 1903,
                                      363.44, 1, 65841, 1915, 533.44, 1, 35832, 1928, 592.51, 1, 75669,
                                      1941, 526.21, 1, 84289, 1955, 512.69, 1, 69719, 1971, 377.46,
                                      1, 33457, 1987, 425.57, 1, 37408, 2001, 711.79, 1, 68924, 2014,
                                      331.87, 1, 56086, 2028, 529.97, 1, 13683, 2041, 381.64, 1, 56834,
                                      2056, 389.09, 1, 73214, 2070, 357.5, 1, 16829, 2085, 392.71,
                                      1, 23624, 2096, 876.04, 1, 11044, 2108, 821.93, 1, 22202, 2120,
                                      821.17, 1, 91811, 2136, 560.45, 1, 64891, 2148, 341.1, 1, 24860,
                                      2166, 511.7, 1, 81326, 2178, 839.21, 1, 23899, 2191, 304.8,
                                      1, 61540, 2208, 963.53, 1, 12855, 2225, 481.16, 1, 91121, 2241,
                                      459.71, 1, 80386, 2257, 553.69, 1, 76321, 2272, 593.5, 1, 14825,
                                      2287, 364.88, 1, 98955, 2300, 349.99, 1, 62125, 2314, 306.91,
                                      1, 14697, 2330, 220.59, 1, 10137, 2345, 243.26, 1, 49165, 2355,
                                      514.31, 1, 49157, 2369, 911.21, 1, 39052, 2384, 247.62, 1, 85195,
                                      2396, 847.81, 1, 27007, 2411, 583.79, 1, 47728, 2424, 454.5,
                                      1, 94088, 2439, 321.86, 1, 91983, 2455, 467.72, 1, 63268, 2469,
                                      420.54, 1, 79252, 2484, 132.9, 1, 32535, 2500, 431.96, 1, 99015,
                                      2517, 281.38, 1, 49963, 2531, 455.5, 1, 21144, 2548, 509.94,
                                      1, 56996, 2562, 599.29, 1, 23322, 2575, 378.66, 1, 81316, 2588,
                                      874.85, 1, 35760, 2601, 646.36, 1, 28497, 2613, 207.04, 1, 51328,
                                      2627, 312.41, 1, 88715, 2643, 632.34, 1, 23927, 2660, 454.81,
                                      1, 43422, 2683, 561.68, 1, 225, 2698, 507.18, 1, 7948, 2717,
                                      725.78, 1, 16429, 2731, 848.72, 1, 57220, 2746, 491.6, 1, 8983,
                                      2761, 423.66, 1, 77259, 2774, 367.43, 1, 76594, 2790, 404.98,
                                      1, 42490, 2807, 262.94, 1, 27837, 2822, 255.6, 1, 22616, 2838,
                                      227.04, 1, 4613, 2854, 626.21, 1, 63502, 2869, 124.27, 1, 72330,
                                      2886, 236.3, 1, 78057, 2906, 401.02, 1, 15776, 2924, 791.64,
                                      1, 17142, 2940, 392.01, 1, 32895, 2959, 374.39, 1, 72564, 2975,
                                      521.33, 1, 42849, 2990, 360.94, 1, 2571, 3006, 406.14, 1, 49473,
                                      3018, 863.27, 1, 77525, 3033, 623.56, 1, 13359, 3047, 1262.85,
                                      1, 43600, 3063, 508.14, 1, 81878, 3077, 183.14, 1, 58479, 3092,
                                      598.33, 1, 82363, 3110, 226.66, 1, 46700, 3125, 974.81, 1, 60863,
                                      3142, 578.36, 1, 59570, 3154, 450.14, 1, 77405, 3169, 907.06,
                                      1, 61344, 3183, 421.5, 1, 22283, 3200, 412.18, 1, 52250, 3214,
                                      421.73, 1, 20250, 3229, 241.69, 1, 91637, 3242, 252.76, 1, 29389,
                                      3257, 587.66, 1, 61391, 3273, 136.1, 1, 40512, 3290, 525.08,
                                      1, 77480, 3307, 182.85, 1, 71075, 3323, 310.99, 1, 75844, 3340,
                                      85.57, 1, 30139, 3356, 402.11, 1, 11407, 3371, 718.06, 1, 26052,
                                      3383, 681.73, 1, 99612, 3394, 2244.4, 1, 89484, 3407, 558.69,
                                      1, 82753, 3422, 144.6, 1, 55573, 3437, 554.25, 1, 42835, 3454,
                                      199.39, 1, 48429, 3469, 252.45, 1, 22862, 3485, 392.82))
})

test_that("<b>Table 5.</b> Selection Summary results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_selectionInformationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("$ 6074.55", "8.2%", 231, 231, "$ 115090.76"))
})

test_that("<b>Table 6.</b> Information about Monetary Interval Selection results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_stratumTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(231, "$ 115090.76", 3500, "Total population", "8.2%", 231, "$ 1403220.82",
			 0, "$ 0", 0, "Ist value &gt; Interval", "100%", 0, "$ 0", 231,
			 "$ 115090.76", 3500, "Ist value &lt; Interval", "8.2%", 231,
			 "$ 1403220.82"))
})