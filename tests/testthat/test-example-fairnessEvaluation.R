context("Example: fairnessEvaluation")

# This test file was auto-generated from a JASP example file.
# The JASP file is stored in the module's examples/ folder.

test_that("auditClassicalFairness results match", {

  # Load from JASP example file
  jaspFile <- testthat::test_path("..", "..", "examples", "fairnessEvaluation.jasp")
  opts <- jaspTools::analysisOptions(jaspFile)
  dataset <- jaspTools::extractDatasetFromJASPFile(jaspFile)

  # Encode and run analysis
  encoded <- jaspTools:::encodeOptionsAndDataset(opts, dataset)
  set.seed(1)
  results <- jaspTools::runAnalysis("auditClassicalFairness", encoded$dataset, encoded$options, encodedDataset = TRUE)

  table <- results[["results"]][["fairnessContainer"]][["collection"]][["fairnessContainer_comparisonsTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list("Caucasian (P)", 0.577380952380952, 0.539016994145188, 0.615062397142818,
     "", 1, "", "", "African_American", 0.665247472059606, 0.643398855100595,
     0.68657904230498, 5.45234228945624e-05, 1.15218118872179, 1.11434028512268,
     1.1891265887344, "Asian", 0.5, 0.067585986488543, 0.932414013511457,
     1, 0.865979381443299, 0.117056141547167, 1.61490262133943, "Hispanic",
     0.590604026845638, 0.507146644057434, 0.670384316336254, 0.783925669127255,
     1.02290181969141, 0.878357074243804, 1.16107799118032, "Native_American",
     0.6, 0.146632799634673, 0.947255049473683, 1, 1.03917525773196,
     0.253961962253867, 1.64060668362452, "Other", 0.611764705882353,
     0.499883743058991, 0.715621551172544, 0.56209502916255, 1.05955124317768,
     0.865778029215573, 1.23942701646379))

  table <- results[["results"]][["fairnessContainer"]][["collection"]][["fairnessContainer_confusionTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list("African_American", 0.665247472059606, "no", 885, 629, "", "",
     "yes", 411, 1250, "Asian", 0.5, "no", 21, 2, "", "", "yes",
     6, 2, "Caucasian", 0.577380952380952, "no", 997, 284, "", "",
     "yes", 434, 388, "Hispanic", 0.590604026845638, "no", 259, 61,
     "", "", "yes", 101, 88, "Native_American", 0.6, "no", 4, 2,
     "", "", "yes", 2, 3, "Other", 0.611764705882353, "no", 186,
     33, "", "", "yes", 72, 52))

  table <- results[["results"]][["fairnessContainer"]][["collection"]][["fairnessContainer_summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list(5, "jaspColumn2", 6172, 0.00209507283665478, 18.7989675485203
    ))

})

