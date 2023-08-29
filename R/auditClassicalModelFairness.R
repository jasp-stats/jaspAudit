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

auditClassicalModelFairness <- function(jaspResults, dataset, options, ...) {
  ready <- (options[["protected"]] != "" && options[["target"]] != "" && options[["predictions"]] != "" && options[["privileged"]] != "" && options[["positive"]] != "")
  dataset <- .jfaFairnessReadData(dataset, options, ready)
  .jfaFairnessSummaryTable(dataset, options, jaspResults, ready, position = 1)
  .jfaFairnessPerformanceTable(dataset, options, jaspResults, ready, position = 2)
  .jfaFairnessParityPlot(dataset, options, jaspResults, ready, position = 3)
  .jfaFairnessPosteriorPlot(dataset, options, jaspResults, ready, position = 4)
}

.jfaFairnessCommonOptions <- function() {
  opt <- c(
    "target", "predictions", "protected", "metric", "conf_level", "privileged", "positive",
    "chooseMeasure", "q1", "q2", "q3", "q4"
  )
  return(opt)
}

.jfaFairnessGetMetricFromQuestion <- function(options) {
  out <- list()
  if (options[["chooseMeasure"]] == "chooseManual") {
    out[["metric"]] <- options[["metric"]]
  } else {
    df <- data.frame(
      id = c("dp", "pp", "prp", "pp", "ap", "fnrp", "fprp", "npvp", "sp", "prp"), # last one was mcc
      q1 = c("no", "no", "yes", "yes", "yes", "yes", "yes", "yes", "yes", "yes"),
      q2 = c("abs", "prop", "yes", "no", "yes", "no", "no", "no", "no", "yes"),
      q3 = c("", "", "", "corr", "", "incorr", "incorr", "corr", "corr", ""),
      q4 = c("", "", "", "tp", "", "fn", "fp", "tn", "tn", "")
    )
    out[["metric"]] <- df[["id"]][df$q1 == options[["q1"]] & df$q2 == options[["q2"]] & df$q3 == options[["q3"]] & df$q4 == options[["q4"]]][1]
  }
  out[["title"]] <- switch(out[["metric"]],
    "pp" = "Proportion",
    "sp" = "Specificity",
    "ap" = "Accuracy",
    "fprp" = "False positive rate",
    "fnrp" = "False negative rate",
    "npvp" = "Negative predictive value",
    "dp" = "Positively classified",
    "prp" = "Precision",
    "tprp" = "True positive rate"
  )
  out[["mainTitle"]] <- switch(out[["metric"]],
    "pp" = "Proportional Parity",
    "sp" = "Specificity Parity",
    "ap" = "Accuracy Parity",
    "fprp" = "False Positive Rate Parity",
    "fnrp" = "False Negative Rate Parity",
    "npvp" = "Negative Predictive Value Parity",
    "dp" = "Demographic Parity",
    "prp" = "Predictive Rate Parity",
    "tprp" = "True Positive Rate Parity"
  )
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
    result[["frequentist"]] <- jfa::model_fairness(dataset,
      protected = options[["protected"]], target = options[["target"]], predictions = options[["predictions"]],
      privileged = options[["privileged"]], positive = options[["positive"]],
      metric = .jfaFairnessGetMetricFromQuestion(options)[["metric"]],
      conf.level = options[["conf_level"]], prior = FALSE
    )
    result[["bayesian"]] <- jfa::model_fairness(dataset, options[["protected"]], options[["target"]], options[["predictions"]],
      privileged = options[["privileged"]], positive = options[["positive"]],
      metric = .jfaFairnessGetMetricFromQuestion(options)[["metric"]],
      conf.level = options[["conf_level"]], prior = TRUE
    )
    jaspResults[["state"]] <- createJaspState(result)
    jaspResults[["state"]]$dependOn(options = .jfaFairnessCommonOptions())
    return(result)
  }
}

.jfaFairnessSummaryTable <- function(dataset, options, jaspResults, ready, position) {
  if (!is.null(jaspResults[["summaryTable"]])) {
    return()
  }
  metric <- .jfaFairnessGetMetricFromQuestion(options)
  tb <- createJaspTable(title = gettextf("Model Fairness Summary - %1$s", metric[["mainTitle"]]))
  tb$position <- position
  tb$dependOn(options = c(.jfaFairnessCommonOptions(), "bayesFactorType"))
  tb$addColumnInfo(name = "group", title = "", type = "string")
  overTitle <- gettextf("%1$s%% Confidence Interval", round(options[["conf_level"]] * 100, 3))
  tb$addColumnInfo(name = "metric", title = metric[["title"]], type = "number")
  if (metric[["metric"]] != "dp") {
    tb$addColumnInfo(name = "metric_lb", title = gettext("Lower"), type = "number", overtitle = overTitle)
    tb$addColumnInfo(name = "metric_ub", title = gettext("Upper"), type = "number", overtitle = overTitle)
  }
  tb$addColumnInfo(name = "parity", title = gettext("Parity"), type = "number")
  if (metric[["metric"]] != "dp") {
    tb$addColumnInfo(name = "parity_lb", title = gettext("Lower"), type = "number", overtitle = overTitle)
    tb$addColumnInfo(name = "parity_ub", title = gettext("Upper"), type = "number", overtitle = overTitle)
    tb$addColumnInfo(name = "p", title = gettext("p"), type = "pvalue")
    bfTitle <- switch(options[["bayesFactorType"]],
      "BF10" = gettextf("BF%1$s", "\u2081\u2080"),
      "BF01" = gettextf("BF%1$s", "\u2080\u2081"),
      "logBF10" = gettextf("Log(BF%1$s)", "\u2080\u2081")
    )
    tb$addColumnInfo(name = "bf", title = bfTitle, type = "number")
  }
  jaspResults[["summaryTable"]] <- tb
  if (!ready) {
    if ((options[["target"]] != "" && options[["predictions"]] != "" && options[["protected"]] != "") && (options[["privileged"]] == "" || options[["positive"]] == "")) {
      tb$addFootnote(symbol = "\u26A0", gettext("Please specify a privileged group and positive class to start the analysis."))
    }
    return()
  }
  result <- .jfaFairnessState(dataset, options, jaspResults)
  privilegedIndex <- which(rownames(result[["frequentist"]][["metric"]][["all"]]) == options[["privileged"]])
  rowNames <- rownames(result[["frequentist"]][["metric"]][["all"]])
  rowNames[privilegedIndex] <- paste0(rowNames[privilegedIndex], " (P)")
  tb[["group"]] <- rowNames
  tb[["metric"]] <- result[["frequentist"]][["metric"]][["all"]][["estimate"]]
  tb[["parity"]] <- result[["frequentist"]][["parity"]][["all"]][["estimate"]]
  if (metric[["metric"]] != "dp") {
    tb[["metric_lb"]] <- result[["frequentist"]][["metric"]][["all"]][["lb"]]
    tb[["metric_ub"]] <- result[["frequentist"]][["metric"]][["all"]][["ub"]]
    tb[["parity_lb"]] <- result[["frequentist"]][["parity"]][["all"]][["lb"]]
    tb[["parity_ub"]] <- result[["frequentist"]][["parity"]][["all"]][["ub"]]
    tb[["p"]] <- append(result[["frequentist"]][["odds.ratio"]][["all"]][["p.value"]], NA, after = privilegedIndex - 1)
    bfs <- switch(options[["bayesFactorType"]],
      "BF10" = result[["bayesian"]][["odds.ratio"]][["all"]][["bf10"]],
      "BF01" = 1 / result[["bayesian"]][["odds.ratio"]][["all"]][["bf10"]],
      "logBF10" = log(result[["bayesian"]][["odds.ratio"]][["all"]][["bf10"]])
    )
    tb[["bf"]] <- append(bfs, NA, after = privilegedIndex - 1)
    tb$addFootnote(gettext("The null hypothesis specifies that the fairness metric of an unprivileged group is equal to that of the privileged (P) group."))
  }
}

.jfaFairnessPerformanceTable <- function(dataset, options, jaspResults, ready, position) {
  if (!options[["performanceTable"]] || !is.null(jaspResults[["performanceTable"]])) {
    return()
  }
  tb <- createJaspTable(title = "Model Performance")
  tb$position <- position
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

.jfaFairnessParityPlot <- function(dataset, options, jaspResults, ready, position) {
  if (!options[["parityPlot"]] || !is.null(jaspResults[["parityPlot"]])) {
    return()
  }
  plot <- createJaspPlot(title = gettext("Parity Estimates Plot"), width = 530, height = 350)
  plot$position <- position
  plot$dependOn(options = c(.jfaFairnessCommonOptions(), "parityPlot"))
  jaspResults[["parityPlot"]] <- plot
  if (!ready) {
    return()
  }
  result <- .jfaFairnessState(dataset, options, jaspResults)[["frequentist"]]
  plot$plotObject <- plot(result, type = "estimates") +
    jaspGraphs::geom_rangeframe() +
    jaspGraphs::themeJaspRaw(legend.position = "top")
}

.jfaFairnessPosteriorPlot <- function(dataset, options, jaspResults, ready, position) {
  metric <- .jfaFairnessGetMetricFromQuestion(options)
  if (!options[["posteriorPlot"]] || !is.null(jaspResults[["posteriorPlot"]]) || metric[["metric"]] == "dp") {
    return()
  }
  plot <- createJaspPlot(title = gettext("Prior and Posterior Distribution Plot"), width = 530, height = 350)
  plot$position <- position
  plot$dependOn(options = c(.jfaFairnessCommonOptions(), "posteriorPlot"))
  jaspResults[["posteriorPlot"]] <- plot
  if (!ready) {
    return()
  }
  result <- .jfaFairnessState(dataset, options, jaspResults)[["bayesian"]]
  plot$plotObject <- plot(result, type = "posterior") +
    jaspGraphs::geom_rangeframe() +
    jaspGraphs::themeJaspRaw(legend.position = "right")
}
