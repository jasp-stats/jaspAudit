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
    result[["frequentist"]] <- model_fairness(dataset = dataset, protected = options[["protected"]], target = options[["target"]], predictions = options[["predictions"]], 
                                  privileged = options[["privileged"]], positive = options[["positive"]],
                                  metric = .jfaFairnessGetMetricFromQuestion(options)[["metric"]],
                                  conf.level = options[["conf_level"]], prior = FALSE)
    # result[["bayesian"]] <- model_fairness(dataset, options[["protected"]], options[["target"]], options[["predictions"]], 
    #                               privileged = options[["privileged"]], positive = options[["positive"]],
    #                               metric = .jfaFairnessGetMetricFromQuestion(options)[["metric"]],
    #                               conf.level = options[["conf_level"]], prior = true)
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
  # tb[["bf"]] <- result[["bayesian"]][["odds.ratio"]][["all"]][["bf10"]]
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

model_fairness <- function(dataset,
                           protected,
                           target,
                           predictions,
                           privileged = NULL,
                           positive = NULL,
                           metric = c(
                             "prp", "pp", "ap", "fnrp", "fprp",
                             "tprp", "npvp", "sp", "dp"
                           ),
                           alternative = c("two.sided", "less", "greater"),
                           conf.level = 0.95,
                           prior = FALSE) {
  metric <- match.arg(metric)
  alternative <- match.arg(alternative)
  dname <- deparse(substitute(dataset))
  dataset <- as.data.frame(dataset, row.names = seq_len(nrow(dataset)))
  valid_prior <- (is.logical(prior)) || (is.numeric(prior) && prior >= 1)
  is_bayesian <- (is.logical(prior) && isTRUE(prior)) || (is.numeric(prior) && prior >= 1)
  stopifnot("'prior' must be TRUE or FALSE, or a numeric value >= 1 representing the prior concentration parameter" = valid_prior)
  stopifnot("'protected' does not exist in 'data'" = protected %in% colnames(dataset))
  stopifnot("'protected' must be a factor column" = is.factor(dataset[, protected]))
  stopifnot("'target' does not exist in 'data'" = target %in% colnames(dataset))
  stopifnot("'target' must be a factor column" = is.factor(dataset[, target]))
  stopifnot("'predictions' does not exist in 'data'" = predictions %in% colnames(dataset))
  stopifnot("'predictions' must be a factor column" = is.factor(dataset[, predictions]))
  groups <- levels(dataset[, protected])
  targetLevels <- levels(dataset[, target])
  stopifnot("'target' must contain at least 2 factor levels" = length(targetLevels) > 1)
  stopifnot("'predictions' must contain at least 1 factor level" = nlevels(dataset[, predictions]) > 0)
  stopifnot("'predictions' contain a factor level not in 'target'" = all(levels(dataset[, predictions]) %in% targetLevels))
  if (is.null(privileged)) {
    privileged <- groups[1]
  }
  stopifnot("'privileged' is not a class in 'protected'" = privileged %in% groups)
  if (is.null(positive)) {
    positive <- targetLevels[1]
  }
  stopifnot("'positive' is not a class in 'target'" = positive %in% targetLevels)
  confmat <- list()
  samples_list <- list()
  unprivileged <- groups[-which(groups == privileged)]
  negative <- targetLevels[-which(targetLevels == positive)]
  performance <- list(all = as.data.frame(matrix(NA, nrow = length(groups), ncol = 5), row.names = groups))
  colnames(performance[["all"]]) <- c("support", "accuracy", "precision", "recall", "f1.score")
  metrics <- list(all = as.data.frame(matrix(NA, nrow = length(groups), ncol = if (metric == "dp") 1 else 3), row.names = groups))
  parity <- list(all = as.data.frame(matrix(NA, nrow = length(groups), ncol = if (metric == "dp") 1 else 3), row.names = groups))
  colnames(metrics[["all"]]) <- colnames(parity[["all"]]) <- if (metric != "dp") c("estimate", "lb", "ub") else "estimate"
  odds.ratio <- list(all = as.data.frame(matrix(NA, nrow = length(unprivileged), ncol = 4), row.names = unprivileged))
  colnames(odds.ratio[["all"]]) <- if (is_bayesian) c("estimate", "lb", "ub", "bf10") else c("estimate", "lb", "ub", "p.value")
  for (i in seq_len(nlevels(dataset[, protected]))) {
    group <- levels(dataset[, protected])[i]
    groupDat <- dataset[dataset[, protected] == group, ]
    # Confusion matrices for each group
    confmat[[group]][["matrix"]] <- table("Actual" = groupDat[, target], "Predicted" = groupDat[, predictions])
    confmat[[group]][["tp"]] <- tp <- confmat[[group]][["matrix"]][positive, positive]
    confmat[[group]][["fp"]] <- fp <- sum(confmat[[group]][["matrix"]][negative, positive])
    confmat[[group]][["tn"]] <- tn <- sum(confmat[[group]][["matrix"]][negative, negative])
    confmat[[group]][["fn"]] <- fn <- sum(confmat[[group]][["matrix"]][positive, negative])
    # Performance measures for each group
    performance[[group]][["support"]] <- performance[["all"]][i, 1] <- sum(confmat[[group]][["matrix"]])
    performance[[group]][["accuracy"]] <- performance[["all"]][i, 2] <- (confmat[[group]][["tp"]] + confmat[[group]][["tn"]]) / (confmat[[group]][["tp"]] + confmat[[group]][["tn"]] + confmat[[group]][["fp"]] + confmat[[group]][["fn"]])
    performance[[group]][["precision"]] <- performance[["all"]][i, 3] <- confmat[[group]][["tp"]] / (confmat[[group]][["tp"]] + confmat[[group]][["fp"]])
    performance[[group]][["recall"]] <- performance[["all"]][i, 4] <- confmat[[group]][["tp"]] / (confmat[[group]][["tp"]] + confmat[[group]][["fn"]])
    performance[[group]][["f1.score"]] <- performance[["all"]][i, 5] <- 2 * ((performance[[group]][["precision"]] * performance[[group]][["recall"]]) / (performance[[group]][["precision"]] + performance[[group]][["recall"]]))
    if (metric == "dp") {
      metrics[[group]][["estimate"]] <- metrics[["all"]][i, 1] <- tp + fp
    } else {
      metrics[[group]][["numerator"]] <- switch(metric,
        "pp" = tp + fp,
        "prp" = tp,
        "ap" = tp + tn,
        "fnrp" = fn,
        "fprp" = fp,
        "tprp" = tp,
        "npvp" = tn,
        "sp" = tn
      )
      metrics[[group]][["denominator"]] <- switch(metric,
        "pp" = tp + fp + tn + fn,
        "prp" = tp + fp,
        "ap" = tp + fp + tn + fn,
        "fnrp" = tp + fn,
        "fprp" = tn + fp,
        "tprp" = tp + fn,
        "npvp" = tn + fn,
        "sp" = tn + fp
      )
    }
  }
  names(confmat) <- groups
  # Sample estimates for each group
  if (metric != "dp") {
    for (i in seq_len(nlevels(dataset[, protected]))) {
      group <- levels(dataset[, protected])[i]
      if (!is_bayesian) {
        binom_test <- stats::binom.test(x = metrics[[group]][["numerator"]], n = metrics[[group]][["denominator"]], conf.level = conf.level, alternative = alternative)
        metrics[[group]][["estimate"]] <- metrics[["all"]][i, 1] <- as.numeric(binom_test$estimate)
        metrics[[group]][["lb"]] <- metrics[["all"]][i, 2] <- as.numeric(binom_test$conf.int[1])
        metrics[[group]][["ub"]] <- metrics[["all"]][i, 3] <- as.numeric(binom_test$conf.int[2])
      } else {
        contingencyTable <- matrix(c(
          metrics[[group]][["numerator"]],
          metrics[[group]][["denominator"]] - metrics[[group]][["numerator"]],
          metrics[[privileged]][["numerator"]],
          metrics[[privileged]][["denominator"]] - metrics[[privileged]][["numerator"]]
        ), ncol = 2)
        samples_list[[group]] <- .mcmc_or(counts = c(contingencyTable), prior_a = prior)
        metrics[[group]][["estimate"]] <- metrics[["all"]][i, 1] <- .comp_mode_bayes(analytical = FALSE, samples = samples_list[[group]]$prob)
        metrics[[group]][["lb"]] <- metrics[["all"]][i, 2] <- .comp_lb_bayes(alternative, conf.level, analytical = FALSE, samples = samples_list[[group]]$prob)
        metrics[[group]][["ub"]] <- metrics[["all"]][i, 3] <- .comp_ub_bayes(alternative, conf.level, analytical = FALSE, samples = samples_list[[group]]$prob)
      }
    }
  }
  # Parity for each group
  rowIndex <- 1
  for (group in groups) {
    if (group == privileged) {
      parity[[group]][["estimate"]] <- parity[["all"]][rowIndex, 1] <- 1
      if (metric != "dp") {
        parity[[group]][["lb"]] <- parity[[group]][["ub"]] <- parity[["all"]][rowIndex, 2] <- parity[["all"]][rowIndex, 3] <- 1
      }
    } else {
      parity[[group]][["estimate"]] <- parity[["all"]][rowIndex, 1] <- metrics[[group]][["estimate"]] / metrics[[privileged]][["estimate"]]
      if (metric != "dp") {
        parity[[group]][["lb"]] <- parity[["all"]][rowIndex, 2] <- metrics[[group]][["lb"]] / metrics[[privileged]][["estimate"]]
        parity[[group]][["ub"]] <- parity[["all"]][rowIndex, 3] <- metrics[[group]][["ub"]] / metrics[[privileged]][["estimate"]]
      }
    }
    rowIndex <- rowIndex + 1
  }
  # Odds ratio for each protected class
  if (metric != "dp") {
    rowIndex <- 1
    for (group in unprivileged) {
      contingencyTable <- matrix(c(
        metrics[[group]][["numerator"]],
        metrics[[group]][["denominator"]] - metrics[[group]][["numerator"]],
        metrics[[privileged]][["numerator"]],
        metrics[[privileged]][["denominator"]] - metrics[[privileged]][["numerator"]]
      ), ncol = 2)
      if (!is_bayesian) {
        fisher_test <- stats::fisher.test(contingencyTable, alternative = alternative, conf.level = conf.level)
        odds.ratio[[group]][["estimate"]] <- odds.ratio[["all"]][rowIndex, 1] <- as.numeric(fisher_test$estimate)
        odds.ratio[[group]][["lb"]] <- odds.ratio[["all"]][rowIndex, 2] <- as.numeric(fisher_test$conf.int[1])
        odds.ratio[[group]][["ub"]] <- odds.ratio[["all"]][rowIndex, 3] <- as.numeric(fisher_test$conf.int[2])
        odds.ratio[[group]][["p.value"]] <- odds.ratio[["all"]][rowIndex, 4] <- as.numeric(fisher_test$p.value)
      } else {
        odds.ratio[[group]][["estimate"]] <- odds.ratio[["all"]][i, 1] <- .comp_mode_bayes(analytical = FALSE, samples = samples_list[[group]]$OR)
        odds.ratio[[group]][["lb"]] <- odds.ratio[["all"]][i, 2] <- .comp_lb_bayes(alternative, conf.level, analytical = FALSE, samples = samples_list[[group]]$OR)
        odds.ratio[[group]][["ub"]] <- odds.ratio[["all"]][i, 3] <- .comp_ub_bayes(alternative, conf.level, analytical = FALSE, samples = samples_list[[group]]$OR)
        odds.ratio[[group]][["bf10"]] <- odds.ratio[["all"]][i, 4] <- .contingencyTableBf(contingencyTable, prior_a = prior)
        density_post <- density(log(samples_list[[group]]$OR), n = 1000)
        density_post_alt <- density(log(samples_list[[group]]$OR), n = 10000, from = -10, to = 10)
        density_prior_alt <- density(log(samples_list[[group]]$prior), n = 10000, from = -10, to = 10)
        odds.ratio[[group]][["density"]] <- list(x = density_post_alt$x, y = density_post_alt$y, xmin = min(c(density_post$x, -2)), xmax = max(c(density_post$x, 2)), prior_x = density_prior_alt$x, prior_y = density_prior_alt$y)
      }
      rowIndex <- rowIndex + 1
    }
  }
  result <- list()
  result[["privileged"]] <- privileged
  result[["unprivileged"]] <- unprivileged
  result[["positive"]] <- positive
  result[["negative"]] <- negative
  result[["alternative"]] <- alternative
  result[["measure"]] <- metric
  result[["confusion.matrix"]] <- confmat
  result[["performance"]] <- performance
  result[["metric"]] <- metrics
  result[["parity"]] <- parity
  if (result[["measure"]] != "dp") {
    result[["odds.ratio"]] <- odds.ratio
  }
  result[["prior"]] <- prior
  result[["data.name"]] <- dname
  class(result) <- c("jfaFairness", "list")
  return(result)
}