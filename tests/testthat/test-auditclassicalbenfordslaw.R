context("[Audit] Benford's Law")

options <- jaspTools::analysisOptions("auditClassicalBenfordsLaw")
options$values <- "value"
options$benfordsLawPlot <- TRUE
options$distribution <- "benford"
options$digits <- "first"
options$bayesFactorType <- "BF10"
options$matchTable <- TRUE
options$match <- 9
set.seed(1)
results <- jaspTools::runAnalysis("auditClassicalBenfordsLaw", "sinoForest.csv", options)


test_that("Observed vs. Expected Relative Frequencies plot matches", {
  plotName <- results[["results"]][["benfordsLawContainer"]][["collection"]][["benfordsLawContainer_benfordsLawPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "observed-vs-expected-relative-frequencies")
})

test_that("<b>Table 2.</b> Frequency Table results match", {
  table <- results[["results"]][["benfordsLawContainer"]][["collection"]][["benfordsLawContainer_benfordsLawTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      231, 1, 0.301029995663981, 0.299222797927461, 124, 2, 0.176091259055681,
      0.160621761658031, 97, 3, 0.1249387366083, 0.125647668393782,
      70, 4, 0.0969100130080564, 0.0906735751295337, 64, 5, 0.0791812460476248,
      0.0829015544041451, 54, 6, 0.0669467896306132, 0.0699481865284974,
      40, 7, 0.0579919469776867, 0.0518134715025907, 54, 8, 0.0511525224473813,
      0.0699481865284974, 38, 9, 0.0457574905606751, 0.0492227979274611
    )
  )
})

test_that("<b>Table 1.</b> Goodness-of-fit Test results match", {
  table <- results[["results"]][["benfordsLawContainer"]][["collection"]][["benfordsLawContainer_benfordsLawTestTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(772, 1.4493429670676e-07, 8, 0.468206381300368, "value", 7.652)
  )
})

test_that("<b>Table 3.</b> Rows Matched to Leading Digit 9 results match", {
  table <- results[["results"]][["benfordsLawContainer"]][["collection"]][["benfordsLawContainer_matchTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      12, 9691, 30, 97030, 67, 925466, 156, 9200, 163, 9458, 179, 9714,
      185, 9699, 242, 9000, 300, 966000, 337, 9135000, 342, 91107000,
      348, 939, 351, 97077922, 353, 939000, 390, 9209102, 452, 90764,
      459, 97030000, 485, 924, 487, 924, 492, 99711, 503, 98863000,
      504, 96605000, 549, 90432000, 551, 92054000, 588, 9351000, 621,
      9684, 631, 927, 637, 9858, 645, 954194, 657, 960, 684, 9454000,
      686, 96454000, 699, 9140, 703, 913480, 708, 926507000, 711,
      925929000, 737, 96, 758, 9336
    )
  )
})
