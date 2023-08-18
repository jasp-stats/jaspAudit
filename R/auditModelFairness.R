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

auditModelFairness <- function(jaspResults, dataset, options, ...) {

  ready <- (options[["protected"]] != "" && options[["target"]] != "" && options[["predictions"]] != "" && options[["selectedRow"]] != -1)
  dataset <- .jfaFairnessReadData(dataset, options, ready)
  .jfaFairnessSummaryTable(dataset, options, jaspResults, ready)
  .jfaFairnessPerformanceTable(dataset, options, jaspResults, ready)

#   options[["Q1Selector"]] <- "yahaha"

#   .auditFMEvaluationMatrixGroup(jaspResults, options, dataset, ready, cbind(results[["levelsGroup"]], results[, c(1:4)]))
#   # calculate evaluation measures for all
#   .auditFMEvaluationMatrixAll(jaspResults, options, dataset, ready)
}

.jfaFairnessReadData <- function(dataset, options, ready) {
  if (!is.null(dataset)) {
    return(dataset)
  }
  if (ready) {
    dataset <- .readDataSetToEnd(columns.as.factor = c(options[["target"]], options[["predictions"]], options[["protected"]]))
    return(dataset)
  }
}

.jfaFairnessState <- function(dataset, options, jaspResults) {
  if (!is.null(jaspResults[["state"]])) {
    return(jaspResults[["state"]]$object)
  } else {
    result <- jfa::model_fairness(dataset, options[["protected"]], options[["target"]], options[["predictions"]], 
                                  priveleged = levels(data[[options[["protected"]]]])[options[["selectedRow"]] + 1],
                                  metric = "pp", conf.level = 0.95, prior = FALSE)
    jaspResults[["state"]] <- createJaspState(result)
    return(result)
  }
}

.jfaFairnessSummaryTable <- function(dataset, options, jaspResults, ready) {
  if (!is.null(jaspResults[["summaryTable"]])) {
    return()
  }
  tb <- createJaspTable(title = "Fairness Metrics and Parity")
  jaspResults[["summaryTable"]] <- tb
  tb$addColumnInfo(name = "group", title = "")
  tb$addColumnInfo(name = "metric", title = gettext("Metric"), type = "number")
  tb$addColumnInfo(name = "metric_lb", title = gettext("Lower"), type = "number", overtitle = gettext("95% CI"))
  tb$addColumnInfo(name = "metric_ub", title = gettext("Upper"), type = "number", overtitle = gettext("95% CI"))
  tb$addColumnInfo(name = "parity", title = gettext("Parity"), type = "number")
  tb$addColumnInfo(name = "parity_lb", title = gettext("Lower"), type = "number", overtitle = gettext("95% CI"))
  tb$addColumnInfo(name = "parity_ub", title = gettext("Upper"), type = "number", overtitle = gettext("95% CI"))
  tb$addColumnInfo(name = "p", title = gettext("p"), type = "pvalue")
  tb$addColumnInfo(name = "bf", title = gettextf("BF%1$s", "\u2080\u2081"), type = "number")
  if (!ready) {
    return()
  }
  result <- .jfaFairnessState(data, options, jaspResults)
}

.jfaFairnessPerformanceTable <- function(dataset, options, jaspResults, ready) {
  if (!options[["performanceTable"]] || !is.null(jaspResults[["performanceTable"]])) {
    return()
  }
  tb <- createJaspTable(title = "Model Performance")
  jaspResults[["performanceTable"]] <- tb
  tb$addColumnInfo(name = "group", title = "")
  tb$addColumnInfo(name = "support", title = gettext("Support"), type = "integer")
  tb$addColumnInfo(name = "accuracy", title = gettext("Accuracy"), type = "number")
  tb$addColumnInfo(name = "precision", title = gettext("Precision (Positive Predictive Value)"), type = "number")
  tb$addColumnInfo(name = "recall", title = gettext("Recall (True Positive Rate)"), type = "number")
  tb$addColumnInfo(name = "f1", title = gettext("F1 Score"), type = "number")
  if (!ready) {
	return()
  }
  result <- .jfaFairnessState(data, options, jaspResults)
  tb[["support"]] <- result[["performance"]][["all"]][["support"]]
  tb[["accuracy"]] <- result[["performance"]][["all"]][["accuracy"]]
  tb[["precision"]] <- result[["performance"]][["all"]][["precision"]]
  tb[["recall"]] <- result[["performance"]][["all"]][["recall"]]
  tb[["f1"]] <- result[["performance"]][["all"]][["f1.score"]]
}

.auditFMEvaluationMatrixGroup <- function(jaspResults, options, dataset, ready, results) {
  if (!is.null(jaspResults[["performanceMeasuresGroup"]]) || !options[["performanceMeasuresGroup"]]) {
    jaspResults[["performanceMeasuresGroup"]] <- NULL
    return()
  }

  tableGroup <- createJaspTable(title = "Performance Metrics per Group")

  # Bind table to jaspResults
  jaspResults[["performanceMeasuresGroup"]] <- tableGroup

  if (!ready) {
    return()
  }

  tableGroup$addColumns(results)
}

.auditFMCalcFairMeasures <- function(counts) {
  # equal amount of positive predictions in each group
  # therefore, just add up TP + FP
  demPar <- counts$tn / (counts$tp + counts$fp + counts$tn + counts$fn)
  # counts$tp for the positive class
  # counts$tn / all counts (total number of samples that belong to this sample group)
  # this is in case the negative class corresponds to the favorable outcome

  eqOdds <- counts$tp / (counts$tp + counts$fn)

  prPar <- counts$tp / (counts$tp + counts$fp)

  accPar <- (counts$tp + counts$tn) / (counts$tp + counts$fp + counts$tn + counts$fn)

  fnrPar <- counts$fn / (counts$tp + counts$fn)

  fprPar <- counts$fp / (counts$tn + counts$fp)

  npvPar <- counts$tn / (counts$tn + counts$fn)

  specPar <- counts$tn / (counts$tn + counts$fp)

  mcc <- (counts$tp * counts$tn - counts$fp * counts$fn) /
    sqrt(as.numeric(counts$tp + counts$fp) * as.numeric(counts$tp + counts$fn) *
      as.numeric(counts$tn + counts$fp) * as.numeric(counts$tn + counts$fn))

  resultsDf <- data.frame(
    demPar, eqOdds, prPar, accPar,
    fnrPar, fprPar, npvPar,
    specPar, mcc
  )
  return(resultsDf)
}

.auditFMCompareGroups <- function(all_groups_df, reference) {
  as.numeric(all_groups_df) / as.numeric(all_groups_df[reference])
}
