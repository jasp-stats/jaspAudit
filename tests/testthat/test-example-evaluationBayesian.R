context("Example: evaluationBayesian")

# This test file was auto-generated from a JASP example file.
# The JASP file is stored in the module's examples/ folder.

test_that("auditClassicalEvaluation results match", {

  # Load from JASP example file
  jaspFile <- testthat::test_path("..", "..", "examples", "evaluationBayesian.jasp")
  opts <- jaspTools::analysisOptions(jaspFile)
  dataset <- jaspTools::extractDatasetFromJASPFile(jaspFile)

  # Encode and run analysis
  encoded <- jaspTools:::encodeOptionsAndDataset(opts, dataset)
  set.seed(1)
  results <- jaspTools::runAnalysis("auditClassicalEvaluation", encoded$dataset, encoded$options, encodedDataset = TRUE)

  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(0.03, 0.00122543162765505, 90, "Value", 0.0817175436704155, 0.0343969643749134,
     0.110288846488955, 0.0356223960025685, 1))

  plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotObjectives"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "analysis-1_figure-1_evaluation-of-sampling-objectives")

})

