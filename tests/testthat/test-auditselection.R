context("[Audit] Selection")

### TEST 1: TAKING A MONETARY UNIT SAMPLE OF SIZE n = 200

options <- analysisOptions("auditSelection")
options$recordNumberVariable <- "ID"
options$monetaryVariable <- "bookValue"
options$sampleSize <- 200
options$displaySample <- TRUE
options$addSampleIndicator <- FALSE
options$selectionType <- "musSampling"
options$selectionMethod <- "systematicSampling"
options$valuta <- "euroValuta"
options$.meta <- list(additionalVariables = list(containsColumn = TRUE), monetaryVariable = list(
    containsColumn = TRUE), rankingVariable = list(containsColumn = TRUE), 
    recordNumberVariable = list(containsColumn = TRUE), sampleIndicatorColumn = list(
        containsColumn = TRUE))
options$sampleIndicatorColumn <- ""
set.seed(1)
results <- runAnalysis("auditSelection", "BuildIt_Monetary.csv", options)


test_that("<b>Table 3.</b> Selected Transactions results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_sampleTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(1, 82884, 1, 242.61, 1, 46163, 17, 511.62, 1, 57172, 38, 329.3,
			 1, 86073, 55, 874.46, 1, 90160, 73, 205.69, 1, 31740, 89, 735.45,
			 1, 4756, 110, 295.96, 1, 13081, 128, 734.93, 1, 90183, 146,
			 333.28, 1, 76263, 162, 701.99, 1, 96080, 183, 449.07, 1, 96029,
			 201, 465.35, 1, 11890, 218, 296.31, 1, 98624, 235, 340.6, 1,
			 78992, 252, 686.1, 1, 96292, 269, 179.32, 1, 22629, 289, 488.41,
			 1, 11569, 306, 1025.03, 1, 57791, 325, 376, 1, 15197, 344, 536.77,
			 1, 20711, 358, 610.88, 1, 58735, 377, 620.96, 1, 75887, 392,
			 739, 1, 497, 411, 640.18, 1, 24835, 430, 237, 1, 52055, 449,
			 879.91, 1, 26364, 462, 740.25, 1, 71824, 479, 305.14, 1, 8847,
			 497, 397.11, 1, 56756, 514, 348.08, 1, 61005, 536, 233.97, 1,
			 44391, 554, 374.93, 1, 88214, 574, 214.61, 1, 16689, 589, 630.99,
			 1, 27905, 606, 868.59, 1, 51619, 625, 274.09, 1, 58370, 641,
			 182.14, 1, 47485, 660, 773.14, 1, 20237, 679, 669.75, 1, 64305,
			 699, 319.68, 1, 99012, 715, 313.75, 1, 78676, 735, 346.28, 1,
			 4261, 752, 214.07, 1, 47596, 771, 256.13, 1, 72660, 795, 366.19,
			 1, 82711, 813, 288.93, 1, 80057, 828, 762.64, 1, 35269, 850,
			 281.84, 1, 83339, 867, 614.68, 1, 93477, 887, 692.36, 1, 98110,
			 902, 617.6, 1, 73208, 921, 370.28, 1, 68039, 939, 684.79, 1,
			 99419, 956, 668.93, 1, 64369, 972, 382.49, 1, 47424, 992, 469.18,
			 1, 92166, 1010, 566.01, 1, 83189, 1031, 199.8, 1, 59197, 1050,
			 796.94, 1, 37569, 1068, 633.59, 1, 65319, 1081, 502.54, 1, 85233,
			 1098, 686.1, 1, 28178, 1113, 367.64, 1, 38019, 1132, 537.14,
			 1, 37412, 1150, 306.66, 1, 59189, 1165, 186.49, 1, 10345, 1182,
			 294.04, 1, 90284, 1198, 550.7, 1, 12827, 1214, 688.28, 1, 5324,
			 1233, 503.95, 1, 57764, 1249, 696.32, 1, 6771, 1267, 351.53,
			 1, 45561, 1286, 702.76, 1, 60970, 1301, 348.48, 1, 28529, 1317,
			 471.97, 1, 77871, 1335, 812.13, 1, 19517, 1354, 340.07, 1, 8070,
			 1368, 938.12, 1, 83336, 1383, 656.34, 1, 55381, 1402, 900.38,
			 1, 88454, 1421, 856.28, 1, 13214, 1437, 994.44, 1, 60630, 1455,
			 681.91, 1, 83225, 1474, 221.15, 1, 81443, 1492, 543.8, 1, 48139,
			 1505, 718.58, 1, 7652, 1518, 846.99, 1, 36945, 1534, 714.02,
			 1, 4120, 1552, 233.88, 1, 26525, 1572, 941.47, 1, 97834, 1590,
			 294.9, 1, 60760, 1606, 715.14, 1, 98301, 1627, 429.07, 1, 6686,
			 1646, 343.83, 1, 39990, 1668, 788, 1, 20736, 1685, 407.24, 1,
			 83784, 1702, 389.55, 1, 35982, 1721, 829.17, 1, 24275, 1738,
			 721.75, 1, 10054, 1754, 369.34, 1, 87258, 1774, 157.68, 1, 6154,
			 1791, 285.42, 1, 40471, 1808, 438.74, 1, 65326, 1822, 484.13,
			 1, 37044, 1839, 654.61, 1, 78043, 1858, 664.6, 1, 78011, 1877,
			 583.89, 1, 2885, 1895, 285, 1, 94914, 1912, 646.29, 1, 27340,
			 1927, 659.18, 1, 98561, 1942, 294.24, 1, 27256, 1958, 314.22,
			 1, 85588, 1976, 535.51, 1, 2740, 1995, 714.23, 1, 5590, 2010,
			 676.34, 1, 21217, 2026, 172.91, 1, 13683, 2041, 381.64, 1, 35189,
			 2058, 337.29, 1, 29742, 2075, 554.85, 1, 89961, 2089, 337.64,
			 1, 48652, 2103, 497.21, 1, 99274, 2118, 816.62, 1, 72040, 2135,
			 509.04, 1, 25056, 2149, 344.4, 1, 16092, 2168, 595.35, 1, 39429,
			 2183, 338.23, 1, 87666, 2199, 544.79, 1, 53398, 2220, 448.74,
			 1, 60413, 2238, 418.78, 1, 80386, 2257, 553.69, 1, 60271, 2275,
			 502.81, 1, 34881, 2289, 1041.99, 1, 93548, 2306, 439.82, 1,
			 432, 2324, 593.65, 1, 9063, 2340, 700.38, 1, 1692, 2354, 607.25,
			 1, 49157, 2369, 911.21, 1, 23549, 2389, 718.86, 1, 65112, 2403,
			 408.75, 1, 58501, 2420, 386.36, 1, 37248, 2435, 1041.44, 1,
			 53304, 2452, 346.7, 1, 68187, 2470, 289.23, 1, 72681, 2486,
			 651.26, 1, 78346, 2505, 478.69, 1, 37458, 2522, 554.27, 1, 64553,
			 2540, 432.18, 1, 16188, 2558, 649.78, 1, 23322, 2575, 378.66,
			 1, 76001, 2590, 1230.94, 1, 97083, 2605, 849.02, 1, 95414, 2618,
			 337.08, 1, 32760, 2636, 599.3, 1, 39805, 2656, 617.63, 1, 35420,
			 2679, 320.63, 1, 225, 2698, 507.18, 1, 46509, 2719, 353.72,
			 1, 73254, 2736, 343.81, 1, 11585, 2755, 157.51, 1, 98790, 2768,
			 558.36, 1, 10925, 2787, 377.1, 1, 67454, 2806, 218.2, 1, 66041,
			 2824, 684.86, 1, 51035, 2843, 337.96, 1, 58155, 2860, 229.59,
			 1, 76649, 2880, 465.22, 1, 71135, 2900, 334.26, 1, 41792, 2920,
			 202.58, 1, 21214, 2941, 430.11, 1, 81544, 2961, 427.78, 1, 99150,
			 2982, 514.03, 1, 74281, 2998, 215.46, 1, 75272, 3014, 510.93,
			 1, 52121, 3029, 993.57, 1, 13359, 3047, 1262.85, 1, 6080, 3064,
			 722.45, 1, 20335, 3082, 564.01, 1, 78336, 3100, 359.43, 1, 31532,
			 3120, 469, 1, 72035, 3137, 322.92, 1, 71832, 3152, 1001.82,
			 1, 77405, 3169, 907.06, 1, 67180, 3187, 254.39, 1, 14754, 3205,
			 212.81, 1, 90783, 3222, 543.95, 1, 17096, 3237, 606.61, 1, 89779,
			 3255, 295.77, 1, 61391, 3273, 136.1, 1, 2111, 3292, 215.07,
			 1, 79729, 3313, 882.54, 1, 47872, 3330, 444.67, 1, 85306, 3349,
			 674.63, 1, 15, 3368, 475.92, 1, 26052, 3383, 681.73, 1, 99612,
			 3394, 2244.4, 1, 18796, 3409, 414.75, 1, 70852, 3428, 606.14,
			 1, 54606, 3444, 377.4, 1, 53902, 3465, 400.3, 1, 89394, 3483,
			 698.2))
})

test_that("<b>Table 1.</b> Selection Summary results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_selectionInformationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("<unicode><unicode><unicode> 7016.1", "7.5%", 200, 200, "<unicode><unicode><unicode> 105247.58"
			))
})

test_that("<b>Table 2.</b> Information about Monetary Interval Selection results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_stratumTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(200, "<unicode><unicode><unicode> 105247.58", 3500, "Total population",
			 "7.5%", 200, "<unicode><unicode><unicode> 1403220.82", 0, "<unicode><unicode><unicode> 0",
			 0, "Ist value &gt; Interval", "100%", 0, "<unicode><unicode><unicode> 0",
			 200, "<unicode><unicode><unicode> 105247.58", 3500, "Ist value &lt; Interval",
			 "7.5%", 200, "<unicode><unicode><unicode> 1403220.82"))
})

### Test 2: Taking a record sample of n = 200 using ID only

options <- analysisOptions("auditSelection")
options$recordNumberVariable <- "ID"
options$sampleSize <- 200
options$displaySample <- TRUE
options$addSampleIndicator <- FALSE
options$selectionType <- "recordSampling"
options$selectionMethod <- "randomSampling"
options$.meta <- list(additionalVariables = list(containsColumn = TRUE), monetaryVariable = list(
    containsColumn = TRUE), rankingVariable = list(containsColumn = TRUE), 
    recordNumberVariable = list(containsColumn = TRUE), sampleIndicatorColumn = list(
        containsColumn = TRUE))
options$sampleIndicatorColumn <- ""
set.seed(1)
results <- runAnalysis("auditSelection", "BuildIt_Monetary.csv", options)


test_that("<b>Table 2.</b> Selected Transactions results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_sampleTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(1, 85674, 930, 1, 83429, 1303, 1, 70246, 2004, 1, 45736, 3177,
			 1, 7246, 706, 1, 5964, 3140, 1, 10934, 3301, 1, 12499, 2309,
			 1, 48009, 2197, 1, 55391, 216, 1, 64893, 719, 1, 58475, 617,
			 1, 84079, 2397, 1, 754, 1340, 1, 67078, 2684, 1, 85129, 1735,
			 1, 82438, 2501, 1, 35945, 3455, 1, 85806, 1324, 1, 1832, 2707,
			 1, 39179, 3253, 1, 72671, 739, 1, 67488, 2267, 1, 11649, 437,
			 1, 38549, 929, 1, 71371, 1342, 1, 53784, 47, 1, 32940, 1329,
			 1, 8716, 3020, 1, 10345, 1182, 1, 1679, 1673, 1, 4632, 2080,
			 1, 44122, 1712, 1, 40763, 646, 1, 49057, 2868, 1, 82429, 2317,
			 1, 77998, 2752, 1, 14869, 374, 1, 13137, 2506, 1, 73509, 1424,
			 1, 4480, 2841, 1, 44352, 2239, 1, 83149, 2708, 1, 94914, 1912,
			 1, 59661, 1831, 1, 77138, 2728, 1, 18890, 81, 1, 79250, 1648,
			 1, 76399, 2528, 1, 22064, 2391, 1, 26455, 3453, 1, 6808, 2971,
			 1, 17899, 1511, 1, 43678, 844, 1, 63863, 244, 1, 10991, 343,
			 1, 77111, 1090, 1, 14140, 1786, 1, 27002, 2279, 1, 79305, 1400,
			 1, 71279, 3141, 1, 92166, 1010, 1, 62317, 1579, 1, 67749, 1143,
			 1, 50692, 2237, 1, 93477, 887, 1, 28997, 1644, 1, 72195, 2631,
			 1, 4913, 290, 1, 28658, 3004, 1, 32125, 1164, 1, 93251, 2879,
			 1, 50469, 1189, 1, 85213, 1144, 1, 85405, 1632, 1, 86317, 3056,
			 1, 42536, 2960, 1, 77871, 1335, 1, 23927, 2660, 1, 70312, 3287,
			 1, 45542, 1487, 1, 99028, 2437, 1, 8070, 1368, 1, 69483, 1112,
			 1, 85471, 2587, 1, 52164, 693, 1, 92106, 2428, 1, 26163, 416,
			 1, 43352, 838, 1, 14139, 489, 1, 45922, 818, 1, 96029, 201,
			 1, 42699, 2189, 1, 47090, 2986, 1, 17218, 2653, 1, 77455, 2715,
			 1, 54, 1550, 1, 25836, 1396, 1, 16442, 2759, 1, 35189, 2058,
			 1, 86909, 2227, 1, 13669, 1201, 1, 75063, 919, 1, 450, 3373,
			 1, 4911, 2152, 1, 1000, 724, 1, 985, 440, 1, 47899, 1623, 1,
			 79478, 3135, 1, 91278, 2031, 1, 72546, 3310, 1, 27786, 2481,
			 1, 5434, 1209, 1, 75782, 1462, 1, 67148, 502, 1, 32267, 45,
			 1, 7886, 2422, 1, 13682, 350, 1, 58, 1510, 1, 46940, 2165, 1,
			 13965, 3353, 1, 65816, 1675, 1, 8383, 1637, 1, 16836, 586, 1,
			 60214, 2549, 1, 82902, 1532, 1, 3954, 1725, 1, 65772, 701, 1,
			 8596, 772, 1, 2933, 2009, 1, 35525, 1938, 1, 14001, 260, 1,
			 8083, 120, 1, 31200, 3381, 1, 31873, 3126, 1, 78060, 2013, 1,
			 57162, 1887, 1, 14678, 1770, 1, 16249, 3312, 1, 85734, 1707,
			 1, 34895, 2295, 1, 77179, 2021, 1, 91330, 803, 1, 83339, 867,
			 1, 42192, 2448, 1, 49287, 1519, 1, 41417, 588, 1, 68151, 2504,
			 1, 94854, 352, 1, 12845, 2898, 1, 72231, 2060, 1, 74600, 1866,
			 1, 52815, 1101, 1, 86084, 1517, 1, 85322, 3379, 1, 19938, 605,
			 1, 71607, 1772, 1, 78992, 252, 1, 51209, 3476, 1, 79101, 711,
			 1, 46089, 952, 1, 83073, 2989, 1, 40983, 1490, 1, 42016, 2603,
			 1, 45941, 2938, 1, 2046, 1378, 1, 40051, 213, 1, 96557, 1119,
			 1, 42588, 2412, 1, 17785, 1125, 1, 90852, 2100, 1, 11974, 2799,
			 1, 2569, 2850, 1, 86390, 3499, 1, 52022, 1266, 1, 63071, 2978,
			 1, 53527, 2142, 1, 7396, 2463, 1, 50165, 2011, 1, 44268, 3000,
			 1, 31284, 976, 1, 8709, 635, 1, 38318, 2942, 1, 91213, 1670,
			 1, 97156, 2909, 1, 24203, 628, 1, 71123, 2513, 1, 54631, 2401,
			 1, 37735, 3366, 1, 6468, 1814, 1, 77844, 2356, 1, 90736, 1287,
			 1, 59766, 334, 1, 38896, 3067, 1, 25683, 937, 1, 94787, 1952,
			 1, 85828, 365, 1, 67231, 2777, 1, 59197, 1050, 1, 53213, 2585
			))
})

test_that("<b>Table 1.</b> Selection Summary results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_selectionInformationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("5.71%", 200, 200))
})

### Test 3: Selection using auditRattle.csv data set

options <- analysisOptions("auditSelection")
options$recordNumberVariable <- "ID"
options$monetaryVariable <- "Deductions"
options$sampleSize <- 40
options$displaySample <- TRUE
options$sampleDescriptives <- TRUE
options$addSampleIndicator <- FALSE
options$selectionType <- "musSampling"
options$selectionMethod <- "randomSampling"
options$valuta <- "euroValuta"
options$.meta <- list(additionalVariables = list(containsColumn = TRUE), monetaryVariable = list(
    containsColumn = TRUE), rankingVariable = list(containsColumn = TRUE), 
    recordNumberVariable = list(containsColumn = TRUE), sampleIndicatorColumn = list(
        containsColumn = TRUE))
options$plotHistograms <- TRUE
options$sampleIndicatorColumn <- ""
set.seed(1)
results <- runAnalysis("auditSelection", "auditRattle.csv", options)


test_that("<b>Table 2.</b> Descriptive Statistics for Selected Transactions results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_sampleDescriptivesTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(1724.16666666667, 1887, 489.370128335519, 40, "Deductions"))
})

test_that("<b>Table 3.</b> Selected Transactions results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_sampleTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(1, 1977, 29, 29, 1, 1902, 73, 73, 1, 1848, 19, 19, 1, 1098.66666666667,
			 22, 22, 1, 2246, 1, 1, 1, 1114.66666666667, 37, 37, 1, 1060,
			 23, 23, 1, 1559.33333333333, 68, 68, 1, 1568, 36, 36, 1, 2513.33333333333,
			 53, 53, 1, 2174, 14, 14, 1, 2246, 55, 55, 1, 1492, 69, 69, 1,
			 1902, 38, 38, 1, 1316, 25, 25, 1, 1887, 3, 3, 1, 1367.33333333333,
			 13, 13, 1, 649.333333333333, 28, 28, 1, 1902, 10, 10, 1, 1250.66666666667,
			 5, 5, 1, 1068, 77, 77, 1, 2174, 8, 8, 1, 1564, 27, 27, 1, 2415,
			 48, 48, 1, 1977, 63, 63, 1, 1902, 17, 17, 1, 2904, 65, 65, 1,
			 1902, 43, 43, 1, 1114.66666666667, 42, 42, 1, 1902, 60, 60,
			 1, 1887, 66, 66, 1, 1564, 31, 31, 1, 1887, 44, 44, 1, 2258,
			 46, 46, 1, 1147.33333333333, 71, 71, 1, 1452.66666666667, 18,
			 18, 1, 1160.66666666667, 74, 74, 1, 2392, 49, 49, 1, 1320, 12,
			 12, 1, 1902, 4, 4))
})

test_that("<b>Table 1.</b> Selection Summary results match", {
	table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_selectionInformationTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("51.03%", 40, 40, "<unicode><unicode><unicode> 68966.67"))
})