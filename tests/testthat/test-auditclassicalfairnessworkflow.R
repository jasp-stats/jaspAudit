context("[Audit] Classical Fairness Workflow")

options <- analysisOptions("auditClassicalFairnessWorkflow")
options$alternative <- "two.sided"
options$comparisonsTable <- TRUE
options$concentration <- 1
options$conf_level <- 0.95
options$confusionTable <- TRUE
options$confusionTableProportions <- FALSE
options$confusionTableTransposed <- FALSE
options$evaluationChecked <- TRUE
options$explanatoryText <- TRUE
options$firstquestion <- "firstquestion_yes"
options$fourthquestion_caseA <- "fourthquestion_caseA_FP"
options$fourthquestion_caseB <- "fourthquestion_caseB_FP"
options$fourthquestion_caseC <- "fourthquestion_caseC_FP"
options$parityPlot <- TRUE
options$performanceTable <- TRUE
options$positive <- "yes"
options$posteriorPlot <- FALSE
options$predictions <- "Predicted"
options$privileged <- "Male"
options$protected <- "Gender"
options$robustnessPlot <- FALSE
options$secondquestion <- "secondquestion_correct"
options$seed <- 35
options$sequentialPlot <- FALSE
options$target <- "TwoYrRecidivism"
options$thirdquestion <- "thirdquestion_positive"
set.seed(1)
results <- runAnalysis("auditClassicalFairnessWorkflow", "compas.csv", options)


test_that("<b>Table 2.</b> Comparisons to Privileged (P) Group results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_comparisonsTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("Male (P)", 0.642716146861429, 0.623700702880261, 0.661401080604867,
			 "", 1, "", "", "Female", 0.593869731800766, 0.531585986504689,
			 0.653996486583677, 0.120175319975637, 0.924000018827605, 0.827092938462148,
			 1.01755104454328))
})

test_that("<b>Table 4.</b> Confusion Matrix results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_confusionTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list("Female", 0.593869731800766, "no", 656, 106, "", "", "yes", 258,
			 155, "Male", 0.642716146861429, "no", 1696, 905, "", "", "yes",
			 768, 1628))
})

test_that("Parity Estimates Plot matches", {
	plotName <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_parityPlot"]][["data"]]
	testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
	jaspTools::expect_equal_plots(testPlot, "parity-estimates-plot")
})

test_that("<b>Table 3.</b> Model Performance results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_performanceTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(0.690212765957447, 0.459940652818991, "Female", 0.593869731800766,
			 0.375302663438257, 1175, 0.665199119471683, 0.660580239399472,
			 "Male", 0.642716146861429, 0.679465776293823, 4997))
})

test_that("<b>Table 1.</b> Omnibus Test - Predictive rate parity results match", {
	table <- results[["results"]][["evaluationContainer"]][["collection"]][["evaluationContainer_summaryTable"]][["data"]]
	jaspTools::expect_equal_tables(table,
		list(1, "Gender", 6172, 0.134658353661447, 2.23796205515652))
})
