context("Example: BuildIt_Binary")

# This test file was auto-generated from a JASP example file.
# The JASP file is stored in the module's examples/ folder.

test_that("auditBayesianEvaluation results match", {

  # Load from JASP example file
  jaspFile <- testthat::test_path("..", "..", "examples", "BuildIt_Binary.jasp")
  opts <- jaspTools::analysisOptions(jaspFile)
  dataset <- jaspTools::extractDatasetFromJASPFile(jaspFile)

  # Encode and run analysis
  encoded <- jaspTools:::encodeOptionsAndDataset(opts, dataset)
  set.seed(1)
  results <- jaspTools::runAnalysis("auditBayesianEvaluation", encoded$dataset, encoded$options, encodedDataset = TRUE)

  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_evaluationTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(64.5435368372794, 0.1, 0.0294117647058824, 34, "Value", 0.0990892716354183,
     1, 0.128501036341301, 1))

  plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_plotPriorAndPosterior"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "analysis-1_figure-1_prior-and-posterior-distribution")

  table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_tablePriorPosterior"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(0.95, "beta(<unicode> = 1, <unicode> = 1)", 0.1, 0.9, 0.5, 0.5,
     "NaN", 0.111111111111111, "NaN", "Prior", 0.128501036341301,
     "beta(<unicode> = 2, <unicode> = 34)", 0.877623508644775, 0.122376491355225,
     0.0555555555555556, 0.0474909852361679, 0.0294117647058824,
     7.17150409303104, 0.0990892716354183, "Posterior", -0.821498963658699,
     "", 8.77623508644775, 0.135973879283583, -0.444444444444444,
     -0.452509014763832, "NaN", 64.5435368372794, "", "Shift"))

})

