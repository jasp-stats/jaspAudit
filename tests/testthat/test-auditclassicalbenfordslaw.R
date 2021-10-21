context("[Audit] Benford's Law")

options <- jaspTools::analysisOptions("auditClassicalBenfordsLaw")
options$values <- "value"
options$benfordsLawPlot <- TRUE
options$distribution <- "benford"
options$digits <- "first"
options$bayesFactorType <- "BF10"
set.seed(1)
results <- jaspTools::runAnalysis("auditClassicalBenfordsLaw", "sinoForest.csv", options)


test_that("Observed vs. Expected Relative Frequencies plot matches", {
	plotName <- results[["results"]][["benfordsLawContainer"]][["collection"]][["benfordsLawContainer_benfordsLawPlot"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "observed-vs-expected-relative-frequencies")
})

test_that("<b>Table 2.</b> Frequency Table results match", {
	table <- results[["results"]][["benfordsLawContainer"]][["collection"]][["benfordsLawContainer_benfordsLawTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(231, 1, 0.301029995663981, 0.299222797927461, 124, 2, 0.176091259055681,
			 0.160621761658031, 97, 3, 0.1249387366083, 0.125647668393782,
			 70, 4, 0.0969100130080564, 0.0906735751295337, 64, 5, 0.0791812460476248,
			 0.0829015544041451, 54, 6, 0.0669467896306132, 0.0699481865284974,
			 40, 7, 0.0579919469776867, 0.0518134715025907, 54, 8, 0.0511525224473813,
			 0.0699481865284974, 38, 9, 0.0457574905606751, 0.0492227979274611
			))
})

test_that("<b>Table 1.</b> Goodness-of-fit Test results match", {
	table <- results[["results"]][["benfordsLawContainer"]][["collection"]][["benfordsLawContainer_benfordsLawTestTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(772, 1.4493429670676e-07, 8, 0.468206381300368, "value", 7.652
			))
})
