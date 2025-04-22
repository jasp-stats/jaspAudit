context("[Audit] True Value Estimation")

options <- jaspTools::analysisOptions("auditClassicalEstimation")
options$auditValues <- "Werkelijk"
options$bookValues <- "Waarde"
options$estimator <- "regression"
options$populationSize <- 1000
options$populationValue <- 769458
options$requiredSampleSizeTable <- TRUE
options$requiredUncertainty <- 25000
set.seed(1)
results <- jaspTools::runAnalysis("auditClassicalEstimation", "estimation.csv", options)

test_that("Regression Estimator table results match", {
  table <- results[["results"]][["regressionTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(754494.24, 723938.11, 30556.13, 785050.37)
  )
})

test_that("Required Sample Size table results match", {
  table <- results[["results"]][["requiredSampleSizeTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(73, 50, 23, 30556.13, 25000)
  )
})
