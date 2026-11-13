context("Library: planningAndSelectingBayesian")

# This test file was auto-generated from a JASP example file.
# The JASP file is stored in tests/testthat/jaspfiles/library/.

test_that("auditClassicalPlanning (analysis 1) results match", {

  # Load from JASP example file
  jaspFile <- testthat::test_path("jaspfiles", "library", "planningAndSelectingBayesian.jasp")
  opts <- jaspTools::analysisOptions(jaspFile)[[1]]
  dataset <- jaspTools::extractDatasetFromJASPFile(jaspFile)

  # Run analysis
  set.seed(1)
  results <- jaspTools::runAnalysis("auditClassicalPlanning", dataset, opts)

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
  jaspFile <- testthat::test_path("jaspfiles", "library", "planningAndSelectingBayesian.jasp")
  opts <- jaspTools::analysisOptions(jaspFile)[[2]]
  dataset <- jaspTools::extractDatasetFromJASPFile(jaspFile)

  # Run analysis
  set.seed(1)
  results <- jaspTools::runAnalysis("auditSelection", dataset, opts)

  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableInterval"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(
      3500, 1403220.82, 93, 93, 0.0352553278107718, "Total", 49471.01, 0, 0, 0,
      0, 0, "Top stratum", 0, 3500, 1403220.82, 93, 93, 0.0352553278107718,
      "Bottom stratum", 49471.01
    ))

  table <- results[["results"]][["selectionContainer"]][["collection"]][["selectionContainer_tableSelection"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(
      93, 0.0352553278107718, 93, 49471.01
    ))

})

