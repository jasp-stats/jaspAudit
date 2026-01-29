context("Example: sinoForest")

# This test file was auto-generated from a JASP example file.
# The JASP file is stored in the module's examples/ folder.

test_that("auditClassicalBenfordsLaw results match", {

  # Load from JASP example file
  jaspFile <- testthat::test_path("..", "..", "examples", "sinoForest.jasp")
  opts <- jaspTools::analysisOptions(jaspFile)
  dataset <- jaspTools::extractDatasetFromJASPFile(jaspFile)

  # Encode and run analysis
  encoded <- jaspTools:::encodeOptionsAndDataset(opts, dataset)
  set.seed(1)
  results <- jaspTools::runAnalysis("auditClassicalBenfordsLaw", encoded$dataset, encoded$options, encodedDataset = TRUE)

  plotName <- results[["results"]][["benfordsLawContainer"]][["collection"]][["benfordsLawContainer_benfordsLawPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "analysis-1_figure-1_observed-vs-expected-relative-frequencies")

  table <- results[["results"]][["benfordsLawContainer"]][["collection"]][["benfordsLawContainer_benfordsLawTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(0.0415229424902467, 231, 1, 0.301029995663981, 0.299222797927461,
     0.937480194377935, 0.0635458690802664, 124, 2, 0.176091259055681,
     0.160621761658031, 0.277151207356297, 0.0299425488511425, 97,
     3, 0.1249387366083, 0.125647668393782, 0.956579169400674, 0.030854185130594,
     70, 4, 0.0969100130080564, 0.0906735751295337, 0.626267970444132,
     0.026739636123204, 64, 5, 0.0791812460476248, 0.0829015544041451,
     0.68910154007723, 0.0243154602394908, 54, 6, 0.0669467896306132,
     0.0699481865284974, 0.718708863481434, 0.0264584042014319, 40,
     7, 0.0579919469776867, 0.0518134715025907, 0.537358273015455,
     0.28990205872858, 54, 8, 0.0511525224473813, 0.0699481865284974,
     0.0218682966906594, 0.0216686653563006, 38, 9, 0.0457574905606751,
     0.0492227979274611, 0.605512438676766))

  table <- results[["results"]][["benfordsLawContainer"]][["collection"]][["benfordsLawContainer_benfordsLawTestTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(772, 1.44934296706826e-07, 8, 0.00659813521950867, 0.468206381300368,
     "jaspColumn1", 7.65174269894998))

})

