#
# Copyright (C) 2013-2018 University of Amsterdam
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#
# When making changes to this file always mention @koenderks as a
# reviewer in the pull Request.


#DOE ALLES ONDER AUDIT OF ALGORITHMS
#AUDIT OF FINANCIAL STATEMENS
#AUDIT OF DATA

auditFairnessMeasures <- function(jaspResults, dataset, options, ...) {

  #x <- jfa::fairness()

  ready <- (options[["group"]] != "" &&
              options[["actual"]]      != "" &&
              options[["predicted"]]   != "" &&
              options[["selectedRow"]] != -1 )

  dataset <- .auditFMReadData(dataset, options, ready)
  results <- .auditFMComputeResults(dataset, options, ready)

  options[["Q1Selector"]] <- "yahaha"

  # Compute results and create the model summary table
  #.mlClassificationTableMetrics(dataset, options, jaspResults, ready, position = 2)

  #.auditFMClassificationTableSummary(dataset, options, jaspResults, ready, position = 1, type = "neuralnet")
  .auditFMCreateTable(jaspResults, options, dataset, ready, results[, -c(1:4)])

  #calculate evaluation measures per group

  .auditFMEvaluationMatrixGroup(jaspResults, options, dataset, ready, cbind(results[["levelsGroup"]], results[, c(1:4)]))
  #calculate evaluation measures for all
  .auditFMEvaluationMatrixAll(jaspResults, options, dataset, ready)

}

.auditFMReadData<- function(dataset, options, ready){
  if (!is.null(dataset)) {
    return(dataset)
  }

  if (ready) {
    dataset <- .readDataSetToEnd(columns.as.numeric = c(options[["predicted"]], options[["actual"]]),
                                 columns.as.factor= options[["group"]])
    return(dataset)
  }
}

#maak functie waarin results <- .auditFMComputeResults
.auditFMCreateTable <- function(jaspResults, options, dataset, ready, results){
  tb <- createJaspTable("Comparison of Fairness Measures Between Groups")

  jaspResults[["FMtable"]] <- tb

  if (!ready){
    return ()
  }

  #df<- read.csv("~/jaspAudit/R/measuresdict.csv")
  df<- data.frame(id = c("demPar", "accPar"), "q1" = c("rep","err"), "q2" = c("a","b"), "q3" = c("c","d"))

  subset <- subset(df, (q1 == options[["q1"]] & q2 == options[["q2"]] & q3 == options[["q3"]]))[["id"]]
  if (length(subset) != 0){
    results<- results[c("levelsGroup", subset)]
  }
  # if (options[["q1"]]=="representation" && options[["q2"]] != "q2option1" && options[["q2"]] != "q2option2")){
  #   results <- results[c("levelsGroup", "demPar")]
  # }
  # else if (options[["q1"]]=="errors"&& (options[["q2"]] != "q2option1" && options[["q2"]] != "q2option2")){
  #   results <- results[c("levelsGroup", "accPar")]
  # }



  tb$addColumns(results)
}

.auditFMEvaluationMatrixGroup <- function(jaspResults, options, dataset, ready, results){
  if (!is.null(jaspResults[["performanceMeasuresGroup"]]) || !options[["performanceMeasuresGroup"]]) {
    jaspResults[["performanceMeasuresGroup"]] <- NULL
    return()
  }

  tableGroup <- createJaspTable(title = "Performance Metrics per Group")

  # Bind table to jaspResults
  jaspResults[["performanceMeasuresGroup"]] <- tableGroup

  if (!ready){
    return ()
  }

  tableGroup$addColumns(results)
}

.auditFMEvaluationMatrixAll <- function(jaspResults, options, dataset, ready){
  if (!is.null(jaspResults[["performanceMeasuresAll"]]) || !options[["performanceMeasuresAll"]]) {
    jaspResults[["performanceMeasuresAll"]] <- NULL
    return()
  }

  tableAll <- createJaspTable(title = "Performance Metrics for Whole Dataset")

  jaspResults[["performanceMeasuresAll"]] <- tableAll

  if (!ready){
    return ()
  }

  cf <- .auditFMCreateCM(dataset, options[["predicted"]], options[["actual"]])
  counts <- .auditFMGetCounts(cf)
  results<- .auditFMEvalMeasures(counts)

  tableAll$addColumnInfo(name = "", title = gettext(""))
  tableAll$addColumnInfo(name = "accuracy", title = gettext("Accuracy"), type = "number")
  tableAll$addColumnInfo(name = "precision", title = gettext("Precision (Positive Predictive Value)"), type = "number")
  tableAll$addColumnInfo(name = "recall", title = gettext("Recall (True Positive Rate)"), type = "number")
  tableAll$addColumnInfo(name = "f1", title = gettext("F1 Score"), type = "number")

  tableAll[["accuracy"]] <- results[["accuracy"]]
  tableAll[["precision"]] <- results[["precision"]]
  tableAll[["recall"]] <- results[["recall"]]
  tableAll[["f1"]] <- results[["f1"]]

  tableAll$transpose <- TRUE
}

.auditFMCreateCM <- function(df, actual_col, pred_col){
  act <- (df[[actual_col]])
  pred <- (df[[pred_col]])
  return(table(factor(act), factor(pred)))
  #table(factor(act), factor(pred))
}

.auditFMGetCounts <- function(confusion_matrix){
  tp  <- confusion_matrix[2,2]
  fp <- confusion_matrix[2,1]
  fn <- confusion_matrix[1,2]
  tn  <- confusion_matrix[1,1]
  counts <- data.frame(tp, fp, tn, fn)
  return(counts)
}

.auditFMEvalMeasures <- function(counts){
  accuracy <-  (counts$tp + counts$tn) / (counts$tp + counts$fn + counts$fp + counts$tn)
  precision <- counts$tp / (counts$tp + counts$fp)
  recall <- counts$tp / (counts$tp + counts$fn)
  f1 <- 2 * ((precision * recall) / (precision + recall))

  resultsDf<- data.frame(accuracy, precision, recall, f1)

  return(resultsDf)
}

.auditFMCalcFairMeasures <- function(counts){
  #equal amount of positive predictions in each group
  #therefore, just add up TP + FP
  demPar <- counts$tn/(counts$tp + counts$fp + counts$tn + counts$fn)
  #counts$tp for the positive class
  #counts$tn / all counts (total number of samples that belong to this sample group)
  #this is in case the negative class corresponds to the favorable outcome

  eqOdds <- counts$tp / (counts$tp + counts$fn)

  prPar <- counts$tp / (counts$tp + counts$fp)

  accPar <- (counts$tp + counts$tn) / (counts$tp + counts$fp + counts$tn + counts$fn)

  fnrPar <- counts$fn / (counts$tp + counts$fn)

  fprPar <- counts$fp / (counts$tn + counts$fp)

  npvPar <- counts$tn / (counts$tn + counts$fn)

  specPar <- counts$tn / (counts$tn + counts$fp)

  mcc <- (counts$tp * counts$tn - counts$fp * counts$fn)/
    sqrt(as.numeric(counts$tp + counts$fp) * as.numeric(counts$tp + counts$fn) *
           as.numeric(counts$tn + counts$fp)*as.numeric(counts$tn +counts$fn))

  resultsDf <- data.frame(demPar, eqOdds, prPar, accPar,
                          fnrPar, fprPar, npvPar,
                          specPar, mcc)
  return (resultsDf)
}

.auditFMCompareGroups <- function(all_groups_df, reference){
  as.numeric(all_groups_df)/as.numeric(all_groups_df[reference])
}

.auditFMComputeResults <- function(data, options, ready)
{

  group<- options[["group"]]
  predCol<- options[["predicted"]]
  actualCol<- options[["actual"]]
  ref<- options[["selectedRow"]]

  if (!ready) {
    ref = 0
  }

  allMeasures <- data.frame()
  evalMeasures <- data.frame()
  #for each group in the dataset, calculate the confusion matrix, counts and fairness measures
  for (level in levels(factor(data[[group]]))){
    #group the data based on the specified group (e.g race)
    oneGroup <- subset(data, data[[group]] == level)

    #create confusion matrix and get counts
    cf <- .auditFMCreateCM(oneGroup, predCol, actualCol)
    counts <- .auditFMGetCounts(cf)

    #calculate the fairness measures per group
    oneGroupMeasures <- .auditFMCalcFairMeasures(counts)
    oneGroupEval<- .auditFMEvalMeasures(counts)

    #combine every measure from a single group to one dataframe
    allMeasures<- rbind(allMeasures, oneGroupMeasures)
    evalMeasures<- rbind(evalMeasures, oneGroupEval)
  }

  # get all the levels for the specified group
  levelsGroup <- levels(as.factor(data[[group]]))

  #get the index of the referenced level
  #lev_index <- match(levelsGroup[ref, ], levelsGroup)
  lev_index <- ref + 1L

  # if (options[["q1"]][["q1option1"]]){
  #   allMeasures<- allMeasures[[options[["q1"]][["q1option1"]]]]
  # }

  #compare the fairness measures of the referenced group with other groups
  results <- apply(allMeasures[, names(allMeasures) != "groups"], 2, .auditFMCompareGroups, reference = lev_index)

  if (ready) {
    results <- data.frame(apply(results, 2, signif, digits = 2))
    results <- cbind(data.frame(levelsGroup), results)
    results <- cbind(evalMeasures, results)
  }

  results

}




#een maat moet er makkelijk bij kunne
#voorbeeld" in de audit, is er dan iets waar iemand
#jfa::functienaam
