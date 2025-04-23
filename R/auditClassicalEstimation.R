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

auditClassicalEstimation <- function(jaspResults, dataset, options, ...) {
  # Read in the data
  dataset <- .jfaEstimationReadData(dataset, options)

  # Perform early error checks
  .jfaEstimationDataCheck(dataset, options)

  # Ready for analysis
  ready <- .jfaEstimationReadyCheck(options)

  # Create explanatory text
  .jfaEstimationAddText(dataset, options, jaspResults, ready, position = 1)

  # --- TABLES

  # Create results table
  .jfaEstimationTable(dataset, options, jaspResults, ready, position = 2)

  # Required sample size table
  .jfaEstimationSampleSizeTable(dataset, options, jaspResults, ready, position = 3)

  # ---

  # --- PLOTS

  # Scatter plot
  .jfaEstimationCorrelationPlot(dataset, options, jaspResults, ready, position = 4)

  # ---

  .jfaCreatedByText(jaspResults)
}

.jfaEstimationReadData <- function(dataset, options) {
  bookValues <- options[["bookValues"]]
  if (bookValues == "") {
    bookValues <- NULL
  }

  auditValues <- options[["auditValues"]]
  if (auditValues == "") {
    auditValues <- NULL
  }

  variables <- c(bookValues, auditValues)

  dataset <- jaspBase::excludeNaListwise(dataset, variables)
  return(dataset)
}

.jfaEstimationDataCheck <- function(dataset, options) {
  variables <- NULL

  if (options[["bookValues"]] != "") {
    variables <- c(variables, options[["bookValues"]])
  }

  if (options[["auditValues"]] != "") {
    variables <- c(variables, options[["auditValues"]])
  }

  .hasErrors(dataset,
    type = c("infinity", "variance", "observations"),
    all.target = variables,
    message = "short",
    observations.amount = "< 3",
    exitAnalysisIfErrors = TRUE
  )
}

.jfaEstimationReadyCheck <- function(options) {
  if (options[["estimator"]] == "mpu") {
    ready <- options[["auditValues"]] != "" &&
      options[["populationSize"]] != 0
  } else {
    ready <- options[["bookValues"]] != "" &&
      options[["auditValues"]] != "" &&
      options[["populationSize"]] != 0 &&
      options[["populationValue"]] != 0 # adjust for mpu
  }
  return(ready)
}

.jfaEstimationTable <- function(dataset, options, jaspResults, ready, position) {
  if (!is.null(jaspResults[["regressionTable"]])) {
    return()
  }

  title <- switch(options[["estimator"]],
    "mpu"         = gettext("Direct Estimator"),
    "difference"  = gettext("Difference Estimator"),
    "ratio"       = gettext("Ratio Estimator"),
    "regression"  = gettext("Regression Estimator")
  )

  regressionTable <- createJaspTable(title)
  regressionTable$position <- position

  regressionTable$dependOn(options = c(
    "bookValues",
    "auditValues",
    "populationValue",
    "populationSize",
    "confidence",
    "estimator"
  ))

  regressionTable$addColumnInfo(
    name = "estimate",
    title = gettext("Point estimate"),
    type = "number",
    format = "monetary"
  )
  regressionTable$addColumnInfo(
    name = "uncertainty",
    title = gettext("Precision"),
    type = "number",
    format = "monetary"
  )
  regressionTable$addColumnInfo(
    name = "lower",
    title = gettext("Lower"),
    type = "number",
    format = "monetary",
    overtitle = gettextf("%1$s%% Confidence interval", round(options[["confidence"]] * 100, 2))
  )
  regressionTable$addColumnInfo(
    name = "upper",
    title = gettext("Upper"),
    type = "number",
    format = "monetary",
    overtitle = gettextf("%1$s%% Confidence interval", round(options[["confidence"]] * 100, 2))
  )

  jaspResults[["regressionTable"]] <- regressionTable

  if (!ready) {
    if (options[["estimator"]] == "mpu") {
      regressionTable$addFootnote(gettext("Please specify the population size and your audit values."))
    } else {
      regressionTable$addFootnote(gettext("Please specify the population size, population value and your sample variables."))
    }

    return()
  }

  if (options[["explanatoryText"]]) {
    regressionTable$addFootnote(gettext("The displayed numbers are exact and may differ slightly from the rounded numbers in the explanatory text."))
  }
  if (nrow(dataset) > options[["populationSize"]]) {
    regressionTable$addFootnote(symbol = gettext("<b>Warning.</b>"), gettext("The number of items in the population is lower than the number of items in the sample."))
  }
  if (sum(dataset[[options[["bookValues"]]]]) > options[["populationValue"]]) {
    regressionTable$addFootnote(symbol = gettext("<b>Warning.</b>"), gettext("The number of items in the population is lower than the number of items in the sample."))
  }

  N <- options[["populationSize"]]
  n <- nrow(dataset)

  if (options[["estimator"]] == "mpu") {
    meanW <- mean(dataset[[options[["auditValues"]]]])
    sW <- sd(dataset[[options[["auditValues"]]]])
    pointEstimate <- N * meanW
    uncertainty <- qt(p = (1 - (1 - options[["confidence"]]) / 2), df = n - 1) * sW * (N / sqrt(n)) * sqrt((N - n) / (N - 1))
    lowerCI <- pointEstimate - uncertainty
    upperCI <- pointEstimate + uncertainty
    result <- list(sW = sW, n = n, uncertainty = uncertainty)
  } else if (options[["estimator"]] == "difference") {
    B <- options[["populationValue"]]
    meanE <- mean(dataset[[options[["bookValues"]]]] - dataset[[options[["auditValues"]]]])
    sE <- sd(dataset[[options[["bookValues"]]]] - dataset[[options[["auditValues"]]]])
    pointEstimate <- B - N * meanE
    uncertainty <- qt(p = (1 - (1 - options[["confidence"]]) / 2), df = n - 1) * sE * (N / sqrt(n)) * sqrt((N - n) / (N - 1))
    lowerCI <- pointEstimate - uncertainty
    upperCI <- pointEstimate + uncertainty
    result <- list(sE = sE, n = n, uncertainty = uncertainty)
  } else if (options[["estimator"]] == "ratio") {
    B <- options[["populationValue"]]
    meanB <- mean(dataset[[options[["bookValues"]]]])
    sB <- sd(dataset[[options[["bookValues"]]]])
    meanW <- mean(dataset[[options[["auditValues"]]]])
    sW <- sd(dataset[[options[["auditValues"]]]])
    r <- cor(dataset[[options[["bookValues"]]]], dataset[[options[["auditValues"]]]])
    q <- meanW / meanB
    s <- sqrt(sW^2 - 2 * q * r * sB * sW + q^2 * sB^2)
    pointEstimate <- q * B
    uncertainty <- qt(p = (1 - (1 - options[["confidence"]]) / 2), df = n - 1) * s * (N / sqrt(n)) * sqrt((N - n) / (N - 1))
    lowerCI <- pointEstimate - uncertainty
    upperCI <- pointEstimate + uncertainty
    result <- list(s = s, n = n, uncertainty = uncertainty)
  } else if (options[["estimator"]] == "regression") {
    B <- options[["populationValue"]]
    meanB <- mean(dataset[[options[["bookValues"]]]])
    meanW <- mean(dataset[[options[["auditValues"]]]])
    sW <- sd(dataset[[options[["auditValues"]]]])
    r <- cor(dataset[[options[["bookValues"]]]], dataset[[options[["auditValues"]]]])
    b1 <- (sum(dataset[[options[["bookValues"]]]] * dataset[[options[["auditValues"]]]]) - n * meanB * meanW) / (sum(dataset[[options[["bookValues"]]]]^2) - (sum(dataset[[options[["bookValues"]]]])^2) / n)
    s <- sW * sqrt(1 - r^2)
    pointEstimate <- N * meanW + b1 * (B - N * meanB)
    uncertainty <- qt(p = (1 - (1 - options[["confidence"]]) / 2), df = n - 1) * s * (N / sqrt(n)) * sqrt((N - n) / (N - 1))
    lowerCI <- pointEstimate - uncertainty
    upperCI <- pointEstimate + uncertainty
    result <- list(sW = sW, r = r, n = n, uncertainty = uncertainty)
  }

  row <- data.frame(
    estimate = pointEstimate,
    uncertainty = uncertainty,
    lower = lowerCI,
    upper = upperCI
  )

  regressionTable$addRows(row)
  jaspResults[["result"]] <- createJaspState(result)
}

.jfaEstimationAddText <- function(dataset, options, jaspResults, ready, position) {
  if (options[["explanatoryText"]] || !is.null(jaspResults[["calculationsContainer"]])) {
    calculationsContainer <- createJaspContainer(title = gettext("<u>Calculations</u>"))
    calculationsContainer$position <- 1
    calculationsContainer$dependOn(options = c("explanatoryText", "bookValues", "auditValues", "populationValue", "populationSize", "confidence", "estimator"))

    if (options[["estimator"]] == "mpu") {
      calculationsContainer[["intro"]] <- createJaspHtml(gettext("<i>The required information for the <b>direct</b> estimator consists of:</i>"), "p")

      calc1 <- gettext("The population size <i>N</i>")
      if (options[["populationSize"]] != 0) {
        N <- options[["populationSize"]]
        calc1 <- gettextf("%1$s = %2$i", calc1, N)
      }

      calc2 <- gettext("The sample size <i>n</i>")
      if (options[["auditValues"]] != "") {
        n <- nrow(dataset)
        calc2 <- gettextf("%1$s = %2$i", calc2, n)
      }

      calc3 <- gettextf("The mean of the sample audit values %1$s", "<i>w&#772</i>")
      if (options[["auditValues"]] != "") {
        meanW <- round(mean(dataset[[options[["auditValues"]]]]), 3)
        calc3 <- gettextf("%1$s = %2$s", calc3, meanW)
      }

      calc4 <- gettextf("The standard deviation of the sample audit values %1$s", "<i>s<sub>w</sub></i>")
      if (options[["auditValues"]] != "") {
        sW <- round(sd(dataset[[options[["auditValues"]]]]), 3)
        calc4 <- gettextf("%1$s = %2$s", calc4, sW)
      }

      calc5 <- gettextf("The t-value <i>(df = n - 1)</i> corresponding to %1$s%% confidence %2$s%3$s%4$s", round(options[["confidence"]] * 100), "<i>t<sub>", round(1 - options[["confidence"]], 2), "/2</sub></i>")
      if (options[["auditValues"]] != "") {
        calc5 <- gettextf(
          "The t-value <i>(df = %1$s - 1)</i> corresponding to %2$s%% confidence %3$s%4$s%5$s%6$s",
          n, round(options[["confidence"]] * 100), "<i>t<sub>", round(1 - options[["confidence"]], 2), "/2</sub></i> = ",
          round(qt(p = (1 - (1 - options[["confidence"]]) / 2), df = n - 1), 3)
        )
      }

      calculations <- gettextf("%1$s
                                %2$s
                                %3$s
                                %4$s
                                %5$s", calc1, calc2, calc3, calc4, calc5)
      calculationsContainer[["all"]] <- createJaspHtml(calculations, "p")

      calculationsContainer[["intro2"]] <- createJaspHtml(gettext("<i>This information allows for calculation of:</i>"), "p")

      pointEstimate <- gettextf("The point estimate of the true population value %1$s", "<i>W&#770 = N \u00D7 w&#772</i>")
      if (ready) {
        W <- round(N * meanW, 2)
        pointEstimate <- gettextf("%1$s = %2$s", pointEstimate, W)
      }

      uncertainty <- gettextf(
        "The precision of the estimator %1$s%2$s%3$s",
        "<i>U = t<sub>",
        round(1 - options[["confidence"]], 2),
        "/2</sub> \u00D7 s<sub>w</sub> \u00D7 <sup>N</sup>&frasl;<sub>\u221A n</sub> \u00D7 \u221A (<sup>N - n</sup>&frasl;<sub>N - 1</sub>)</i>"
      )
      if (ready) {
        U <- round(qt(p = (1 - (1 - options[["confidence"]]) / 2), df = n - 1) * sW * (N / sqrt(n)) * sqrt((N - n) / (N - 1)), 2)
        uncertainty <- gettextf("%1$s = %2$s", uncertainty, U)
      }

      confidenceInterval <- gettextf("The confidence interval around the point estimate %1$s", "<i>W&#770 \u00B1 U</i>")
      if (ready) {
        confidenceInterval <- gettextf("%1$s = %2$s %3$s %4$s", confidenceInterval, W, " \u00B1 ", U)
      }

      results <- gettextf(
        "%1$s
                           %2$s
                           %3$s",
        pointEstimate,
        uncertainty,
        confidenceInterval
      )
      calculationsContainer[["results"]] <- createJaspHtml(results, "p")
    } else if (options[["estimator"]] == "difference") {
      calculationsContainer[["intro"]] <- createJaspHtml(gettext("<i>The required information for the <b>difference</b> estimator consists of:</i>"), "p")

      calc1 <- gettext("The population size <i>N</i>")
      if (options[["populationSize"]] != 0) {
        N <- options[["populationSize"]]
        calc1 <- gettextf("%1$s = %2$s", calc1, N)
      }

      calc2 <- gettext("The sample size <i>n</i>")
      if (options[["auditValues"]] != "" || options[["bookValues"]] != "") {
        n <- nrow(dataset)
        calc2 <- gettextf("%1$s = %2$s", calc2, n)
      }

      calc3 <- gettext("The sum of the population book values <i>B</i>")
      if (options[["populationValue"]] != 0) {
        B <- round(options[["populationValue"]], 3)
        calc3 <- gettextf("%1$s = %2$s", calc3, B)
      }

      calc4 <- gettextf("The mean of the sample errors %1$s", "<i>e&#772</i>")
      if (ready) {
        meanE <- round(mean(dataset[[options[["bookValues"]]]] - dataset[[options[["auditValues"]]]]), 3)
        calc4 <- gettextf("%1$s = %2$s", calc4, meanE)
      }

      calc5 <- gettextf("The standard deviation of the sample errors %1$s", "<i>s<sub>e</sub></i>")
      if (ready) {
        sE <- round(sd(dataset[[options[["bookValues"]]]] - dataset[[options[["auditValues"]]]]), 3)
        calc5 <- gettextf("%1$s = %2$s", calc5, sE)
      }

      calc6 <- gettextf(
        "The t-value <i>(df = n - 1)</i> corresponding to %1$s%% confidence %2$s%3$s%4$s",
        round(options[["confidence"]] * 100),
        "<i>t<sub>",
        round(1 - options[["confidence"]], 2),
        "/2</sub></i>"
      )
      if (options[["auditValues"]] != "") {
        calc6 <- gettextf(
          "The t-value <i>(df = %1$s - 1)</i> corresponding to %2$s%% confidence %3$s%4$s%5$s%6$s",
          n,
          round(options[["confidence"]] * 100),
          "<i>t<sub>",
          round(1 - options[["confidence"]], 2),
          "/2</sub></i> = ",
          round(qt(p = (1 - (1 - options[["confidence"]]) / 2), df = n - 1), 3)
        )
      }

      calculations <- gettextf(
        "%1$s
                                %2$s
                                %3$s
                                %4$s
                                %5$s
                                %6$s",
        calc1, calc2, calc3, calc4, calc5, calc6
      )
      calculationsContainer[["all"]] <- createJaspHtml(calculations, "p")

      calculationsContainer[["intro2"]] <- createJaspHtml(gettext("<i>This information allows for calculation of:</i>"), "p")

      pointEstimate <- gettextf("The point estimate of the true population value %1$s", "<i>W&#770 = B - N \u00D7 e&#772</i>")
      if (ready) {
        W <- round(B - N * meanE, 2)
        pointEstimate <- gettextf("%1$s = %2$s", pointEstimate, W)
      }

      uncertainty <- gettextf(
        "The precision of the estimator %1$s%2$s%3$s",
        "<i>U = t<sub>",
        round(1 - options[["confidence"]], 2),
        "/2</sub> \u00D7 s<sub>e</sub> \u00D7 <sup>N</sup>&frasl;<sub>\u221A n</sub> \u00D7 \u221A (<sup>N - n</sup>&frasl;<sub>N - 1</sub>)</i>"
      )
      if (ready) {
        U <- round(qt(p = (1 - (1 - options[["confidence"]]) / 2), df = n - 1) * sE * (N / sqrt(n)) * sqrt((N - n) / (N - 1)), 2)
        uncertainty <- gettextf("%1$s = %2$s", uncertainty, U)
      }

      confidenceInterval <- gettextf("The confidence interval around the point estimate %1$s", "<i>W&#770 \u00B1 U")
      if (ready) {
        confidenceInterval <- gettextf("%1$s = %2$s %3$s %4$s", confidenceInterval, W, " \u00B1 ", U)
      }

      results <- gettextf(
        "%1$s
                            %2$s
                            %3$s",
        pointEstimate,
        uncertainty,
        confidenceInterval
      )
      calculationsContainer[["results"]] <- createJaspHtml(results, "p")
    } else if (options[["estimator"]] == "ratio") {
      calculationsContainer[["intro"]] <- createJaspHtml(gettext("<i>The required information for the <b>ratio</b> estimator consists of:</i>"), "p")

      calc1 <- gettext("The population size <i>N</i>")
      if (options[["populationSize"]] != 0) {
        N <- options[["populationSize"]]
        calc1 <- gettextf("%1$s = %2$s", calc1, N)
      }

      calc2 <- gettext("The sample size <i>n</i>")
      if (options[["auditValues"]] != "" || options[["bookValues"]] != "") {
        n <- nrow(dataset)
        calc2 <- gettextf("%1$s = %2$s", calc2, n)
      }

      calc3 <- gettext("The sum of the population book values <i>B</i>")
      if (options[["populationValue"]] != 0) {
        B <- round(options[["populationValue"]], 3)
        calc3 <- gettextf("%1$s = %2$s", calc3, B)
      }

      calc4 <- gettextf("The mean of the sample book values %1$s", "<i>b&#772</i>")
      if (options[["bookValues"]] != "") {
        meanB <- round(mean(dataset[[options[["bookValues"]]]]), 3)
        calc4 <- gettextf("%1$s = %2$s", calc4, meanB)
      }

      calc5 <- gettextf("The standard deviation of the sample book values %1$s", "<i>s<sub>b</sub></i>")
      if (options[["bookValues"]] != "") {
        sB <- round(sd(dataset[[options[["bookValues"]]]]), 3)
        calc5 <- gettextf("%1$s = %2$s", calc5, sB)
      }

      calc6 <- gettextf("The mean of the sample audit values %1$s", "<i>w&#772</i>")
      if (options[["auditValues"]] != "") {
        meanW <- round(mean(dataset[[options[["auditValues"]]]]), 3)
        calc6 <- gettextf("%1$s = %2$s", calc6, meanW)
      }

      calc7 <- gettextf("The standard deviation of the sample audit values %1$s", "<i>s<sub>w</sub></i>")
      if (options[["auditValues"]] != "") {
        sW <- round(sd(dataset[[options[["auditValues"]]]]), 3)
        calc7 <- gettextf("%1$s = %2$s", calc7, sW)
      }

      calc8 <- gettextf("The correlation coefficient of the sample book values and audit values %1$s", "<i>r<sub>bw</sub></i>")
      if (ready) {
        r <- round(cor(dataset[[options[["bookValues"]]]], dataset[[options[["auditValues"]]]]), 5)
        calc8 <- gettextf("%1$s = %2$s", calc8, r)
      }

      calc9 <- gettextf("The correctness ratio %1$s", "<i>q<sub>bw</sub></i>")
      if (ready) {
        q <- round(meanW / meanB, 5)
        calc9 <- gettextf("%1$s = %2$s", calc9, q)
      }

      calc10 <- gettextf(
        "The t-value <i>(df = n - 1)</i> corresponding to %1$s%% confidence %2$s%3$s%4$s",
        round(options[["confidence"]] * 100),
        "<i>t<sub>",
        round(1 - options[["confidence"]], 2),
        "/2</sub></i>"
      )
      if (options[["auditValues"]] != "") {
        calc10 <- gettextf(
          "The t-value <i>(df = %1$s - 1)</i> corresponding to %2$s%% confidence %3$s%4$s%5$s%6$s",
          n,
          round(options[["confidence"]] * 100),
          "<i>t<sub>",
          round(1 - options[["confidence"]], 2),
          "/2</sub></i> = ",
          round(qt(p = (1 - (1 - options[["confidence"]]) / 2), df = n - 1), 3)
        )
      }

      calculations <- gettextf(
        "%1$s
                                %2$s
                                %3$s
                                %4$s
                                %5$s
                                %6$s
                                %7$s
                                %8$s
                                %9$s
                                %10$s",
        calc1, calc2, calc3, calc4, calc5,
        calc6, calc7, calc8, calc9, calc10
      )
      calculationsContainer[["all"]] <- createJaspHtml(calculations, "p")

      calculationsContainer[["intro2"]] <- createJaspHtml(gettext("<i>This information allows for calculation of:</i>"), "p")

      pointEstimate <- gettextf("The point estimate of the true population value %1$s", "<i>W&#770 = q<sub>bw</sub> \u00D7 B</i>")
      if (ready) {
        W <- round(q * B, 2)
        pointEstimate <- gettextf("%1$s = %2$s", pointEstimate, W)
      }

      uncertainty <- gettextf(
        "The precision of the estimator %1$s%2$s%3$s",
        "<i>U = t<sub>",
        round(1 - options[["confidence"]], 2),
        "/2</sub> \u00D7 \u221A(s<sub>w</sub><sup>2</sup> - 2 \u00D7 q<sub>bw</sub> \u00D7 r<sub>bw</sub> \u00D7 s<sub>b</sub> \u00D7 s<sub>w</sub> + q<sub>bw</sub><sup>2</sup> \u00D7 s<sub>b</sub><sup>2</sup>) \u00D7 <sup>N</sup>&frasl;<sub>\u221A n</sub> \u00D7 \u221A (<sup>N - n</sup>&frasl;<sub>N - 1</sub>)</i>"
      )
      if (ready) {
        U <- round(qt(p = (1 - (1 - options[["confidence"]]) / 2), df = n - 1) * sqrt(sW^2 - 2 * q * r * sB * sW + q^2 * sB^2) * (N / sqrt(n)) * sqrt((N - n) / (N - 1)), 2)
        uncertainty <- gettextf("%1$s = %2$s", uncertainty, U)
      }

      confidenceInterval <- gettextf("The confidence interval around the point estimate %1$s", "<i>W&#770 \u00B1 U")
      if (ready) {
        confidenceInterval <- gettextf("%1$s = %2$s %3$s %4$s", confidenceInterval, W, " \u00B1 ", U)
      }

      results <- gettextf(
        "%1$s
                           %2$s
                           %3$s",
        pointEstimate, uncertainty, confidenceInterval
      )
      calculationsContainer[["results"]] <- createJaspHtml(results, "p")
    } else if (options[["estimator"]] == "regression") {
      calculationsContainer[["intro"]] <- createJaspHtml(gettext("<i>The required information for the <b>regression</b> estimator consists of:</i>"), "p")

      calc1 <- gettext("The population size <i>N</i>")
      if (options[["populationSize"]] != 0) {
        N <- options[["populationSize"]]
        calc1 <- gettextf("%1$s = %2$s", calc1, N)
      }

      calc2 <- gettext("The sample size <i>n</i>")
      if (options[["auditValues"]] != "" || options[["bookValues"]] != "") {
        n <- nrow(dataset)
        calc2 <- gettextf("%1$s = %2$s", calc2, n)
      }

      calc3 <- gettext("The sum of the population book values <i>B</i>")
      if (options[["populationValue"]] != 0) {
        B <- round(options[["populationValue"]], 3)
        calc3 <- gettextf("%1$s = %2$s", calc3, B)
      }

      calc4 <- gettextf("The mean of the sample book values %1$s", "<i>b&#772</i>")
      if (options[["bookValues"]] != "") {
        meanB <- round(mean(dataset[[options[["bookValues"]]]]), 3)
        calc4 <- gettextf("%1$s = %2$s", calc4, meanB)
      }

      calc5 <- gettextf("The mean of the sample audit values %1$s", "<i>w&#772</i>")
      if (options[["auditValues"]] != "") {
        meanW <- round(mean(dataset[[options[["auditValues"]]]]), 3)
        calc5 <- gettextf("%1$s = %2$s", calc5, meanW)
      }

      calc6 <- gettextf("The standard deviation of the sample audit values %1$s", "<i>s<sub>w</sub></i>")
      if (options[["auditValues"]] != "") {
        sW <- round(sd(dataset[[options[["auditValues"]]]]), 3)
        calc6 <- gettextf("%1$s = %2$s", calc6, sW)
      }

      calc7 <- gettextf("The correlation coefficient of the sample book values and audit values %1$s", "<i>r<sub>bw</sub></i>")
      if (ready) {
        r <- round(cor(dataset[[options[["bookValues"]]]], dataset[[options[["auditValues"]]]]), 5)
        calc7 <- gettextf("%1$s = %2$s", calc7, r)
      }

      calc8 <- gettextf("The regression coefficient of the sample book values and audit values %1$s", "<i>b<sub>1</sub></i>")
      if (ready) {
        b1 <- round((sum(dataset[[options[["bookValues"]]]] * dataset[[options[["auditValues"]]]]) - n * meanB * meanW) / (sum(dataset[[options[["bookValues"]]]]^2) - (sum(dataset[[options[["bookValues"]]]])^2) / n), 5)
        calc8 <- gettextf("%1$s = %2$s", calc8, b1)
      }

      calc9 <- gettextf(
        "The t-value <i>(df = n - 1)</i> corresponding to %1$s%% confidence %2$s%3$s%4$s",
        round(options[["confidence"]] * 100, 2),
        "<i>t<sub>",
        round(1 - options[["confidence"]], 2),
        "/2</sub></i>"
      )
      if (options[["auditValues"]] != "") {
        calc9 <- gettextf(
          "The t-value <i>(df = %1$s - 1)</i> corresponding to %2$s%% confidence %3$s%4$s%5$s%6$s",
          n,
          round(options[["confidence"]] * 100, 2),
          "<i>t<sub>",
          round(1 - options[["confidence"]], 2),
          "/2</sub></i> = ",
          round(qt(p = (1 - (1 - options[["confidence"]]) / 2), df = n - 1), 3)
        )
      }

      calculations <- gettextf(
        "%1$s
                                %2$s
                                %3$s
                                %4$s
                                %5$s
                                %6$s
                                %7$s
                                %8$s
                                %9$s",
        calc1, calc2, calc3, calc4, calc5,
        calc6, calc7, calc8, calc9
      )
      calculationsContainer[["all"]] <- createJaspHtml(calculations, "p")

      calculationsContainer[["intro2"]] <- createJaspHtml(gettext("<i>This information allows for calculation of:</i>"), "p")

      pointEstimate <- gettextf("The point estimate of the true population value %1$s", "<i>W&#770 = N \u00D7 w&#772 + b<sub>1</sub> x (B - N \u00D7 b&#772)</i>")
      if (ready) {
        W <- round(N * meanW + b1 * (B - N * meanB), 2)
        pointEstimate <- gettextf("%1$s = %2$s", pointEstimate, W)
      }

      uncertainty <- gettextf(
        "The precision of the estimator %1$s%2$s%3$s",
        "<i>U = t<sub>",
        round(1 - options[["confidence"]], 2),
        "/2</sub> \u00D7 s<sub>w</sub> \u00D7 \u221A(1 - r<sub>bw</sub><sup>2</sup>) \u00D7 <sup>N</sup>&frasl;<sub>\u221A n</sub> \u00D7 \u221A (<sup>N - n</sup>&frasl;<sub>N - 1</sub>)</i>"
      )
      if (ready) {
        U <- round(qt(p = (1 - (1 - options[["confidence"]]) / 2), df = n - 1) * sW * sqrt(1 - r^2) * (N / sqrt(n)) * sqrt((N - n) / (N - 1)), 2)
        uncertainty <- gettextf("%1$s = %2$s", uncertainty, U)
      }

      confidenceInterval <- gettextf("The confidence interval around the point estimate %1$s", "<i>W&#770 \u00B1 U")
      if (ready) {
        confidenceInterval <- gettextf("%1$s = %2$s %3$s %4$s", confidenceInterval, W, " \u00B1 ", U)
      }

      results <- gettextf(
        "%1$s
                           %2$s
                           %3$s",
        pointEstimate,
        uncertainty,
        confidenceInterval
      )
      calculationsContainer[["results"]] <- createJaspHtml(results, "p")
    }

    jaspResults[["calculationsContainer"]] <- calculationsContainer
  } else {
    return()
  }
}

.jfaEstimationSampleSizeTable <- function(dataset, options, jaspResults, ready, position) {
  if (!is.null(jaspResults[["requiredSampleSizeTable"]]) ||
    !options[["requiredSampleSizeTable"]]) {
    return()
  }

  requiredSampleSizeTable <- createJaspTable(gettext("Required Sample Size"))
  requiredSampleSizeTable$position <- position
  requiredSampleSizeTable$dependOn(options = c(
    "requiredSampleSizeTable",
    "bookValues",
    "auditValues",
    "populationValue",
    "populationSize",
    "confidence",
    "estimator",
    "requiredUncertainty"
  ))

  requiredSampleSizeTable$addColumnInfo(
    name = "realUncertainty",
    title = gettext("Achieved precision"),
    type = "number",
    format = "monetary"
  )
  requiredSampleSizeTable$addColumnInfo(
    name = "ncurrent",
    title = gettext("Current <i>n</i>"),
    type = "integer"
  )
  requiredSampleSizeTable$addColumnInfo(
    name = "uncertainty",
    title = gettext("Required precision"),
    type = "number",
    format = "monetary"
  )
  requiredSampleSizeTable$addColumnInfo(
    name = "n",
    title = gettext("Required <i>n</i>"),
    type = "integer"
  )
  requiredSampleSizeTable$addColumnInfo(
    name = "nextra",
    title = gettext("Additional <i>n</i>"),
    type = "integer"
  )

  E <- options[["requiredUncertainty"]]
  requiredSampleSizeTable[["uncertainty"]] <- E

  jaspResults[["requiredSampleSizeTable"]] <- requiredSampleSizeTable

  if (!ready) {
    requiredSampleSizeTable[["ncurrent"]] <- "."
    requiredSampleSizeTable[["realUncertainty"]] <- "."
    requiredSampleSizeTable[["n"]] <- "."
    requiredSampleSizeTable[["nextra"]] <- "."
    return()
  }

  result <- jaspResults[["result"]]$object

  if (options[["estimator"]] == "mpu") {
    gamma <- E^2 / (qt(p = (1 - (1 - options[["confidence"]]) / 2), df = nrow(dataset) - 1)^2 * options[["populationSize"]] * result[["sW"]]^2)
  } else if (options[["estimator"]] == "difference") {
    gamma <- E^2 / (qt(p = (1 - (1 - options[["confidence"]]) / 2), df = nrow(dataset) - 1)^2 * options[["populationSize"]] * result[["sE"]]^2)
  } else if (options[["estimator"]] == "ratio") {
    gamma <- E^2 / (qt(p = (1 - (1 - options[["confidence"]]) / 2), df = nrow(dataset) - 1)^2 * options[["populationSize"]] * result[["s"]]^2)
  } else if (options[["estimator"]] == "regression") {
    gamma <- E^2 / (qt(p = (1 - (1 - options[["confidence"]]) / 2), df = nrow(dataset) - 1)^2 * options[["populationSize"]] * result[["sW"]]^2 * (1 - result[["r"]]^2))
  }
  n2 <- ceiling(options[["populationSize"]] / (1 + gamma))

  requiredSampleSizeTable[["ncurrent"]] <- result[["n"]]
  requiredSampleSizeTable[["realUncertainty"]] <- result[["uncertainty"]]
  requiredSampleSizeTable[["n"]] <- n2
  nExtra <- max(0, n2 - nrow(dataset))
  requiredSampleSizeTable[["nextra"]] <- nExtra
}

.jfaEstimationCorrelationPlot <- function(dataset, options, jaspResults, ready, position) {
  if (!is.null(jaspResults[["correlationPlot"]]) ||
    !options[["correlationPlot"]] ||
    options[["estimator"]] == "mpu") {
    return()
  }

  correlationPlot <- createJaspPlot(plot = NULL, title = gettext("Scatter Plot"), width = 500, height = 400)
  correlationPlot$position <- position
  correlationPlot$dependOn(options = c(
    "correlationPlot",
    "bookValues",
    "auditValues",
    "explanatoryText",
    "estimator",
    "populationValue",
    "populationSize"
  ))

  jaspResults[["correlationPlot"]] <- correlationPlot

  if (!ready) {
    return()
  }

  d <- data.frame(xx = dataset[[options[["bookValues"]]]], yy = dataset[[options[["auditValues"]]]])
  co <- cor(d$xx, d$yy, method = "pearson")
  d <- na.omit(d)
  d <- ceiling(d)
  xVar <- d$xx
  yVar <- d$yy

  fit <- vector("list", 1) # vector("list", 4)
  fit[[1]] <- lm(yy ~ poly(xx, 1, raw = TRUE), data = d)

  bestModel <- 1 # which.min(Bic)

  # format x labels
  xticks <- jaspGraphs::getPrettyAxisBreaks(c(xVar, yVar))
  xLabs <- vector("character", length(xticks))
  xLabs <- format(xticks, digits = 3, scientific = FALSE)

  # Format y labels
  yticks <- xticks
  yLabs <- vector("character", length(yticks))
  yLabs <- format(yticks, digits = 3, scientific = FALSE)

  co <- round(co, 2)

  cols <- rep("gray", nrow(d))
  cols[which(d$xx != d$yy)] <- "red"

  p <- ggplot2::ggplot(data = d, mapping = ggplot2::aes(x = xx, y = yy)) +
    ggplot2::scale_x_continuous(
      name = gettext("Book value"),
      breaks = xticks,
      labels = xLabs,
      limits = range(xticks)
    ) +
    ggplot2::scale_y_continuous(
      name = gettext("Audit value"),
      breaks = yticks,
      labels = yLabs,
      limits = range(yticks)
    ) +
    jaspGraphs::geom_point(size = 3, fill = cols)

  p <- .jfaAddCorrelationLineToPlot(
    fit = fit[[bestModel]],
    plot = p,
    xMin = xticks[1],
    xMax = xticks[length(xticks)],
    lwd = 1
  )
  p <- p + ggplot2::annotate("text",
    x = xticks[1], y = (yticks[length(yticks)] - ((yticks[length(yticks)] - yticks[length(yticks) - 1]) / 2)),
    label = paste0("italic(r) == ", co), size = 8, parse = TRUE, hjust = -0.5, vjust = 0.5
  )
  p <- p + ggplot2::theme(panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb"), panel.grid.major.y = ggplot2::element_line(color = "#cbcbcb")) +
    jaspGraphs::geom_rangeframe() +
    jaspGraphs::themeJaspRaw(legend.position = "none")

  correlationPlot$plotObject <- p

  if (options[["explanatoryText"]]) {
    figure1 <- createJaspHtml(gettext("<b>Figure 1.</b> Scatter plot of the book values in the selection and their audit values. Red dots indicate observations that did not match their original book value. If these red dots lie in the bottom part of the graph, the book values are overstated. If these red dots lie in the upper part of the graph, they are understated. The value <i>r</i> is the Pearson correlation coefficient of the book values and the audit values, an indicator of the strength of the linear relationship between the two variables."), "p")
    figure1$position <- position + 1
    figure1$dependOn(optionsFromObject = correlationPlot)
    figure1$dependOn(options = "explanatoryText")
    jaspResults[["figure1"]] <- figure1
  }
}
