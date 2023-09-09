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
  # Create the procedure paragraph
  .jfaFairnessAddProcedure(options, jaspResults, position = 1)

  # Read in the data
  dataset <- .jfaFairnessReadData(dataset, options)

  # Ready for analysis
  ready <- (options[["protected"]] != "" && options[["target"]] != "" && options[["predictions"]] != "" && options[["privileged"]] != "" && options[["positive"]] != "")

  fairnessContainer <- .jfaFairnessStage(options, jaspResults, position = 2)

  # --- TABLES

  .jfaTableNumberInit(jaspResults) # Initialize table numbers

  # Create the omnibus test table
  .jfaFairnessSummaryTable(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer = 1)

  # Create the comparisons to privileged group table
  .jfaFairnessComparisonsTable(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer = 2)

  # Create the model performance table
  .jfaFairnessPerformanceTable(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer = 3)

  # Create the confusion matrix table
  .jfaFairnessConfusionTable(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer = 4)

  # ---

  # --- PLOTS

  .jfaFigureNumberInit(jaspResults) # Initialize figure numbers

  # Create the parity plot
  .jfaFairnessParityPlot(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer = 5)

  # Create the prior and posterior plot
  .jfaFairnessPosteriorPlot(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer = 7)

  # Create the Bayes factor robustness plot
  .jfaFairnessRobustnessPlot(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer = 9)

  # Create the sequential analysis plot
  .jfaFairnessSequentialPlot(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer = 11)

  # ---

  # Create the conclusion paragraph
  .jfaFairnessAddConclusion(options, fairnessContainer, jaspResults, ready, position = 3)

  # ---

  .jfaCreatedByText(jaspResults)
}

.jfaFairnessCommonOptions <- function() {
  opt <- c(
    "target", "predictions", "protected", "metric", "conf_level", "privileged", "positive",
    "chooseMeasure", "q1", "q2", "q3", "q4", "alternative", "seed", "concentration"
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

.jfaFairnessReadData <- function(dataset, options) {
  if (!is.null(dataset)) {
    return(dataset)
  } else {
    vars <- NULL
    if (options[["target"]] != "") {
      vars <- c(vars, options[["target"]])
    }
    if (options[["predictions"]] != "") {
      vars <- c(vars, options[["predictions"]])
    }
    if (options[["protected"]] != "") {
      vars <- c(vars, options[["protected"]])
    }
    dataset <- .readDataSetToEnd(columns.as.factor = vars)
    return(dataset)
  }
}

.jfaFairnessAddProcedure <- function(options, jaspResults, position) {
  if (options[["explanatoryText"]] && is.null(jaspResults[["procedureContainer"]])) {
    procedureContainer <- createJaspContainer(title = gettext("<u>Procedure</u>"))
    procedureContainer$position <- position
    procedureText <- gettextf(
      "The goal of this procedure is to determine to what extent the predictions of an algorithm are fair towards protected groups on a sensitive attribute, and to test this fairness with a type-I error of %1$s%%. Considering the positive class (<i>%2$s</i>), fairness -or discrimination- can be quantified using so-called fairness metrics. The ratio of a fairness metric of an unprivileged group compared to the privileged (<i>%3$s</i>) group is called parity.",
      round((1 - options[["conf_level"]]) * 100, 3),
      if (options[["positive"]] == "") "..." else options[["positive"]],
      if (options[["privileged"]] == "") "..." else options[["privileged"]]
    )
    procedureContainer[["procedureParagraph"]] <- createJaspHtml(procedureText, "p")
    procedureContainer[["procedureParagraph"]]$position <- 1
    procedureContainer$dependOn(options = c(.jfaFairnessCommonOptions(), "explanatoryText"))
    jaspResults[["procedureContainer"]] <- procedureContainer
  }
}

.jfaFairnessStage <- function(options, jaspResults, position) {
  title <- gettext("<u>Assessing Model Fairness</u>")
  container <- createJaspContainer(title = title)
  container$position <- position
  container$dependOn(options = .jfaFairnessCommonOptions())
  jaspResults[["fairnessContainer"]] <- container
  return(container)
}

.jfaFairnessState <- function(dataset = NULL, options, jaspResults) {
  if (!is.null(jaspResults[["state"]])) {
    return(jaspResults[["state"]]$object)
  } else {
    result <- list()
    set.seed(options[["seed"]])
    result[["frequentist"]] <- jfa::model_fairness(dataset,
      protected = options[["protected"]], target = options[["target"]], predictions = options[["predictions"]],
      privileged = options[["privileged"]], positive = options[["positive"]],
      metric = .jfaFairnessGetMetricFromQuestion(options)[["metric"]], alternative = options[["alternative"]],
      conf.level = options[["conf_level"]], prior = FALSE
    )
    result[["bayesian"]] <- jfa::model_fairness(dataset, options[["protected"]], options[["target"]], options[["predictions"]],
      privileged = options[["privileged"]], positive = options[["positive"]],
      metric = .jfaFairnessGetMetricFromQuestion(options)[["metric"]], alternative = options[["alternative"]],
      conf.level = options[["conf_level"]], prior = options[["concentration"]]
    )
    jaspResults[["state"]] <- createJaspState(result)
    jaspResults[["state"]]$dependOn(options = .jfaFairnessCommonOptions())
    return(result)
  }
}

.jfaFairnessSummaryTable <- function(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer) {
  .jfaTableNumberUpdate(jaspResults)

  if (!is.null(fairnessContainer[["summaryTable"]])) {
    return()
  }

  metric <- .jfaFairnessGetMetricFromQuestion(options)
  title <- gettextf(
    "<b>Table %1$i.</b> Omnibus Test - %2$s",
    jaspResults[["tabNumber"]]$object,
    metric[["mainTitle"]]
  )
  tb <- createJaspTable(title = title)
  tb$position <- positionInContainer
  tb$dependOn(options = c(.jfaFairnessCommonOptions(), "bayesFactorType"))
  tb$addColumnInfo(name = "group", title = "", type = "string")
  tb$addColumnInfo(name = "n", title = gettext("n"), type = "integer")
  if (metric[["metric"]] != "dp") {
    tb$addColumnInfo(name = "value", title = "X\u00B2", type = "number")
    tb$addColumnInfo(name = "df", title = gettext("df"), type = "integer")
    tb$addColumnInfo(name = "p", title = "p", type = "pvalue")
    bfTitle <- switch(options[["bayesFactorType"]],
      "BF10" = gettextf("BF%1$s", "\u2081\u2080"),
      "BF01" = gettextf("BF%1$s", "\u2080\u2081"),
      "logBF10" = gettextf("Log(BF%1$s)", "\u2080\u2081")
    )
    tb$addColumnInfo(name = "bf", title = bfTitle, type = "number")
    tb$addFootnote(gettextf("The null hypothesis specifies that the %1$s is equal across protected groups.", tolower(metric[["title"]])))
  }
  fairnessContainer[["summaryTable"]] <- tb
  if (!ready) {
    if ((options[["target"]] != "" && options[["predictions"]] != "" && options[["protected"]] != "") && (options[["privileged"]] == "" || options[["positive"]] == "")) {
      tb$addFootnote(symbol = "\u26A0", gettext("Please specify a privileged group and positive class to start the analysis."))
    }
    return()
  }
  result <- .jfaFairnessState(dataset, options, jaspResults)
  tb[["group"]] <- options[["protected"]]
  tb[["n"]] <- result[["frequentist"]][["n"]]
  if (metric[["metric"]] != "dp") {
    tb[["value"]] <- result[["frequentist"]][["statistic"]]
    tb[["df"]] <- result[["frequentist"]][["parameter"]]
    tb[["p"]] <- result[["frequentist"]][["p.value"]]
    tb[["bf"]] <- switch(options[["bayesFactorType"]],
      "BF10" = result[["bayesian"]][["bf"]],
      "BF01" = 1 / result[["bayesian"]][["bf"]],
      "logBF10" = log(result[["bayesian"]][["bf"]])
    )
    tb$addFootnote(gettextf("The Bayes factor is computed using a Dirichlet(%1$s%2$s, ..., %1$s%3$s) prior with %1$s = 1.", "\u03B1", "\u2081", "\u1D62"), colName = "bf")
  }
}

.jfaFairnessComparisonsTable <- function(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer) {
  if (!options[["comparisonsTable"]]) {
    return()
  }

  .jfaTableNumberUpdate(jaspResults)

  if (is.null(fairnessContainer[["comparisonsTable"]])) {
    metric <- .jfaFairnessGetMetricFromQuestion(options)
    title <- gettextf(
      "<b>Table %i.</b> Comparisons to Privileged (P) Group",
      jaspResults[["tabNumber"]]$object
    )
    tb <- createJaspTable(title = title)
    tb$position <- positionInContainer
    tb$dependOn(options = c(.jfaFairnessCommonOptions(), "bayesFactorType"))
    tb$addColumnInfo(name = "group", title = "", type = "string")
    overTitle <- gettextf("%1$s%% Confidence Interval", round(options[["conf_level"]] * 100, 3))
    if (metric[["metric"]] == "dp") {
      tb$addColumnInfo(name = "metric", title = metric[["title"]], type = "integer")
    } else {
      tb$addColumnInfo(name = "metric", title = metric[["title"]], type = "number")
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
      message <- switch(options[["alternative"]],
        "two.sided" = gettextf("The null hypothesis specifies that the %1$s of an unprivileged group is equal to that of the privileged (P) group.", tolower(metric[["title"]])),
        "less" = gettextf("The null hypothesis specifies that the %1$s of an unprivileged group is greater than, or equal to, that of the privileged (P) group.", tolower(metric[["title"]])),
        "greater" = gettextf("The null hypothesis specifies that the %1$s of an unprivileged group is lower than, or equal to, that of the privileged (P) group.", tolower(metric[["title"]]))
      )
      tb$addFootnote(message)
    }
    fairnessContainer[["comparisonsTable"]] <- tb
    if (!ready) {
      return()
    }
    result <- .jfaFairnessState(dataset, options, jaspResults)
    metrics <- result[["frequentist"]][["metric"]][["all"]]
    parity <- result[["frequentist"]][["parity"]][["all"]]
    # Put privileged group on top
    privilegedIndex <- which(rownames(metrics) == options[["privileged"]])
    metrics <- rbind(metrics[privilegedIndex, , drop = FALSE], metrics[-privilegedIndex, , drop = FALSE])
    parity <- rbind(parity[privilegedIndex, , drop = FALSE], parity[-privilegedIndex, , drop = FALSE])
    rowNames <- rownames(metrics)
    rowNames[1] <- paste0(rowNames[1], " (P)")
    tb[["group"]] <- rowNames
    tb[["metric"]] <- metrics[["estimate"]]
    tb[["parity"]] <- parity[["estimate"]]
    if (metric[["metric"]] != "dp") {
      tb[["metric_lb"]] <- metrics[["lb"]]
      tb[["metric_ub"]] <- metrics[["ub"]]
      tb[["parity_lb"]] <- c(NA, parity[["lb"]][-1])
      tb[["parity_ub"]] <- c(NA, parity[["ub"]][-1])
      tb[["p"]] <- c(NA, result[["frequentist"]][["odds.ratio"]][["all"]][["p.value"]])
      bfs <- switch(options[["bayesFactorType"]],
        "BF10" = result[["bayesian"]][["odds.ratio"]][["all"]][["bf10"]],
        "BF01" = 1 / result[["bayesian"]][["odds.ratio"]][["all"]][["bf10"]],
        "logBF10" = log(result[["bayesian"]][["odds.ratio"]][["all"]][["bf10"]])
      )
      tb[["bf"]] <- c(NA, bfs)
      tb$addFootnote(gettext("<i>p</i>-values are uncorrected for multiple comparisons and are based on Fisher's exact test."), colName = "p")
      tb$addFootnote(gettextf("Bayes factors are uncorrected and are computed using a Dirichlet(%1$s%2$s, %1$s%3$s, %1$s%4$s, %1$s%5$s) prior with %1$s = 1.", "\u03B1", "\u2081", "\u2082", "\u2083", "\u2084"), colName = "bf")
    }
  }
}

.jfaFairnessPerformanceTable <- function(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer) {
  if (!options[["performanceTable"]]) {
    return()
  }

  .jfaTableNumberUpdate(jaspResults)

  if (is.null(fairnessContainer[["performanceTable"]])) {
    tb <- createJaspTable(title = gettext("Model Performance"))
    tb$position <- positionInContainer
    tb$dependOn(options = c(.jfaFairnessCommonOptions(), "performanceTable"))
    tb$addColumnInfo(name = "group", title = "", type = "string")
    tb$addColumnInfo(name = "support", title = gettext("Support"), type = "integer")
    tb$addColumnInfo(name = "accuracy", title = gettext("Accuracy"), type = "number")
    tb$addColumnInfo(name = "precision", title = gettext("Precision"), type = "number")
    tb$addColumnInfo(name = "recall", title = gettext("Recall"), type = "number")
    tb$addColumnInfo(name = "f1", title = gettext("F1 Score"), type = "number")
    fairnessContainer[["performanceTable"]] <- tb
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
}

.jfaFairnessConfusionTable <- function(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer) {
  if (!options[["confusionTable"]]) {
    return()
  }

  .jfaTableNumberUpdate(jaspResults)

  if (is.null(fairnessContainer[["confusionTable"]])) {
    title <- gettextf(
      "<b>Table %i.</b> Confusion Matrix",
      jaspResults[["tabNumber"]]$object
    )
    tb <- createJaspTable(title = title)
    tb$position <- positionInContainer
    tb$dependOn(options = c(.jfaFairnessCommonOptions(), "confusionTable", "confusionTableProportions"))
    if (ready) {
      tb$addColumnInfo(name = "group", title = "", type = "string")
      tb$addColumnInfo(name = "varname_obs", title = gettext("Actual"), type = "string")
      factorLevels <- levels(dataset[, options[["target"]]])
      groupLevels <- levels(dataset[, options[["protected"]]])
      group <- rep("", length(groupLevels) * length(factorLevels))
      group[(seq_along(groupLevels) - 1) * length(factorLevels) + 1] <- groupLevels
      tb[["group"]] <- group
      result <- .jfaFairnessState(dataset, options, jaspResults)[["frequentist"]]
      privConfTable <- result[["confusion.matrix"]][[options[["privileged"]]]]$matrix
      tb[["varname_obs"]] <- rep(rownames(privConfTable), length(groupLevels))
      colType <- if (options[["confusionTableProportions"]]) "number" else "integer"
      for (i in seq_along(colnames(privConfTable))) {
        name <- paste("varname_pred", i, sep = "")
        tb$addColumnInfo(name = name, title = colnames(privConfTable)[i], type = colType, overtitle = gettext("Predicted"))
        col <- numeric()
        for (j in seq_along(groupLevels)) {
          values <- result[["confusion.matrix"]][[j]]$matrix[, i]
          if (options[["confusionTableProportions"]]) {
            values <- values / sum(result[["confusion.matrix"]][[j]]$matrix)
          }
          col <- c(col, values)
        }
        tb[[name]] <- col
      }
    } else {
      tb$addColumnInfo(name = "obs_name", title = "", type = "string")
      tb$addColumnInfo(name = "varname_obs", title = "", type = "string")
      tb$addColumnInfo(name = "varname_pred1", title = ".", type = "integer", overtitle = gettext("Predicted"))
      tb$addColumnInfo(name = "varname_pred2", title = ".", type = "integer", overtitle = gettext("Predicted"))
      tb[["obs_name"]] <- c(gettext("Observed"), "")
      tb[["varname_obs"]] <- rep(".", 2)
      tb[["varname_pred1"]] <- rep("", 2)
      tb[["varname_pred2"]] <- rep("", 2)
    }
    fairnessContainer[["confusionTable"]] <- tb
  }
}

.jfaFairnessParityPlot <- function(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer) {
  if (!options[["parityPlot"]]) {
    return()
  }

  .jfaFigureNumberUpdate(jaspResults)

  if (is.null(fairnessContainer[["parityPlot"]])) {
    plot <- createJaspPlot(title = gettext("Parity Estimates Plot"), width = 530, height = 350)
    plot$position <- positionInContainer
    plot$dependOn(options = c(.jfaFairnessCommonOptions(), "parityPlot"))
    fairnessContainer[["parityPlot"]] <- plot
    if (!ready) {
      return()
    }
    result <- .jfaFairnessState(dataset, options, jaspResults)[["frequentist"]]
    plot$plotObject <- plot(result, type = "estimates") +
      jaspGraphs::geom_rangeframe() +
      jaspGraphs::themeJaspRaw(legend.position = "top")
  }

  if (options[["explanatoryText"]]) {
    caption <- createJaspHtml(gettextf("<b>Figure %1$i.</b> Estimated parity statistics (i.e., the ratio of %2$s from each unprivileged group to the privileged %3$s group) for all groups in the data. The closer the parity lies to one, the less discrimination occurs in the algorithm.", jaspResults[["figNumber"]]$object, tolower(.jfaFairnessGetMetricFromQuestion(options)[["title"]]), options[["privileged"]]), "p")
    caption$position <- positionInContainer + 1
    caption$dependOn(optionsFromObject = fairnessContainer[["parityPlot"]])
    fairnessContainer[["parityPlotText"]] <- caption
  }
}

.jfaFairnessPosteriorPlot <- function(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer) {
  metric <- .jfaFairnessGetMetricFromQuestion(options)
  if (!options[["posteriorPlot"]] || metric[["metric"]] == "dp") {
    return()
  }

  .jfaFigureNumberUpdate(jaspResults)

  if (is.null(fairnessContainer[["posteriorPlot"]])) {
    plot <- createJaspPlot(title = gettext("Prior and Posterior Distribution Plot"), width = 730, height = 350)
    plot$position <- positionInContainer
    plot$dependOn(options = c(.jfaFairnessCommonOptions(), "posteriorPlot"))
    fairnessContainer[["posteriorPlot"]] <- plot
    if (!ready) {
      return()
    }
    result <- .jfaFairnessState(dataset, options, jaspResults)[["bayesian"]]
    plot$plotObject <- plot(result, type = "posterior") +
      jaspGraphs::geom_rangeframe() +
      jaspGraphs::themeJaspRaw(legend.position = "right")
  }
  if (options[["explanatoryText"]]) {
    caption <- createJaspHtml(gettextf("<b>Figure %i.</b> The prior and posterior distributions on the log odds ratio for each unprivileged group compared to the privileged group (%2$s).", jaspResults[["figNumber"]]$object, options[["privileged"]]), "p")
    caption$position <- positionInContainer + 1
    caption$dependOn(optionsFromObject = fairnessContainer[["posteriorPlot"]])
    fairnessContainer[["posteriorPlotText"]] <- caption
  }
}

.jfaFairnessRobustnessPlot <- function(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer) {
  metric <- .jfaFairnessGetMetricFromQuestion(options)
  if (!options[["robustnessPlot"]] || metric[["metric"]] == "dp") {
    return()
  }

  .jfaFigureNumberUpdate(jaspResults)

  if (is.null(fairnessContainer[["robustnessPlot"]])) {
    plot <- createJaspPlot(title = gettext("Bayes Factor Robustness Plot"), width = 530, height = 450)
    plot$position <- positionInContainer
    plot$dependOn(options = c(.jfaFairnessCommonOptions(), "robustnessPlot"))
    fairnessContainer[["robustnessPlot"]] <- plot
    if (!ready) {
      return()
    }
    result <- .jfaFairnessState(dataset, options, jaspResults)[["bayesian"]]
    plot$plotObject <- plot(result, type = "robustness") +
      jaspGraphs::geom_rangeframe() +
      jaspGraphs::themeJaspRaw(legend.position = "top")
  }
  if (options[["explanatoryText"]]) {
    caption <- createJaspHtml(gettextf("<b>Figure %i.</b> The results of a robustness check for the Bayes factor. The figure illustrates the impact of different specifications (i.e., concentration parameters) of the Dirichlet prior on the Bayes factor values, providing insights into the robustness of the statistical evidence to the choice of prior distribution.", jaspResults[["figNumber"]]$object), "p")
    caption$position <- positionInContainer + 1
    caption$dependOn(optionsFromObject = fairnessContainer[["robustnessPlot"]])
    fairnessContainer[["robustnessPlotText"]] <- caption
  }
}

.jfaFairnessSequentialPlot <- function(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer) {
  metric <- .jfaFairnessGetMetricFromQuestion(options)
  if (!options[["sequentialPlot"]] || metric[["metric"]] == "dp") {
    return()
  }

  .jfaFigureNumberUpdate(jaspResults)

  if (is.null(fairnessContainer[["sequentialPlot"]])) {
    plot <- createJaspPlot(title = gettext("Sequential Analysis Plot"), width = 530, height = 450)
    plot$position <- positionInContainer
    plot$dependOn(options = c(.jfaFairnessCommonOptions(), "sequentialPlot"))
    fairnessContainer[["sequentialPlot"]] <- plot
    if (!ready) {
      return()
    }
    result <- .jfaFairnessState(dataset, options, jaspResults)[["bayesian"]]
    plot$plotObject <- plot(result, type = "sequential") +
      jaspGraphs::geom_rangeframe() +
      jaspGraphs::themeJaspRaw(legend.position = "top")
  }
  if (options[["explanatoryText"]]) {
    caption <- createJaspHtml(gettextf("<b>Figure %i.</b> The results of a sequential analysis using the Bayes factor. The figure provides insight into how the statistical evidence from these data accumulates over time and under different prior specifications.", jaspResults[["figNumber"]]$object), "p")
    caption$position <- positionInContainer + 1
    caption$dependOn(optionsFromObject = fairnessContainer[["sequentialPlot"]])
    fairnessContainer[["sequentialPlotText"]] <- caption
  }
}

.jfaFairnessAddConclusion <- function(options, fairnessContainer, jaspResults,
                                      ready, position) {
  metric <- .jfaFairnessGetMetricFromQuestion(options)
  if (!is.null(jaspResults[["conclusionContainer"]]) || !ready || !options[["explanatoryText"]] || metric[["metric"]] == "dp") {
    return()
  }

  container <- createJaspContainer(title = gettext("<u>Conclusion</u>"))
  container$position <- position
  container$dependOn(options = c(.jfaFairnessCommonOptions(), "explanatoryText"))

  state <- .jfaFairnessState(dataset = NULL, options, jaspResults)

  rejectnull <- state[["frequentist"]][["p.value"]] < (1 - options[["conf_level"]])
  conclusion <- if (rejectnull) gettext("is rejected") else gettext("is not rejected")
  pvalue <- format.pval(state[["frequentist"]][["p.value"]], eps = 0.001)
  pvalue <- if (rejectnull) gettextf("%1$s < %2$s", pvalue, "\u03B1") else gettextf("%1$s >= %2$s", pvalue, "\u03B1")

  caption <- gettextf("The <i>p</i>-value is %1$s and the null hypothesis of equal %2$s across protected groups %3$s.", pvalue, tolower(.jfaFairnessGetMetricFromQuestion(options)[["title"]]), conclusion)
  caption <- gettextf("%1$s The Bayes factor indicates that the data are %2$s times more likely to occur under the null hypothesis than under the alternative hypothesis.", caption, format(1 / state[["bayesian"]][["bf"]], digits = 3))

  container[["conclusionParagraph"]] <- createJaspHtml(caption, "p")
  container[["conclusionParagraph"]]$position <- 1
  container$dependOn(options = c(.jfaFairnessCommonOptions(), "explanatoryText"))

  jaspResults[["conclusionContainer"]] <- container
}
