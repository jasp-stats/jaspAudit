context("[Audit] Benford's Law")

options <- jaspTools::analysisOptions("auditClassicalBenfordsLaw")
options$values <- "value"
options$benfordsLawPlot <- TRUE
options$distribution <- "benford"
options$digits <- "first"
options$bayesFactorType <- "BF10"
set.seed(1)
results <- jaspTools::runAnalysis("auditClassicalBenfordsLaw", "sinoForest.csv", options)


test_that("Observed Percentages vs. Expected Percentages plot matches", {
  plotName <- results[["results"]][["benfordsLawContainer"]][["collection"]][["benfordsLawContainer_benfordsLawPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "observed-percentages-vs-expected-percentages")
})

test_that("<b>Table 2.</b> Frequency Statistics results match", {
  table <- results[["results"]][["benfordsLawContainer"]][["collection"]][["benfordsLawContainer_benfordsLawTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      231, 1, "30.1%", "29.92%", 124, 2, "17.61%", "16.06%", 97, 3,
      "12.49%", "12.56%", 70, 4, "9.69%", "9.07%", 64, 5, "7.92%",
      "8.29%", 54, 6, "6.69%", "6.99%", 40, 7, "5.8%", "5.18%", 54,
      8, "5.12%", "6.99%", 38, 9, "4.58%", "4.92%"
    )
  )
})

test_that("<b>Table 1.</b> Goodness-of-fit Test results match", {
  table <- results[["results"]][["benfordsLawContainer"]][["collection"]][["benfordsLawContainer_benfordsLawTestTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(772, 1.4493429670676e-07, 8, 0.468206381300367, "value", 7.652)
  )
})
