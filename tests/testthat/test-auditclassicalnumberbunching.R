context("[Audit] Classical Number Bunching")

# The test here are taken directly from http://datacolada.org/77

### TEST 1: Study 2

options <- analysisOptions("auditClassicalNumberBunching")
options$values <- "Variable"
options$noSamples <- 1000
options$summaryTable <- TRUE
options$numberBunchingPlotFrequency <- TRUE
options$numberBunchingPlotEntropy <- TRUE
options$numberBunchingHistogram <- TRUE
options$noHeads <- 13
set.seed(1)
results <- runAnalysis("auditClassicalNumberBunching", "numberBunching1.csv", options)


test_that("<b>Table 2.</b> Assumption Checks results match", {
  table <- results[["results"]][["numberBunchingContainer"]][["collection"]][["numberBunchingContainer_correlationTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                                 list(0.0235054850952473, "-", 1598, 1600, 0.34741538358077, 0.939891267447534,
                                      "Integer values", "Decimal values", -0.960281111669023, "-",
                                      998, 1000, 0, -108.7191221832, "Samples frequency", "Samples entropy"
                                 ))
})

test_that("Histogram of Individual Values plot matches", {
  plotName <- results[["results"]][["numberBunchingContainer"]][["collection"]][["numberBunchingContainer_numberBunchingHistogram"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "histogram-of-individual-values", dir="auditClassicalNumberBunching")
})

test_that("Observed vs. Expected Entropy plot matches", {
  plotName <- results[["results"]][["numberBunchingContainer"]][["collection"]][["numberBunchingContainer_numberBunchingPlotEntropy"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "observed-vs-expected-entropy", dir="auditClassicalNumberBunching")
})

test_that("Observed vs. Expected Average Frequency plot matches", {
  plotName <- results[["results"]][["numberBunchingContainer"]][["collection"]][["numberBunchingContainer_numberBunchingPlotFrequency"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "observed-vs-expected-average-frequency", dir="auditClassicalNumberBunching")
})

test_that("<b>Table 3.</b> Frequency Statistics results match", {
  table <- results[["results"]][["numberBunchingContainer"]][["collection"]][["numberBunchingContainer_numberBunchingTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                                 list(1013, 1, "63.31%", 203, 2, "12.69%", 41, 3, "2.56%", 12, 4, "0.75%",
                                      2, 5, "0.12%", 0, 6, "0%", 0, 7, "0%", 0, 8, "0%", 0, 9, "0%"
                                 ))
})

test_that("<b>Table 1.</b> Number Bunching Test results match", {
  table <- results[["results"]][["numberBunchingContainer"]][["collection"]][["numberBunchingContainer_numberBunchingTestTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                                 list(1600, 1.5225, 7.06576917368312, "Variable", 0.002, 0.002))
})

### TEST 2: Study 3

options <- analysisOptions("auditClassicalNumberBunching")
options$values <- "Variable"
options$noSamples <- 1000
options$summaryTable <- TRUE
options$numberBunchingPlotFrequency <- TRUE
options$numberBunchingPlotEntropy <- TRUE
options$numberBunchingHistogram <- TRUE
options$noHeads <- 13
set.seed(1)
results <- runAnalysis("auditClassicalNumberBunching", "numberBunching2.csv", options)


test_that("<b>Table 2.</b> Assumption Checks results match", {
  table <- results[["results"]][["numberBunchingContainer"]][["collection"]][["numberBunchingContainer_correlationTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                                 list(-0.124707157162072, "-", 3233, 3235, 1.09474735289137e-12, -7.14657265617445,
                                      "Integer values", "Decimal values", -0.832179912262436, "-",
                                      998, 1000, 7.94464781314267e-258, -47.4107110066442, "Samples frequency",
                                      "Samples entropy"))
})

test_that("Histogram of Individual Values plot matches", {
  plotName <- results[["results"]][["numberBunchingContainer"]][["collection"]][["numberBunchingContainer_numberBunchingHistogram"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "histogram-of-individual-values-2", dir="auditClassicalNumberBunching")
})

test_that("Observed vs. Expected Entropy plot matches", {
  plotName <- results[["results"]][["numberBunchingContainer"]][["collection"]][["numberBunchingContainer_numberBunchingPlotEntropy"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "observed-vs-expected-entropy-2", dir="auditClassicalNumberBunching")
})

test_that("Observed vs. Expected Average Frequency plot matches", {
  plotName <- results[["results"]][["numberBunchingContainer"]][["collection"]][["numberBunchingContainer_numberBunchingPlotFrequency"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "observed-vs-expected-average-frequency-2", dir="auditClassicalNumberBunching")
})

test_that("<b>Table 3.</b> Frequency Statistics results match", {
  table <- results[["results"]][["numberBunchingContainer"]][["collection"]][["numberBunchingContainer_numberBunchingTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                                 list(1252, 1, "38.7%", 408, 2, "12.61%", 158, 3, "4.88%", 54, 4, "1.67%",
                                      34, 5, "1.05%", 22, 6, "0.68%", 9, 7, "0.28%", 5, 8, "0.15%",
                                      2, 9, "0.06%"))
})

test_that("<b>Table 1.</b> Number Bunching Test results match", {
  table <- results[["results"]][["numberBunchingContainer"]][["collection"]][["numberBunchingContainer_numberBunchingTestTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                                 list(3235, 2.57341576506955, 7.38007620473818, "Variable", 0, 0))
})