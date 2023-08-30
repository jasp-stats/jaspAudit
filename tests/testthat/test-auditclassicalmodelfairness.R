context("[Audit] Model Fairness")

options <- analysisOptions("auditClassicalModelFairness")
options$chooseMeasure <- "chooseManual"
options$parityPlot <- TRUE
options$performanceTable <- TRUE
options$positive <- "yes"
options$predictions <- "Predicted"
options$privileged <- "Caucasian"
options$protected <- "Ethnicity"
options$q1 <- "yes"
options$q2 <- "no"
options$q3 <- ""
options$q4 <- ""
options$target <- "TwoYrRecidivism"
options$bayesFactorType <- "BF10"
options$alternative <- "two.sided"
options$seed <- 1
set.seed(1)
results <- runAnalysis("auditClassicalModelFairness", "compas.csv", options)


test_that("Parity Estimates Plot matches", {
  plotName <- results[["results"]][["parityPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "parity-estimates-plot")
})

test_that("Model Performance table results match", {
  table <- results[["results"]][["performanceTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      0.67244094488189, 0.706214689265537, "African_American", 0.665247472059606,
      0.752558699578567, 3175, 0.741935483870968, 0.333333333333333,
      "Asian", 0.5, 0.25, 31, 0.658582976699952, 0.519410977242303,
      "Caucasian", 0.577380952380952, 0.472019464720195, 2103, 0.681728880157171,
      0.520710059171598, "Hispanic", 0.590604026845638, 0.465608465608466,
      509, 0.636363636363636, 0.6, "Native_American", 0.6, 0.6, 11,
      0.693877551020408, 0.497607655502392, "Other", 0.611764705882353,
      0.419354838709677, 343
    )
  )
})

test_that("Model Fairness Summary - Predictive Rate Parity table results match", {
  table <- results[["results"]][["summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      231.16495878369, "African_American", 0.665247472059606, 0.643398855100595,
      0.68657904230498, 5.45234228945624e-05, 1.15218118872179, 1.11434028512268,
      1.1891265887344, 0.0246144155687338, "Asian", 0.5, 0.067585986488543,
      0.932414013511457, 1, 0.865979381443299, 0.117056141547167,
      1.61490262133943, "", "Caucasian (P)", 0.577380952380952, 0.539016994145188,
      0.615062397142818, "", 1, "", "", 0.103700796473506, "Hispanic",
      0.590604026845638, 0.507146644057434, 0.670384316336254, 0.783925669127255,
      1.02290181969141, 0.878357074243804, 1.16107799118032, 0.0255337438083833,
      "Native_American", 0.6, 0.146632799634673, 0.947255049473683,
      1, 1.03917525773196, 0.253961962253867, 1.64060668362452, 0.101060279359127,
      "Other", 0.611764705882353, 0.499883743058991, 0.715621551172544,
      0.56209502916255, 1.05955124317768, 0.865778029215573, 1.23942701646379
    )
  )
})
