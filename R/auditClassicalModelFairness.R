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
  .jfaFairnessConfusionTable(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer = 3)

  # ---

  # --- PLOTS

  .jfaFigureNumberInit(jaspResults) # Initialize figure numbers

  # Create the parity plot
  .jfaFairnessParityPlot(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer = 4)

  # Create the prior and posterior plot
  # .jfaFairnessPosteriorPlot(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer = 7)

  # Create the Bayes factor robustness plot
  # .jfaFairnessRobustnessPlot(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer = 9)

  # Create the sequential analysis plot
  # .jfaFairnessSequentialPlot(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer = 11)

  # ---

  # Create the conclusion paragraph
  .jfaFairnessAddConclusion(options, fairnessContainer, jaspResults, ready, position = 13)

  # ---

  .jfaCreatedByText(jaspResults)
}

.jfaFairnessCommonOptions <- function() {
  opt <- c(
    "target", "predictions", "protected", "metric", "conf_level", "privileged", "positive",
    "alternative"
    # , "seed", "concentration"
  )
  return(opt)
}

.jfaFairnessGetMetricFromQuestion <- function(options) {
  out <- list()
  out[["metric"]] <- options[["metric"]]
  out[["title"]] <- switch(out[["metric"]],
    "sp" = gettext("Specificity"),
    "ap" = gettext("Accuracy"),
    "fprp" = gettext("False positive rate"),
    "fnrp" = gettext("False negative rate"),
    "npvp" = gettext("Negative predictive value"),
    "pp" = gettext("Positive Rate"),
    "prp" = gettext("Precision"),
    "tprp" = gettext("True positive rate"),
    "eo" = c(gettext("True positive rate"), gettext("False positive rate"))
  )
  out[["mainTitle"]] <- switch(out[["metric"]],
    "sp" = gettext("Specificity Parity"),
    "ap" = gettext("Accuracy Parity"),
    "fprp" = gettext("False Positive Rate Parity"),
    "fnrp" = gettext("False Negative Rate Parity"),
    "npvp" = gettext("Negative Predictive Value Parity"),
    "pp" = gettext("Disparate Impact"),
    "prp" = gettext("Predictive Rate Parity"),
    "tprp" = gettext("Equal Opportunity"),
    "eo" = gettext("Equalized Odds"),
  )
  out[["formula"]] <- switch(out[["metric"]],
    "sp" = "TN / (TN + FP)",
    "ap" = "(TP + TN) / (TP + FP + TN + FN)",
    "fprp" = "FP / (TN + FP)",
    "fnrp" = "FN / (TP + FN)",
    "npvp" = "TN / (TN + FN)",
    "pp" = "(TP + FP) / (TP + FP + TN + FN)",
    "prp" = "TP / (TP + FP)",
    "tprp" = "TP / (TP + FN)",
    "eo" = c("TP / (TP + FN)", "FP / (TN + FP)")
  )
  return(out)
}

.jfaFairnessReadData <- function(dataset, options) {
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
  dataset <- jaspBase::excludeNaListwise(dataset, vars)
  return(dataset)
}

.jfaFairnessAddProcedure <- function(options, jaspResults, position) {
  if (options[["explanatoryText"]] && is.null(jaspResults[["procedureContainer"]])) {
    procedureContainer <- createJaspContainer(title = gettext("<u>Procedure</u>"))
    procedureContainer$position <- position
    metric <- .jfaFairnessGetMetricFromQuestion(options)
    if (metric[["metric"]] == "eo") {
      procedureText <- gettextf(
        "The goal of this procedure is to determine to what extent the predictions of an algorithm are fair towards protected groups on a sensitive attribute, and to test this fairness with a type-I error of %1$s%%. Considering the positive class (<i>%2$s</i>), fairness -or discrimination- can be quantified using so-called fairness measures. Calculating a fairness measure involves determining the value of the model evaluation metric on which the fairness measure is based for both the privileged and unprivileged groups. In this specific case, Equalized Odds is not based on a single model evaluation metric but rather on two: the true positive rate and the false positive rate. Therefore, using Equalized Odds requires applying two statistical tests to check for any significant differences between the values that the two model evaluation metrics take for each of the two groups. The two tests conducted are Pearson's chi-squared tests. Only if the null hypothesis is rejected for both tests can we conclude that the algorithm is fair.", round((1 - options[["conf_level"]]) * 100, 3),
        if (options[["positive"]] == "") "..." else options[["positive"]],
        if (options[["privileged"]] == "") "..." else options[["privileged"]]
      )
    } else if (metric[["metric"]] == "pp") {
      procedureText <- gettextf(
        "The goal of this procedure is to determine to what extent the predictions of an algorithm are fair towards protected groups on a sensitive attribute. Considering the positive class (<i>%2$s</i>), fairness -or discrimination- can be quantified using so-called fairness measures. Calculating a fairness measure implies determining the value of the model evaluation metric, on which the fairness measure is based, for both the privileged and unprivileged groups.",
        if (options[["positive"]] == "") "..." else options[["positive"]],
        if (options[["privileged"]] == "") "..." else options[["privileged"]]
      )
    } else {
      procedureText <- gettextf(
        "The goal of this procedure is to determine to what extent the predictions of an algorithm are fair towards protected groups on a sensitive attribute, and to test this fairness with a type-I error of %1$s%%. Considering the positive class (<i>%2$s</i>), fairness -or discrimination- can be quantified using so-called fairness measures. Calculating a fairness measure implies determining the value of the model evaluation metric, on which the fairness measure is based, for both the privileged and unprivileged groups. Subsequently, a statistical test is conducted to check for any significant differences between the values that the model evaluation metric takes for each of the two groups. The used test is the Pearson's chi-squared test", round((1 - options[["conf_level"]]) * 100, 3),
        if (options[["positive"]] == "") "..." else options[["positive"]],
        if (options[["privileged"]] == "") "..." else options[["privileged"]]
      )
    }
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
    metric <- .jfaFairnessGetMetricFromQuestion(options)
    # set.seed(options[["seed"]])
    if (metric[["metric"]] != "eo") {
      tryResult <- try({
      result[["frequentist"]] <- jfa::model_fairness(dataset,
        protected = options[["protected"]], target = options[["target"]], predictions = options[["predictions"]],
        privileged = options[["privileged"]], positive = options[["positive"]],
        metric = .jfaFairnessGetMetricFromQuestion(options)[["metric"]], alternative = options[["alternative"]],
        conf.level = options[["conf_level"]], prior = FALSE
      )
      })
      # result[["bayesian"]] <- jfa::model_fairness(dataset, options[["protected"]], options[["target"]], options[["predictions"]],
      #  privileged = options[["privileged"]], positive = options[["positive"]],
      #  metric = .jfaFairnessGetMetricFromQuestion(options)[["metric"]], alternative = options[["alternative"]],
      #  conf.level = options[["conf_level"]], prior = options[["concentration"]]
      # )
    } else {
      result[["frequentist"]] <- list()
      tryResult <- try({
      result[["frequentist"]][["tp"]] <- jfa::model_fairness(dataset,
        protected = options[["protected"]], target = options[["target"]], predictions = options[["predictions"]],
        privileged = options[["privileged"]], positive = options[["positive"]],
        metric = "tprp", alternative = options[["alternative"]],
        conf.level = options[["conf_level"]], prior = FALSE
      )
      })
      tryResult <- try({
      result[["frequentist"]][["fp"]] <- jfa::model_fairness(dataset,
        protected = options[["protected"]], target = options[["target"]], predictions = options[["predictions"]],
        privileged = options[["privileged"]], positive = options[["positive"]],
        metric = "fprp", alternative = options[["alternative"]],
        conf.level = options[["conf_level"]], prior = FALSE
      )
      })
    }
    if(isTryError(tryResult)) {
    jaspBase:::.quitAnalysis(gettextf("An error occurred: %1$s", jaspBase:::.extractErrorMessage(result)))
    }
    jaspResults[["state"]] <- createJaspState(result)
    jaspResults[["state"]]$dependOn(options = .jfaFairnessCommonOptions())
    return(result)
  }
}

.jfaFairnessSummaryTable <- function(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer) {
  .jfaTableNumberUpdate(jaspResults)
  metric <- .jfaFairnessGetMetricFromQuestion(options)
  if (!is.null(fairnessContainer[["summaryTable"]])) {
    return()
  }
  title <- gettextf(
    "<b>Table %1$i.</b> Omnibus Test - %2$s",
    jaspResults[["tabNumber"]]$object,
    metric[["mainTitle"]]
  )
  tb <- createJaspTable(title = title)
  tb$position <- positionInContainer
  tb$dependOn(options = c(.jfaFairnessCommonOptions()))
  tb$addColumnInfo(name = "group", title = "", type = "string")
  if (metric[["metric"]] != "pp") {
    if (metric[["metric"]] != "eo") {
      tb$addColumnInfo(name = "n", title = gettext("n"), type = "integer")
      tb$addColumnInfo(name = "value", title = "X\u00B2", type = "number")
      tb$addColumnInfo(name = "df", title = gettext("df"), type = "integer")
      tb$addColumnInfo(name = "p", title = "p", type = "pvalue")
      # bfTitle <- switch(options[["bayesFactorType"]],
      #  "BF10" = gettextf("BF%1$s", "\u2081\u2080"),
      #  "BF01" = gettextf("BF%1$s", "\u2080\u2081"),
      #  "logBF10" = gettextf("Log(BF%1$s)", "\u2080\u2081")
      # )
      # tb$addColumnInfo(name = "bf", title = bfTitle, type = "number")
      tb$addFootnote(gettextf("The null hypothesis specifies that the %1$s is equal across protected groups.", tolower(metric[["title"]])))
    } else {
      tb$addColumnInfo(name = "metric", title = "metric", type = "string")
      tb$addColumnInfo(name = "n", title = gettext("n"), type = "integer")
      tb$addColumnInfo(name = "value", title = "X\u00B2", type = "number")
      tb$addColumnInfo(name = "df", title = gettext("df"), type = "integer")
      tb$addColumnInfo(name = "p", title = "p", type = "pvalue")
      tb$addFootnote(gettextf("The null hypothesis specifies that the %1$s is equal across protected groups.", tolower(metric[["title"]])))
    }
  } else {
    tb$addColumnInfo(name = "n", title = gettext("n"), type = "integer")
    tb$addColumnInfo(name = "value", title = "X\u00B2", type = "number")
    tb$addColumnInfo(name = "df", title = gettext("df"), type = "integer")
    tb$addColumnInfo(name = "p", title = "p", type = "pvalue")
    tb$addColumnInfo(name = "ratio", title = gettext("Protected-to-Privileged Positive Rate Ratio"), type = "number")
    tb$addFootnote(gettextf("The null hypothesis specifies that the %1$s is equal across protected groups.", tolower(metric[["title"]])))
    tb$addFootnote(gettextf("The use of Disparate Impact is often associated with the so-called 80-percent rule. According to this rule, the protected-to-privileged positive rate ratio is compared against a decision threshold of 0.80. If the value of the ratio is lower than 0.80 then the algorithm is unfair against the unprivileged group(s)"), colName = "ratio")
  }
  fairnessContainer[["summaryTable"]] <- tb
  if (!ready) {
    if ((options[["target"]] != "" && options[["predictions"]] != "" && options[["protected"]] != "") && (options[["privileged"]] == "" || options[["positive"]] == "")) {
      tb$addFootnote(symbol = "\u26A0", gettext("Please specify a privileged group and positive class to start the analysis."))
    }
    return()
  }
  result <- .jfaFairnessState(dataset, options, jaspResults)
  if (metric[["metric"]] != "eo") {
    tb[["group"]] <- options[["protected"]]
    tb[["n"]] <- result[["frequentist"]][["n"]]
  } else {
    tb[["metric"]] <- c("TPR", "FPR")
    tb[["group"]] <- c(options[["protected"]], "")
    tb[["n"]] <- c(result[["frequentist"]][["tp"]][["n"]], result[["frequentist"]][["fp"]][["n"]])
  }
  if (metric[["metric"]] != "pp") {
    if (metric[["metric"]] != "eo") {
      tb[["value"]] <- result[["frequentist"]][["statistic"]]
      tb[["df"]] <- result[["frequentist"]][["parameter"]]
      tb[["p"]] <- result[["frequentist"]][["p.value"]]
      # tb[["bf"]] <- switch(options[["bayesFactorType"]],
      #  "BF10" = result[["bayesian"]][["bf"]],
      #  "BF01" = 1 / result[["bayesian"]][["bf"]],
      #  "logBF10" = log(result[["bayesian"]][["bf"]])
      # )
      # tb$addFootnote(gettextf("The Bayes factor is computed using a Dirichlet(%1$s%2$s, ..., %1$s%3$s) prior with %1$s = %4$s.", "\u03B1", "\u2081", "\u1D62", options[["concentration"]]), colName = "bf")
    } else {
      tb[["value"]] <- c(result[["frequentist"]][["tp"]][["statistic"]], tb[["value"]] <- result[["frequentist"]][["fp"]][["statistic"]])
      tb[["df"]] <- c(result[["frequentist"]][["tp"]][["parameter"]], result[["frequentist"]][["fp"]][["parameter"]])
      tb[["p"]] <- c(result[["frequentist"]][["tp"]][["p.value"]], result[["frequentist"]][["fp"]][["p.value"]])
    }
  } else {
    tb[["value"]] <- result[["frequentist"]][["statistic"]]
    tb[["df"]] <- result[["frequentist"]][["parameter"]]
    tb[["p"]] <- result[["frequentist"]][["p.value"]]
    tb[["ratio"]] <- result[["frequentist"]][["parity"]][["all"]][2, "estimate"]
  }
}

.jfaFairnessComparisonsTable <- function(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer) {
  if (!options[["comparisonsTable"]]) {
    return()
  }

  metric <- .jfaFairnessGetMetricFromQuestion(options)

  if (metric[["metric"]] != "eo") {
    .jfaTableNumberUpdate(jaspResults)

    if (is.null(fairnessContainer[["comparisonsTable"]])) {
      title <- gettextf(
        "<b>Table %1$i.</b> Comparisons to Privileged (P) Group",
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
        # bfTitle <- switch(options[["bayesFactorType"]],
        #  "BF10" = gettextf("BF%1$s", "\u2081\u2080"),
        #  "BF01" = gettextf("BF%1$s", "\u2080\u2081"),
        #  "logBF10" = gettextf("Log(BF%1$s)", "\u2080\u2081")
        # )
        # tb$addColumnInfo(name = "bf", title = bfTitle, type = "number")
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
        # bfs <- switch(options[["bayesFactorType"]],
        #  "BF10" = result[["bayesian"]][["odds.ratio"]][["all"]][["bf10"]],
        #  "BF01" = 1 / result[["bayesian"]][["odds.ratio"]][["all"]][["bf10"]],
        #  "logBF10" = log(result[["bayesian"]][["odds.ratio"]][["all"]][["bf10"]])
        # )
        # tb[["bf"]] <- c(NA, bfs)
        tb$addFootnote(gettext("<i>p</i>-values are uncorrected for multiple comparisons and are based on Fisher's exact test."), colName = "p")
        # tb$addFootnote(gettextf("Bayes factors are uncorrected and are computed using a Dirichlet(%1$s%2$s, %1$s%3$s, %1$s%4$s, %1$s%5$s) prior with %1$s = %6$s.", "\u03B1", "\u2081", "\u2082", "\u2083", "\u2084", options[["concentration"]]), colName = "bf")
      }
    }
  } else {
    container <- createJaspContainer(title = gettext("<u>Individual Comparisons</u>"))
    container$position <- positionInContainer
    container$dependOn(options = .jfaFairnessCommonOptions())
    fairnessContainer[["individualcomparison"]] <- container

    if (is.null(fairnessContainer[["comparisonsTable"]])) {
      .jfaTableNumberUpdate(jaspResults)

      title <- gettextf(
        "<b>Table %1$i.</b> Comparisons to Privileged (P) Group - True Positive Rate",
        jaspResults[["tabNumber"]]$object
      )
      tb1 <- createJaspTable(title = title)
      tb1$position <- positionInContainer
      tb1$dependOn(options = c(.jfaFairnessCommonOptions(), "bayesFactorType"))
      tb1$addColumnInfo(name = "group", title = "", type = "string")
      overTitle <- gettextf("%1$s%% Confidence Interval", round(options[["conf_level"]] * 100, 3))
      tb1$addColumnInfo(name = "metric", title = gettext("True Positive Rate"), type = "number")
      tb1$addColumnInfo(name = "metric_lb", title = gettext("Lower"), type = "number", overtitle = overTitle)
      tb1$addColumnInfo(name = "metric_ub", title = gettext("Upper"), type = "number", overtitle = overTitle)
      tb1$addColumnInfo(name = "parity", title = gettext("Parity"), type = "number")
      tb1$addColumnInfo(name = "parity_lb", title = gettext("Lower"), type = "number", overtitle = overTitle)
      tb1$addColumnInfo(name = "parity_ub", title = gettext("Upper"), type = "number", overtitle = overTitle)
      tb1$addColumnInfo(name = "p", title = gettext("p"), type = "pvalue")
      message <- switch(options[["alternative"]],
        "two.sided" = gettextf("The null hypothesis specifies that the %1$s of an unprivileged group is equal to that of the privileged (P) group.", tolower(metric[["title"]])),
        "less" = gettextf("The null hypothesis specifies that the %1$s of an unprivileged group is greater than, or equal to, that of the privileged (P) group.", tolower(metric[["title"]])),
        "greater" = gettextf("The null hypothesis specifies that the %1$s of an unprivileged group is lower than, or equal to, that of the privileged (P) group.", tolower(metric[["title"]]))
      )
      tb1$addFootnote(message)

      container[["table1"]] <- tb1

      .jfaTableNumberUpdate(jaspResults)

      title <- gettextf(
        "<b>Table %1$i.</b> Comparisons to Privileged (P) Group - False Positive Rate",
        jaspResults[["tabNumber"]]$object
      )
      tb2 <- createJaspTable(title = title)
      tb2$position <- positionInContainer
      tb2$dependOn(options = c(.jfaFairnessCommonOptions(), "bayesFactorType"))
      tb2$addColumnInfo(name = "group", title = "", type = "string")
      overTitle <- gettextf("%1$s%% Confidence Interval", round(options[["conf_level"]] * 100, 3))
      tb2$addColumnInfo(name = "metric", title = gettext("False Positive Rate"), type = "number")
      tb2$addColumnInfo(name = "metric_lb", title = gettext("Lower"), type = "number", overtitle = overTitle)
      tb2$addColumnInfo(name = "metric_ub", title = gettext("Upper"), type = "number", overtitle = overTitle)
      tb2$addColumnInfo(name = "parity", title = gettext("Parity"), type = "number")
      tb2$addColumnInfo(name = "parity_lb", title = gettext("Lower"), type = "number", overtitle = overTitle)
      tb2$addColumnInfo(name = "parity_ub", title = gettext("Upper"), type = "number", overtitle = overTitle)
      tb2$addColumnInfo(name = "p", title = gettext("p"), type = "pvalue")
      message <- switch(options[["alternative"]],
        "two.sided" = gettextf("The null hypothesis specifies that the %1$s of an unprivileged group is equal to that of the privileged (P) group.", tolower(metric[["title"]])),
        "less" = gettextf("The null hypothesis specifies that the %1$s of an unprivileged group is greater than, or equal to, that of the privileged (P) group.", tolower(metric[["title"]])),
        "greater" = gettextf("The null hypothesis specifies that the %1$s of an unprivileged group is lower than, or equal to, that of the privileged (P) group.", tolower(metric[["title"]]))
      )
      tb2$addFootnote(message)

      container[["table2"]] <- tb2

      if (!ready) {
        return()
      }

      result <- .jfaFairnessState(dataset, options, jaspResults)
      metrics <- result[["frequentist"]][["tp"]][["metric"]][["all"]]
      parity <- result[["frequentist"]][["tp"]][["parity"]][["all"]]
      # Put privileged group on top
      privilegedIndex <- which(rownames(metrics) == options[["privileged"]])
      metrics <- rbind(metrics[privilegedIndex, , drop = FALSE], metrics[-privilegedIndex, , drop = FALSE])
      parity <- rbind(parity[privilegedIndex, , drop = FALSE], parity[-privilegedIndex, , drop = FALSE])
      rowNames <- rownames(metrics)
      rowNames[1] <- paste0(rowNames[1], " (P)")
      tb1[["group"]] <- rowNames
      tb1[["metric"]] <- metrics[["estimate"]]
      tb1[["parity"]] <- parity[["estimate"]]
      tb1[["metric_lb"]] <- metrics[["lb"]]
      tb1[["metric_ub"]] <- metrics[["ub"]]
      tb1[["parity_lb"]] <- c(NA, parity[["lb"]][-1])
      tb1[["parity_ub"]] <- c(NA, parity[["ub"]][-1])
      tb1[["p"]] <- c(NA, result[["frequentist"]][["tp"]][["odds.ratio"]][["all"]][["p.value"]])
      tb1$addFootnote(gettext("<i>p</i>-values are uncorrected for multiple comparisons and are based on Fisher's exact test."), colName = "p")

      result <- .jfaFairnessState(dataset, options, jaspResults)
      metrics <- result[["frequentist"]][["fp"]][["metric"]][["all"]]
      parity <- result[["frequentist"]][["fp"]][["parity"]][["all"]]
      # Put privileged group on top
      privilegedIndex <- which(rownames(metrics) == options[["privileged"]])
      metrics <- rbind(metrics[privilegedIndex, , drop = FALSE], metrics[-privilegedIndex, , drop = FALSE])
      parity <- rbind(parity[privilegedIndex, , drop = FALSE], parity[-privilegedIndex, , drop = FALSE])
      rowNames <- rownames(metrics)
      rowNames[1] <- paste0(rowNames[1], " (P)")
      tb2[["group"]] <- rowNames
      tb2[["metric"]] <- metrics[["estimate"]]
      tb2[["parity"]] <- parity[["estimate"]]
      tb2[["metric_lb"]] <- metrics[["lb"]]
      tb2[["metric_ub"]] <- metrics[["ub"]]
      tb2[["parity_lb"]] <- c(NA, parity[["lb"]][-1])
      tb2[["parity_ub"]] <- c(NA, parity[["ub"]][-1])
      tb2[["p"]] <- c(NA, result[["frequentist"]][["fp"]][["odds.ratio"]][["all"]][["p.value"]])
      tb2$addFootnote(gettext("<i>p</i>-values are uncorrected for multiple comparisons and are based on Fisher's exact test."), colName = "p")

      # fairnessContainer[["comparisonsTable"]] <- container
    }
  }
}

 .jfaFairnessPerformanceTable <- function(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer) {
  if (!options[["performanceTable"]]) {
    return()
  }

  .jfaTableNumberUpdate(jaspResults)

  if (is.null(fairnessContainer[["performanceTable"]])) {
    title <- gettextf(
      "<b>Table %1$i.</b> Model Performance",
      jaspResults[["tabNumber"]]$object
    )
    tb <- createJaspTable(title = title)
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
      metric <- .jfaFairnessGetMetricFromQuestion(options)

  if (metric[["metric"]] != "eo") {
    result <- .jfaFairnessState(dataset, options, jaspResults)[["frequentist"]]
    tb[["group"]] <- rownames(result[["performance"]][["all"]])
    tb[["support"]] <- result[["performance"]][["all"]][["support"]]
    tb[["accuracy"]] <- result[["performance"]][["all"]][["accuracy"]]
    tb[["precision"]] <- result[["performance"]][["all"]][["precision"]]
    tb[["recall"]] <- result[["performance"]][["all"]][["recall"]]
    tb[["f1"]] <- result[["performance"]][["all"]][["f1.score"]]
  }else{
    result <- .jfaFairnessState(dataset, options, jaspResults)[["frequentist"]][["fp"]]
    tb[["group"]] <- rownames(result[["performance"]][["all"]])
    tb[["support"]] <- result[["performance"]][["all"]][["support"]]
    tb[["accuracy"]] <- result[["performance"]][["all"]][["accuracy"]]
    tb[["precision"]] <- result[["performance"]][["all"]][["precision"]]
    tb[["recall"]] <- result[["performance"]][["all"]][["recall"]]
    tb[["f1"]] <- result[["performance"]][["all"]][["f1.score"]]
  }
  }
 }

.jfaFairnessConfusionTable <- function(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer) {
  if (!options[["confusionTable"]]) {
    return()
  }
  metric <- .jfaFairnessGetMetricFromQuestion(options)
  .jfaTableNumberUpdate(jaspResults)

  if (is.null(fairnessContainer[["confusionTable"]])) {
    title <- gettextf(
      "<b>Table %1$i.</b> Confusion Matrix",
      jaspResults[["tabNumber"]]$object
    )
    tb <- createJaspTable(title = title)
    tb$position <- positionInContainer
    tb$dependOn(options = c(.jfaFairnessCommonOptions(), "confusionTable", "confusionTableProportions", "confusionTranspose"))

    if (ready) {
      if (!options[["confusionTranspose"]]) {
        tb$addColumnInfo(name = "group", title = "", type = "string")
        tb$addColumnInfo(name = "varname_obs", title = gettext("Observed"), type = "string")
        factorLevels <- levels(dataset[, options[["target"]]])
        groupLevels <- levels(dataset[, options[["protected"]]])
        group <- rep("", length(groupLevels) * length(factorLevels))
        group[(seq_along(groupLevels) - 1) * length(factorLevels) + 1] <- groupLevels
        tb[["group"]] <- group
        if (metric[["metric"]] == "eo") {
          result <- .jfaFairnessState(dataset, options, jaspResults)[["frequentist"]][["tp"]]
        } else {
          result <- .jfaFairnessState(dataset, options, jaspResults)[["frequentist"]]
        }
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
        tb$addColumnInfo(name = "group", title = "", type = "string")
        tb$addColumnInfo(name = "varname_pred", title = gettext("Values"), type = "string")
        factorLevels <- levels(dataset[, options[["predictions"]]])
        groupLevels <- levels(dataset[, options[["protected"]]])
        group <- rep("", length(groupLevels) * length(factorLevels))
        group[(seq_along(groupLevels) - 1) * length(factorLevels) + 1] <- groupLevels
        tb[["group"]] <- group
        if (metric[["metric"]] == "eo") {
          result <- .jfaFairnessState(dataset, options, jaspResults)[["frequentist"]][["tp"]]
        } else {
          result <- .jfaFairnessState(dataset, options, jaspResults)[["frequentist"]]
        }
        privConfTable <- result[["confusion.matrix"]][[options[["privileged"]]]]$matrix
        tb[["varname_pred"]] <- rep(colnames(privConfTable), length(groupLevels))
        colType <- if (options[["confusionTableProportions"]]) "number" else "integer"
        for (i in seq_along(rownames(privConfTable))) {
          name <- paste("varname_obs", i, sep = "")
          tb$addColumnInfo(name = name, title = rownames(privConfTable)[i], type = colType, overtitle = gettext("Observed"))
          col <- numeric()
          for (j in seq_along(groupLevels)) {
            values <- result[["confusion.matrix"]][[j]]$matrix[i, ]
            if (options[["confusionTableProportions"]]) {
              values <- values / sum(result[["confusion.matrix"]][[j]]$matrix)
            }
            col <- c(col, values)
          }
          tb[[name]] <- col
        }
      }
      if (metric[["metric"]] == "eo") {
        tb$addColumnInfo(name = "fmetric", title = .jfaFairnessGetMetricFromQuestion(options)[["title"]][[1]], type = if (.jfaFairnessGetMetricFromQuestion(options)[["metric"]] == "pp") "integer" else "number")
        tb$addColumnInfo(name = "smetric", title = .jfaFairnessGetMetricFromQuestion(options)[["title"]][[2]], type = if (.jfaFairnessGetMetricFromQuestion(options)[["metric"]] == "pp") "integer" else "number")
        result <- .jfaFairnessState(dataset, options, jaspResults)[["frequentist"]][["tp"]]
        est <- result[["metric"]][["all"]][["estimate"]]
        after <- 1
        for (i in seq_along(groupLevels)) {
          est <- append(est, rep(NA, length(factorLevels) - 1), after = after)
          after <- after + length(factorLevels)
        }
        tb[["fmetric"]] <- est
        resultb <- .jfaFairnessState(dataset, options, jaspResults)[["frequentist"]][["fp"]]
        estb <- resultb[["metric"]][["all"]][["estimate"]]
        afterb <- 1
        for (i in seq_along(groupLevels)) {
          estb <- append(estb, rep(NA, length(factorLevels) - 1), after = afterb)
          afterb <- afterb + length(factorLevels)
        }
        tb[["smetric"]] <- estb
        tb$addFootnote(gettextf("True Positives (TP) are cells in which the positive class (<i>%1$s</i>) is correctly predicted, while True Negatives (TN) are cells where the negative class is correctly predicted. False Negatives (FN) are cells in which the positive class is incorrectly predicted, and False Positives (FP) are cells in which the negative class is incorrectly predicted.", options[["positive"]]))
        tb$addFootnote(gettextf("%1$s = %2$s", .jfaFairnessGetMetricFromQuestion(options)[["title"]][[1]], .jfaFairnessGetMetricFromQuestion(options)[["formula"]][[1]]), colName = "fmetric")
        tb$addFootnote(gettextf("%1$s = %2$s", .jfaFairnessGetMetricFromQuestion(options)[["title"]][[2]], .jfaFairnessGetMetricFromQuestion(options)[["formula"]][[2]]), colName = "smetric")
      } else {
        tb$addColumnInfo(name = "metric", title = .jfaFairnessGetMetricFromQuestion(options)[["title"]], type = "number")
        est <- result[["metric"]][["all"]][["estimate"]]
        after <- 1
        for (i in seq_along(groupLevels)) {
          est <- append(est, rep(NA, length(factorLevels) - 1), after = after)
          after <- after + length(factorLevels)
        }
        tb[["metric"]] <- est
        tb$addFootnote(gettextf("True Positives (TP) are cells in which the positive class (<i>%1$s</i>) is correctly predicted, while True Negatives (TN) are cells where the negative class is correctly predicted. False Negatives (FN) are cells in which the positive class is incorrectly predicted, and False Positives (FP) are cells in which the negative class is incorrectly predicted.", options[["positive"]]))
        tb$addFootnote(gettextf("%1$s = %2$s", .jfaFairnessGetMetricFromQuestion(options)[["title"]], .jfaFairnessGetMetricFromQuestion(options)[["formula"]]), colName = "metric")
      }
    } else {
      if (!options[["confusionTranspose"]]) {
        tb$addColumnInfo(name = "obs_name", title = "", type = "string")
        tb$addColumnInfo(name = "varname_obs", title = "", type = "string")
        tb$addColumnInfo(name = "varname_pred1", title = ".", type = "integer", overtitle = gettext("Predicted"))
        tb$addColumnInfo(name = "varname_pred2", title = ".", type = "integer", overtitle = gettext("Predicted"))
        tb[["obs_name"]] <- c(gettext("Observed"), "")
        tb[["varname_obs"]] <- rep(".", 2)
        tb[["varname_pred1"]] <- rep("", 2)
        tb[["varname_pred2"]] <- rep("", 2)
      } else {
        tb$addColumnInfo(name = "pred_name", title = "", type = "string")
        tb$addColumnInfo(name = "varname_pred", title = "", type = "string")
        tb$addColumnInfo(name = "varname_obs1", title = ".", type = "integer", overtitle = gettext("Observed"))
        tb$addColumnInfo(name = "varname_obs2", title = ".", type = "integer", overtitle = gettext("Observed"))
        tb[["pred_name"]] <- c(gettext("Predicted"), "")
        tb[["varname_pred"]] <- rep(".", 2)
        tb[["varname_obs1"]] <- rep("", 2)
        tb[["varname_obs2"]] <- rep("", 2)
      }
    }
    fairnessContainer[["confusionTable"]] <- tb
  }
}

.jfaFairnessParityPlot <- function(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer) {
  if (!options[["parityPlot"]]) {
    return()
  }

  metric <- .jfaFairnessGetMetricFromQuestion(options)

  if (metric[["metric"]] != "eo") {
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
  } else {
    container <- createJaspContainer(title = gettext("<u>Parity Estimates Plots</u>"))
    container$position <- positionInContainer
    container$dependOn(options = .jfaFairnessCommonOptions())
    fairnessContainer[["parityplot"]] <- container

    if (is.null(fairnessContainer[["parityPlot"]])) {
      .jfaFigureNumberUpdate(jaspResults)

      plot1 <- createJaspPlot(title = gettext("Parity Estimates Plot - True Positive Rate Parity"), width = 530, height = 350)
      plot1$position <- positionInContainer
      plot1$dependOn(options = c(.jfaFairnessCommonOptions(), "parityPlot"))
      container[["parityPlot1"]] <- plot1

      .jfaFigureNumberUpdate(jaspResults)

      if (options[["explanatoryText"]]) {
        caption1 <- createJaspHtml(gettextf("<b>Figure 1.</b> Estimated parity statistics (i.e., the ratio of true positive rate from each unprivileged group to the privileged %1$s group) for all groups in the data. The closer the parity lies to one, the less discrimination occurs in the algorithm.", options[["privileged"]]), "p")
        caption1$position <- plot1$position + 1
        caption1$dependOn(optionsFromObject = fairnessContainer[["parityPlot1"]])
        container[["parityPlotText1"]] <- caption1
      }

      plot2 <- createJaspPlot(title = gettext("Parity Estimates Plot - False Positive Rate Parity"), width = 530, height = 350)
      plot2$position <- positionInContainer + 1
      plot2$dependOn(options = c(.jfaFairnessCommonOptions(), "parityPlot"))
      container[["parityPlot2"]] <- plot2

      if (options[["explanatoryText"]]) {
        caption2 <- createJaspHtml(gettextf("<b>Figure 2.</b> Estimated parity statistics (i.e., the ratio of false positive rate from each unprivileged group to the privileged %1$s group) for all groups in the data. The closer the parity lies to one, the less discrimination occurs in the algorithm.", options[["privileged"]]), "p")
        caption2$position <- plot2$position + 1
        caption2$dependOn(optionsFromObject = fairnessContainer[["parityPlot2"]])
        container[["parityPlotText2"]] <- caption2
      }

      if (!ready) {
        return()
      }

      result <- .jfaFairnessState(dataset, options, jaspResults)[["frequentist"]][["tp"]]
      plot1$plotObject <- plot(result, type = "estimates") +
        jaspGraphs::geom_rangeframe() +
        jaspGraphs::themeJaspRaw(legend.position = "top")

      result <- .jfaFairnessState(dataset, options, jaspResults)[["frequentist"]][["fp"]]
      plot2$plotObject <- plot(result, type = "estimates") +
        jaspGraphs::geom_rangeframe() +
        jaspGraphs::themeJaspRaw(legend.position = "top")

      # fairnessContainer[["parityPlot"]] <- container
    }
  }
}
# .jfaFairnessPosteriorPlot <- function(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer) {
#  metric <- .jfaFairnessGetMetricFromQuestion(options)
#  if (!options[["posteriorPlot"]] || metric[["metric"]] == "dp") {
#    return()
#  }
#
#  .jfaFigureNumberUpdate(jaspResults)
#
#  if (is.null(fairnessContainer[["posteriorPlot"]])) {
#    plot <- createJaspPlot(title = gettext("Prior and Posterior Distribution Plot"), width = 530, height = 350)
#    plot$position <- positionInContainer
#    plot$dependOn(options = c(.jfaFairnessCommonOptions(), "posteriorPlot"))
#    fairnessContainer[["posteriorPlot"]] <- plot
#    if (!ready) {
#      return()
#    }
#    result <- .jfaFairnessState(dataset, options, jaspResults)[["bayesian"]]
#    plot$plotObject <- plot(result, type = "posterior") +
#      jaspGraphs::geom_rangeframe() +
#      jaspGraphs::themeJaspRaw(legend.position = if (length(result[["unprivileged"]]) > 1) "top" else c(0.8, 0.8))
# }
#  if (options[["explanatoryText"]]) {
#    caption <- createJaspHtml(gettextf("<b>Figure %1$i.</b> The prior and posterior distributions on the log odds ratio for each unprivileged group compared to the privileged group (%2$s).", jaspResults[["figNumber"]]$object, options[["privileged"]]), "p")
#    caption$position <- positionInContainer + 1
#    caption$dependOn(optionsFromObject = fairnessContainer[["posteriorPlot"]])
#    fairnessContainer[["posteriorPlotText"]] <- caption
#  }
# }

# .jfaFairnessRobustnessPlot <- function(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer) {
#  metric <- .jfaFairnessGetMetricFromQuestion(options)
#  if (!options[["robustnessPlot"]] || metric[["metric"]] == "dp") {
#    return()
#  }
#
#  .jfaFigureNumberUpdate(jaspResults)
#
#  if (is.null(fairnessContainer[["robustnessPlot"]])) {
#    plot <- createJaspPlot(title = gettext("Bayes Factor Robustness Plot"), width = 530, height = 450)
#    plot$position <- positionInContainer
#    plot$dependOn(options = c(.jfaFairnessCommonOptions(), "robustnessPlot"))
#    fairnessContainer[["robustnessPlot"]] <- plot
#    if (!ready) {
#      return()
#    }
#    result <- .jfaFairnessState(dataset, options, jaspResults)[["bayesian"]]
#    plot$plotObject <- plot(result, type = "robustness") +
#      jaspGraphs::geom_rangeframe() +
#      jaspGraphs::themeJaspRaw(legend.position = "top")
#  }
#  if (options[["explanatoryText"]]) {
#    caption <- createJaspHtml(gettextf("<b>Figure %1$i.</b> The results of a robustness check using the Bayes factor. The figure illustrates the impact of different specifications (i.e., concentration parameters) of the Dirichlet prior on the Bayes factor values, providing insights into the robustness of the statistical evidence to the choice of prior distribution.", jaspResults[["figNumber"]]$object), "p")
#    caption$position <- positionInContainer + 1
#    caption$dependOn(optionsFromObject = fairnessContainer[["robustnessPlot"]])
#    fairnessContainer[["robustnessPlotText"]] <- caption
#  }
# }

# .jfaFairnessSequentialPlot <- function(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer) {
#  metric <- .jfaFairnessGetMetricFromQuestion(options)
#  if (!options[["sequentialPlot"]] || metric[["metric"]] == "dp") {
#    return()
#  }

#  .jfaFigureNumberUpdate(jaspResults)

#  if (is.null(fairnessContainer[["sequentialPlot"]])) {
#    plot <- createJaspPlot(title = gettext("Sequential Analysis Plot"), width = 530, height = 450)
#    plot$position <- positionInContainer
#    plot$dependOn(options = c(.jfaFairnessCommonOptions(), "sequentialPlot"))
#    fairnessContainer[["sequentialPlot"]] <- plot
#    if (!ready) {
#      return()
#    }
#    result <- .jfaFairnessState(dataset, options, jaspResults)[["bayesian"]]
#    plot$plotObject <- plot(result, type = "sequential") +
#      jaspGraphs::geom_rangeframe() +
#      jaspGraphs::themeJaspRaw(legend.position = "top")
#  }
#  if (options[["explanatoryText"]]) {
#    caption <- createJaspHtml(gettextf("<b>Figure %1$i.</b> The results of a sequential analysis using the Bayes factor. The figure provides insight into how the statistical evidence from these data accumulates over time and under different prior specifications.", jaspResults[["figNumber"]]$object), "p")
#    caption$position <- positionInContainer + 1
#    caption$dependOn(optionsFromObject = fairnessContainer[["sequentialPlot"]])
#    fairnessContainer[["sequentialPlotText"]] <- caption
#  }
# }

.jfaFairnessAddConclusion <- function(options, fairnessContainer, jaspResults,
                                      ready, position) {
  metric <- .jfaFairnessGetMetricFromQuestion(options)
  if (!is.null(jaspResults[["conclusionContainer"]]) || !ready || !options[["explanatoryText"]]) {
    return()
  } else {
    container <- createJaspContainer(title = gettext("<u>Conclusion</u>"))
    container$position <- position
    container$dependOn(options = c(.jfaFairnessCommonOptions(), "explanatoryText"))
    if (metric[["metric"]] == "eo") {
      state <- .jfaFairnessState(dataset = NULL, options, jaspResults)
      rejectnulla <- state[["frequentist"]][["tp"]][["p.value"]] < (1 - options[["conf_level"]])
      rejectnullb <- state[["frequentist"]][["fp"]][["p.value"]] < (1 - options[["conf_level"]])

      conclusion <- if (rejectnulla || rejectnullb) gettext("is rejected") else gettext("is not rejected")
      conclusion2 <- if (rejectnulla || rejectnullb) gettext(" As the two values are significantly different from each other, we can conclude that this specific algorithm is unfair against the unprivileged group(s).") else gettext("As the two values are not significantly different from each other, we cannot conclude that this specific algorithm is unfair against the unprivileged group(s). ")
      pvalue1 <- format.pval(state[["frequentist"]][["tp"]][["p.value"]], eps = 0.001)
      pvalue2 <- format.pval(state[["frequentist"]][["fp"]][["p.value"]], eps = 0.001)
      pvalue1 <- if (rejectnulla) gettextf("%1$s < %2$s", pvalue1, "\u03B1") else gettextf("%1$s >= %2$s", pvalue1, "\u03B1")
      pvalue2 <- if (rejectnullb) gettextf("%1$s < %2$s", pvalue2, "\u03B1") else gettextf("%1$s >= %2$s", pvalue2, "\u03B1")
      caption <- gettextf("The <i>p</i>-values are %1$s and %2$s and the null hypothesis of equal %3$s and %4$s across protected groups %5$s. %6$s ", pvalue1, pvalue2, tolower(.jfaFairnessGetMetricFromQuestion(options)[["title"]][[1]]), tolower(.jfaFairnessGetMetricFromQuestion(options)[["title"]][[2]]), conclusion, conclusion2)
    } else {
      state <- .jfaFairnessState(dataset = NULL, options, jaspResults)
      rejectnull <- state[["frequentist"]][["p.value"]] < (1 - options[["conf_level"]])
      conclusion <- if (rejectnull) gettext("is rejected") else gettext("is not rejected")
      conclusion2 <- if (rejectnull) gettext(" As the two values are significantly different from each other, we can conclude that this specific algorithm is unfair against the unprivileged group(s).") else gettext("As the two values are not significantly different from each other, we cannot conclude that this specific algorithm is unfair against the unprivileged group(s). ")
      pvalue <- format.pval(state[["frequentist"]][["p.value"]], eps = 0.001)
      pvalue <- if (rejectnull) gettextf("%1$s < %2$s", pvalue, "\u03B1") else gettextf("%1$s >= %2$s", pvalue, "\u03B1")

      caption <- gettextf("The <i>p</i>-value is %1$s and the null hypothesis of equal %2$s across protected groups %3$s. %4$s ", pvalue, tolower(.jfaFairnessGetMetricFromQuestion(options)[["title"]]), conclusion, conclusion2)
      # caption <- gettextf("%1$s The Bayes factor indicates that the data are %2$s times more likely to occur under the null hypothesis than under the alternative hypothesis.", caption, format(1 / state[["bayesian"]][["bf"]], digits = 3))
    }
    container[["conclusionParagraph"]] <- createJaspHtml(caption, "p")
    container[["conclusionParagraph"]]$position <- 1
    container$dependOn(options = c(.jfaFairnessCommonOptions(), "explanatoryText"))

    jaspResults[["conclusionContainer"]] <- container
  }
}
