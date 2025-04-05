context("[Audit] Model Fairness")

options <- analysisOptions("auditClassicalModelFairness")
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
options$concentration <- 1
options$confusionTable <- TRUE
options$comparisonsTable <- TRUE
options$robustnessPlot <- TRUE
options$sequentialPlot <- TRUE
set.seed(1)
results <- runAnalysis("auditClassicalModelFairness", "compas.csv", options)

test_that("<b>Table 2.</b> Comparisons to Privileged (P) Group results match", {
  table <- results[["results"]][["fairnessContainer"]][["collection"]][["fairnessContainer_comparisonsTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      "Caucasian (P)", 0.577380952380952, 0.539016994145188, 0.615062397142818,
      "", 1, "", "", "African_American", 0.665247472059606, 0.643398855100595,
      0.68657904230498, 5.45234228945624e-05, 1.15218118872179, 1.11434028512268,
      1.1891265887344, "Asian", 0.5, 0.067585986488543, 0.932414013511457,
      1, 0.865979381443299, 0.117056141547167, 1.61490262133943, "Hispanic",
      0.590604026845638, 0.507146644057434, 0.670384316336254, 0.783925669127255,
      1.02290181969141, 0.878357074243804, 1.16107799118032, "Native_American",
      0.6, 0.146632799634673, 0.947255049473683, 1, 1.03917525773196,
      0.253961962253867, 1.64060668362452, "Other", 0.611764705882353,
      0.499883743058991, 0.715621551172544, 0.56209502916255, 1.05955124317768,
      0.865778029215573, 1.23942701646379
    )
  )
})

# Commented out because BF is not enabled
# test_that("<b>Table 2.</b> Comparisons to Privileged (P) Group results match", {
#   table <- results[["results"]][["fairnessContainer"]][["collection"]][["fairnessContainer_comparisonsTable"]][["data"]]
#   jaspTools::expect_equal_tables(
#     table,
#     list(
#       "", "Caucasian (P)", 0.577380952380952, 0.539016994145188, 0.615062397142818,
#       "", 1, "", "", 231.16495878369, "African_American", 0.665247472059606,
#       0.643398855100595, 0.68657904230498, 5.45234228945624e-05, 1.15218118872179,
#       1.11434028512268, 1.1891265887344, 0.0246144155687338, "Asian",
#       0.5, 0.067585986488543, 0.932414013511457, 1, 0.865979381443299,
#       0.117056141547167, 1.61490262133943, 0.103700796473506, "Hispanic",
#       0.590604026845638, 0.507146644057434, 0.670384316336254, 0.783925669127255,
#       1.02290181969141, 0.878357074243804, 1.16107799118032, 0.0255337438083833,
#       "Native_American", 0.6, 0.146632799634673, 0.947255049473683,
#       1, 1.03917525773196, 0.253961962253867, 1.64060668362452, 0.101060279359127,
#       "Other", 0.611764705882353, 0.499883743058991, 0.715621551172544,
#       0.56209502916255, 1.05955124317768, 0.865778029215573, 1.23942701646379
#     )
#   )
# })

test_that("<b>Table 4.</b> Confusion Matrix results match", {
  table <- results[["results"]][["fairnessContainer"]][["collection"]][["fairnessContainer_confusionTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      "African_American", 0.665247472059606, "no", 885, 629, "", "",
      "yes", 411, 1250, "Asian", 0.5, "no", 21, 2, "", "", "yes",
      6, 2, "Caucasian", 0.577380952380952, "no", 997, 284, "", "",
      "yes", 434, 388, "Hispanic", 0.590604026845638, "no", 259, 61,
      "", "", "yes", 101, 88, "Native_American", 0.6, "no", 4, 2,
      "", "", "yes", 2, 3, "Other", 0.611764705882353, "no", 186,
      33, "", "", "yes", 72, 52
    )
  )
})

test_that("Parity Estimates Plot matches", {
  plotName <- results[["results"]][["fairnessContainer"]][["collection"]][["fairnessContainer_parityPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "parity-estimates-plot")
})

test_that("<b>Table 3.</b> Model Performance results match", {
  table <- results[["results"]][["fairnessContainer"]][["collection"]][["fairnessContainer_performanceTable"]][["data"]]
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

# test_that("Bayes Factor Robustness Plot matches", {
#  plotName <- results[["results"]][["fairnessContainer"]][["collection"]][["fairnessContainer_robustnessPlot"]][["data"]]
#  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
#  jaspTools::expect_equal_plots(testPlot, "bayes-factor-robustness-plot")
# })
#
# test_that("Sequential Analysis Plot matches", {
#  plotName <- results[["results"]][["fairnessContainer"]][["collection"]][["fairnessContainer_sequentialPlot"]][["data"]]
#  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
#  jaspTools::expect_equal_plots(testPlot, "sequential-analysis-plot")
# })
#
# test_that("<b>Table 1.</b> Omnibus Test - Predictive Rate Parity results match", {
#  table <- results[["results"]][["fairnessContainer"]][["collection"]][["fairnessContainer_summaryTable"]][["data"]]
#  jaspTools::expect_equal_tables(
#    table,
#    list(
#      0.000714070961957615, 5, "Ethnicity", 6172, 0.00209507283665478,
#      18.7989675485203
#    )
#  )
# })
