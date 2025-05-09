context("[Audit] Bayesian True Value Estimation")

# Direct estimator

options <- jaspTools::analysisOptions("auditBayesianEstimation")
options$auditValues <- "Werkelijk"
options$bookValues <- "Waarde"
options$estimator <- "mpu"
options$populationSize <- 1000
options$populationValue <- 769458
options$explanatoryText <- TRUE
options$confidence <- 0.95
options$correlationPlot <- FALSE
options$priorAndPosteriorPlot <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianEstimation", "estimation.csv", options)

test_that("Direct Estimator table results match", {
  table <- results[["results"]][["summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(815398.066666667, 699530.415390775, 115867.651275891, 931265.717942558)
  )
})

# Difference estimator

options <- jaspTools::analysisOptions("auditBayesianEstimation")
options$auditValues <- "Werkelijk"
options$bookValues <- "Waarde"
options$estimator <- "difference"
options$populationSize <- 1000
options$populationValue <- 769458
options$explanatoryText <- TRUE
options$confidence <- 0.95
options$correlationPlot <- FALSE
options$priorAndPosteriorPlot <- TRUE
options$priorMu <- 30
options$priorKappa <- 150
options$priorNu <- 150
options$priorSigma2 <- 5000
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianEstimation", "estimation.csv", options)

test_that("Prior and Posterior Distribution plot matches", {
  plotName <- results[["results"]][["posteriorPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-and-posterior-distribution")
})

test_that("Bayesian Difference Estimator table results match", {
  table <- results[["results"]][["summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(748370.9, 738574.290320705, 9796.60967929545, 758167.509679295)
  )
})

# Ratio estimator

options <- jaspTools::analysisOptions("auditBayesianEstimation")
options$auditValues <- "Werkelijk"
options$bookValues <- "Waarde"
options$estimator <- "ratio"
options$populationSize <- 1000
options$populationValue <- 769458
options$explanatoryText <- TRUE
options$confidence <- 0.95
options$correlationPlot <- FALSE
options$priorAndPosteriorPlot <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianEstimation", "estimation.csv", options)

test_that("Ratio Estimator table results match", {
  table <- results[["results"]][["summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(760959.912828661, 748177.445523007, 12782.4673056537, 773742.380134315)
  )
})

# Regression estimator

options <- jaspTools::analysisOptions("auditBayesianEstimation")
options$auditValues <- "Werkelijk"
options$bookValues <- "Waarde"
options$estimator <- "regression"
options$populationSize <- 1000
options$populationValue <- 769458
options$explanatoryText <- TRUE
options$confidence <- 0.95
options$correlationPlot <- FALSE
options$priorAndPosteriorPlot <- FALSE
set.seed(1)
results <- jaspTools::runAnalysis("auditBayesianEstimation", "estimation.csv", options)

test_that("Regression Estimator table results match", {
  table <- results[["results"]][["summaryTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(757392.591641175, 744560.540015853, 12832.051625322, 770224.643266497)
  )
})
