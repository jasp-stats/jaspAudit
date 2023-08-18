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

  ready <- (options[["protected"]] != "" && options[["target"]] != "" && options[["predictions"]] != "" && options[["privileged"]] != "none" && options[["positive"]] != "none")
  dataset <- .jfaFairnessReadData(dataset, options, ready)
  .jfaFairnessSummaryTable(dataset, options, jaspResults, ready)
  .jfaFairnessPerformanceTable(dataset, options, jaspResults, ready)
  .jfaFairnessParityPlot(dataset, options, jaspResults, ready)
  .jfaFairnessPosteriorPlot(dataset, options, jaspResults, ready)
}

.jfaFairnessCommonOptions <- function() {
  opt <- c("target", "predictions", "protected", "metric", "conf_level", "privileged", "positive")
  return(opt)
}

.jfaFairnessGetMetricFromQuestion <- function(options) {
  out <- list()
  out[["metric"]] <- options[["metric"]]
  out[["title"]] <- switch(options[["metric"]], "pp" = "Proportion", "sp" = "Specificity")
  return(out)
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
    result <- list()
    result[["frequentist"]] <- jfa::model_fairness(dataset = dataset, protected = options[["protected"]], target = options[["target"]], predictions = options[["predictions"]], 
                                  privileged = options[["privileged"]], positive = options[["positive"]],
                                  metric = .jfaFairnessGetMetricFromQuestion(options)[["metric"]],
                                  conf.level = options[["conf_level"]], prior = FALSE)
    result[["bayesian"]] <- jfa::model_fairness(dataset, options[["protected"]], options[["target"]], options[["predictions"]], 
                                  privileged = options[["privileged"]], positive = options[["positive"]],
                                  metric = .jfaFairnessGetMetricFromQuestion(options)[["metric"]],
                                  conf.level = options[["conf_level"]], prior = TRUE)
    jaspResults[["state"]] <- createJaspState(result)
    jaspResults[["state"]]$dependOn(options = .jfaFairnessCommonOptions())
    return(result)
  }
}

.jfaFairnessSummaryTable <- function(dataset, options, jaspResults, ready) {
  if (!is.null(jaspResults[["summaryTable"]])) {
    return()
  }
  tb <- createJaspTable(title = "Algorithmic Fairness Summary")
  tb$dependOn(options = .jfaFairnessCommonOptions())
  tb$addColumnInfo(name = "group", title = "", type = "string")
  metric <- .jfaFairnessGetMetricFromQuestion(options)
  tb$addColumnInfo(name = "metric", title = metric[["title"]], type = "number")
  tb$addColumnInfo(name = "metric_lb", title = gettext("Lower"), type = "number", overtitle = gettext("95% CI"))
  tb$addColumnInfo(name = "metric_ub", title = gettext("Upper"), type = "number", overtitle = gettext("95% CI"))
  tb$addColumnInfo(name = "parity", title = gettext("Parity"), type = "number")
  tb$addColumnInfo(name = "parity_lb", title = gettext("Lower"), type = "number", overtitle = gettext("95% CI"))
  tb$addColumnInfo(name = "parity_ub", title = gettext("Upper"), type = "number", overtitle = gettext("95% CI"))
  tb$addColumnInfo(name = "p", title = gettext("p"), type = "pvalue")
  tb$addColumnInfo(name = "bf", title = gettextf("BF%1$s", "\u2080\u2081"), type = "number")
  jaspResults[["summaryTable"]] <- tb
  if (!ready) {
    return()
  }
  result <- .jfaFairnessState(dataset, options, jaspResults)
  tb[["group"]] <- rownames(result[["frequentist"]][["metric"]][["all"]])
  tb[["metric"]] <- result[["frequentist"]][["metric"]][["all"]][["estimate"]]
  tb[["metric_lb"]] <- result[["frequentist"]][["metric"]][["all"]][["lb"]]
  tb[["metric_ub"]] <- result[["frequentist"]][["metric"]][["all"]][["ub"]]
  tb[["parity"]] <- result[["frequentist"]][["parity"]][["all"]][["estimate"]]
  tb[["parity_lb"]] <- result[["frequentist"]][["parity"]][["all"]][["lb"]]
  tb[["parity_ub"]] <- result[["frequentist"]][["parity"]][["all"]][["ub"]]
  tb[["p"]] <- result[["frequentist"]][["odds.ratio"]][["all"]][["p.value"]]
  tb[["bf"]] <- result[["bayesian"]][["odds.ratio"]][["all"]][["bf10"]]
}

.jfaFairnessPerformanceTable <- function(dataset, options, jaspResults, ready) {
  if (!options[["performanceTable"]] || !is.null(jaspResults[["performanceTable"]])) {
    return()
  }
  tb <- createJaspTable(title = "Model Performance")
  tb$dependOn(options = c(.jfaFairnessCommonOptions(), "performanceTable"))
  tb$addColumnInfo(name = "group", title = "", type = "string")
  tb$addColumnInfo(name = "support", title = gettext("Support"), type = "integer")
  tb$addColumnInfo(name = "accuracy", title = gettext("Accuracy"), type = "number")
  tb$addColumnInfo(name = "precision", title = gettext("Precision"), type = "number")
  tb$addColumnInfo(name = "recall", title = gettext("Recall"), type = "number")
  tb$addColumnInfo(name = "f1", title = gettext("F1 Score"), type = "number")
  jaspResults[["performanceTable"]] <- tb
  if (!ready) {
	  return()
  }
  result <- .jfaFairnessState(dataset, options, jaspResults)[["frequentist"]]
  tb[["group"]] <- rownames(result[["performance"]][["all"]])
  tb[["support"]] <- result[["performance"]][["all"]][["support"]]
  tb[["accuracy"]] <- result[["performance"]][["all"]][["accuracy"]]
  tb[["precision"]] <- result[["performance"]][["all"]][["precision"]]
  tb[["recall"]] <- result[["performance"]][["all"]][["recall"]]
  tb[["f1"]] <- result[["performance"]][["all"]][["f1.score"]]
}

.jfaFairnessParityPlot <- function(dataset, options, jaspResults, ready) {
  if (!options[["parityPlot"]] || !is.null(jaspResults[["parityPlot"]])) {
    return()
  }
  plot <- createJaspPlot(title = gettext("Parity Ratio Plot"))
  plot$dependOn(options = c(.jfaFairnessCommonOptions(), "parityPlot"))
  jaspResults[["parityPlot"]] <- plot
  if (!ready) {
    return()
  }
  result <- .jfaFairnessState(dataset, options, jaspResults)[["frequentist"]]
  plot$plotObject <- plot(result, type = "estimates")
}

.jfaFairnessPosteriorPlot <- function(dataset, options, jaspResults, ready) {
  if (!options[["posteriorPlot"]] || !is.null(jaspResults[["posteriorPlot"]])) {
    return()
  }
  plot <- createJaspPlot(title = gettext("Prior and Posterior Distribution Plot"))
  plot$dependOn(options = c(.jfaFairnessCommonOptions(), "posteriorPlot"))
  jaspResults[["posteriorPlot"]] <- plot
  if (!ready) {
    return()
  }
  result <- .jfaFairnessState(dataset, options, jaspResults)[["bayesian"]]
  plot$plotObject <- plot(result, type = "posterior")
}
