context("[Audit] True Value Estimation")

# Direct estimator

options <- jaspTools::analysisOptions("auditClassicalEstimation")
options$auditValues <- "Werkelijk"
options$bookValues <- "Waarde"
options$estimator <- "mpu"
options$populationSize <- 1000
options$populationValue <- 769458
options$requiredSampleSizeTable <- TRUE
options$requiredUncertainty <- 11000
options$explanatoryText <- TRUE
options$confidence <- 0.95
options$correlationPlot <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditClassicalEstimation", "estimation.csv", options)

test_that("Direct Estimator table results match", {
  table <- results[["results"]][["regressionTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(815398.066666667, 715394.33617263, 100003.730494036, 915401.797160703)
  )
})

test_that("Required Sample Size table results match", {
  table <- results[["results"]][["requiredSampleSizeTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(936, 150, 786, 100003.730494036, 11000)
  )
})

# Difference estimator

options <- jaspTools::analysisOptions("auditClassicalEstimation")
options$auditValues <- "Werkelijk"
options$bookValues <- "Waarde"
options$estimator <- "difference"
options$populationSize <- 1000
options$populationValue <- 769458
options$requiredSampleSizeTable <- TRUE
options$requiredUncertainty <- 11000
options$explanatoryText <- TRUE
options$confidence <- 0.95
options$correlationPlot <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditClassicalEstimation", "estimation.csv", options)

test_that("Difference Estimator table results match", {
  table <- results[["results"]][["regressionTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(757283.8, 745451.349914362, 11832.4500856379, 769116.250085638)
  )
})

test_that("Required Sample Size table results match", {
  table <- results[["results"]][["requiredSampleSizeTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(170, 150, 20, 11832.4500856379, 11000)
  )
})

# Ratio estimator

options <- jaspTools::analysisOptions("auditClassicalEstimation")
options$auditValues <- "Werkelijk"
options$bookValues <- "Waarde"
options$estimator <- "ratio"
options$populationSize <- 1000
options$populationValue <- 769458
options$requiredSampleSizeTable <- TRUE
options$requiredUncertainty <- 11000
options$explanatoryText <- TRUE
options$confidence <- 0.95
options$correlationPlot <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditClassicalEstimation", "estimation.csv", options)

test_that("Ratio Estimator table results match", {
  table <- results[["results"]][["regressionTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(758138.703835895, 746238.969950351, 11899.7338855431, 770038.437721438)
  )
})

test_that("Required Sample Size table results match", {
  table <- results[["results"]][["requiredSampleSizeTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(172, 150, 22, 11899.7338855431, 11000)
  )
})

# Regression estimator

options <- jaspTools::analysisOptions("auditClassicalEstimation")
options$auditValues <- "Werkelijk"
options$bookValues <- "Waarde"
options$estimator <- "regression"
options$populationSize <- 1000
options$populationValue <- 769458
options$requiredSampleSizeTable <- TRUE
options$requiredUncertainty <- 11000
options$explanatoryText <- TRUE
options$confidence <- 0.95
options$correlationPlot <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditClassicalEstimation", "estimation.csv", options)

test_that("Regression Estimator table results match", {
  table <- results[["results"]][["regressionTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(757392.591641175, 745561.607394658, 11830.9842465169, 769223.575887692)
  )
})

test_that("Required Sample Size table results match", {
  table <- results[["results"]][["requiredSampleSizeTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(170, 150, 20, 11830.9842465169, 11000)
  )
})
