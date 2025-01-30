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

  # Create the confusion matrix table
  .jfaFairnessConfusionTable(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer = 2)

  # ---

  # Create the conclusion paragraph
  .jfaFairnessAddConclusion(options, fairnessContainer, jaspResults, ready, position = 3)

  # ---

  .jfaCreatedByText(jaspResults)
}

.jfaFairnessCommonOptions <- function() {
  opt <- c(
    "target", "predictions", "protected", "metric", "conf_level", "privileged", "positive",
    "alternative"
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
    "eo" = gettext("True positive rate and False positive rate")
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
    procedureText <- gettextf(
      "The goal of this procedure is to determine to what extent the predictions of an algorithm are fair towards protected groups on a sensitive attribute, and to test this fairness with a type-I error of %1$s%%. Considering the positive class (<i>%2$s</i>), fairness -or discrimination- can be quantified using so-called fairness measures. Calculating a fairness measure implies determining the value of the model evaluation metric, on which the fairness measure is based, for both the privileged and unprivileged groups. Subsequently, a statistical test is conducted to check for any significant differences between the values that the model evaluation metric takes for each of the two groups. The used test is the Pearson's chi-squared test",      round((1 - options[["conf_level"]]) * 100, 3),
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
    metric <- .jfaFairnessGetMetricFromQuestion(options)
    # set.seed(options[["seed"]])
      result[["frequentist"]] <- jfa::model_fairness(dataset,
      protected = options[["protected"]], target = options[["target"]], predictions = options[["predictions"]],
      privileged = options[["privileged"]], positive = options[["positive"]],
      metric = .jfaFairnessGetMetricFromQuestion(options)[["metric"]], alternative = options[["alternative"]],
      conf.level = options[["conf_level"]], prior = FALSE
    )
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
  tb$addColumnInfo(name = "n", title = gettext("n"), type = "integer")
  if (metric[["metric"]] != "pp") {
    tb$addColumnInfo(name = "value", title = "X\u00B2", type = "number")
    tb$addColumnInfo(name = "df", title = gettext("df"), type = "integer")
    tb$addColumnInfo(name = "p", title = "p", type = "pvalue")
    tb$addFootnote(gettextf("The null hypothesis specifies that the %1$s is equal across protected groups.", tolower(metric[["title"]])))
  }else{
    tb$addColumnInfo(name = "value", title = gettext("Protected-to-Privileged Positive Rate Ratio"), type = "number")
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
  if (metric[["metric"]] != "pp") {
    tb[["value"]] <- result[["frequentist"]][["statistic"]]
    tb[["df"]] <- result[["frequentist"]][["parameter"]]
    tb[["p"]] <- result[["frequentist"]][["p.value"]]
 }else{
     tb[["value"]] <- result[["frequentist"]][["parity"]][["all"]][2, "estimate"]
     }
}
.jfaFairnessConfusionTable <- function(dataset, options, fairnessContainer, jaspResults, ready, positionInContainer) {
  if (!options[["confusionTable"]]) {
    return()
  }

  .jfaTableNumberUpdate(jaspResults)

  if (is.null(fairnessContainer[["confusionTable"]])) {
    title <- gettextf(
      "<b>Table %1$i.</b> Confusion Matrix",
      jaspResults[["tabNumber"]]$object
    )
    tb <- createJaspTable(title = title)
    tb$position <- positionInContainer
    tb$dependOn(options = c(.jfaFairnessCommonOptions(), "confusionTable", "confusionTableProportions"))
    if (ready) {
      tb$addColumnInfo(name = "group", title = "", type = "string")
      tb$addColumnInfo(name = "varname_obs", title = gettext("True Values"), type = "string")
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
        tb$addColumnInfo(name = name, title = colnames(privConfTable)[i], type = colType, overtitle = gettext("Predicted Values"))
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
      tb$addColumnInfo(name = "metric", title = .jfaFairnessGetMetricFromQuestion(options)[["title"]], type = if (.jfaFairnessGetMetricFromQuestion(options)[["metric"]] == "pp") "integer" else "number")
      est <- result[["metric"]][["all"]][["estimate"]]
      after <- 1
      for (i in seq_along(groupLevels)) {
        est <- append(est, rep(NA, length(factorLevels) - 1), after = after)
        after <- after + length(factorLevels)
      }
      tb[["metric"]] <- est
      tb$addFootnote(gettextf("True Positives (TP) are cells in which the positive class (<i>%1$s</i>) is correctly predicted, while True Negatives (TN) are cells where the negative class is correctly predicted. False Negatives (FN) are cells in which the positive class is incorrectly predicted, and False Positives (FP) are cells in which the negative class is incorrectly predicted.", options[["positive"]]))
      tb$addFootnote(gettextf("%1$s = %2$s.", .jfaFairnessGetMetricFromQuestion(options)[["title"]], .jfaFairnessGetMetricFromQuestion(options)[["formula"]]), colName = "metric")
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

.jfaFairnessAddConclusion <- function(options, fairnessContainer, jaspResults,
                                      ready, position) {
  metric <- .jfaFairnessGetMetricFromQuestion(options)
  if (!is.null(jaspResults[["conclusionContainer"]]) || !ready || !options[["explanatoryText"]]) {
    return()
  }else if (metric[["metric"]] == "pp") {
  container <- createJaspContainer(title = gettext("<u>Conclusion</u>"))
  container$position <- position
  container$dependOn(options = c(.jfaFairnessCommonOptions(), "explanatoryText"))

  caption <- gettext("For Disparate Impact, Pearson's chi-squared test is not used to evaluate the fairness of predictions. Instead, a deterministic comparison approach is followed, adhering to the so-called 80% rule. According to this rule, the Protected-to-Privileged Positive Rate Ratio (Table 1) is compared against a decision threshold of 0.80. If the Protected-to-Privileged Positive Rate Ratio is lower than 0.80, it is considered that there is Disparate Impact, meaning there is discrimination against the protected group.")
  
  container[["conclusionParagraph"]] <- createJaspHtml(caption, "p")
  container[["conclusionParagraph"]]$position <- 1
  container$dependOn(options = c(.jfaFairnessCommonOptions(), "explanatoryText"))

  jaspResults[["conclusionContainer"]] <- container
  }else{
  container <- createJaspContainer(title = gettext("<u>Conclusion</u>"))
  container$position <- position
  container$dependOn(options = c(.jfaFairnessCommonOptions(), "explanatoryText"))

  state <- .jfaFairnessState(dataset = NULL, options, jaspResults)

  rejectnull <- state[["frequentist"]][["p.value"]] < (1 - options[["conf_level"]])
  conclusion <- if (rejectnull) gettext("is rejected") else gettext("is not rejected")
  pvalue <- format.pval(state[["frequentist"]][["p.value"]], eps = 0.001)
  pvalue <- if (rejectnull) gettextf("%1$s < %2$s", pvalue, "\u03B1") else gettextf("%1$s >= %2$s", pvalue, "\u03B1")

  caption <- gettextf("The <i>p</i>-value is %1$s and the null hypothesis of equal %2$s across protected groups %3$s.", pvalue, tolower(.jfaFairnessGetMetricFromQuestion(options)[["title"]]), conclusion)
 
  container[["conclusionParagraph"]] <- createJaspHtml(caption, "p")
  container[["conclusionParagraph"]]$position <- 1
  container$dependOn(options = c(.jfaFairnessCommonOptions(), "explanatoryText"))

  jaspResults[["conclusionContainer"]] <- container
  }
}
