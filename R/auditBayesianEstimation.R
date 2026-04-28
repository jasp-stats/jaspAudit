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

auditBayesianEstimation <- function(jaspResults, dataset, options, ...) {
  # Read in the data
  dataset <- .jfaEstimationReadData(dataset, options)

  # Perform early error checks
  .jfaEstimationDataCheck(dataset, options)

  # Ready for analysis
  ready <- .jfaEstimationReadyCheck(options)

  # Create explanatory text
  # .jfaEstimationAddText(dataset, options, jaspResults, ready, position = 1)

  .jfaBayesianEstimationState(dataset, options, jaspResults, ready)

  # --- TABLES

  # Create results table
  .jfaBayesianEstimationTable(dataset, options, jaspResults, ready, position = 2)

  # ---

  # --- PLOTS

  .jfaFigureNumberInit(jaspResults) # Initialize figure numbers

  # Scatter plot
  .jfaEstimationCorrelationPlot(dataset, options, jaspResults, ready, position = 3)

  # Prior and posterior plot
  .jfaEstimationPriorAndPosteriorPlot(options, jaspResults, ready, position = 5)

  # ---

  .jfaCreatedByText(jaspResults)
}

.jfaBayesianEstimationState <- function(dataset, options, jaspResults, ready) {
  if (!is.null(jaspResults[["state"]])) {
    return(jaspResults[["state"]]$object)
  } else if (ready) {
    N <- options[["populationSize"]]
    n <- nrow(dataset)
    y <- dataset[[options[["auditValues"]]]]
    x <- dataset[[options[["bookValues"]]]]
    X <- options[["populationValue"]]
    if (options[["priorSetup"]] == "priorDefault") {
      mu_0 <- switch(options[["estimator"]],
        "mpu" = 0,
        "difference" = 0,
        "ratio" = 0,
        "regression" = 0
      )
      kappa_0 <- switch(options[["estimator"]],
        "mpu" = 0,
        "difference" = 0,
        "ratio" = 0,
        "regression" = 0
      )
      nu_0 <- switch(options[["estimator"]],
        "mpu" = -1,
        "difference" = -1,
        "ratio" = -1,
        "regression" = -2
      )
      sigma2_0 <- switch(options[["estimator"]],
        "mpu" = 0,
        "difference" = 0,
        "ratio" = 0,
        "regression" = 0
      )
    } else {
      mu_0 <- options[["priorMu"]]
      kappa_0 <- options[["priorKappa"]]
      nu_0 <- options[["priorNu"]]
      sigma2_0 <- options[["priorSigma2"]]
    }
    conf.level <- options[["confidence"]]
    if (options[["estimator"]] == "mpu") {
      result <- .jfaDirectBayes(y, n, N, mu_0, kappa_0, nu_0, sigma2_0, conf.level)
    } else if (options[["estimator"]] == "difference") {
      result <- .jfaDifferenceBayes(y, x, n, X, N, mu_0, kappa_0, nu_0, sigma2_0, conf.level)
    } else if (options[["estimator"]] == "ratio") {
      result <- .jfaRatioBayes(y, x, n, X, N, mu_0, kappa_0, nu_0, sigma2_0, conf.level)
    } else if (options[["estimator"]] == "regression") {
      result <- .jfaRegressionBayes(y, x, n, X, N, rep(mu_0, 2), matrix(c(kappa_0, 0, 0, kappa_0), nrow = 2), nu_0, sigma2_0, conf.level)
    }
    jaspResults[["state"]] <- createJaspState(result)
    jaspResults[["state"]]$dependOn(c("bookValues", "auditValues", "populationValue", "populationSize", "confidence", "estimator", "priorSetup", "priorMu", "priorKappa", "priorSigma2", "priorNu"))
  } else {
    return(list())
  }
}

.jfaBayesianEstimationTable <- function(dataset, options, jaspResults, ready, position) {
  if (!is.null(jaspResults[["summaryTable"]])) {
    return()
  }

  title <- switch(options[["estimator"]],
    "mpu"         = gettext("Bayesian Direct Estimator"),
    "difference"  = gettext("Bayesian Difference Estimator"),
    "ratio"       = gettext("Bayesian Ratio Estimator"),
    "regression"  = gettext("Bayesian Regression Estimator")
  )
  overTitle <- gettextf("%1$s%% Credible interval", round(options[["confidence"]] * 100, 2))

  tb <- createJaspTable(title)
  tb$position <- position
  tb$addColumnInfo(name = "estimate", title = gettext("Posterior mode"), type = "number", format = "monetary")
  tb$addColumnInfo(name = "uncertainty", title = gettext("Precision"), type = "number", format = "monetary")
  tb$addColumnInfo(name = "lower", title = gettext("Lower"), type = "number", format = "monetary", overtitle = overTitle)
  tb$addColumnInfo(name = "upper", title = gettext("Upper"), type = "number", format = "monetary", overtitle = overTitle)
  tb$dependOn(c("confidence", "bookValues", "auditValues", "populationValue", "populationSize", "confidence", "estimator", "priorMu", "priorKappa", "priorSigma2", "priorNu"))
  jaspResults[["summaryTable"]] <- tb

  if (!ready) {
    if (options[["estimator"]] == "mpu") {
      tb$addFootnote(gettext("Please specify the population size and your audit values."))
    } else {
      tb$addFootnote(gettext("Please specify the population size, population value and your sample variables."))
    }
    return()
  }

  if (nrow(dataset) > options[["populationSize"]]) {
    tb$addFootnote(symbol = gettext("<b>Warning.</b>"), gettext("The number of items in the population is lower than the number of items in the sample."))
  }
  if (sum(dataset[[options[["bookValues"]]]]) > options[["populationValue"]]) {
    tb$addFootnote(symbol = gettext("<b>Warning.</b>"), gettext("The number of items in the population is lower than the number of items in the sample."))
  }

  result <- jaspResults[["state"]]$object
  row <- data.frame(estimate = result[["est"]], uncertainty = result[["unc"]], lower = result[["lb"]], upper = result[["ub"]])
  tb$addRows(row)
}

.jfaEstimationPriorAndPosteriorPlot <- function(options, jaspResults, ready, position) {
  if (!options[["priorAndPosteriorPlot"]]) {
    return()
  }

  .jfaFigureNumberUpdate(jaspResults)

  if (is.null(jaspResults[["posteriorPlot"]])) {
    fg <- createJaspPlot(plot = NULL, title = gettext("Prior and Posterior Distribution"), width = 500, height = 400)
    fg$position <- position
    fg$dependOn(c("priorAndPosteriorPlot", "bookValues", "auditValues", "populationValue", "populationSize", "confidence", "estimator", "priorSetup", "priorMu", "priorKappa", "priorSigma2", "priorNu"))
    jaspResults[["posteriorPlot"]] <- fg

    if (!ready) {
      return()
    }

    result <- jaspResults[["state"]]$object

    pTry <- try({
      if (options[["priorSetup"]] == "priorDefault" || (options[["priorKappa"]] == 0 || options[["priorNu"]] <= 0 || options[["priorSigma2"]] == 0)) {
        xseq <- seq(extraDistr::qlst(0.0001, df = result$posterior$nu, mu = result$posterior$mu, sigma = result$posterior$sigma),
          extraDistr::qlst(0.9999, df = result$posterior$nu, mu = result$posterior$mu, sigma = result$posterior$sigma),
          length.out = 1000
        )
        plotdata <- data.frame(x = xseq, y = extraDistr::dlst(xseq, df = result$posterior$nu, mu = result$posterior$mu, sigma = result$posterior$sigma), type = rep("Posterior", length(xseq)))
        xBreaks <- pretty(plotdata$x, min.n = 4)
        yBreaks <- pretty(c(0, plotdata$y), min.n = 4)
        p <- ggplot2::ggplot(data = plotdata, mapping = ggplot2::aes(x = x, y = y, linetype = factor(type))) +
          ggplot2::geom_line() +
          ggplot2::scale_x_continuous(name = gettext("True population value"), limits = range(xBreaks), breaks = xBreaks) +
          ggplot2::scale_y_continuous(name = gettext("Density"), limits = range(yBreaks), breaks = yBreaks) +
          ggplot2::scale_linetype_manual(name = NULL, values = 1) +
          jaspGraphs::geom_rangeframe() +
          jaspGraphs::themeJaspRaw(legend.position = c(0.8, 0.9)) +
          ggplot2::theme(
            axis.ticks.y = ggplot2::element_blank(),
            axis.text.y = ggplot2::element_blank()
          )
      } else {
        xseq <- seq(
          min(c(extraDistr::qlst(0.0001, df = result$prior$nu, mu = result$prior$mu, sigma = result$prior$sigma), extraDistr::qlst(0.0001, df = result$posterior$nu, mu = result$posterior$mu, sigma = result$posterior$sigma))),
          max(c(extraDistr::qlst(0.9999, df = result$prior$nu, mu = result$prior$mu, sigma = result$prior$sigma), extraDistr::qlst(0.9999, df = result$posterior$nu, mu = result$posterior$mu, sigma = result$posterior$sigma))),
          length.out = 1000
        )
        plotdata <- data.frame(
          x = c(rep(xseq, 2)),
          y = c(
            extraDistr::dlst(xseq, df = result$prior$nu, mu = result$prior$mu, sigma = result$prior$sigma),
            extraDistr::dlst(xseq, df = result$posterior$nu, mu = result$posterior$mu, sigma = result$posterior$sigma)
          ),
          type = c(rep(c("Prior", "Posterior"), each = length(xseq)))
        )
        plotdata$type <- factor(plotdata$type, levels = c("Posterior", "Prior"))
        xBreaks <- pretty(plotdata$x, min.n = 4)
        yBreaks <- pretty(c(0, plotdata$y), min.n = 4)
        p <- ggplot2::ggplot(data = plotdata, mapping = ggplot2::aes(x = x, y = y, linetype = type)) +
          ggplot2::geom_line() +
          ggplot2::scale_x_continuous(name = gettext("True population value"), limits = range(xBreaks), breaks = xBreaks) +
          ggplot2::scale_y_continuous(name = gettext("Density"), limits = range(yBreaks), breaks = yBreaks) +
          ggplot2::scale_linetype_manual(name = NULL, values = c(1, 2)) +
          jaspGraphs::geom_rangeframe() +
          jaspGraphs::themeJaspRaw(legend.position = c(0.8, 0.9)) +
          ggplot2::theme(
            axis.ticks.y = ggplot2::element_blank(),
            axis.text.y = ggplot2::element_blank()
          )
      }
    })

    if (jaspBase:::isTryError(pTry)) {
      fg$setError(gettextf("Plotting not possible: %1$s", jaspBase:::.extractErrorMessage(pTry)))
      return()
    }

    fg$plotObject <- p
  }

  if (options[["explanatoryText"]]) {
    caption <- createJaspHtml(gettextf("<b>Figure %1$i.</b> The prior and posterior distribution for the true population value.", jaspResults[["figNumber"]]$object), "p")
    caption$position <- position + 1
    caption$dependOn(optionsFromObject = jaspResults[["posteriorPlot"]])
    caption$dependOn(options = "explanatoryText")
    jaspResults[["posteriorPlotCaption"]] <- caption
  }
}

.jfaDirectBayes <- function(y, n, N, mu_0 = 0, kappa_0 = 0, nu_0 = -1, sigma2_0 = 0, conf.level = 0.95) {
  alpha <- (1 - conf.level) / 2
  mu_n <- (kappa_0 * mu_0 + n * mean(y)) / (kappa_0 + n)
  kappa_n <- kappa_0 + n
  nu_n <- nu_0 + n
  sigma2_n <- (1 / nu_n) * (nu_0 * sigma2_0 + (n - 1) * var(y) + (kappa_0 * n) / (kappa_0 + n) * (mean(y) - mu_0)^2)
  mu_Y <- N * mu_n
  sigma_Y <- sqrt(sigma2_n * (N + N^2 / kappa_n))
  if (kappa_0 == 0 || nu_0 == 0) {
    sigma_Y_prior <- mu_Y_prior <- NULL
  } else {
    sigma_Y_prior <- sqrt(sigma2_0 * (N + N^2 / kappa_0))
    mu_Y_prior <- N * mu_0
  }
  lb <- extraDistr::qlst(alpha, df = nu_n, mu = mu_Y, sigma = sigma_Y)
  ub <- extraDistr::qlst(1 - alpha, df = nu_n, mu = mu_Y, sigma = sigma_Y)
  return(list(est = mu_Y, lb = lb, ub = ub, unc = ub - mu_Y, prior = list(nu = nu_0, sigma = sigma_Y_prior, mu = mu_Y_prior), posterior = list(nu = nu_n, sigma = sigma_Y, mu = mu_Y)))
}

.jfaDifferenceBayes <- function(y, x, n, X, N, mu_0 = 0, kappa_0 = 0, nu_0 = -1, sigma2_0 = 0, conf.level = 0.95) {
  alpha <- (1 - conf.level) / 2
  e <- y - x
  mu_n <- (kappa_0 * mu_0 + n * mean(e)) / (kappa_0 + n)
  kappa_n <- kappa_0 + n
  nu_n <- nu_0 + n
  sigma2_n <- (1 / nu_n) * (nu_0 * sigma2_0 + (n - 1) * var(e) + (kappa_0 * n) / (kappa_0 + n) * (mean(e) - mu_0)^2)
  mu_Y <- X + N * mu_n
  sigma_Y <- sqrt(sigma2_n * (N + N^2 / kappa_n))
  if (kappa_0 == 0 || nu_0 == 0) {
    sigma_Y_prior <- mu_Y_prior <- NULL
  } else {
    sigma_Y_prior <- sqrt(sigma2_0 * (N + N^2 / kappa_0))
    mu_Y_prior <- X + N * mu_0
  }
  lb <- extraDistr::qlst(alpha, df = nu_n, mu = mu_Y, sigma = sigma_Y)
  ub <- extraDistr::qlst(1 - alpha, df = nu_n, mu = mu_Y, sigma = sigma_Y)
  return(list(est = mu_Y, lb = lb, ub = ub, unc = ub - mu_Y, prior = list(nu = nu_0, sigma = sigma_Y_prior, mu = mu_Y_prior), posterior = list(nu = nu_n, sigma = sigma_Y, mu = mu_Y)))
}

.jfaRatioBayes <- function(y, x, n, X, N, mu_0 = 0, kappa_0 = 0, nu_0 = -1, sigma2_0 = 0, conf.level = 0.95) {
  alpha <- (1 - conf.level) / 2
  q <- y / x
  mu_n <- (kappa_0 * mu_0 + n * mean(q)) / (kappa_0 + n)
  kappa_n <- kappa_0 + n
  nu_n <- nu_0 + n
  sigma2_n <- (1 / nu_n) * (nu_0 * sigma2_0 + (n - 1) * var(q) + (kappa_0 * n) / (kappa_0 + n) * (mean(q) - mu_0)^2)
  mu_Y <- mu_n * X
  sigma_Y <- sqrt(sigma2_n * (X + X^2 / kappa_n))
  if (kappa_0 == 0 || nu_0 == 0) {
    sigma_Y_prior <- mu_Y_prior <- NULL
  } else {
    sigma_Y_prior <- sqrt(sigma2_0 * (N + N^2 / kappa_0))
    mu_Y_prior <- mu_0 * X
  }
  lb <- extraDistr::qlst(alpha, df = nu_n, mu = mu_Y, sigma = sigma_Y)
  ub <- extraDistr::qlst(1 - alpha, df = nu_n, mu = mu_Y, sigma = sigma_Y)
  return(list(est = mu_Y, lb = lb, ub = ub, unc = ub - mu_Y, prior = list(nu = nu_0, sigma = sigma_Y_prior, mu = mu_Y_prior), posterior = list(nu = nu_n, sigma = sigma_Y, mu = mu_Y)))
}

.jfaRegressionBayes <- function(y, x, n, X, N, mu_0 = c(0, 0), Lambda_0 = diag(2) * 0, nu_0 = -2, sigma2_0 = 0, conf.level = 0.95) {
  alpha <- (1 - conf.level) / 2
  D <- cbind(1, x)
  DtD <- t(D) %*% D
  Dty <- t(D) %*% y
  if (all(Lambda_0 == 0)) {
    Lambda_n <- DtD
    mu_n <- solve(Lambda_n) %*% Dty
    quad_term <- 0
  } else {
    Lambda_n <- DtD + Lambda_0
    mu_n <- solve(Lambda_n) %*% (Dty + Lambda_0 %*% mu_0)
    quad_term <- t(mu0 - mu_n) %*% Lambda0 %*% (mu_0 - nu_n)
  }
  nu_n <- nu_0 + n
  resid <- y - D %*% mu_n
  sigma2_n <- (1 / nu_n) * (nu_0 * sigma2_0 + sum(resid^2) + quad_term)
  a <- c(N, X)
  mu_Y <- t(a) %*% mu_n
  sigma_Y <- sqrt(sigma2_n * (t(a) %*% solve(Lambda_n) %*% a + N))
  if (all(Lambda_0 == 0) || nu_0 == 0) {
    sigma_Y_prior <- mu_Y_prior <- NULL
  } else {
    sigma_Y_prior <- sqrt(sigma2_0 * (t(a) %*% solve(Lambda_0) %*% a + 1))
    mu_Y_prior <- sum(a * beta_0)
  }
  lb <- extraDistr::qlst(alpha, df = nu_n, mu = mu_Y, sigma = sigma_Y)
  ub <- extraDistr::qlst(1 - alpha, df = nu_n, mu = mu_Y, sigma = sigma_Y)
  return(list(est = mu_Y, lb = lb, ub = ub, unc = ub - mu_Y, prior = list(nu = nu_0, sigma = sigma_Y_prior, mu = mu_Y_prior), posterior = list(nu = nu_n, sigma = sigma_Y, mu = mu_Y)))
}
