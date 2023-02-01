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

################################################################################
################## Common functions for Bayesian calculations ##################
################################################################################

.jfaCredibleIntervalCalculation <- function(options, parentState) {

  # In calculation of the credible interval, we split the confidence from the
  # original one-sided bound in two so that it becomes two-sided.
  # Example: A 95% credible bound corresponds to the 95th percentile of the
  # posterior distribution. A 95% credible interval corresponds to the
  # 2.5th and 97.5th percentiles 2.5 and 97.5 of the posterior distribution.

  conf_lb <- (1 - parentState[["conf.level"]]) / 2
  conf_ub <- parentState[["conf.level"]] + conf_lb
  alpha <- parentState[["posterior"]][["description"]]$alpha
  beta <- parentState[["posterior"]][["description"]]$beta

  if (parentState[["method"]] == "poisson") {
    lb <- qgamma(conf_lb, shape = alpha, rate = beta)
    ub <- qgamma(conf_ub, shape = alpha, rate = beta)
  } else if (parentState[["method"]] == "binomial") {
    lb <- qbeta(conf_lb, shape1 = alpha, shape2 = beta)
    ub <- qbeta(conf_ub, shape1 = alpha, shape2 = beta)
  } else if (parentState[["method"]] == "hypergeometric") {
    lb <- jfa:::.qbbinom(conf_lb, N = parentState[["N.units"]] - parentState[["n"]], shape1 = alpha, shape2 = beta) / parentState[["N.units"]]
    ub <- jfa:::.qbbinom(conf_ub, N = parentState[["N.units"]] - parentState[["n"]], shape1 = alpha, shape2 = beta) / parentState[["N.units"]]
  }

  results <- list(lb = lb, ub = ub)

  if (options[["separateMisstatement"]] && options[["values"]] != "") {
    total_lb <- (parentState[["mle"]] + lb * parentState[["unseenValue"]]) / parentState[["N.units"]]
    total_ub <- (parentState[["mle"]] + ub * parentState[["unseenValue"]]) / parentState[["N.units"]]
    results <- list(lb = total_lb, ub = total_ub, lb_unseen = lb, ub_unseen = ub)
  }

  return(results)
}

################################################################################
################## Common functions specific to the planning stage #############
################################################################################

.jfaPlotPriorAndPosterior <- function(options, parentOptions, parentState, parentContainer, jaspResults,
                                      positionInContainer, stage) {
  if ((stage == "planning" && !options[["plotPrior"]]) || (stage == "evaluation" && !options[["plotPosterior"]])) {
    return()
  }

  .jfaFigureNumberUpdate(jaspResults)

  if (is.null(parentContainer[["plotPriorAndPosterior"]])) {
    title <- if (stage == "planning") gettext("Prior and Expected Posterior Distribution") else gettext("Prior and Posterior Distribution")
    figure <- createJaspPlot(plot = NULL, title = title, width = 530, height = 350)
    figure$position <- positionInContainer
    depends <- if (stage == "planning") "plotPrior" else c("plotPosterior", "plotPosteriorInfo", "area")
    figure$dependOn(options = depends)

    parentContainer[["plotPriorAndPosterior"]] <- figure

    if (is.null(parentState[["posterior"]]) || parentContainer$getError()) {
      return()
    }

    method <- if (stage == "planning") options[["likelihood"]] else options[["method"]]
    info <- if (stage == "planning") FALSE else options[["plotPosteriorInfo"]]

    if (method != "hypergeometric") { # Gamma and beta priors

      title <- if (options[["separateMisstatement"]]) gettextf("Unseen population misstatement %1$s", "\u03B8") else gettextf("Population misstatement %1$s", "\u03B8")
      dataPrior <- data.frame(x = c(0, 1), type = factor(gettext("Prior")))
      dataPosterior <- data.frame(x = c(0, 1), type = factor(gettext("Posterior")))

      if (method == "poisson") {
        ySeq <- c(dgamma(seq(0, 1, length = 1000), shape = parentState[["prior"]][["description"]]$alpha, rate = parentState[["prior"]][["description"]]$beta), dgamma(seq(0, 1, length = 1000), shape = parentState[["posterior"]][["description"]]$alpha, rate = parentState[["posterior"]][["description"]]$beta))
        plot <- ggplot2::ggplot(NULL, mapping = ggplot2::aes(x = x, linetype = type)) +
          ggplot2::stat_function(data = dataPrior, fun = dgamma, args = list(shape = parentState[["prior"]][["description"]]$alpha, rate = parentState[["prior"]][["description"]]$beta), n = 500, size = 0.9) +
          ggplot2::stat_function(data = dataPosterior, fun = dgamma, args = list(shape = parentState[["posterior"]][["description"]]$alpha, rate = parentState[["posterior"]][["description"]]$beta), n = 500, size = 0.9)
      } else {
        ySeq <- c(dbeta(seq(0, 1, length = 1000), shape1 = parentState[["prior"]][["description"]]$alpha, shape2 = parentState[["prior"]][["description"]]$beta), dbeta(seq(0, 1, length = 1000), shape1 = parentState[["posterior"]][["description"]]$alpha, shape2 = parentState[["posterior"]][["description"]]$beta))
        plot <- ggplot2::ggplot(NULL, mapping = ggplot2::aes(x = x, linetype = type)) +
          ggplot2::stat_function(data = dataPrior, fun = dbeta, args = list(shape1 = parentState[["prior"]][["description"]]$alpha, shape2 = parentState[["prior"]][["description"]]$beta), n = 500, size = 0.9) +
          ggplot2::stat_function(data = dataPosterior, fun = dbeta, args = list(shape1 = parentState[["posterior"]][["description"]]$alpha, shape2 = parentState[["posterior"]][["description"]]$beta), n = 500, size = 0.9)
      }
      ySeq <- ySeq[!is.infinite(ySeq)]
      yMax <- max(ySeq)
      yBreaks <- jaspGraphs::getPrettyAxisBreaks(c(0, yMax * 1.1))

      plot <- plot +
        ggplot2::scale_x_continuous(name = title, limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
        ggplot2::scale_y_continuous(name = gettext("Density"), limits = c(0, max(yBreaks)), breaks = yBreaks) +
        ggplot2::scale_linetype_manual(values = c("solid", "22"), breaks = c(gettext("Posterior"), gettext("Prior"))) +
        ggplot2::labs(linetype = "")

      if (info && options[["materiality_test"]]) {
        dPrior <- switch(method,
          "poisson" = dgamma(parentState[["materiality"]], shape = parentState[["prior"]][["description"]]$alpha, rate = parentState[["prior"]][["description"]]$beta),
          "binomial" = dbeta(parentState[["materiality"]], shape1 = parentState[["prior"]][["description"]]$alpha, shape2 = parentState[["prior"]][["description"]]$beta)
        )
        dPost <- switch(method,
          "poisson" = dgamma(parentState[["materiality"]], shape = parentState[["posterior"]][["description"]]$alpha, rate = parentState[["posterior"]][["description"]]$beta),
          "binomial" = dbeta(parentState[["materiality"]], shape1 = parentState[["posterior"]][["description"]]$alpha, shape2 = parentState[["posterior"]][["description"]]$beta)
        )
        matData <- data.frame(x = rep(parentState[["materiality"]], 2), y = c(dPrior, dPost))
        plot <- plot + jaspGraphs::geom_point(mapping = ggplot2::aes(x = x, y = y), data = matData, size = 4, stroke = 1.2, inherit.aes = FALSE)
      }
    } else {
      dataPrior <- data.frame(x = 0:parentState[["N.units"]], y = extraDistr::dbbinom(x = 0:parentState[["N.units"]], size = parentState[["N.units"]], alpha = parentState[["prior"]][["description"]]$alpha, beta = parentState[["prior"]][["description"]]$beta), type = factor(gettext("Prior")))
      dataPosterior <- data.frame(x = 0:(parentState[["N.units"]] - parentState[["n"]]), y = extraDistr::dbbinom(x = 0:(parentState[["N.units"]] - parentState[["n"]]), size = parentState[["N.units"]] - parentState[["n"]], alpha = parentState[["posterior"]][["description"]]$alpha, beta = parentState[["posterior"]][["description"]]$beta), type = factor(gettext("Posterior")))
      xBreaks <- jaspGraphs::getPrettyAxisBreaks(c(0, parentState[["N.units"]]), min.n = 4)
      yBreaks <- jaspGraphs::getPrettyAxisBreaks(c(0, max(dataPrior$y, dataPosterior$y) * 1.1))
      yMax <- max(dataPrior$y, dataPosterior$y)
      plot <- ggplot2::ggplot(NULL, mapping = ggplot2::aes(x = x, y = y, fill = type)) +
        ggplot2::geom_bar(data = dataPrior, stat = "identity", color = "black") +
        ggplot2::geom_bar(data = dataPosterior, stat = "identity", color = "black") +
        ggplot2::scale_x_continuous(name = gettext("Population errors"), limits = c(0, max(xBreaks)), breaks = xBreaks) +
        ggplot2::scale_y_continuous(name = gettext("Probability"), limits = c(0, max(yBreaks)), breaks = yBreaks) +
        ggplot2::scale_fill_manual(values = c("lightgray", "darkgray"), breaks = c(gettext("Prior"), gettext("Posterior"))) +
        ggplot2::labs(fill = "")
    }

    plot <- plot + jaspGraphs::geom_rangeframe() +
      jaspGraphs::themeJaspRaw(legend.position = c(0.8, 0.875)) +
      ggplot2::theme(
        legend.title = ggplot2::element_blank(),
        legend.text = ggplot2::element_text(margin = ggplot2::margin(0, 0, 2, 0)),
        legend.key.height = ggplot2::unit(1, "cm"),
        legend.key.width = ggplot2::unit(1.5, "cm")
      )

    if (info && stage == "evaluation") {
      if (options[["area"]] == "area_bound") {
        label_mode <- paste0("Mode: ", formatC(parentState[["posterior"]]$statistics$mode, 3, format = "f"))
        label_ub <- paste0(round(options[["conf_level"]] * 100, 3), "% CI: [0, ", formatC(parentState[["posterior"]]$statistics$ub, 3, format = "f"), "]")
        errorDat <- data.frame(xmin = 0, xmax = parentState[["posterior"]]$statistics$ub, y = (yBreaks[length(yBreaks)] - yMax) / 2 + yMax)
      } else {
        label_mode <- paste0("Median: ", formatC(parentState[["posterior"]]$statistics$median, 3, format = "f"))
        int <- .jfaCredibleIntervalCalculation(options, parentState)
        lb <- if (options[["separateMisstatement"]]) int[["lb_unseen"]] else int[["lb"]]
        ub <- if (options[["separateMisstatement"]]) int[["ub_unseen"]] else int[["ub"]]
        label_ub <- paste0(round(options[["conf_level"]] * 100, 3), "% CI: [", formatC(lb, 3, format = "f"), ", ", formatC(ub, 3, format = "f"), "]")
        errorDat <- data.frame(xmin = lb, xmax = ub, y = (yBreaks[length(yBreaks)] - yMax) / 2 + yMax)
      }
      plot <- plot + ggplot2::geom_errorbarh(data = errorDat, ggplot2::aes(y = y, xmin = xmin, xmax = xmax), inherit.aes = FALSE, size = 1, height = (yBreaks[length(yBreaks)] - (yMax)) / 3 * 2)
      text_right <- jaspGraphs:::draw2Lines(c(label_ub, label_mode), x = 1, align = "right")

      if (options[["materiality_test"]] && !is.na(parentState[["posterior"]]$hypotheses$bf.h1)) {
        lab1 <- paste0("BF\u208A\u208B = ", formatC(parentState[["posterior"]]$hypotheses$bf.h0, 3, format = "f"))
        lab2 <- paste0("BF\u208B\u208A = ", formatC(parentState[["posterior"]]$hypotheses$bf.h1, 3, format = "f"))
        text_left <- jaspGraphs:::draw2Lines(c(lab1, lab2), x = 0.65, align = "center")
        tmp <- jaspGraphs:::makeBFwheelAndText(BF = parentState[["posterior"]]$hypotheses$bf.h1, bfSubscripts = c("-+", "+-"), pizzaTxt = c("data | H\u208A", "data | H\u208B"), drawPizzaTxt = TRUE, bfType = "BF10")
        plot_middle <- tmp$gWheel
      } else {
        plot_middle <- text_left <- ggplot2::ggplot() +
          jaspGraphs::getEmptyTheme()
      }

      plotList <- list(text_left, plot_middle, text_right)
      plotList <- c(plotList, mainGraph = list(plot))
      plot <- jaspGraphs:::jaspGraphsPlot$new(subplots = plotList, layout = matrix(c(1, 4, 2, 4, 3, 4), nrow = 2), heights = c(0.2, 0.8), widths = c(0.4, 0.2, 0.4))
    }

    figure$plotObject <- plot
  }

  if (options[["explanatoryText"]]) {
    method <- if (stage == "planning") options[["likelihood"]] else options[["method"]]
    distribution <- switch(method,
      "poisson" = gettext("gamma"),
      "binomial" = gettext("beta"),
      "hypergeometric" = gettext("beta-binomial")
    )
    if (stage == "planning") {
      additionalText1 <- gettextf("The expected posterior distribution is calculated so that its %1$sth percentile lies below the performance materiality (gray dot).", round(options[["conf_level"]] * 100, 2))
      figureCaption <- createJaspHtml(gettextf(
        "<b>Figure %1$i.</b> The prior and expected posterior distribution (%2$s) on the population misstatement \u03B8. The prior parameters (%3$s = %4$s, %5$s = %6$s) are derived from the prior information. %7$s",
        jaspResults[["figNumber"]]$object,
        distribution,
        "\u03B1",
        round(parentState[["prior"]][["description"]]$alpha, 3),
        "\u03B2",
        round(parentState[["prior"]][["description"]]$beta, 3),
        if (options[["materiality_test"]]) additionalText1 else ""
      ), "p")
    } else {
      additionalText <- gettext("The gray dots represent the performance materiality.")
      figureCaption <- createJaspHtml(gettextf(
        "<b>Figure %1$i.</b> The prior and posterior distribution (%2$s) on the misstatement in the population. %3$s",
        jaspResults[["figNumber"]]$object,
        distribution,
        if (options[["plotPosteriorInfo"]] && options[["materiality_test"]]) additionalText else ""
      ), "p")
    }
    figureCaption$position <- positionInContainer + 1
    figureCaption$dependOn(optionsFromObject = parentContainer[["plotPriorAndPosterior"]])
    figureCaption$dependOn(options = "explanatoryText")
    parentContainer[["priorAndPosteriorPlotText"]] <- figureCaption
  }
}

.jfaPlotPredictive <- function(options, parentOptions, parentState, parentContainer, jaspResults,
                               positionInContainer, stage) {
  if ((stage == "planning" && !options[["plotPriorPredictive"]]) || (stage == "evaluation" && !options[["plotPosteriorPredictive"]])) {
    return()
  }

  if ((stage == "planning" && options[["likelihood"]] == "hypergeometric") || (stage == "evaluation" && options[["method"]] == "hypergeometric")) {
    return()
  }

  .jfaFigureNumberUpdate(jaspResults)

  if (is.null(parentContainer[["plotPredictive"]])) {
    title <- if (stage == "planning") gettext("Prior Predictive Distribution") else gettext("Posterior Predictive Distribution")
    figure <- createJaspPlot(plot = NULL, title = title, width = 530, height = 350)
    figure$position <- positionInContainer
    depends <- if (stage == "planning") "plotPriorPredictive" else "plotPosteriorPredictive"
    figure$dependOn(options = depends)

    parentContainer[["plotPredictive"]] <- figure

    if (is.null(parentState[["posterior"]]) || parentContainer$getError()) {
      return()
    }

    size <- if (stage == "planning") parentState[["n"]] else parentState[["N.units"]] - parentState[["n"]]
    if (size <= 0) {
      figure$setError("The number of units in the population is lower than the sample size")
      return()
    }

    object <- if (stage == "planning") parentState[["prior"]] else parentState[["posterior"]]
    likelihood <- if (stage == "planning") parentState[["likelihood"]] else parentState[["method"]]
    x <- 0:size
    y <- as.numeric(predict(object, n = size))
    xBreaks <- jaspGraphs::getPrettyAxisBreaks(c(0, x))
    yBreaks <- jaspGraphs::getPrettyAxisBreaks(c(0, y))
    plotData <- data.frame(x = x, y = y)
    plot <- ggplot2::ggplot(data = plotData, mapping = ggplot2::aes(x = x, y = y)) +
      ggplot2::geom_bar(stat = "identity", color = "black", fill = "lightgray") +
      ggplot2::scale_x_continuous(name = if (likelihood == "poisson") gettext("Predicted samples before an error") else gettext("Predicted errors"), limits = c(-1, max(xBreaks)), breaks = xBreaks) +
      ggplot2::scale_y_continuous(name = gettext("Probability"), limits = c(0, max(yBreaks)), breaks = yBreaks) +
      jaspGraphs::geom_rangeframe() +
      jaspGraphs::themeJaspRaw(legend.position = "none")

    figure$plotObject <- plot
  }

  if (options[["explanatoryText"]]) {
    object <- if (stage == "planning") parentState[["prior"]] else parentState[["posterior"]]
    size <- if (stage == "planning") parentState[["n"]] else parentState[["N.units"]] - parentState[["n"]]
    figureCaption <- createJaspHtml(gettextf(
      "<b>Figure %1$i.</b> The %2$s predictive distribution is %3$s and displays the predictions of the %2$s distribution for %4$s <i>n</i> = %5$s.",
      jaspResults[["figNumber"]]$object,
      if (stage == "planning") gettext("prior") else gettext("posterior"),
      if (parentState[["posterior"]]$likelihood == "poisson") gettext("negative binomial") else gettext("beta-binomial"),
      if (stage == "planning") gettext("the intended sample of") else gettext("the remaining population of"),
      size
    ), "p")
    figureCaption$position <- positionInContainer + 1
    figureCaption$dependOn(optionsFromObject = parentContainer[["plotPredictive"]])
    figureCaption$dependOn(options = "explanatoryText")
    parentContainer[["priorPredictiveText"]] <- figureCaption
  }
}

################################################################################
################## Common functions not tied to a specific stage ###############
################################################################################

.jfaTablePriorPosterior <- function(options, parentOptions, parentState, parentContainer, jaspResults,
                                    ready = NULL, positionInContainer, stage) {
  if ((stage == "planning" && !options[["tablePrior"]]) || (stage == "evaluation" && !options[["tablePriorPosterior"]])) {
    return()
  }

  .jfaTableNumberUpdate(jaspResults)

  if (is.null(parentContainer[["tablePriorPosterior"]])) {
    title <- if (stage == "planning") gettext("Descriptive Statistics for Prior and Expected Posterior Distribution") else gettext("Descriptive Statistics for Prior and Posterior Distribution")
    tableTitle <- gettextf("<b>Table %1$i.</b> %2$s", jaspResults[["tabNumber"]]$object, title)
    table <- createJaspTable(tableTitle)
    table$position <- positionInContainer
	table$transpose <- TRUE
    depends <- if (stage == "planning") c("tablePrior", "likelihood", "tableImplicitSample", "tableBookDist") else "tablePriorPosterior"
    table$dependOn(options = depends)

    table$addColumnInfo(name = "v", title = "", type = "string")
    table$addColumnInfo(name = "form", title = gettext("Functional form"), type = "string")
    if (options[["materiality_test"]]) {
      table$addColumnInfo(name = "hMin", title = gettextf("Support %1$s", "H\u208B"), type = "number")
      table$addColumnInfo(name = "hPlus", title = gettextf("Support %1$s", "H\u208A"), type = "number")
      table$addColumnInfo(name = "odds", title = gettextf("Ratio %1$s", "<sup>H\u208B</sup>&frasl;<sub>H\u208A</sub>"), type = "number")
    }
    table$addColumnInfo(name = "mean", title = gettext("Mean"), type = "number")
    table$addColumnInfo(name = "median", title = gettext("Median"), type = "number")
    table$addColumnInfo(name = "mode", title = gettext("Mode"), type = "number")
    table$addColumnInfo(name = "bound", title = gettextf("%1$s%% Upper bound", round(options[["conf_level"]] * 100, 2)), type = "number")
    table$addColumnInfo(name = "precision", title = gettext("Precision"), type = "number")

    parentContainer[["tablePriorPosterior"]] <- table

    names <- c(gettext("Prior"), gettext("Posterior"), gettext("Shift"))

    if (stage == "planning") {
      if (!ready || parentContainer$getError()) {
        table[["v"]] <- names
        return()
      }
    } else if (stage == "evaluation") {
      if (!(options[["materiality_test"]] || options[["min_precision_test"]]) ||
        ((options[["values.audit"]] == "" || options[["id"]] == "") && options[["dataType"]] %in% c("data", "pdata")) ||
        (options[["dataType"]] == "stats" && options[["n"]] == 0) ||
        (parentOptions[["materiality_val"]] == 0 && options[["materiality_test"]]) ||
        parentContainer$getError()) {
        table[["v"]] <- names
        return()
      }
    }

    likelihood <- if (stage == "planning") parentState[["likelihood"]] else parentState[["method"]]

    if (options[["materiality_test"]] && likelihood != "hypergeometric") {
      table$addFootnote(message = gettextf("%1$s %2$s vs. %3$s %2$s.", "H\u208B: \u03B8 <", round(parentState[["materiality"]], 3), "H\u208A: \u03B8 >"))
    }
    if (options[["materiality_test"]] && likelihood == "hypergeometric") {
      table$addFootnote(message = gettextf("%1$s %2$s vs. %3$s %2$s.", "H\u208B: \u03B8 <", ceiling(parentState[["materiality"]] * parentState[["N.units"]]), "H\u208A: \u03B8 >="))
    }

    N <- parentState[["N.units"]]
    prior <- parentState[["prior"]]
    posterior <- parentState[["posterior"]]
    n <- parentState[["n"]]
    k <- parentState[["x"]]

    if (likelihood == "poisson") {
      formPrior <- paste0("gamma(\u03B1 = ", round(prior[["description"]]$alpha, 3), ", \u03B2 = ", round(prior[["description"]]$beta, 3), ")")
      formPost <- paste0("gamma(\u03B1 = ", round(posterior[["description"]]$alpha, 3), ", \u03B2 = ", round(posterior[["description"]]$beta, 3), ")")
    } else if (likelihood == "binomial") {
      formPrior <- paste0("beta(\u03B1 = ", round(prior[["description"]]$alpha, 3), ", \u03B2 = ", round(prior[["description"]]$beta, 3), ")")
      formPost <- paste0("beta(\u03B1 = ", round(posterior[["description"]]$alpha, 3), ", \u03B2 = ", round(posterior[["description"]]$beta, 3), ")")
    } else if (likelihood == "hypergeometric") {
      formPrior <- paste0("beta-binomial(N = ", N, ", \u03B1 = ", round(prior[["description"]]$alpha, 3), ", \u03B2 = ", round(prior[["description"]]$beta, 3), ")")
      formPost <- paste0("beta-binomial(N = ", N - n, ", \u03B1 = ", round(posterior[["description"]]$alpha, 3), ", \u03B2 = ", round(posterior[["description"]]$beta, 3), ")")
    }

    rows <- data.frame(
      v = names,
      form = c(formPrior, formPost, ""),
      mean = c(prior[["statistics"]]$mean, posterior[["statistics"]]$mean, posterior[["statistics"]]$mean - prior[["statistics"]]$mean),
      median = c(prior[["statistics"]]$median, posterior[["statistics"]]$median, posterior[["statistics"]]$median - prior[["statistics"]]$median),
      mode = c(prior[["statistics"]]$mode, posterior[["statistics"]]$mode, posterior[["statistics"]]$mode - prior[["statistics"]]$mode),
      bound = c(prior[["statistics"]]$ub, posterior[["statistics"]]$ub, posterior[["statistics"]]$ub - prior[["statistics"]]$ub),
      precision = c(prior[["statistics"]]$precision, posterior[["statistics"]]$precision, NA)
    )

    if (options[["materiality_test"]]) {
      rows <- cbind(rows,
        hMin = c(prior[["hypotheses"]][["p.h1"]], posterior[["hypotheses"]][["p.h1"]], posterior[["hypotheses"]][["p.h1"]] / prior[["hypotheses"]][["p.h1"]]),
        hPlus = c(prior[["hypotheses"]][["p.h0"]], posterior[["hypotheses"]][["p.h0"]], posterior[["hypotheses"]][["p.h0"]] / prior[["hypotheses"]][["p.h0"]]),
        odds = c(prior[["hypotheses"]][["odds.h1"]], posterior[["hypotheses"]][["odds.h1"]], posterior[["hypotheses"]][["bf.h1"]])
      )
    }

    table$addRows(rows)
  }
}

################################################################################
################## End Bayesian functions ######################################
################################################################################
