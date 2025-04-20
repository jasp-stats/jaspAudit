context("[Audit] Benford's Law")

options <- jaspTools::analysisOptions("auditClassicalBenfordsLaw")
options$values <- "value"
options$benfordsLawPlot <- TRUE
options$distribution <- "benford"
options$digits <- "first"
options$bayesFactorType <- "BF10"
options$matchTable <- TRUE
options$match <- 9
options$concentration <- 1
options$confidenceInterval <- TRUE
options$expectedCounts <- TRUE
options$robustnessPlot <- TRUE
options$sequentialPlot <- TRUE
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
      0.0415229424902467, 231, 1, 0.301029995663981, 232.395156652593,
      0.267092227600401, 0.299222797927461, 0.937480194377935, 0.332895545592227,
      0.0635458690802664, 124, 2, 0.176091259055681, 135.942451990986,
      0.135408813935099, 0.160621761658031, 0.277151207356297, 0.188457707689031,
      0.0299425488511425, 97, 3, 0.1249387366083, 96.4527046616076,
      0.103084733432614, 0.125647668393782, 0.956579169400674, 0.151113589359132,
      0.030854185130594, 70, 4, 0.0969100130080564, 74.8145300422196,
      0.0713657011979488, 0.0906735751295337, 0.626267970444132, 0.1131723389419,
      0.026739636123204, 64, 5, 0.0791812460476248, 61.1279219487664,
      0.0644274771826673, 0.0829015544041451, 0.68910154007723, 0.104632349633987,
      0.0243154602394908, 54, 6, 0.0669467896306132, 51.6829215948334,
      0.0529806795549406, 0.0699481865284974, 0.718708863481435, 0.0902845382033494,
      0.0264584042014319, 40, 7, 0.0579919469776867, 44.7697830667742,
      0.0372708039500887, 0.0518134715025907, 0.537358273015455, 0.0698899020082103,
      0.289902058728581, 54, 8, 0.0511525224473813, 39.4897473293784,
      0.0529806795549406, 0.0699481865284974, 0.0218682966906594,
      0.0902845382033494, 0.0216686653563006, 38, 9, 0.0457574905606751,
      35.3247827128412, 0.0350650519475953, 0.0492227979274611, 0.605512438676766,
      0.066939022957015
    )
  )
})

test_that("<b>Table 1.</b> Omnibus Test - Benford's Law results match", {
  table <- results[["results"]][["benfordsLawContainer"]][["collection"]][["benfordsLawContainer_benfordsLawTestTable"]][["data"]]
  jaspTools::expect_equal_tables(
    table,
    list(
      772, 1.44934296706826e-07, 8, 0.00659813521950867, 0.468206381300368,
      "value", 7.65174269894998
    )
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

test_that("Bayes Factor Robustness Plot matches", {
  plotName <- results[["results"]][["benfordsLawContainer"]][["collection"]][["benfordsLawContainer_robustnessPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "bayes-factor-robustness-plot")
})

test_that("Sequential Analysis Plot matches", {
  plotName <- results[["results"]][["benfordsLawContainer"]][["collection"]][["benfordsLawContainer_sequentialPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "sequential-analysis-plot")
})
