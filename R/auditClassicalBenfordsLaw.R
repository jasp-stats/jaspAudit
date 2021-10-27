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

auditClassicalBenfordsLaw <- function(jaspResults, dataset, options, ...) {

  # Create the procedure paragraph
  .jfaBenfordsLawAddProcedure(options, jaspResults, position = 1)

  # Read in the data
  dataset <- .jfaBenfordsLawReadData(dataset, options)

  # Perform early error checks
  .jfaBenfordsLawDataCheck(dataset, options)

  # Ready for analysis
  ready <- .jfaBenfordsLawReadyCheck(options)

  benfordsLawContainer <- jfaBenfordsLawStage(options, jaspResults, position = 2)

  # --- TABLES

  .jfaTableNumberInit(jaspResults) # Initialize table numbers

  # Create the goodness-of-fit table
  jfaBenfordsLawTable(dataset, options, benfordsLawContainer, jaspResults, ready, positionInContainer = 1)

  # Create the observed and predicted probabilities table
  .jfaBenfordsLawDescriptivesTable(dataset, options, benfordsLawContainer, jaspResults, ready, positionInContainer = 2)

  # ---

  # --- PLOTS

  .jfaFigureNumberInit(jaspResults) # Initialize figure numbers

  # Create the observed and predicted probabilities plot
  .jfaBenfordsLawPlot(dataset, options, benfordsLawContainer, jaspResults, ready, positionInContainer = 3)

  # ---

  # Create the conclusion paragraph
  .jfaBenfordsLawAddConclusion(options, benfordsLawContainer, jaspResults, ready, position = 3)

  # ---
}

.jfaBenfordsLawReadData <- function(dataset, options) {
  if (!is.null(dataset)) {
    return(dataset)
  }
  values <- options[["values"]]
  if (values == "") {
    values <- NULL
  }
  dataset <- .readDataSetToEnd(columns.as.numeric = values, exclude.na.listwise = values)
  return(dataset)
}

.jfaBenfordsLawAddProcedure <- function(options, jaspResults, position) {
  if (options[["explanatoryText"]] &&
    is.null(jaspResults[["procedureContainer"]])) {
    procedureContainer <- createJaspContainer(title = gettext("<u>Procedure</u>"))
    procedureContainer$position <- position

    confidenceLabel <- paste0(round((1 - options[["confidence"]]) * 100, 2), "%")

    if (options[["distribution"]] == "benford") {
      procedureText <- switch(options[["digits"]],
        "first" = gettextf("Benford's law states that in many naturally occurring collections of numerical observations, the leading significant digit is likely to be small. The goal of this procedure is to determine to what extent the first leading digits in the data set follow Benford's law, and to test this relation with a type-I error of <b>%1$s</b>. Data that are not distributed according to Benford's law might need further investigation.", confidenceLabel),
        "firsttwo" = gettextf("Benford's law states that in many naturally occurring collections of numerical observations, the leading significant digit is likely to be small. The goal of this procedure is to determine to what extent the first two leading digits in the data set follow Benford's law, and to test this relation with a type-I error of <b>%1$s</b>. Data that are not distributed according to Benford's law might need further investigation.", confidenceLabel),
        "last" = gettextf("Benford's law states that in many naturally occurring collections of numerical observations, the leading significant digit is likely to be small. The goal of this procedure is to determine to what extent the last digits in the data set follow Benford's law, and to test this relation with a type-I error of <b>%1$s</b>. Data that are not distributed according to Benford's law might need further investigation.", confidenceLabel)
      )
    } else if (options[["distribution"]] == "uniform") {
      procedureText <- switch(options[["digits"]],
        "first" = gettextf("The uniform distribution assigns equal probability to all possible digits that may occur. The goal of this procedure is to determine to what extent the first leading digits in the data set follow the uniform distribution, and to test this relation with a type-I error of <b>%1$s</b>. If the uniform distribution assumption is desirable, then violation of uniformity is cause for further investigation.", confidenceLabel),
        "firsttwo" = gettextf("The uniform distribution assigns equal probability to all possible digits that may occur. The goal of this procedure is to determine to what extent the first two leading digits in the data set follow the uniform distribution, and to test this relation with a type-I error of <b>%1$s</b>. If the uniform distribution assumption is desirable, then violation of uniformity is cause for further investigation.", confidenceLabel),
        "last" = gettextf("The uniform distribution assigns equal probability to all possible digits that may occur. The goal of this procedure is to determine to what extent the last digits in the data set follow the uniform distribution, and to test this relation with a type-I error of <b>%1$s</b>. If the uniform distribution assumption is desirable, then violation of uniformity is cause for further investigation.", confidenceLabel)
      )
    }
    procedureContainer[["procedureParagraph"]] <- createJaspHtml(procedureText, "p")
    procedureContainer[["procedureParagraph"]]$position <- 1
    procedureContainer$dependOn(options = c(
      "explanatoryText",
      "confidence",
      "digits",
      "distribution"
    ))

    jaspResults[["procedureContainer"]] <- procedureContainer
  }
}

.jfaBenfordsLawDataCheck <- function(dataset, options) {
  if (options[["values"]] == "") {
    return()
  }

  .hasErrors(dataset,
    type = c("infinity", "observations"),
    all.target = options[["values"]],
    message = "short",
    observations.amount = "< 2",
    exitAnalysisIfErrors = TRUE
  )
}

.jfaBenfordsLawReadyCheck <- function(options) {
  ready <- options[["values"]] != ""
  return(ready)
}

jfaBenfordsLawStage <- function(options, jaspResults, position) {
  containerTitle <- switch(options[["distribution"]],
    "benford" = gettext("<u>Assessing Benford's Law</u>"),
    "uniform" = gettext("<u>Assessing the Uniform Distribution</u>")
  )
  benfordsLawContainer <- createJaspContainer(title = containerTitle)
  benfordsLawContainer$position <- position
  benfordsLawContainer$dependOn(options = c(
    "values",
    "confidence",
    "digits",
    "distribution"
  ))

  jaspResults[["benfordsLawContainer"]] <- benfordsLawContainer

  return(benfordsLawContainer)
}

.jfaBenfordsLawState <- function(dataset, options, benfordsLawContainer, ready) {
  if (!is.null(benfordsLawContainer[["result"]])) {
    return(benfordsLawContainer[["result"]]$object)
  } else if (ready) {
    test <- digitTests::distr.test(dataset[[options[["values"]]]], check = options[["digits"]], reference = options[["distribution"]])
    btest <- digitTests::distr.btest(dataset[[options[["values"]]]],
      check = options[["digits"]], reference = options[["distribution"]],
      alpha = NULL, BF10 = TRUE, log = TRUE
    )

    result <- list(
      digits = as.numeric(test$digits),
      relFrequencies = as.numeric(test$observed) / as.numeric(test$n),
      inBenford = as.numeric(test$expected) / as.numeric(test$n),
      N = as.numeric(test$n),
      observed = as.numeric(test$observed),
      expected = as.numeric(test$expected),
      chiSquare = as.numeric(test$statistic),
      df = as.numeric(test$parameter),
      pvalue = as.numeric(test$p.value),
      logBF10 = as.numeric(btest$bf)
    )

    benfordsLawContainer[["result"]] <- createJaspState(result)
    benfordsLawContainer[["result"]]$dependOn(options = c(
      "values",
      "confidence",
      "digits",
      "distribution"
    ))
    return(benfordsLawContainer[["result"]]$object)
  } else {
    return(list())
  }
}

jfaBenfordsLawTable <- function(dataset, options, benfordsLawContainer,
                                jaspResults, ready, positionInContainer) {
  .jfaTableNumberUpdate(jaspResults)

  if (!is.null(benfordsLawContainer[["benfordsLawTestTable"]])) {
    return()
  }

  tableTitle <- gettextf(
    "<b>Table %i.</b> Goodness-of-fit Test",
    jaspResults[["tabNumber"]]$object
  )

  benfordsLawTestTable <- createJaspTable(tableTitle)
  benfordsLawTestTable$position <- positionInContainer
  benfordsLawTestTable$dependOn(options = "bayesFactorType")

  bfTitle <- switch(options[["bayesFactorType"]],
    "BF10" = gettextf("BF%1$s", "\u2081\u2080"),
    "BF01" = gettextf("BF%1$s", "\u2080\u2081"),
    "logBF10" = gettextf("Log(BF%1$s)", "\u2081\u2080")
  )

  benfordsLawTestTable$addColumnInfo(
    name = "test",
    title = "",
    type = "string"
  )
  benfordsLawTestTable$addColumnInfo(
    name = "N",
    title = "n",
    type = "integer"
  )
  benfordsLawTestTable$addColumnInfo(
    name = "value",
    title = "X\u00B2",
    type = "string"
  )
  benfordsLawTestTable$addColumnInfo(
    name = "df",
    title = gettext("df"),
    type = "integer"
  )
  benfordsLawTestTable$addColumnInfo(
    name = "pvalue",
    title = "p",
    type = "pvalue"
  )
  benfordsLawTestTable$addColumnInfo(
    name = "bf",
    title = bfTitle,
    type = "number"
  )

  distribution <- switch(options[["distribution"]],
    "benford" = "Benford's law",
    "uniform" = "the uniform distribution"
  )

  message <- switch(options[["digits"]],
    "first" = gettextf("The null hypothesis specifies that the first digits (1 - 9) in the data set are distributed according to %1$s.", distribution),
    "firsttwo" = gettextf("The null hypothesis specifies that the first two digits (10 - 99) in the data set are distributed according to %1$s.", distribution),
    "last" = gettextf("The null hypothesis specifies that the last digits (1 - 9) in the data set are distributed according to %1$s.", distribution)
  )
  benfordsLawTestTable$addFootnote(message)

  message <- gettextf("The Bayes factor is computed using a <i>Dirichlet(%1$s,...,%2$s%3$s)</i> prior with <i>%2$s = 1</i>.", "\u03B1\u2081", "\u03B1", if (options[["digits"]] == "first" || options[["digits"]] == "last") "\u2089" else "\u2089\u2089")
  benfordsLawTestTable$addFootnote(message, colName = "bf")

  benfordsLawContainer[["benfordsLawTestTable"]] <- benfordsLawTestTable

  df <- if (options[["digits"]] == "first" || options[["digits"]] == "last") 8 else 89

  if (!ready) {
    row <- data.frame(test = ".", N = ".", value = ".", df = df, pvalue = ".", bf = ".")
    benfordsLawTestTable$addRows(row)
    return()
  }

  state <- .jfaBenfordsLawState(dataset, options, benfordsLawContainer, ready)

  bf <- switch(options[["bayesFactorType"]],
    "BF10" = exp(state[["logBF10"]]),
    "BF01" = 1 / exp(state[["logBF10"]]),
    "logBF10" = state[["logBF10"]]
  )

  row <- data.frame(
    test = options[["values"]],
    N = state[["N"]],
    value = round(state[["chiSquare"]], 3),
    df = state[["df"]],
    pvalue = state[["pvalue"]],
    bf = bf
  )
  benfordsLawTestTable$addRows(row)
}

.jfaBenfordsLawDescriptivesTable <- function(dataset, options, benfordsLawContainer,
                                             jaspResults, ready, positionInContainer) {
  if (!options[["summaryTable"]]) {
    return()
  }

  .jfaTableNumberUpdate(jaspResults)

  if (is.null(benfordsLawContainer[["benfordsLawTable"]])) {
    tableTitle <- gettextf(
      "<b>Table %i.</b> Frequency Table",
      jaspResults[["tabNumber"]]$object
    )

    benfordsLawTable <- createJaspTable(tableTitle)
    benfordsLawTable$position <- positionInContainer
    columnTitle <- switch(options[["distribution"]],
      "benford" = gettext("Benford's law"),
      "uniform" = gettext("Uniform distribution")
    )

    benfordsLawTable$dependOn(options = "summaryTable")

    whichDigit <- switch(options[["digits"]],
      "first" = gettext("Leading digit"),
      "firsttwo" = gettext("Leading digits"),
      "last" = gettext("Last digit")
    )

    benfordsLawTable$addColumnInfo(name = "digit", title = whichDigit, type = "integer")
    benfordsLawTable$addColumnInfo(name = "count", title = gettext("Count"), type = "integer")
    benfordsLawTable$addColumnInfo(name = "observed", title = gettext("Relative frequency"), type = "number")
    benfordsLawTable$addColumnInfo(name = "expected", title = columnTitle, type = "number")

    benfordsLawContainer[["benfordsLawTable"]] <- benfordsLawTable

    if (options[["digits"]] == "first" || options[["digits"]] == "last") {
      digits <- 1:9
    } else {
      digits <- 10:99
    }

    if (!ready) {
      expected <- switch(options[["distribution"]],
        "benford" = log10(1 + 1 / digits),
        "uniform" = 1 / length(digits)
      )

      row <- data.frame(
        digit = digits,
        count = rep(".", length(digits)),
        observed = rep(".", length(digits)),
        expected = expected
      )
      benfordsLawTable$addRows(row)
      return()
    }

    state <- .jfaBenfordsLawState(dataset, options, benfordsLawContainer, ready)

    row <- data.frame(
      digit = state[["digits"]],
      count = state[["observed"]],
      observed = state[["relFrequencies"]],
      expected = state[["inBenford"]]
    )

    benfordsLawTable$addRows(row)
  }
}

.jfaBenfordsLawPlot <- function(dataset, options, benfordsLawContainer,
                                jaspResults, ready, positionInContainer) {
  if (!options[["benfordsLawPlot"]]) {
    return()
  }

  .jfaFigureNumberUpdate(jaspResults)

  if (is.null(benfordsLawContainer[["benfordsLawPlot"]])) {
    benfordsLawPlot <- createJaspPlot(
      plot = NULL,
      title = gettext("Observed vs. Expected Relative Frequencies"),
      width = 600, height = 400
    )

    benfordsLawPlot$position <- positionInContainer
    benfordsLawPlot$dependOn(options = c("benfordsLawPlot"))

    benfordsLawContainer[["benfordsLawPlot"]] <- benfordsLawPlot

    if (!ready) {
      return()
    }

    if (options[["digits"]] == "first" || options[["digits"]] == "last") {
      pointSize <- 5
      lineSize <- 1.5
    } else if (options[["digits"]] == "firsttwo") {
      pointSize <- 2
      lineSize <- 1.2
    }

    state <- .jfaBenfordsLawState(dataset, options, benfordsLawContainer, ready)

    legendName <- switch(options[["distribution"]],
      "benford" = gettext("Benford's law"),
      "uniform" = gettext("Uniform distribution")
    )

    d <- data.frame(
      x = c(state[["digits"]], state[["digits"]]),
      y = c(state[["relFrequencies"]], state[["inBenford"]]),
      type = c(
        rep(gettext("Observed"), length(state[["digits"]])),
        rep(legendName, length(state[["digits"]]))
      )
    )

    yBreaks <- jaspGraphs::getPrettyAxisBreaks(c(0, d$y), min.n = 4)

    if (options[["digits"]] == "first" || options[["digits"]] == "last") {
      xBreaks <- state[["digits"]]
      xLabels <- state[["digits"]]
    } else {
      xBreaks <- state[["digits"]]
      xLabels <- c(
        10, rep("", 9),
        20, rep("", 9),
        30, rep("", 9),
        40, rep("", 9),
        50, rep("", 9),
        60, rep("", 9),
        70, rep("", 9),
        80, rep("", 9),
        90, rep("", 8),
        99
      )
    }

    axisName <- switch(options[["digits"]],
      "first" = gettext("Leading digit"),
      "firsttwo" = gettext("Leading digits"),
      "last" = gettext("Last digit")
    )

    plotData <- data.frame(x = c(0, 0), y = c(0, 1), type = c(gettext("Observed"), legendName))
    plotData$type <- switch(options[["distribution"]],
      "benford" = factor(x = plotData$type, levels = levels(factor(plotData$type))[c(1, 2)]),
      "uniform" = factor(x = plotData$type, levels = levels(factor(plotData$type))[c(2, 1)])
    )

    p <- ggplot2::ggplot(data = plotData, mapping = ggplot2::aes(x = x, y = y, fill = type)) +
      ggplot2::geom_point(alpha = 0) +
      ggplot2::geom_bar(
        data = subset(d, type == legendName), mapping = ggplot2::aes(x = x, y = y), fill = "darkgray",
        stat = "identity", color = "black", size = 1.2
      ) +
      jaspGraphs::geom_line(
        data = subset(d, type == gettext("Observed")), mapping = ggplot2::aes(x = x, y = y),
        color = "dodgerblue", size = lineSize
      ) +
      jaspGraphs::geom_point(
        data = subset(d, type == gettext("Observed")), mapping = ggplot2::aes(x = x, y = y),
        fill = "dodgerblue", size = pointSize, stroke = 1.5
      ) +
      ggplot2::scale_x_continuous(
        name = axisName, breaks = xBreaks, labels = xLabels,
        limits = c(min(state[["digits"]]) - 0.5, max(state[["digits"]]) + 0.5),
      ) +
      ggplot2::scale_y_continuous(
        name = gettext("Relative frequency"), breaks = yBreaks, limits = c(0, max(yBreaks))
      ) +
      ggplot2::labs(fill = "") +
      ggplot2::theme(legend.text = ggplot2::element_text(margin = ggplot2::margin(l = -5, r = 50))) +
      ggplot2::guides(fill = ggplot2::guide_legend(reverse = TRUE, override.aes = list(
        size = c(7, 10), shape = c(21, 22),
        fill = c("dodgerblue", "darkgray"), stroke = 2, color = "black", alpha = 1
      ))) +
      jaspGraphs::geom_rangeframe() +
      jaspGraphs::themeJaspRaw(legend.position = "top")

    benfordsLawPlot$plotObject <- p
  }

  if (options[["explanatoryText"]]) {
    distribution <- switch(options[["distribution"]],
      "benford" = "Benford's law",
      "uniform" = "the uniform distribution"
    )
    benfordsLawPlotText <- createJaspHtml(gettextf("<b>Figure %i.</b> The observed relative frequencies of each digit in the data set compared to the expected relative frequencies under %2$s. For data sets distributed according %2$s the blue dots will lie near the top of the grey bars.", jaspResults[["figNumber"]]$object, distribution), "p")

    benfordsLawPlotText$position <- positionInContainer + 1
    benfordsLawPlotText$dependOn(optionsFromObject = benfordsLawContainer[["benfordsLawPlot"]])
    benfordsLawContainer[["benfordsLawPlotText"]] <- benfordsLawPlotText
  }
}

.jfaBenfordsLawAddConclusion <- function(options, benfordsLawContainer, jaspResults,
                                         ready, position) {
  if (!is.null(jaspResults[["conclusionContainer"]]) || !ready || !options[["explanatoryText"]]) {
    return()
  }

  conclusionContainer <- createJaspContainer(title = gettext("<u>Conclusion</u>"))
  conclusionContainer$position <- position
  conclusionContainer$dependOn(options = c(
    "values",
    "confidence",
    "digits",
    "explanatoryText",
    "distribution"
  ))

  confidenceLabel <- paste0(round(options[["confidence"]] * 100, 2), "%")

  state <- .jfaBenfordsLawState(dataset, options, benfordsLawContainer, ready)

  rejectnull <- state[["pvalue"]] < (1 - options[["confidence"]])
  conclusion <- if (rejectnull) gettext("is rejected") else gettext("is not rejected")

  pvalue <- format.pval(state[["pvalue"]], eps = 0.001)
  pvalue <- if (rejectnull) gettextf("%1$s < %2$s", pvalue, "\u03B1") else gettextf("%1$s >= %2$s", pvalue, "\u03B1")

  distribution <- switch(options[["distribution"]],
    "benford" = "Benford's law",
    "uniform" = "the uniform distribution"
  )

  conclusionText <- switch(options[["digits"]],
    "first" = gettextf("The <i>p</i> value is %1$s and the null hypothesis that the first digits in the data set are distributed according to %2$s <b>%3$s</b>.", pvalue, distribution, conclusion),
    "firsttwo" = gettextf("The <i>p</i> value is %1$s and the null hypothesis that the first two digits in the data set are distributed according to %2$s <b>%3$s</b>.", pvalue, distribution, conclusion),
    "last" = gettextf("The <i>p</i> value is %1$s and the null hypothesis that the last digits in the data set are distributed according to %2$s <b>%3$s</b>.", pvalue, distribution, conclusion)
  )
  conclusionText <- gettextf("%1$s The Bayes factor indicates that the data are <b>%2$s times</b> more likely to occur under the null hypothesis than under the alternative hypothesis.", conclusionText, format(1 / exp(state[["logBF10"]]), digits = 3))

  conclusionContainer[["conclusionParagraph"]] <- createJaspHtml(conclusionText, "p")
  conclusionContainer[["conclusionParagraph"]]$position <- 1
  conclusionContainer$dependOn(options = c(
    "explanatoryText",
    "confidence",
    "values",
    "digits",
    "distribution"
  ))

  jaspResults[["conclusionContainer"]] <- conclusionContainer
}
