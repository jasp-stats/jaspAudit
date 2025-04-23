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
    list(754494.24, 728909.89, 25584.35, 780078.59)
  )
})

test_that("Required Sample Size table results match", {
  table <- results[["results"]][["requiredSampleSizeTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(53, 50, 3, 25584.35, 25000)
  )
})
