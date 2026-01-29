context("Example: stratifiedEvaluation")

# This test file was auto-generated from a JASP example file.
# The JASP file is stored in the module's examples/ folder.

test_that("auditBayesianEvaluation results match", {

  # Load from JASP example file
  jaspFile <- testthat::test_path("..", "..", "examples", "stratifiedEvaluation.jasp")
  opts <- jaspTools::analysisOptions(jaspFile)
  dataset <- jaspTools::extractDatasetFromJASPFile(jaspFile)

  # Encode and run analysis
  encoded <- jaspTools:::encodeOptionsAndDataset(opts, dataset)
  set.seed(1)
  results <- jaspTools::runAnalysis("auditBayesianEvaluation", encoded$dataset, encoded$options, encodedDataset = TRUE)

  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(0.04, 0.2463, 447, "Value", 0.0238974181820045, 197.511293779585,
     0.270197418182004, 242))

  plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotEstimates"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "analysis-1_figure-1_estimates")

  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_tableStratum"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(6, 0.0146916017064134, 87, 0.042975002099517, "Distribution center",
     1.27816934845797, 0.0576666038059305, 233, 0.633551227643041,
     305, 0.0438250517812251, "Store Amsterdam", 193.233124431127,
     0.677376279424266, 3, 0.0545454545454545, 55, 0.0781328667566767,
     "Store Rotterdam", 3, 0.132678321302131))

})

