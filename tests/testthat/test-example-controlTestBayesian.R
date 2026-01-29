context("Example: controlTestBayesian")

# This test file was auto-generated from a JASP example file.
# The JASP file is stored in the module's examples/ folder.

test_that("auditBayesianWorkflow results match", {

  # Load from JASP example file
  jaspFile <- testthat::test_path("..", "..", "examples", "controlTestBayesian.jasp")
  opts <- jaspTools::analysisOptions(jaspFile)
  dataset <- jaspTools::extractDatasetFromJASPFile(jaspFile)

  # Encode and run analysis
  encoded <- jaspTools:::encodeOptionsAndDataset(opts, dataset)
  set.seed(1)
  results <- jaspTools::runAnalysis("auditBayesianWorkflow", encoded$dataset, encoded$options, encodedDataset = TRUE)

  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(0.05, 0.05, 92, "Value", 1))

  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_tablePriorPosterior"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(0.95, "beta(<unicode> = 1, <unicode> = 1)", 0.05, 0.95, 0.5, 0.5,
     "NaN", 0.0526315789473684, "NaN", "Prior", 0.0499939783879884,
     "beta(<unicode> = 2, <unicode> = 92)", 0.950024204757383, 0.0499757952426165,
     0.0212765957446809, 0.017981081133262, 0.0108695652173913, 19.0096865921857,
     0.0391244131705971, "Posterior", -0.900006021612012, "", 19.0004840951477,
     0.0526061002553858, -0.478723404255319, -0.482018918866738,
     "NaN", 361.184045251528, "", "Shift"))

  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(92, 0.92, 92))

})

