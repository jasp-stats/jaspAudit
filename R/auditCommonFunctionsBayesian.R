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
    fg <- createJaspPlot(plot = NULL, title = title, width = 530, height = 350)
    fg$position <- positionInContainer
    depends <- if (stage == "planning") "plotPrior" else c("plotPosterior", "plotPosteriorInfo", "area")
    fg$dependOn(options = depends)

    parentContainer[["plotPriorAndPosterior"]] <- fg

    if (is.null(parentState[["posterior"]]) || parentContainer$getError()) {
      return()
    }

    p <- plot(parentState) +
      jaspGraphs::geom_rangeframe() +
      jaspGraphs::themeJaspRaw(legend.position = c(0.8, 0.875)) +
      ggplot2::theme(
        legend.title = ggplot2::element_blank(),
        legend.text = ggplot2::element_text(margin = ggplot2::margin(0, 0, 2, 0)),
        legend.key.height = ggplot2::unit(1, "cm"),
        legend.key.width = ggplot2::unit(1.5, "cm")
      )

    if (stage == "evaluation" && options[["plotPosteriorInfo"]]) {
      if (options[["area"]] == "area_bound") {
        label_mode <- paste0("Mode: ", formatC(parentState[["posterior"]]$statistics$mode, 3, format = "f"))
        label_ub <- paste0(round(options[["conf_level"]] * 100, 3), "% CI: [0, ", formatC(parentState[["posterior"]]$statistics$ub, 3, format = "f"), "]")
      } else {
        label_mode <- paste0("Median: ", formatC(parentState[["posterior"]]$statistics$median, 3, format = "f"))
        int <- if (options[["separateMisstatement"]]) .jfaCredibleIntervalCalculation(options, parentState) else NULL
        lb <- if (options[["separateMisstatement"]]) int[["lb_unseen"]] else parentState[["lb"]]
        ub <- if (options[["separateMisstatement"]]) int[["ub_unseen"]] else parentState[["ub"]]
        label_ub <- paste0(round(options[["conf_level"]] * 100, 3), "% CI: [", formatC(lb, 3, format = "f"), ", ", formatC(ub, 3, format = "f"), "]")
      }
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
      plotList <- c(plotList, mainGraph = list(p))
      p <- jaspGraphs:::jaspGraphsPlot$new(subplots = plotList, layout = matrix(c(1, 4, 2, 4, 3, 4), nrow = 2), heights = c(0.2, 0.8), widths = c(0.4, 0.2, 0.4))
    }
    fg$plotObject <- p
  }

  if (options[["explanatoryText"]]) {
    method <- if (stage == "planning") options[["likelihood"]] else options[["method"]]
    distribution <- switch(method,
      "poisson" = gettext("gamma"),
      "binomial" = gettext("beta"),
      "hypergeometric" = gettext("beta-binomial")
    )
    if (stage == "planning") {
      caption <- createJaspHtml(gettextf(
        "<b>Figure %1$i.</b> The prior and expected posterior distribution (%2$s) on the population misstatement \u03B8. The prior parameters (%3$s = %4$s, %5$s = %6$s) are derived from the prior information. The expected posterior distribution fulfills the conditions set in the sampling objectives.",
        jaspResults[["figNumber"]]$object,
        distribution,
        "\u03B1",
        round(parentState[["prior"]][["description"]]$alpha, 3),
        "\u03B2",
        round(parentState[["prior"]][["description"]]$beta, 3)
      ), "p")
    } else {
      caption <- createJaspHtml(gettextf(
        "<b>Figure %1$i.</b> The prior and posterior distribution (%2$s) on the misstatement in the population.",
        jaspResults[["figNumber"]]$object,
        distribution
      ), "p")
    }
    caption$position <- positionInContainer + 1
    caption$dependOn(optionsFromObject = parentContainer[["plotPriorAndPosterior"]])
    caption$dependOn(options = "explanatoryText")
    parentContainer[["priorAndPosteriorPlotText"]] <- caption
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
    fg <- createJaspPlot(plot = NULL, title = title, width = 530, height = 350)
    fg$position <- positionInContainer
    depends <- if (stage == "planning") "plotPriorPredictive" else "plotPosteriorPredictive"
    fg$dependOn(options = depends)

    parentContainer[["plotPredictive"]] <- fg

    if (is.null(parentState[["posterior"]]) || parentContainer$getError()) {
      return()
    }

    size <- if (stage == "planning") parentState[["n"]] else parentState[["N.units"]] - parentState[["n"]]
    if (size <= 0) {
      fg$setError("The number of units in the population is lower than the sample size")
      return()
    }

    object <- if (stage == "planning") parentState[["prior"]] else parentState[["posterior"]]
    fg$plotObject <- plot(predict(object, size)) +
      jaspGraphs::geom_rangeframe() +
      jaspGraphs::themeJaspRaw(legend.position = "none")
  }

  if (options[["explanatoryText"]]) {
    object <- if (stage == "planning") parentState[["prior"]] else parentState[["posterior"]]
    size <- if (stage == "planning") parentState[["n"]] else parentState[["N.units"]] - parentState[["n"]]
    caption <- createJaspHtml(gettextf(
      "<b>Figure %1$i.</b> The %2$s predictive distribution is %3$s and displays the predictions of the %2$s distribution for %4$s <i>n</i> = %5$s.",
      jaspResults[["figNumber"]]$object,
      if (stage == "planning") gettext("prior") else gettext("posterior"),
      if (parentState[["posterior"]]$likelihood == "poisson") gettext("negative binomial") else gettext("beta-binomial"),
      if (stage == "planning") gettext("the intended sample of") else gettext("the remaining population of"),
      size
    ), "p")
    caption$position <- positionInContainer + 1
    caption$dependOn(optionsFromObject = parentContainer[["plotPredictive"]])
    caption$dependOn(options = "explanatoryText")
    parentContainer[["priorPredictiveText"]] <- caption
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
    tb <- createJaspTable(tableTitle)
    tb$position <- positionInContainer
    tb$transpose <- TRUE
    depends <- if (stage == "planning") c("tablePrior", "likelihood", "tableImplicitSample", "tableBookDist") else "tablePriorPosterior"
    tb$dependOn(options = depends)

    tb$addColumnInfo(name = "v", title = "", type = "string")
    tb$addColumnInfo(name = "form", title = gettext("Functional form"), type = "string")
    if (options[["materiality_test"]]) {
      tb$addColumnInfo(name = "hMin", title = gettextf("Support %1$s", "H\u208B"), type = "number")
      tb$addColumnInfo(name = "hPlus", title = gettextf("Support %1$s", "H\u208A"), type = "number")
      tb$addColumnInfo(name = "odds", title = gettextf("Ratio %1$s", "<sup>H\u208B</sup>&frasl;<sub>H\u208A</sub>"), type = "number")
    }
    tb$addColumnInfo(name = "mean", title = gettext("Mean"), type = "number")
    tb$addColumnInfo(name = "median", title = gettext("Median"), type = "number")
    tb$addColumnInfo(name = "mode", title = gettext("Mode"), type = "number")
    tb$addColumnInfo(name = "bound", title = gettextf("%1$s%% Upper bound", round(options[["conf_level"]] * 100, 2)), type = "number")
    tb$addColumnInfo(name = "precision", title = gettext("Precision"), type = "number")

    parentContainer[["tablePriorPosterior"]] <- tb

    names <- c(gettext("Prior"), gettext("Posterior"), gettext("Shift"))

    if (stage == "planning") {
      if (!ready || parentContainer$getError()) {
        tb[["v"]] <- names
        return()
      }
    } else if (stage == "evaluation") {
      if (!(options[["materiality_test"]] || options[["min_precision_test"]]) ||
        ((options[["values.audit"]] == "" || options[["id"]] == "") && options[["dataType"]] %in% c("data", "pdata")) ||
        (options[["dataType"]] == "stats" && options[["n"]] == 0) ||
        (parentOptions[["materiality_val"]] == 0 && options[["materiality_test"]]) ||
        parentContainer$getError()) {
        tb[["v"]] <- names
        return()
      }
    }

    likelihood <- if (stage == "planning") parentState[["likelihood"]] else parentState[["method"]]

    if (options[["materiality_test"]] && likelihood != "hypergeometric") {
      tb$addFootnote(message = gettextf("%1$s %2$s vs. %3$s %2$s.", "H\u208B: \u03B8 <", round(parentState[["materiality"]], 3), "H\u208A: \u03B8 >"))
    }
    if (options[["materiality_test"]] && likelihood == "hypergeometric") {
      tb$addFootnote(message = gettextf("%1$s %2$s vs. %3$s %2$s.", "H\u208B: \u03B8 <", ceiling(parentState[["materiality"]] * parentState[["N.units"]]), "H\u208A: \u03B8 >="))
    }

    N <- parentState[["N.units"]]
    prior <- parentState[["prior"]]
    posterior <- parentState[["posterior"]]
    n <- parentState[["n"]]

	if (posterior[["description"]]$density != "MCMC") {
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
	} else {
		formPrior <- gettext("Nonparametric")
		formPost <- gettext("Nonparametric")
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

    tb$addRows(rows)
  }
}

################################################################################
################## End Bayesian functions ######################################
################################################################################
