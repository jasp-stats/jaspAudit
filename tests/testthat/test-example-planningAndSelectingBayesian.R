context("Example: planningAndSelectingBayesian")

# This test file was auto-generated from a JASP example file.
# The JASP file is stored in the module's examples/ folder.

test_that("auditClassicalPlanning (analysis 1) results match", {

  # Load from JASP example file
  jaspFile <- testthat::test_path("..", "..", "examples", "planningAndSelectingBayesian.jasp")
  opts <- jaspTools::analysisOptions(jaspFile)[[1]]
  dataset <- jaspTools::extractDatasetFromJASPFile(jaspFile)

  # Encode and run analysis
  encoded <- jaspTools:::encodeOptionsAndDataset(opts, dataset)
  set.seed(1)
  results <- jaspTools::runAnalysis("auditClassicalPlanning", encoded$dataset, encoded$options, encodedDataset = TRUE)

  table <- results[["results"]][["ARMcontainer"]][["collection"]][["ARMcontainer_table"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(0, 0, 0, 1, "High", 1, 1, 0.5, "Medium", 0.52, 0.63, 0.25, "Low",
     0.34, 0.4))

  table <- results[["results"]][["planningContainer"]][["collection"]][["planningContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(1, 1, 0.05, 1, 0.05, 93, "Value", 0.93))

})

test_that("auditSelection (analysis 2) results match", {

  # Load from JASP example file
  jaspFile <- testthat::test_path("..", "..", "examples", "planningAndSelectingBayesian.jasp")
  opts <- jaspTools::analysisOptions(jaspFile)[[2]]
  dataset <- jaspTools::extractDatasetFromJASPFile(jaspFile)

  # Encode and run analysis
  encoded <- jaspTools:::encodeOptionsAndDataset(opts, dataset)
  set.seed(1)
  results <- jaspTools::runAnalysis("auditSelection", encoded$dataset, encoded$options, encodedDataset = TRUE)

  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(3500, 1403220.82, 93, 93, 0.033977738443191, "Total", 47678.27,
     0, 0, 0, 0, 0, "Top stratum", 0, 3500, 1403220.82, 93, 93, 0.033977738443191,
     "Bottom stratum", 47678.27))

  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(93, 0.033977738443191, 93, 47678.27))

})

