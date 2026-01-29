context("Example: substantiveTestBayesian")

# This test file was auto-generated from a JASP example file.
# The JASP file is stored in the module's examples/ folder.

test_that("auditBayesianWorkflow results match", {

  # Load from JASP example file
  jaspFile <- testthat::test_path("..", "..", "examples", "substantiveTestBayesian.jasp")
  opts <- jaspTools::analysisOptions(jaspFile)
  dataset <- jaspTools::extractDatasetFromJASPFile(jaspFile)

  # Encode and run analysis
  encoded <- jaspTools:::encodeOptionsAndDataset(opts, dataset)
  set.seed(1)
  results <- jaspTools::runAnalysis("auditBayesianWorkflow", encoded$dataset, encoded$options, encodedDataset = TRUE)

  table <- results[["results"]][["ARMcontainer"]][["collection"]][["ARMcontainer_table"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(0, 0, 1, "High", 1, 1, 0, 0.5, "Medium", 0.52, 0.63, 0.25, "Low",
     0.34, 0.4))

  plotName <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_plotPriorAndPosterior"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "analysis-1_figure-1_prior-and-expected-posterior-distribution")

  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(1, 0.52, 0.0961538461538462, 1, 0.05, 192, "Value", 4.8))

  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_tablePriorPosterior"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(0.230440944119538, "gamma(<unicode> = 1, <unicode> = 13)", 0.477954223238984,
     0.522045776761016, 0.0769230769230769, 0.0533190138892266, 0,
     0.915540829013896, 0.230440944119538, "Prior", 0.0499697688044414,
     "gamma(<unicode> = 5.8, <unicode> = 205)", 0.950182094519228,
     0.0498179054807719, 0.0282926829268293, 0.0266843363065968,
     0.0234146341463415, 19.0731040446084, 0.0265551346581, "Posterior",
     -0.180471175315096, "", 1.98801903680245, 0.0954282319643738,
     -0.0486303939962477, -0.0266346775826297, 0.0234146341463415,
     20.8326089237893, "", "Shift"))

  plotName <- results[["results"]][["procedureContainer"]][["collection"]][["procedureContainer_plotBookDist"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "analysis-1_figure-2_distribution-of-book-values")

  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(3500, 1403220.82, 192, 192, 0.0638414772095529, "Total", 89583.69,
     0, 0, 0, 0, 0, "Top stratum", 0, 3500, 1403220.82, 192, 192,
     0.0638414772095529, "Bottom stratum", 89583.69))

  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(192, 0.0638414772095529, 192, 89583.69))

})

