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

# This is a temporary fix
# TODO: remove it when R will solve this problem!
gettextf <- function(fmt, ..., domain = NULL) {
  return(sprintf(gettext(fmt, domain = domain), ...))
}

################################################################################
################## The Audit Workflow ##########################################
################################################################################

.jfaWorkflowAnalysis <- function(options, jaspResults) {
  ### PROCEDURE STAGE ###
  .jfaProcedureStage(options, jaspResults)
  ready <- .jfaReadyForNextStageCheck(options, jaspResults, stage = "procedure")
  if (!ready) {
    return()
  } # Stop if not enough information is given to quantify the sampling objectives

  ### PLANNING STAGE ###
  .jfaPlanningStage(options, jaspResults, workflow = TRUE)

  ready <- .jfaReadyForNextStageCheck(options, jaspResults, stage = "planning")
  if (!ready) {
    return()
  } # Stop if "To Selection" is not pressed

  ### SELECTION STAGE ###
  .jfaSelectionStage(options, jaspResults, workflow = TRUE)

  ### EXECUTION STAGE ###
  .jfaExecutionStage(options, jaspResults)

  ready <- .jfaReadyForNextStageCheck(options, jaspResults, stage = "execution")
  if (!ready) {
    return()
  } # Stop if "To Evaluation" is not pressed

  ### EVALUATION STAGE ###
  .jfaEvaluationStage(options, jaspResults, workflow = TRUE)
}

################################################################################
################## The Separate Stages of the Audit Workflow ###################
################################################################################

#####################################
######### PROCEDURE STAGE ###########
#####################################

.jfaProcedureStage <- function(options, jaspResults) {
  # Extract the record number and book value columns
  dataset <- .jfaReadData(options, jaspResults, stage = "procedure")

  # Check for errors due to incompatible options (variables)
  .jfaInputOptionsCheck(options, dataset, parentContainer = NULL, stage = "procedure")

  # Deduce the necessary values from the input options
  planningOptions <- .jfaInputOptionsGather(options, dataset, jaspResults,
    stage = "planning",
    rawData = TRUE
  )

  # Create the procedure paragraph
  .jfaAddExplanatoryText(options, planningOptions,
    stageContainer = NULL, stageState = NULL,
    jaspResults, stage = "procedure", positionInContainer = 1
  )

  # Create the audit risk model paragraph
  .jfaAddAuditRiskModel(options, jaspResults, position = 2)

  # --- TABLES

  .jfaTableNumberInit(jaspResults) # Initialize table numbers

  # Create a table containing descriptive statistics for the book values
  .jfaTableBookDist(options, planningOptions, jaspResults, positionInContainer = 2)

  # --- PLOTS

  .jfaFigureNumberInit(jaspResults) # Initialize figure numbers

  # Create a plot of the population book values (if the user wants it)
  .jfaPlotBookDist(options, dataset, jaspResults, positionInContainer = 3)
}

#####################################
######### PLANNING STAGE ############
#####################################

.jfaPlanningStage <- function(options, jaspResults, workflow) {
  if (workflow) {
    .jfaCriticalTransactionsInit(options, jaspResults)

    # Deduce the necessary values from the input options
    planningOptions <- .jfaInputOptionsGather(options,
      dataset = NULL, jaspResults,
      stage = "planning", rawData = TRUE
    )
  } else if (!workflow) {
    .jfaTableNumberInit(jaspResults) # Initialize table numbers
    .jfaFigureNumberInit(jaspResults) # Initialize figure numbers

    # Deduce the necessary values from the input options
    planningOptions <- .jfaInputOptionsGather(options,
      dataset = NULL, jaspResults,
      stage = "planning", rawData = FALSE
    )

    # Create the procedure paragraph
    .jfaAddExplanatoryText(options, planningOptions,
      stageContainer = NULL, stageState = NULL,
      jaspResults, stage = "procedure", positionInContainer = 1
    )

    # Create the audit risk model paragraph
    .jfaAddAuditRiskModel(options, jaspResults, position = 2)
  }

  # Check if the options have valid values for running the analysis
  ready <- .jfaReadyCheck(options)

  if (!options[["materiality_test"]] && !options[["min_precision_test"]]) {
    return()
  } # Stop if no sampling objective is selected

  # Create the container that holds the planning output
  planningContainer <- .jfaAddStageContainer(jaspResults, stage = "planning", position = 3)

  # Perfrom early error checks
  .jfaInputOptionsCheck(options,
    dataset = NULL, planningContainer, stage = "planning",
    ready, planningOptions
  )

  # Get the planning state if it exists, otherwise make one
  planningState <- .jfaPlanningState(options, planningOptions, planningContainer, ready, jaspResults)

  # Create explanatory text for the planning
  .jfaAddExplanatoryText(options, planningOptions, planningContainer, planningState, jaspResults,
    stage = "planning", positionInContainer = 1
  )

  # --- TABLES

  # Create the summary table
  .jfaTablePlanning(options, planningOptions, planningState, planningContainer, jaspResults,
    ready,
    positionInContainer = 2
  )

  if (options[["bayesian"]]) {
    # Cerate the prior and posterior statistics table
    .jfaTablePriorPosterior(options, planningOptions, planningState, planningContainer,
      jaspResults, ready,
      positionInContainer = 4, stage = "planning"
    )
  }

  # --- PLOTS

  # Create the sample size comparison plot
  .jfaPlotSampleSizes(options, planningOptions, planningState, planningContainer, jaspResults,
    ready,
    positionInContainer = 5
  )

  if (!options[["bayesian"]]) {
    # Create the implied distribution plot
    .plotErrorDist(options, planningOptions, planningState, planningContainer,
      jaspResults, ready,
      positionInContainer = 7
    )
  } else if (options[["bayesian"]]) {
    # Create the prior and expected posterior plot
    .jfaPlotPriorAndPosterior(options, planningOptions, planningState, planningContainer,
      jaspResults,
      positionInContainer = 7, stage = "planning"
    )

    # Create the prior predictive plots
    .jfaPlotPredictive(options, planningOptions, planningState, planningContainer,
      jaspResults,
      positionInContainer = 9, stage = "planning"
    )
  }
}

#####################################
######### SELECTION STAGE ###########
#####################################

.jfaSelectionStage <- function(options, jaspResults, workflow) {
  if (workflow) {
    # Create the container that holds the selection output
    selectionContainer <- .jfaAddStageContainer(jaspResults, stage = "selection-workflow", position = 4)

    # Read in additional variables
    dataset <- .jfaAddSelectionResult(options, jaspResults)

    # Import options and results from the planning stage
    selectionOptions <- .jfaInputOptionsGather(options, dataset, jaspResults, stage = "planning", rawData = TRUE)

    planningContainer <- jaspResults[["planningContainer"]]
    planningState <- planningContainer[["planningState"]]$object

    error <- .jfaInputOptionsCheck(options, dataset, selectionContainer, stage = "selection")
    if (error) {
      return()
    } # Quit on errors

    if (is.null(planningState)) {
      return()
    } # Quit if no planning was done

    # Perform the sampling
    selectionState <- .jfaSelectionState(options, dataset, planningState, selectionContainer)
  } else if (!workflow) {
    .jfaFigureNumberInit(jaspResults) # Initialize figure numbers
    .jfaTableNumberInit(jaspResults) # Initialize table numbers

    # Create a custom container for the selection analysis
    selectionContainer <- .jfaAddStageContainer(jaspResults, stage = "selection", position = 1)

    # Read in the relevant variables from the data set
    dataset <- .jfaReadData(options, jaspResults, stage = "selection")

    # Deduce relevant quantities from input options
    selectionOptions <- .jfaInputOptionsGather(options, dataset, jaspResults, stage = "selection")

    # Check for errors due to incompatible options
    error <- .jfaInputOptionsCheck(options, dataset, selectionContainer, stage = "selection", parentOptions = selectionOptions)
    if (error) {
      return()
    } # Quit on errors

    options[["materiality_type"]] <- if (options[["units"]] == "values") "materiality_abs" else "materiality_rel"

    # Create a planning state
    planningState <- .jfaGetPreviousStageFromOptions(options, stage = "planning", dataset)

    # Perform error checks
    .jfaInputOptionsCheck(options, dataset, parentContainer = NULL, stage = "procedure")

    # Perform the sampling
    selectionState <- .jfaSelectionCalculation(options, dataset, planningState, selectionContainer)

    # Add the sample indicator to the data
    .jfaAddSelectionIndicator(options, selectionOptions, selectionState, jaspResults)
  }

  # Create explanatory text for the selection
  .jfaAddExplanatoryText(options, selectionOptions, selectionContainer, selectionState, jaspResults, stage = "selection", positionInContainer = 1, prevState = planningState)

  # --- TABLES

  # Create a table containing information about the selection process
  .jfaTableSelection(options, dataset, selectionOptions, planningState, selectionState, selectionContainer, jaspResults, positionInContainer = 2)

  # Create a table containing information about the monetary interval selection
  .jfaTableInterval(options, dataset, selectionOptions, planningState, selectionContainer, selectionState, jaspResults, positionInContainer = 4)

  # Create a table containing descriptive statistics of the sample
  .jfaTableSampleDescriptives(options, selectionState, selectionContainer, jaspResults, positionInContainer = 5)

  # Create a table displaying the selection
  .jfaTableSample(options, selectionOptions, selectionState, selectionContainer, jaspResults, positionInContainer = 6)
}

#####################################
######### EXECUTION STAGE ###########
#####################################

.jfaExecutionStage <- function(options, jaspResults) {
  if (options[["pasteVariables"]]) {
    # Add the two computed colums to the data set
    planningOptions <- .jfaInputOptionsGather(options, dataset = NULL, jaspResults, stage = "planning", rawData = TRUE)
    selectionState <- .jfaSelectionState(options, dataset, jaspResults[["planningState"]], jaspResults[["selectionContainer"]])

    sample <- selectionState[["sample"]]
    dataset <- .readDataSetToEnd(columns.as.numeric = options[["id"]])
    sampleFilter <- numeric(selectionState[["N.items"]])
    rowNumber <- as.numeric(sample[["row"]])
    sampleFilter[rowNumber] <- as.numeric(sample[["times"]])
    auditDataVariable <- rep(NA, selectionState[["N.items"]])
    auditDataVariable[options[["performAudit"]][[1]]$rowIndices] <- options[["performAudit"]][[1]]$values

    if (is.null(jaspResults[["indicator_col"]])) {
      jaspResults[["indicator_col"]] <- createJaspColumn(columnName = options[["indicator_col"]], dependencies = "indicator_col")
    }
    if (is.null(jaspResults[["variable_col"]])) {
      jaspResults[["variable_col"]] <- createJaspColumn(columnName = options[["variable_col"]], dependencies = "variable_col")
    }

    jaspResults[["indicator_col"]]$setOrdinal(sampleFilter)
    jaspResults[["variable_col"]]$setScale(auditDataVariable)
  }
}

#####################################
######### EVALUATION STAGE ##########
#####################################

.jfaEvaluationStage <- function(options, jaspResults, workflow) {
  if (workflow) {
    # Create the container that holds the selection output
    evaluationContainer <- .jfaAddStageContainer(jaspResults, stage = "evaluation-workflow", position = 5)

    # Read in additional variables
    dataset <- .jfaAddEvaluationResult(options, jaspResults)

    # See if analysis can be run
    ready <- options[["values.audit"]] != ""

    # Extract only the sample
    if (ready) {
      sample <- subset(dataset, dataset[[options[["indicator_col"]]]] != 0)
    }

    # Import options and results from the planning and selection stages
    evaluationOptions <- .jfaInputOptionsGather(options, dataset, jaspResults, stage = "planning", rawData = TRUE)

    planningContainer <- jaspResults[["planningContainer"]]
    planningState <- planningContainer[["planningState"]]$object

    selectionContainer <- jaspResults[["selectionContainer"]]
    selectionState <- selectionContainer[["selectionState"]]$object

    if (is.null(selectionState)) {
      return()
    }

    # Perform the evaluation
    evaluationState <- .jfaEvaluationState(options, sample, evaluationOptions, evaluationContainer, selectionState)

    # Create explanatory text for the evaluation
    .jfaAddExplanatoryTextEvaluation(options, evaluationOptions, planningState, selectionState, evaluationContainer, positionInContainer = 1)
  } else if (!workflow) {
    .jfaTableNumberInit(jaspResults) # Initialize table numbers
    .jfaFigureNumberInit(jaspResults) # Initialize figure numbers

    # Create an empty container for the evaluation analysis
    evaluationContainer <- .jfaAddStageContainer(jaspResults, stage = "evaluation", position = 1)

    # Read in the relevant variables from the data set
    sample <- .jfaReadData(options, jaspResults, stage = "evaluation")

    # Remove the critical transactions if wanted
    sample <- .jfaSubsetWithoutCritical(options, sample)

    # Check for errors due to incompatible options
    error <- .jfaInputOptionsCheck(options, sample, evaluationContainer, stage = "evaluation")
    if (error) {
      return()
    }

    # Deduce relevant quantities from input options
    evaluationOptions <- .jfaInputOptionsGather(options, sample, jaspResults, stage = "evaluation")

    # Create the evaluation state that holds the results
    evaluationState <- .jfaEvaluationAnalysisState(options, sample, evaluationOptions, evaluationContainer)

    # Create a backwards a planning state and a selection state
    planningState <- .jfaGetPreviousPlanningStateFromOptions(options, sample, evaluationOptions)
    selectionState <- .jfaGetPreviousStageFromOptions(options, stage = "selection")

    # Create explanatory text for the evaluation
    .jfaAddExplanatoryTextEvaluation(options, evaluationOptions, planningState, selectionState, evaluationContainer, positionInContainer = 1)
  }

  # --- TABLES

  # Create a table containing information about the evaluation process
  .jfaTableEvaluation(options, evaluationOptions, evaluationState, evaluationContainer, jaspResults, positionInContainer = 2)
  if (!options[["workflow"]]) {
    .jfaTableStratum(options, sample, evaluationState, evaluationContainer, jaspResults, positionInContainer = 3)
  }

  .jfaTableTaints(options, sample, evaluationContainer, jaspResults, positionInContainer = 4)

  if (options[["bayesian"]]) { # Create a table containing assumption checks
    .jfaTableAssumptions(options, sample, evaluationContainer, jaspResults, positionInContainer = 5)
  }

  if (options[["bayesian"]]) { # Create a table containing information regarding the prior and posterior
    .jfaTablePriorPosterior(options, evaluationOptions, evaluationState, evaluationContainer, jaspResults, ready = NULL, positionInContainer = 6, stage = "evaluation")
  }

  .jfaTableTaints(options, sample, evaluationContainer, jaspResults, positionInContainer = 5)

  # --- PLOTS

  if (options[["bayesian"]]) { # Create a plot containing the prior and posterior distribution
    .jfaPlotPriorAndPosterior(options, evaluationOptions, evaluationState, evaluationContainer,
      jaspResults,
      positionInContainer = 7, stage = "evaluation"
    )
  }

  if (options[["bayesian"]]) { # Create the prior predictive plots
    .jfaPlotPredictive(options, evaluationOptions, evaluationState, evaluationContainer,
      jaspResults,
      positionInContainer = 9, stage = "evaluation"
    )
  }

  # Create a plot containing evaluation information
  .jfaPlotObjectives(options, evaluationOptions, evaluationState, evaluationContainer, jaspResults, positionInContainer = 11)

  # Create a plot containing the correlation between the book and audit values
  .jfaPlotScatter(options, sample, evaluationOptions, evaluationContainer, jaspResults, positionInContainer = 13)

  # Add the conclusion stage
  .jfaConclusionStage(options, jaspResults, workflow)
}

#####################################
######### CONCLUSION STAGE ##########
#####################################

.jfaConclusionStage <- function(options, jaspResults, workflow) {
  if (!is.null(jaspResults[["conclusionContainer"]]) || (options[["values.audit"]] == "" && options[["dataType"]] %in% c("data", "pdata"))) {
    return()
  }

  evaluationContainer <- jaspResults[["evaluationContainer"]]
  evaluationState <- evaluationContainer[["evaluationState"]]$object

  # Create a container for the conclusion
  conclusionContainer <- createJaspContainer(title = gettext("<u>Conclusion</u>"))
  conclusionContainer$position <- 5
  conclusionContainer$dependOn(optionsFromObject = evaluationContainer)
  conclusionContainer$dependOn(options = c("explanatoryText", "tableCorrections"))
  jaspResults[["conclusionContainer"]] <- conclusionContainer

  .jfaAddExplanatoryText(options, stageOptions = NULL, stageContainer = NULL, stageState = NULL, jaspResults, stage = "conclusion", positionInContainer = 1, workflow = workflow)

  .jfaCorrectionsTable(options, jaspResults, workflow, positionInContainer = 3)
}

################################################################################
################## Common functions for figure and table numbers ###############
################################################################################

.jfaFigureNumberInit <- function(jaspResults) {
  # Initialize figure numbers
  jaspResults[["figNumber"]] <- createJaspState(0)
}

.jfaTableNumberInit <- function(jaspResults) {
  # Initialize table numbers
  jaspResults[["tabNumber"]] <- createJaspState(0)
}

.jfaTableNumberUpdate <- function(jaspResults) {
  # Update table numbers + 1
  currentNumber <- jaspResults[["tabNumber"]]$object
  jaspResults[["tabNumber"]] <- createJaspState(currentNumber + 1)
}

.jfaFigureNumberUpdate <- function(jaspResults) {
  # Update figure numbers + 1
  currentNumber <- jaspResults[["figNumber"]]$object
  jaspResults[["figNumber"]] <- createJaspState(currentNumber + 1)
}

################################################################################
################## Common functions for reading data and options ###############
################################################################################

.jfaReadVariableFromOptions <- function(options, type) {
  name <- switch(type,
    "id" = options[["id"]],
    "values" = options[["values"]],
    "values.audit" = options[["values.audit"]],
    "times" = options[["times"]],
    "rank" = options[["rank"]],
    "additional" = unlist(options[["variables"]]),
    "critical" = options[["critical_name"]],
    "stratum" = options[["stratum"]]
  )
  if (!is.null(name) && name == "" && !(type %in% c("additional", "critical"))) {
    name <- NULL
  }
  return(name)
}

.jfaReadData <- function(options, jaspResults, stage) {
  if (stage == "procedure") {
    id <- .jfaReadVariableFromOptions(options, type = "id")
    values <- .jfaReadVariableFromOptions(options, type = "values")

    out <- list()

    if (!is.null(id)) {
      dataset <- .readDataSetToEnd(columns = id, exclude.na.listwise = id)
      dataset[[id]] <- as.character(dataset[[id]])

      out[["N.items"]] <- nrow(dataset)
      out[["N.items.unique"]] <- length(unique(dataset[[id]]))

      if (!is.null(values)) {
        dataset <- .readDataSetToEnd(columns.as.numeric = values, columns = id, exclude.na.listwise = c(values, id))
        dataset[[id]] <- as.character(dataset[[id]])

        data_values <- dataset[[values]]
        out[["N.units"]] <- sum(data_values, na.rm = TRUE)
        out[["N.units.abs"]] <- sum(abs(data_values), na.rm = TRUE)
        out[["mean"]] <- mean(data_values, na.rm = TRUE)
        out[["sd"]] <- sd(data_values, na.rm = TRUE)
        out[["quantile"]] <- as.numeric(quantile(data_values, probs = c(0.25, 0.50, 0.75), na.rm = TRUE))
        out[["ready"]] <- TRUE
      } else {
        out[["N.units"]] <- out[["N.items"]]
        out[["ready"]] <- if (options[["materiality_test"]]) options[["materiality_type"]] == "materiality_rel" else TRUE
      }
    } else {
      dataset <- NULL
      out[["N.items"]] <- 0
      out[["N.items.unique"]] <- 0
      out[["N.units"]] <- 0
      out[["ready"]] <- FALSE
    }

    materiality <- if (options[["materiality_type"]] == "materiality_rel") options[["materiality_rel_val"]] else options[["materiality_abs_val"]]

    if (materiality == 0) out[["ready"]] <- FALSE

    jaspResults[["procedureOptions"]] <- createJaspState(out)
    jaspResults[["procedureOptions"]]$dependOn(c("id", "values", "materiality_type", "materiality_rel_val", "materiality_abs_val"))

    return(dataset)
  } else if (stage == "selection") {
    id <- .jfaReadVariableFromOptions(options, type = "id")
    if (is.null(id)) {
      return(NULL)
    }
    values <- .jfaReadVariableFromOptions(options, type = "values")
    rank <- .jfaReadVariableFromOptions(options, type = "rank")
    vars <- .jfaReadVariableFromOptions(options, type = "additional")
    variables <- c(id, values, rank, vars)
  } else if (stage == "evaluation") {
    id <- .jfaReadVariableFromOptions(options, type = "id")
    values <- .jfaReadVariableFromOptions(options, type = "values")
    values.audit <- .jfaReadVariableFromOptions(options, type = "values.audit")
    times <- .jfaReadVariableFromOptions(options, type = "times")
    stratum <- .jfaReadVariableFromOptions(options, type = "stratum")
    variables <- c(id, values, values.audit, times, stratum)
  }
  if (!is.null(variables)) {
    if (!is.null(.jfaReadVariableFromOptions(options, type = "stratum"))) {
      dataset <- .readDataSetToEnd(columns = id, columns.as.numeric = variables[which(variables != id & variables != stratum)], columns.as.factor = stratum, exclude.na.listwise = variables)
    } else {
      dataset <- .readDataSetToEnd(columns = id, columns.as.numeric = variables[which(variables != id)], exclude.na.listwise = variables)
    }
    dataset[[id]] <- as.character(dataset[[id]])
    # if (stage == "evaluation" && !is.null(times) && !is.null(id) && !is.null(values.audit)) { # Apply sample filter only when required variables are given
    #   dataset <- subset(dataset, dataset[[times]] > 0)
    # }
    return(dataset)
  } else {
    return(NULL)
  }
}

.jfaInputOptionsGather <- function(options, dataset, jaspResults, stage, rawData = FALSE) {
  input <- list()

  if (stage == "planning") {
    input[["conf_level"]] <- options[["conf_level"]]
    input[["conf_level_label"]] <- paste0(round(input[["conf_level"]] * 100, 2), "%")

    if (!rawData) {
      input[["N.units"]] <- options[["n_units"]]
    } else {
      procedureOptions <- jaspResults[["procedureOptions"]]$object
      input[["N.items"]] <- procedureOptions[["N.items"]]
      input[["N.units"]] <- procedureOptions[["N.units"]]
    }

    input[["materiality_type"]] <- if (options[["materiality_type"]] == "materiality_rel") gettext("percentage") else gettext("amount")
    input[["materiality_val"]] <- if (options[["materiality_type"]] == "materiality_rel") options[["materiality_rel_val"]] else options[["materiality_abs_val"]] / input[["N.units"]]
    input[["materiality_label"]] <- if (options[["materiality_type"]] == "materiality_rel") paste0(round(input[["materiality_val"]] * 100, 2), "%") else format(options[["materiality_abs_val"]], scientific = FALSE)

    input[["expected_val"]] <- if (options[["expected_type"]] == "expected_rel") options[["expected_rel_val"]] else options[["expected_abs_val"]]
    input[["expected_type"]] <- if (options[["expected_type"]] == "expected_rel") gettext("percentage") else gettext("amount")
    input[["expected_label"]] <- if (options[["expected_type"]] == "expected_rel") paste0(round(input[["expected_val"]] * 100, 2), "%") else options[["expected_abs_val"]]

    input[["min_precision_rel_val"]] <- options[["min_precision_rel_val"]]
    input[["min_precision_label"]] <- paste0(round(input[["min_precision_rel_val"]] * 100, 4), "%")
  } else if (stage == "selection") {
    input[["N.items"]] <- if (is.null(dataset)) 0 else nrow(dataset)
    if (options[["id"]] != "" && options[["values"]] != "") {
      input[["N.units"]] <- sum(dataset[[options[["values"]]]])
    } else {
      input[["N.units"]] <- input[["N.items"]]
    }
    input[["n.units"]] <- options[["n"]]
  } else if (stage == "evaluation") {
    input[["conf_level"]] <- options[["conf_level"]]
    input[["conf_level_label"]] <- paste0(round(options[["conf_level"]] * 100, 2), "%")
    input[["likelihood"]] <- options[["method"]]
    # Take over N.units and N.items from population
    if (options[["dataType"]] == "pdata") {
      if (options[["id"]] != "") {
        if (options[["values"]] != "") {
          if (options[["stratum"]] != "") {
            dataset <- as.data.frame(.readDataSetToEnd(columns.as.numeric = options[["values"]], columns.as.factor = options[["stratum"]], exclude.na.listwise = c(options[["values"]], options[["stratum"]])))
            input[["N.items"]] <- as.numeric(table(dataset[[options[["stratum"]]]]))
            input[["N.units"]] <- aggregate(dataset[[options[["values"]]]], by = list(stratum = dataset[[options[["stratum"]]]]), FUN = sum)[["x"]]
          } else {
            dataset <- as.data.frame(.readDataSetToEnd(columns = options[["values"]], exclude.na.listwise = options[["values"]]))
            input[["N.items"]] <- nrow(dataset)
            input[["N.units"]] <- sum(dataset[[options[["values"]]]])
          }
        } else {
          dataset <- as.data.frame(.readDataSetToEnd(columns = options[["id"]], exclude.na.listwise = options[["id"]]))
          input[["N.items"]] <- nrow(dataset)
          input[["N.units"]] <- input[["N.items"]]
        }
      } else {
        input[["N.items"]] <- 0
        input[["N.units"]] <- 0
      }
    } else {
      input[["N.items"]] <- options[["n_items"]]
      input[["N.units"]] <- options[["n_units"]]
    }

    input[["materiality_val"]] <- if (options[["materiality_type"]] == "materiality_rel") options[["materiality_rel_val"]] else options[["materiality_abs_val"]] / input[["N.units"]]
    input[["materiality_label"]] <- if (options[["materiality_type"]] == "materiality_rel") paste0(round(options[["materiality_rel_val"]] * 100, 2), "%") else format(options[["materiality_abs_val"]], scientific = FALSE)

    if (options[["bayesian"]]) {
      input[["expected_type"]] <- if (options[["expected_type"]] == "expected_rel") gettext("percentage") else gettext("amount")
      input[["expected_val"]] <- if (options[["expected_type"]] == "expected_rel") options[["expected_rel_val"]] else options[["expected_abs_val"]]
    }
    input[["min_precision_val"]] <- options[["min_precision_rel_val"]]
  }
  return(input)
}

.jfaGetPreviousStageFromOptions <- function(options, stage, dataset = NULL) {
  state <- switch(stage,
    "planning" = list("N.items" = nrow(dataset), "n" = options[["n"]]),
    "selection" = list("n.units" = options[["n"]], "n.items" = options[["n"]])
  )
  return(state)
}

.jfaSubsetWithoutCritical <- function(options, sample) {
  if (options[["critical_negative"]] && options[["critical_action"]] == "remove" && options[["values"]] != "") {
    sample <- subset(sample, sample[[options[["values"]]]] >= 0)
  }
  return(sample)
}

################################################################################
################## Common functions for containers #############################
################################################################################

.jfaAddStageContainer <- function(jaspResults, stage, position = 1) {
  if (stage == "procedure") {
    if (!is.null(jaspResults[["procedureContainer"]])) {
      return(jaspResults[["procedureContainer"]])
    }

    container <- createJaspContainer(title = gettext("<u>Procedure</u>"))
    container$position <- position
    container$dependOn(options = c(
      "explanatoryText", "conf_level", "materiality_type", "materiality_abs_val",
      "materiality_rel_val", "values", "id"
    ))

    jaspResults[["procedureContainer"]] <- container
  } else if (stage == "planning") {
    if (!is.null(jaspResults[["planningContainer"]])) {
      return(jaspResults[["planningContainer"]])
    }

    container <- createJaspContainer(title = gettext("<u>Planning</u>"))
    container$position <- position
    container$dependOn(options = c(
      "ir", "irCustom", "cr", "crCustom", "conf_level", "n_units", "materiality_type",
      "materiality_rel_val", "materiality_abs_val", "expected_type", "expected_rel_val",
      "expected_abs_val", "likelihood", "id", "values", "separateMisstatement",
      "min_precision_rel_val", "min_precision_test", "materiality_test", "by", "max", "prior_method",
      "n_prior", "x_prior", "alpha", "beta", "display"
    ))

    jaspResults[["planningContainer"]] <- container
  } else if (stage == "selection") {
    if (!is.null(jaspResults[["selectionContainer"]])) {
      return(jaspResults[["selectionContainer"]])
    }

    container <- createJaspContainer(title = "")
    container$position <- position
    container$dependOn(options = c(
      "id", "values", "variables", "rank", "sampling_method", "units",
      "start", "seed", "n", "randomize", "file", "randomStart"
    ))

    jaspResults[["selectionContainer"]] <- container
  } else if (stage == "selection-workflow") {
    prevContainer <- jaspResults[["planningContainer"]]
    prevState <- prevContainer[["planningState"]]$object

    if (!is.null(jaspResults[["selectionContainer"]])) {
      return(jaspResults[["selectionContainer"]])
    } else if (!is.null(prevState)) {
      container <- createJaspContainer(title = gettext("<u>Selection</u>"))
      container$position <- position
      container$dependOn(
        optionsFromObject = prevContainer,
        options = c(
          "samplingChecked", "units", "sampling_method", "seed",
          "start", "variables", "rank", "separateMisstatement", "randomize", "randomStart"
        )
      )

      jaspResults[["selectionContainer"]] <- container
    }
  } else if (stage == "evaluation") {
    if (!is.null(jaspResults[["evaluationContainer"]])) {
      return(jaspResults[["evaluationContainer"]])
    }

    container <- createJaspContainer(title = "")
    container$position <- position
    container$dependOn(options = c(
      "id", "values", "values.audit", "times", "conf_level",
      "n_units", "n_items", "ir", "irCustom", "cr", "crCustom",
      "expected_type", "expected_rel_val", "expected_abs_val",
      "materiality_test", "materiality_type", "materiality_rel_val", "materiality_abs_val",
      "dataType", "n", "x", "method", "area", "lta",
      "display", "priorType", "separateMisstatement",
      "min_precision_test", "min_precision_rel_val",
      "by", "prior_method", "prior_n", "prior_x", "alpha", "beta",
      "critical_items", "critical_negative", "critical_action",
      "stratum", "pooling"
    ))

    jaspResults[["evaluationContainer"]] <- container
  } else if (stage == "evaluation-workflow") {
    prevContainer <- jaspResults[["selectionContainer"]]
    prevState <- prevContainer[["selectionState"]]$object

    if (!is.null(jaspResults[["evaluationContainer"]])) {
      return(jaspResults[["evaluationContainer"]])
    } else if (!is.null(prevState)) {
      container <- createJaspContainer(title = gettext("<u>Evaluation</u>"))
      container$position <- position
      container$dependOn(options = c("evaluationChecked", "values.audit", "method", "performAudit", "lta", "area", "display"))
      jaspResults[["evaluationContainer"]] <- container
    }
  }
  return(container)
}

################################################################################
################## Common functions for error checks ###########################
################################################################################

.jfaInputOptionsCheck <- function(options, dataset, parentContainer, stage,
                                  ready = NULL, parentOptions = NULL) {
  if (stage == "procedure") {
    variables <- NULL
    if (options[["id"]] != "") {
      variables <- c(variables, options[["id"]])
    }
    if (options[["values"]] != "") {
      variables <- c(variables, options[["values"]])
    }
    if (length(variables) == 0) {
      return()
    }

    # Check for infinity, zero variance, and any missing observations
    .hasErrors(dataset,
      type = c("infinity", "observations"),
      all.target = variables, message = "short",
      observations.amount = paste0("< ", nrow(dataset)),
      exitAnalysisIfErrors = TRUE
    )
  } else if (stage == "planning") {
    if (ready) {
      if (options[["materiality_type"]] == "materiality_abs" && options[["materiality_abs_val"]] >= parentOptions[["N.units"]]) {
        # Error if the value of the performance materiality exceeds the total population value
        parentContainer$setError(gettext("Analysis not possible: The materiality is higher than, or equal to the total value of the observations."))
        return(TRUE)
      }
      expTMP <- if (options[["expected_type"]] == "expected_rel") options[["expected_rel_val"]] else options[["expected_abs_val"]]
      if (options[["expected_type"]] == "expected_abs" && parentOptions[["N.units"]] > 0) {
        if (expTMP >= parentOptions[["N.units"]]) {
          parentContainer$setError(gettext("Analysis not possible: The expected errors are equal to, or higher than, the number of units in the population."))
          return(TRUE)
        }
        if (expTMP != 0 && expTMP >= ceiling(parentOptions[["materiality_val"]] * parentOptions[["N.units"]]) && options[["materiality_test"]]) {
          # Error if the expected errors exceed the performance materiality
          parentContainer$setError(gettext("Analysis not possible: The expected errors are higher than the performance materiality."))
          return(TRUE)
        }
      } else if (options[["expected_type"]] == "expected_rel") {
        if (expTMP != 0 && expTMP >= parentOptions[["materiality_val"]] && options[["materiality_test"]]) {
          # Error if the expected errors exceed the performance materiality
          parentContainer$setError(gettext("Analysis not possible: The expected errors are higher than the performance materiality."))
          return(TRUE)
        }
      }
      if (.jfaAuditRiskModelCalculation(options) >= 1) {
        # Error if the detection risk of the analysis is higher than one
        parentContainer$setError(gettextf("The detection risk is equal to or higher than 100%%. Please re-specify the custom values for the Inherent risk and/or Control risk, or the confidence."))
        return(TRUE)
      }
      if (options[["bayesian"]] && !options[["materiality_test"]] && options[["prior_method"]] %in% c("impartial", "arm")) {
        # Error if the prior construction method does not match the sampling objective
        parentContainer$setError(gettext("You cannot incorporate this prior information into your analysis because you are not testing against a performance materiality."))
        return(TRUE)
      }
      if (options[["bayesian"]] && options[["expected_type"]] == "expected_abs" && options[["prior_method"]] %in% c("impartial", "arm")) {
        # Error if the prior construction method does not match the sampling objective
        currentMethod <- switch(options[["prior_method"]],
          "impartial" = gettext("an impartial prior distribution"),
          "arm" = gettext("a prior distribution using risk assessments")
        )
        parentContainer$setError(gettextf("In order to construct %1$s, specify the expected errors as a percentage of the total population.", currentMethod))
        return(TRUE)
      }
    }
    # No error in the planning options
    return(FALSE)
  } else if (stage == "selection") {
    if (options[["id"]] != "" && !is.null(dataset) && nrow(dataset) != length(unique(dataset[[options[["id"]]]]))) {
      # Error if the transaction ID's are not unique
      parentContainer[["errorMessage"]] <- createJaspTable(gettext("Selection Summary"))
      parentContainer$setError(gettext("You must specify unique item ID's. The row numbers of the data set are sufficient."))
      return(TRUE)
    } else {
      # No error in the selection options
      return(FALSE)
    }
  } else if (stage == "evaluation") {
    if (!options[["bayesian"]] && options[["method"]] == "hypergeometric" && (options[["n_units"]] == 0 && options[["dataType"]] != "pdata")) {
      # Error if the population size is not defined when the hypergeometric bound is used.
      parentContainer[["errorMessage"]] <- createJaspTable(gettext("Evaluation Summary"))
      parentContainer$setError(gettext("The hypergeometric upper bound requires that you specify the number of units in the population."))
      return(TRUE)
    } else if (options[["method"]] %in% c("direct", "difference", "quotient", "regression") && ((options[["n_items"]] == 0 || options[["n_units"]] == 0) && options[["dataType"]] != "pdata")) {
      # Error if the population size or the population value are zero when using direct, difference, quotient, or regression.
      parentContainer[["errorMessage"]] <- createJaspTable(gettext("Evaluation Summary"))
      parentContainer$setError(gettext("The direct, difference, ratio, and regression bounds require that you specify the number of items and the number of units in the population."))
      return(TRUE)
    } else if (options[["dataType"]] %in% c("data", "pdata") && options[["id"]] != "" && !is.null(dataset) && nrow(dataset) != length(unique(dataset[[options[["id"]]]]))) {
      # Error if the transaction ID's are not unique
      parentContainer[["errorMessage"]] <- createJaspTable(gettext("Selection Summary"))
      parentContainer$setError(gettext("You must specify unique item ID's. The row numbers of the data set are sufficient."))
      return(TRUE)
    } else if (.jfaAuditRiskModelCalculation(options) >= 1) {
      # Error if the detection risk of the analysis is higher than one
      parentContainer[["errorMessage"]] <- createJaspTable(gettext("Evaluation Summary"))
      parentContainer$setError(gettextf("The detection risk is equal to or higher than 100%%. Please re-specify your values for the Inherent risk and/or Control risk, or the confidence."))
      return(TRUE)
    } else {
      # No error in the evaluation options
      return(FALSE)
    }
  }
}

.jfaReadyForNextStageCheck <- function(options, jaspResults, stage) {
  if (stage == "procedure") {
    # Check whether any of the two sampling objectives is selected
    ready <- ((options[["materiality_test"]] && ((options[["materiality_type"]] == "materiality_rel" && options[["materiality_rel_val"]] != 0) || (options[["materiality_type"]] == "materiality_abs" && options[["materiality_abs_val"]] != 0))) || (options[["min_precision_test"]] && options[["min_precision_rel_val"]] != 0))
  } else if (stage == "planning") {
    # Check whether the "To selection" button is pressed and no error occurred in the previous stage
    ready <- options[["samplingChecked"]] && !jaspResults[["planningContainer"]]$getError() && (options[["materiality_test"]] || options[["min_precision_test"]])
  } else if (stage == "selection") {
    # No check for selection
  } else if (stage == "execution") {
    # Check whether the "To evaluation" button is pressed and no error occurred in the previous stage
    ready <- options[["evaluationChecked"]] && !jaspResults[["planningContainer"]]$getError() && !jaspResults[["selectionContainer"]]$getError()
  } else if (stage == "evaluation") {
    # No check for evaluation
  }
  return(ready)
}

.jfaReadyCheck <- function(options) {
  ready <- TRUE
  if (options[["materiality_test"]] && !options[["min_precision_test"]] && options[["materiality_type"]] == "materiality_abs") {
    if (options[["workflow"]]) {
      ready <- options[["materiality_abs_val"]] > 0 && options[["values"]] != ""
    }
    if (!options[["workflow"]]) {
      ready <- options[["materiality_abs_val"]] > 0 && options[["n_units"]] > 0
    }
  }
  if (options[["materiality_test"]] && !options[["min_precision_test"]] && options[["materiality_type"]] == "materiality_rel") {
    ready <- options[["materiality_rel_val"]] > 0
  }
  if (options[["min_precision_test"]] && options[["materiality_test"]]) {
    if (options[["materiality_type"]] == "materiality_abs") {
      if (options[["workflow"]]) {
        ready <- options[["materiality_abs_val"]] > 0 && options[["values"]] != ""
      }
      if (!options[["workflow"]]) {
        ready <- options[["materiality_abs_val"]] > 0 && options[["n_units"]] > 0
      }
    } else {
      ready <- options[["materiality_rel_val"]] > 0
    }
  }
  return(ready)
}

################################################################################
################## Common functions for the explanatory text ###################
################################################################################

.jfaAddExplanatoryText <- function(options, stageOptions, stageContainer, stageState,
                                   jaspResults, stage, positionInContainer, prevState = NULL, workflow = NULL) {
  if (options[["explanatoryText"]]) {
    if (stage == "procedure") {
      container <- .jfaAddStageContainer(jaspResults, stage = "procedure", position = 1)

      if (!options[["materiality_test"]] && !options[["min_precision_test"]]) {
        text <- gettextf("Select one or both sampling objectives to begin planning an audit sample.\n\n%1$s <b>Test against a performance materiality</b>\n\nEnable this objective if you want to test whether the total misstatement in the population exceeds a certain limit (i.e., the performance materiality) based on a sample. This approach allows you to plan a sample such that, when the sample meets your expectations, the maximum error is said to be below performance materiality. In the evaluation you will be able to quantify the evidence that your sample contains for or against the statement that the population misstatement does not exceed the performance materiality.\n\n%2$s <b>Obtain a minimum precision</b>\n\nEnable this objective if you want to obtain a minimum precision when estimating the total misstatement in the population based on a sample. This approach allows you to plan a sample such that, when the sample meets expectations, the accuracy of your estimate is below a tolerable percentage. In the evaluation you will be able to quantify the accuracy of your estimate of the population misstatement.", "\u25CF", "\u25CF")
      } else if (options[["materiality_test"]] && !options[["min_precision_test"]]) {
        text <- gettextf(
          "The objective of this sampling procedure is to show with %1$s confidence that the %2$s of misstatement in the population is lower than the performance materiality of %3$s.",
          stageOptions[["conf_level_label"]],
          stageOptions[["expected_type"]],
          stageOptions[["materiality_label"]]
        )
      } else if (!options[["materiality_test"]] && options[["min_precision_test"]]) {
        text <- gettextf(
          "The objective of this sampling procedure is to estimate the misstatement in the population with %1$s confidence and a minimum precision of %2$s.\n\nThe quantity of interest is the misstatement \u03B8 in the population. Misstatement is defined as the difference between an item's booked (recorded) value and its audited (true) value.",
          stageOptions[["conf_level_label"]],
          stageOptions[["min_precision_label"]]
        )
      } else if (options[["materiality_test"]] && options[["min_precision_test"]]) {
        text <- gettextf(
          "The objective of this sampling procedure is to show with %1$s confidence and a precision of %3$s that the %2$s of misstatement in the population is lower than the performance materiality of %4$s.",
          stageOptions[["conf_level_label"]],
          stageOptions[["expected_type"]],
          stageOptions[["min_precision_label"]],
          stageOptions[["materiality_label"]]
        )
      }

      if (options[["materiality_test"]]) {
        text <- gettextf(
          "%1$s\n\nThe quantity of interest is the misstatement (%2$s) in the population. Misstatement is defined as the difference between an item's booked (recorded) value and its audit (true) value. When testing the population misstatement against a given performance materiality, %2$s*, two statistical hypotheses about %2$s are formulated:\n
                                  The (null) hypothesis of intolerable misstatement %3$s,
                                  The (alternative) hypothesis of tolerable misstatement %4$s.\n
                                  The audit risk (%5$s) is the risk of incorrectly rejecting the hypothesis %3$s. To reject this hypothesis on the basis of a sample, the information from the sample must be sufficient to reduce %5$s to an appropriately low level (< %6$s%%).",
          text,
          "\u03B8",
          "H\u208A: \u03B8 \u2265 \u03B8*",
          "H\u208B: \u03B8 < \u03B8*",
          "\u03B1",
          round((1 - options[["conf_level"]]) * 100, 2)
        )
      }

      if (options[["bayesian"]]) {
        text <- gettextf(
          "%1$s\n\nIn a Bayesian analysis, the parameter %2$s is first assigned a prior probability distribution that incorporates the existing information about its possible values. A description and figure of the current prior distribution can be found under the <i>Report</i> section. You can incorporate existing information using the options under the <i>Prior</i> section.",
          text, "\u03B8"
        )
      }

      container[["paragraph"]] <- createJaspHtml(text, "p")
      container[["paragraph"]]$position <- positionInContainer
    } else if (stage == "planning") {
      if (is.null(stageContainer[["paragraph"]]) && !stageContainer$getError()) {
        if (options[["materiality_test"]] && !options[["min_precision_test"]]) {
          samplingObjectivesMessage <- gettextf("a performance materiality of %1$s", stageOptions[["materiality_label"]])
          samplingObjectivesMessage2 <- gettextf("the sample provides sufficient information to conclude that the misstatement %1$s is below the performance materiality %1$s*", "\u03B8")
        } else if (!options[["materiality_test"]] && options[["min_precision_test"]]) {
          samplingObjectivesMessage <- gettextf("a minimum precision of %1$s", stageOptions[["min_precision_label"]])
          samplingObjectivesMessage2 <- gettextf("the sample provides sufficient information to estimate the misstatement %1$s with the minimum precision", "\u03B8")
        } else if (options[["materiality_test"]] && options[["min_precision_test"]]) {
          samplingObjectivesMessage <- gettextf("a performance materiality of %1$s and a minimum precision of %2$s", stageOptions[["materiality_label"]], stageOptions[["min_precision_label"]])
          samplingObjectivesMessage2 <- gettextf("the sample provides sufficient information to conclude that the misstatement %1$s is below the performance materiality %1$s* with the minimum precision", "\u03B8")
        }

        separateMisstatementMessage <- if (options[["separateMisstatement"]]) gettext("\n\nFurthermore, the uncertainty regarding \u03B8 will only be extrapolated over the unseen part of the population. This requires the additional assumption that the population taints are homogeneous.") else ""

        distribution <- options[["likelihood"]]
        if (options[["bayesian"]]) {
          distribution <- switch(options[["likelihood"]],
            "poisson" = gettext("gamma"),
            "binomial" = gettext("beta"),
            "hypergeometric" = gettext("beta-binomial")
          )
        }

        introMessage <- gettext("The purpose of the planning stage is to find a minimum sample size so that, given a certain number of expected misstatements, the sample provides sufficient information to achieve the specified sampling objectives.\n\n")
        if (options[["separateMisstatement"]] && options[["expected_type"]] == "expected_all") {
          mleMessage <- gettext("No assumptions are made about the most likely expected error in the sample.")
        } else {
          mleMessage <- gettextf("The most likely expected error in the sample is expected to be %1$s.", stageOptions[["expected_label"]])
        }
        finalx <- if (options[["separateMisstatement"]] && options[["expected_type"]] == "expected_all") stageState[["n"]] else stageState[["x"]]
        if (options[["prior_method"]] == "default" || options[["prior_method"]] == "strict") {
          stageContainer[["paragraph"]] <- createJaspHtml(gettextf(
            "%1$s%2$s The minimum sample size that is required for %3$s, assuming the sample contains %4$s errors, is %5$s. This sample size is based on the %6$s distribution, the a priori assumption that every value of the misstatement is equally likely, and the given expected errors.\n\nConsequently, if the intended sample is evaluated and the sum of (proportional) misstatements in the audited items is lower than (or equal to) %7$s, %8$s. %9$s",
            introMessage,
            mleMessage,
            samplingObjectivesMessage,
            finalx,
            stageState[["n"]],
            distribution,
            finalx,
            samplingObjectivesMessage2,
            separateMisstatementMessage
          ), "p")
        } else if (options[["prior_method"]] == "arm") {
          stageContainer[["paragraph"]] <- createJaspHtml(gettextf(
            "%1$s%2$s The minimum sample size that is required for %3$s, assuming the sample contains %4$s errors, is %5$s. This sample size is based on the %6$s distribution, the a priori assessments of inherent risk (<i>%7$s</i>) and control risk (<i>%8$s</i>) from the Audit Risk Model, and the given expected errors.\n\nConsequently, if the intended sample is evaluated and the sum of (proportional) misstatements in the audited items is lower than (or equal to) %9$s, %10$s. %11$s",
            introMessage,
            mleMessage,
            samplingObjectivesMessage,
            finalx,
            stageState[["n"]],
            distribution,
            options[["ir"]],
            options[["cr"]],
            finalx,
            samplingObjectivesMessage2,
            separateMisstatementMessage
          ), "p")
        } else if (options[["prior_method"]] == "impartial") {
          stageContainer[["paragraph"]] <- createJaspHtml(gettextf(
            "%1$s%2$s The minimum sample size that is required for %3$s, assuming the sample contains %4$s errors, is %5$s. This sample size is based on the %6$s distribution, the a priori assumption that tolerable misstatement is equally likely to occur as intolerable misstatement, and the given expected errors.\n\nConsequently, if the intended sample is evaluated and the sum of (proportional) misstatements in the audited items is lower than (or equal to) %7$s, %8$s. %9$s",
            introMessage,
            mleMessage,
            samplingObjectivesMessage,
            finalx,
            stageState[["n"]],
            distribution,
            finalx,
            samplingObjectivesMessage2,
            separateMisstatementMessage
          ), "p")
        } else if (options[["prior_method"]] == "sample") {
          stageContainer[["paragraph"]] <- createJaspHtml(gettextf(
            "%1$s%2$s The minimum sample size that is required for %3$s, assuming the sample contains %4$s errors, is %5$s. This sample size is based on the %6$s distribution, the a priori assumption that an earlier sample of %7$s transactions containing %8$s errors is seen, and the given expected errors.\n\nConsequently, if the intended sample is evaluated and the sum of (proportional) misstatements in the audited items is lower than (or equal to) %9$s, %10$s. %11$s",
            introMessage,
            mleMessage,
            samplingObjectivesMessage,
            finalx,
            stageState[["n"]],
            distribution,
            options[["n_prior"]],
            options[["x_prior"]],
            finalx,
            samplingObjectivesMessage2,
            separateMisstatementMessage
          ), "p")
        } else if (options[["prior_method"]] == "param") {
          stageContainer[["paragraph"]] <- createJaspHtml(gettextf(
            "%1$s%2$s The minimum sample size that is required for %3$s, assuming the sample contains %4$s errors, is %5$s. This sample size is based on the %6$s distribution, the manually specified prior distribution, and the given expected errors.\n\nConsequently, if the intended sample is evaluated and the sum of (proportional) misstatements in the audited items is lower than (or equal to) %7$s, %8$s. %9$s",
            introMessage,
            mleMessage,
            samplingObjectivesMessage,
            finalx,
            stageState[["n"]],
            distribution,
            finalx,
            samplingObjectivesMessage2,
            separateMisstatementMessage
          ), "p")
        }

        stageContainer[["paragraph"]]$position <- positionInContainer
        stageContainer[["paragraph"]]$dependOn(options = "explanatoryText")
      }
    } else if (stage == "selection") {
      label_method <- switch(options[["sampling_method"]],
        "random" = gettext("random"),
        "interval" = gettext("fixed interval"),
        "cell" = gettext("cell")
      )

      if (options[["units"]] == "values") {
        label_var <- if (options[["values"]] != "") gettextf("book values (<i>%1$s</i>)", options[["values"]]) else gettext("book values (<i>...</i>)")
      }
      if (options[["units"]] == "items") {
        label_var <- if (options[["id"]] != "") gettextf("ID variable (<i>%1$s</i>)", options[["id"]]) else gettext("ID variable (<i>...</i>)")
      }

      if (!is.null(stageState) && !is.null(stageState[["musFailed"]])) {
        # MUS has failed for some reason, make a note and use record sampling
        warningMessage <- gettext("\n\n<br><b>Warning:</b> A monetary unit sampling method was tried but failed.")
      } else {
        warningMessage <- ""
      }

      label_method <- if (options[["units"]] == "items") gettextf("%1$s record sampling", label_method) else gettextf("%1$s monetary unit sampling", label_method)

      message <- gettextf(
        "The purpose of the selection stage is to statistically select a number of sampling units from the population. Sampling units can be individual items (rows) or individual monetary units. The sampling units are selected from the population according to the selection method. To learn more about the current selection method, look under the <i>Method</i> section.\n\nFrom the population of %1$s %2$s items, %3$s sampling units (%4$s) are selected from the %5$s using the %6$s method.%7$s",
        stageOptions[["N.items"]],
        if (options[["randomize"]]) gettext("randomized") else gettext("non-randomized"),
        if (options[["workflow"]]) prevState[["n"]] else options[["n"]],
        if (options[["units"]] == "items") gettext("items") else gettext("monetary units"),
        label_var,
        label_method,
        warningMessage
      )

      if (!is.null(stageState) && stageState[["n.units"]] > stageState[["n.items"]]) {
        message <- gettextf(
          "%1$s\n\n<b>Note:</b> The selected sample (%2$s) contains fewer items than the planned sample size (%3$s) because some items are selected more than once. The items containing these %4$s extra selected sampling units will be counted multiple times in the evaluation.",
          message,
          stageState[["n.items"]],
          stageState[["n.units"]],
          stageState[["n.units"]] - stageState[["n.items"]]
        )
      }


      stageContainer[["paragraph"]] <- createJaspHtml(message, "p")
      stageContainer[["paragraph"]]$position <- positionInContainer
      stageContainer[["paragraph"]]$dependOn(options = "explanatoryText")
    } else if (stage == "conclusion") {
      # Import options and results from the planning and selection stages
      stage <- if (workflow) "planning" else "evaluation"
      planningOptions <- .jfaInputOptionsGather(options,
        dataset = NULL, jaspResults,
        stage = stage, rawData = TRUE
      )

      # Import result of analysis from jaspResults
      evaluationContainer <- jaspResults[["evaluationContainer"]]
      evaluationState <- evaluationContainer[["evaluationState"]]$object

      if (is.null(evaluationState) || is.na(evaluationState[["ub"]]) || is.na(evaluationState[["precision"]])) {
        return()
      }

      conclusionContainer <- jaspResults[["conclusionContainer"]]

      # Produce relevant terms conditional on the analysis result
      approveMateriality <- TRUE
      if (options[["materiality_test"]]) {
        ubCrit <- if (evaluationState[["method"]] %in% c("direct", "difference", "quotient", "regression")) evaluationState[["ub"]] / evaluationState[["N.units"]] else evaluationState[["ub"]]
        if (ubCrit < planningOptions[["materiality_val"]]) {
          aboveBelowMateriality <- gettext("below")
          lowerHigherMateriality <- gettext("lower")
          approveMateriality <- TRUE
        } else {
          aboveBelowMateriality <- gettext("above")
          lowerHigherMateriality <- gettext("higher")
          approveMateriality <- FALSE
        }
      }

      approvePrecision <- TRUE
      if (options[["min_precision_test"]]) {
        precisionCrit <- if (evaluationState[["method"]] %in% c("direct", "difference", "quotient", "regression")) evaluationState[["precision"]] / evaluationState[["N.units"]] else evaluationState[["precision"]]
        if (precisionCrit <= options[["min_precision_rel_val"]]) {
          lowerHigherPrecision <- gettext("lower")
          approvePrecision <- TRUE
        } else {
          lowerHigherPrecision <- gettext("higher")
          approvePrecision <- FALSE
        }
      }

      additionalMessage <- if (approveMateriality && approvePrecision) gettext("\n\n<b>Objectives:</b> You have achieved your initial sampling objectives.") else gettext("\n\n<b>Objectives:</b> You have not achieved your initial sampling objectives. It is recommended to draw more samples from this population and continue audit procedures.")

      if (options[["materiality_test"]] && !options[["min_precision_test"]]) {
        message <- gettextf(
          "The objective of this audit sampling procedure was to determine with %1$s confidence whether the misstatement in the population is lower than the specified performance materiality, in this case %2$s. For the current data, the %1$s upper bound for the misstatement is %3$s the performance materiality. \n\nThe conclusion on the basis of these results is that the misstatement in the population is %4$s than the performance materiality. %5$s",
          planningOptions[["conf_level_label"]],
          planningOptions[["materiality_label"]],
          aboveBelowMateriality,
          lowerHigherMateriality,
          additionalMessage
        )
      } else if (!options[["materiality_test"]] && options[["min_precision_test"]]) {
        message <- gettextf(
          "The objective of this audit sampling procedure was to determine the misstatement in the population with %1$s confidence and a minimum precision of %2$s. For the current data, the obtained precision is %3$s than the minimum precision. \n\nThe conclusion on the basis of these results is that the misstatement in the population has been determined with at least %1$s confidence and a precision of %4$s. %5$s",
          planningOptions[["conf_level_label"]],
          paste0(options[["min_precision_rel_val"]] * 100, "%"),
          lowerHigherPrecision,
          paste0(round(evaluationState[["precision"]] * 100, 3), "%"),
          additionalMessage
        )
      } else if (options[["materiality_test"]] && options[["min_precision_test"]]) {
        message <- gettextf(
          "The objective of this audit sampling procedure was to determine with %1$s confidence, and a minimum precision of %2$s, whether the misstatement in the population is lower than the specified performance materiality, in this case %3$s. For the current data, the %1$s upper bound for the misstatement is %4$s the performance materiality and the obtained precision is %5$s than the minimum precision. \n\nThe conclusion on the basis of these results is that, with a precision of %6$s, the misstatement in the population is %7$s than the performance materiality. %8$s",
          planningOptions[["conf_level_label"]],
          paste0(options[["min_precision_rel_val"]] * 100, "%"),
          planningOptions[["materiality_label"]],
          aboveBelowMateriality,
          lowerHigherPrecision,
          paste0(round(evaluationState[["precision"]] * 100, 3), "%"),
          lowerHigherMateriality,
          additionalMessage
        )
      }
      conclusionContainer[["conclusionParagraph"]] <- createJaspHtml(message, "p")
      conclusionContainer[["conclusionParagraph"]]$position <- 1
      conclusionContainer[["conclusionParagraph"]]$dependOn(optionsFromObject = conclusionContainer)

      # Finsh conclusion
      jaspResults[["conclusionContainer"]] <- conclusionContainer
    }
  }
}

################################################################################
################## Common functions for the procedure stage ####################
################################################################################

.jfaTableBookDist <- function(options, parentOptions, jaspResults, positionInContainer) {
  parentContainer <- .jfaAddStageContainer(jaspResults, stage = "procedure", position = 1)

  if (!options[["tableBookDist"]] || options[["values"]] == "") {
    return()
  }

  .jfaTableNumberUpdate(jaspResults)

  if (is.null(parentContainer[["tableBookDist"]])) {
    title <- gettextf(
      "<b>Table %1$i.</b> Descriptive Statistics for Book Values",
      jaspResults[["tabNumber"]]$object
    )

    table <- createJaspTable(title)
    table$position <- positionInContainer
    table$dependOn(options = c(
      "tableBookDist", "tableDescriptives", "tableSample",
      "samplingChecked", "evaluationChecked"
    ))

    table$addColumnInfo(name = "N", title = gettext("Population size"), type = "integer")
    table$addColumnInfo(name = "val", title = gettext("Value"), type = "number")
    table$addColumnInfo(name = "absval", title = gettext("Absolute value"), type = "number")
    table$addColumnInfo(name = "mean", title = gettext("Mean"), type = "number")
    table$addColumnInfo(name = "sigma", title = gettext("Std. deviation"), type = "number")
    table$addColumnInfo(name = "q1", title = gettext("1"), type = "number", overtitle = gettext("Quartile"))
    table$addColumnInfo(name = "q2", title = gettext("2"), type = "number", overtitle = gettext("Quartile"))
    table$addColumnInfo(name = "q3", title = gettext("3"), type = "number", overtitle = gettext("Quartile"))

    parentContainer[["tableBookDist"]] <- table

    if (options[["id"]] == "") {
      return()
    }

    prevOptions <- jaspResults[["procedureOptions"]]$object

    row <- data.frame(
      N = prevOptions[["N.items"]],
      val = prevOptions[["N.units"]],
      absval = prevOptions[["N.units.abs"]],
      mean = prevOptions[["mean"]],
      sigma = prevOptions[["sd"]],
      q1 = prevOptions[["quantile"]][1],
      q2 = prevOptions[["quantile"]][2],
      q3 = prevOptions[["quantile"]][3]
    )

    table$addRows(row)
  }
}

.jfaPlotBookDist <- function(options, dataset, jaspResults, positionInContainer) {
  parentContainer <- .jfaAddStageContainer(jaspResults, stage = "procedure", position = 1)

  if (!options[["plotBookDist"]] || options[["values"]] == "") {
    return()
  }

  .jfaFigureNumberUpdate(jaspResults)

  if (is.null(parentContainer[["plotBookDist"]])) {
    figure <- createJaspPlot(plot = NULL, title = gettext("Distribution of Book Values"), width = 530, height = 350)
    figure$position <- positionInContainer
    figure$dependOn(options = "plotBookDist")
    parentContainer[["plotBookDist"]] <- figure

    if (options[["id"]] == "") {
      return()
    }

    prevOptions <- jaspResults[["procedureOptions"]]$object
    values <- dataset[[options[["values"]]]]
    mean <- prevOptions[["mean"]]
    stdev <- prevOptions[["sd"]]
    quantiles <- prevOptions[["quantile"]]

    legendData <- data.frame(x = c(0, 0, 0), y = c(0, 0, 0), l = c("1", "2", "3"))

    h <- hist(values, plot = FALSE, breaks = 20)
    yBreaks <- jaspGraphs::getPrettyAxisBreaks(c(0, h$counts), min.n = 4)
    xBreaks <- jaspGraphs::getPrettyAxisBreaks(c(values, h$breaks), min.n = 4)

    plot <- ggplot2::ggplot(data = data.frame(values), mapping = ggplot2::aes(x = values, y = ..count..)) +
      ggplot2::scale_x_continuous(name = gettext("Book value"), breaks = xBreaks, limits = range(xBreaks)) +
      ggplot2::scale_y_continuous(name = gettext("Frequency"), breaks = yBreaks, limits = c(0, max(yBreaks))) +
      ggplot2::geom_histogram(binwidth = (h$breaks[2] - h$breaks[1]), fill = "grey", col = "black", size = .7, center = ((h$breaks[2] - h$breaks[1]) / 2)) +
      ggplot2::geom_point(mapping = ggplot2::aes(x = quantiles[1], y = 0), shape = 21, fill = "orange", stroke = 1.5, size = 2) +
      ggplot2::geom_point(mapping = ggplot2::aes(x = quantiles[2], y = 0), shape = 21, fill = "orange", stroke = 1.5, size = 2) +
      ggplot2::geom_point(mapping = ggplot2::aes(x = quantiles[3], y = 0), shape = 21, fill = "orange", stroke = 1.5, size = 2) +
      ggplot2::geom_point(mapping = ggplot2::aes(x = mean, y = 0), shape = 21, fill = "red", stroke = 1.5, size = 4) +
      ggplot2::geom_point(mapping = ggplot2::aes(x = mean + stdev, y = 0), shape = 21, fill = "dodgerblue1", stroke = 1.5, size = 3) +
      ggplot2::geom_point(mapping = ggplot2::aes(x = mean - stdev, y = 0), shape = 21, fill = "dodgerblue1", stroke = 1.5, size = 3) +
      ggplot2::geom_point(data = legendData, mapping = ggplot2::aes(x = x, y = y, shape = l), size = 0, color = rgb(0, 1, 0, 0)) +
      ggplot2::scale_shape_manual(name = "", values = c(21, 21, 21), labels = c(gettext("Mean"), gettext("Mean \u00B1 St.dev"), gettext("Quartile"))) +
      ggplot2::guides(shape = ggplot2::guide_legend(override.aes = list(size = c(4, 3, 2), shape = c(21, 21, 21), fill = c("red", "dodgerblue1", "orange"), stroke = 1.5, color = "black")), order = 1) +
      jaspGraphs::geom_rangeframe() +
      jaspGraphs::themeJaspRaw(legend.position = "top") +
      ggplot2::theme(legend.text = ggplot2::element_text(margin = ggplot2::margin(l = -10, r = 50)))

    figure$plotObject <- plot
  }

  if (options[["explanatoryText"]]) {
    figureCaption <- createJaspHtml(gettextf("<b>Figure %1$i.</b> The distribution of book values in the population. The red and blue dots respectively represent the mean and the values exactly one standard deviation from the mean. The orange dots represent the first, second (median) and third quartiles of the book values.", jaspResults[["figNumber"]]$object), "p")
    figureCaption$position <- positionInContainer + 1
    figureCaption$dependOn(optionsFromObject = parentContainer[["plotBookDist"]])
    figureCaption$dependOn(options = "explanatoryText")
    parentContainer[["bookValuePlotText"]] <- figureCaption
  }
}

################################################################################
################## Common functions for the Audit Risk Model ###################
################################################################################

.jfaAuditRiskModelCalculation <- function(options) {
  # Audit risk 		= Inherent risk x Control risk x Detection risk
  # Detection risk 	= Audit risk / (Inherent risk x Control risk)

  ar <- 1 - options[["conf_level"]]
  ir <- switch(options[["ir"]],
    "high" = 1,
    "medium" = 0.60,
    "low" = 0.36,
    "custom" = options[["irCustom"]]
  )
  cr <- switch(options[["cr"]],
    "high" = 1,
    "medium" = 0.60,
    "low" = 0.36,
    "custom" = options[["crCustom"]]
  )
  dr <- ar / (ir * cr)
  return(dr)
}

.jfaAddAuditRiskModel <- function(options, jaspResults, position) {
  if (!is.null(jaspResults[["ARMcontainer"]]) || (!options[["materiality_test"]] && !options[["min_precision_test"]])) {
    return()
  }

  if (options[["prior_method"]] != "arm" || !options[["materiality_test"]]) {
    return()
  }

  container <- createJaspContainer(title = gettext("<u>Audit Risk Model</u>"))
  container$position <- position
  container$dependOn(options = c(
    "conf_level",
    "ir",
    "irCustom",
    "cr",
    "crCustom",
    "materiality_test",
    "materiality_rel_val",
    "materiality_abs_val",
    "explanatoryText",
    "materiality_type",
    "min_precision_test",
    "prior_method"
  ))

  jaspResults[["ARMcontainer"]] <- container

  ar <- 1 - options[["conf_level"]]
  ir <- switch(options[["ir"]],
    "high" = 1,
    "medium" = 0.60,
    "low" = 0.36,
    "custom" = options[["irCustom"]]
  )
  cr <- switch(options[["cr"]],
    "high" = 1,
    "medium" = 0.60,
    "low" = 0.36,
    "custom" = options[["crCustom"]]
  )
  dr <- ar / (ir * cr)

  textARM <- gettextf(
    "Audit risk (%1$s%%) = Inherent risk (%2$s%%) x Control risk (%3$s%%) x Detection risk (%4$s%%)",
    round(ar * 100, 2),
    if (options[["explanatoryText"]]) paste0(options[["ir"]], " = ", round(ir * 100, 2)) else round(ir * 100, 2),
    if (options[["explanatoryText"]]) paste0(options[["cr"]], " = ", round(cr * 100, 2)) else round(cr * 100, 2),
    round(dr * 100, 2)
  )

  container[["formula"]] <- createJaspHtml(textARM, "h3", "21cm")
  container[["formula"]]$position <- 2

  if (options[["explanatoryText"]]) {
    message <- gettextf(
      "The Audit Risk Model is a method to reduce the required information from the sample on the basis of earlier assessments of inherent risk and control risk, while maintaining the desired audit risk.\n\nPrior to the sampling procedure, the inherent risk was determined to be %1$s. The internal control risk was determined to be %2$s. According to the Audit Risk Model, the required detection risk to maintain an audit risk of %3$s should be %4$s.",
      paste0(options[["ir"]], " (", round(ir * 100, 2), "%)"),
      paste0(options[["cr"]], " (", round(cr * 100, 2), "%)"),
      paste0(round((1 - options[["conf_level"]]) * 100, 2), "%"),
      paste0(round(dr * 100, 2), "%")
    )

    if (options[["ir"]] == "custom" || options[["cr"]] == "custom") {
      message <- gettextf(
        "%1$s\n\nThe translation of High, Medium and Low to probabilities is done according custom preferences.",
        message
      )
    } else {
      message <- gettextf(
        "%1$s\n\nThe translation of High, Medium and Low to probabilities is done using default values. To learn more about the choice of these values and how to adjust these, see the help file of this analysis or look under the <i>Audit Risk Model</i> section.",
        message
      )
    }

    container[["paragraph"]] <- createJaspHtml(message, "p")
    container[["paragraph"]]$position <- 1
  }
}

################################################################################
################## Common functions for the planning stage #####################
################################################################################

.jfaPlanningState <- function(options, parentOptions, parentContainer, ready, jaspResults) {
  if (!is.null(parentContainer[["planningState"]])) {
    return(parentContainer[["planningState"]]$object)
  } else if (ready && !parentContainer$getError()) {
    if (options[["workflow"]]) {
      dataset <- .jfaReadData(options, jaspResults, stage = "procedure")
    }

    materiality <- if (options[["materiality_test"]]) parentOptions[["materiality_val"]] else NULL
    min_precision <- if (options[["min_precision_test"]]) options[["min_precision_rel_val"]] else NULL

    N.units <- parentOptions[["N.units"]]

    if (options[["prior_method"]] == "arm") {
      ar <- 1 - options[["conf_level"]]
      ir <- switch(options[["ir"]],
        "high" = 1,
        "medium" = 0.60,
        "low" = 0.36,
        "custom" = options[["irCustom"]]
      )
      cr <- switch(options[["cr"]],
        "high" = 1,
        "medium" = 0.60,
        "low" = 0.36,
        "custom" = options[["crCustom"]]
      )
      dr <- ar / (ir * cr)

      if (dr >= 1) {
        parentContainer$setError(gettext("The detection risk is equal to or higher than 100%%. Please re-specify your custom values for the Inherent risk and/or Control risk."))
        return()
      }

      confidence <- 1 - dr
    }

    if (!options[["bayesian"]]) {
      result <- try({
        jfa::planning(
          materiality = materiality, min.precision = min_precision, expected = parentOptions[["expected_val"]],
          likelihood = options[["likelihood"]], N.units = N.units, conf.level = confidence,
          by = options[["by"]], max = options[["max"]]
        )
      })
    } else {
      prior <- jfa::auditPrior(
        method = options[["prior_method"]], conf.level = options[["conf_level"]],
        materiality = materiality, expected = parentOptions[["expected_val"]],
        likelihood = options[["likelihood"]], N.units = N.units, ir = ir,
        cr = cr, n = options[["n_prior"]], x = options[["x_prior"]],
        alpha = options[["alpha"]], beta = options[["beta"]]
      )

      result <- try({
        if (options[["separateMisstatement"]] && options[["values"]] != "") {
          .jfaSeparatedMisstatementPlanningState(options, dataset, prior, parentOptions)
        } else {
          jfa::planning(
            materiality = materiality, min.precision = min_precision, expected = parentOptions[["expected_val"]],
            likelihood = options[["likelihood"]], N.units = N.units, conf.level = options[["conf_level"]],
            prior = prior, by = options[["by"]], max = options[["max"]]
          )
        }
      })
    }

    if (isTryError(result)) {
      if (jaspBase:::.extractErrorMessage(result) == "the sample size is lower than 'max'") {
        parentContainer$setError(gettextf("You cannot achieve your current sampling objectives with this population. The resulting sample size exceeds the maximum of %1$s. Adjust the maximum option accordingly.", options[["max"]]))
        return()
      } else {
        parentContainer$setError(gettextf("An error occurred: %1$s", jaspBase:::.extractErrorMessage(result)))
        return()
      }
    }

    parentContainer[["planningState"]] <- createJaspState(result)
    parentContainer[["planningState"]]$dependOn(options = c("likelihood"))

    return(result)
  } else {
    return(list(
      n = 0, x = 0, N.units = parentOptions[["N.units"]],
      materiality = parentOptions[["materiality"]],
      prior = list(description = list(alpha = 1, beta = 0, implicit.n = 0, implicit.x = 0))
    ))
  }
}

.jfaTablePlanning <- function(options, parentOptions, parentState, parentContainer, jaspResults,
                              ready, positionInContainer) {
  .jfaTableNumberUpdate(jaspResults)

  if (!is.null(parentContainer[["summaryTable"]])) {
    return()
  }

  tableTitle <- gettextf("<b>Table %1$i.</b> Planning Summary", jaspResults[["tabNumber"]]$object)

  table <- createJaspTable(tableTitle)
  table$position <- positionInContainer
  table$transpose <- TRUE
  table$dependOn(options = c(
    "plotBookDist",
    "tableDescriptives",
    "tableSample",
    "samplingChecked",
    "evaluationChecked",
    "likelihood",
    "expected_type",
    "min_precision_test",
    "materiality_test",
    "separateMisstatement",
    "by",
    "display"
  ))
  columnType <- if (options[["display"]] == "percent") "string" else "number"

  # Add columns to table layout
  table$addColumnInfo(name = "null", title = "", type = "string")
  if (options[["materiality_test"]]) {
    table$addColumnInfo(name = "materiality", title = gettext("Performance materiality"), type = columnType)
  }
  if (options[["min_precision_test"]]) {
    table$addColumnInfo(name = "precision", title = gettext("Min. precision"), type = columnType)
  }
  if (options[["materiality_test"]] && options[["prior_method"]] == "arm") {
    table$addColumnInfo(name = "ir", title = gettext("Inherent risk"), type = columnType)
    table$addColumnInfo(name = "cr", title = gettext("Control risk"), type = columnType)
    table$addColumnInfo(name = "dr", title = gettext("Detection risk"), type = columnType)
  } else {
    table$addColumnInfo(name = "ar", title = gettext("Audit risk"), type = columnType)
  }

  table$addColumnInfo(name = "x", title = gettext("Tolerable misstatements"), type = if (options[["expected_type"]] == "expected_all") "string" else "number")
  table$addColumnInfo(name = "n", title = gettext("Minimum sample size"), type = "integer")

  parentContainer[["summaryTable"]] <- table

  ar <- 1 - options[["conf_level"]]
  if (options[["prior_method"]] == "arm") {
    ir <- switch(options[["ir"]],
      "high" = 1,
      "medium" = 0.60,
      "low" = 0.36,
      "custom" = options[["irCustom"]]
    )
    cr <- switch(options[["cr"]],
      "high" = 1,
      "medium" = 0.60,
      "low" = 0.36,
      "custom" = options[["crCustom"]]
    )
    dr <- ar / (ir * cr)
  }

  if (!ready || parentContainer$getError()) {
    if (!options[["bayesian"]]) {
      message <- switch(options[["likelihood"]],
        "poisson" = gettext("The minimum sample size is based on the Poisson distribution."),
        "binomial" = gettext("The minimum sample size is based on the binomial distribution."),
        "hypergeometric" = gettext("The minimum sample size is based on the hypergeometric distribution.")
      )
    } else {
      message <- switch(options[["likelihood"]],
        "poisson" = gettext("The minimum sample size is based on the gamma distribution."),
        "binomial" = gettext("The minimum sample size is based on the beta distribution."),
        "hypergeometric" = gettextf("The minimum sample size is based on the beta-binomial distribution (N = %1$s).", parentOptions[["N.units"]])
      )
    }
    table$addFootnote(message)

    row <- data.frame(x = ".", n = ".")

    if (options[["materiality_test"]] && !options[["min_precision_test"]]) {
      materiality <- if (options[["display"]] == "percent") paste0(round(parentOptions[["materiality_val"]] * 100, 2), "%") else parentOptions[["materiality_val"]]
      row <- cbind(row, materiality = materiality)
    } else if (!options[["materiality_test"]] && options[["min_precision_test"]]) {
      min_precision <- if (options[["display"]] == "percent") paste0(round(options[["min_precision_rel_val"]] * 100, 2), "%") else parentOptions[["min_precision_rel_val"]]
      row <- cbind(row, precision = min_precision)
    } else if (options[["materiality_test"]] && options[["min_precision_test"]]) {
      materiality <- if (options[["display"]] == "percent") paste0(round(parentOptions[["materiality_val"]] * 100, 2), "%") else parentOptions[["materiality_val"]]
      min_precision <- if (options[["display"]] == "percent") paste0(round(options[["min_precision_rel_val"]] * 100, 2), "%") else parentOptions[["min_precision_rel_val"]]
      row <- cbind(row, materiality = materiality, precision = min_precision)
    }

    if (options[["materiality_test"]] && options[["prior_method"]] == "arm") {
      row <- cbind(row,
        ir = if (options[["display"]] == "percent") paste0(round(ir * 100, 2), "%") else ir,
        cr = if (options[["display"]] == "percent") paste0(round(cr * 100, 2), "%") else cr,
        dr = if (options[["display"]] == "percent") paste0(round(dr * 100, 2), "%") else dr
      )
    } else {
      row <- cbind(row, ar = if (options[["display"]] == "percent") paste0(round((1 - options[["conf_level"]]) * 100, 2), "%") else 1 - options[["conf_level"]])
    }

    table$addRows(row)
    table$addFootnote(
      message = gettext("Either the materiality (if applicable) or the number of units in the population is defined as zero."),
      symbol = gettextf("%1$s <b>Insufficient information.</b>", "\u26A0")
    )

    return()
  }

  if (!options[["bayesian"]]) {
    message <- switch(options[["likelihood"]],
      "poisson" = gettextf("The minimum sample size is based on the Poisson distribution (%1$s = %2$s).", "\u03BB", round(parentState[["materiality"]] * parentState[["n"]], 4)),
      "binomial" = gettextf("The minimum sample size is based on the binomial distribution (p = %1$s)", round(parentState[["materiality"]], 4)),
      "hypergeometric" = gettextf("The minimum sample size is based on the hypergeometric distribution (N = %1$s, K = %2$s).", format(parentState[["N.units"]], scientific = FALSE), format(ceiling(parentState[["N.units"]] * parentState[["materiality"]]), scientific = FALSE))
    )
  } else {
    message <- switch(options[["likelihood"]],
      "poisson" = gettextf(
        "The minimum sample size is based on the gamma distribution (%1$s = %2$s, %3$s = %4$s)",
        "\u03B1", round(parentState[["prior"]][["description"]]$alpha, 3),
        "\u03B2", round(parentState[["prior"]][["description"]]$beta, 3)
      ),
      "binomial" = gettextf(
        "The minimum sample size is based on the beta distribution (%1$s = %2$s, %3$s = %4$s).",
        "\u03B1", round(parentState[["prior"]][["description"]]$alpha, 3),
        "\u03B2", round(parentState[["prior"]][["description"]]$beta, 3)
      ),
      "hypergeometric" = gettextf(
        "The minimum sample size is based on the beta-binomial distribution (N = %1$s, %2$s = %3$s, %4$s = %5$s).",
        format(parentState[["N.units"]], scientific = FALSE),
        "\u03B1", round(parentState[["prior"]][["description"]]$alpha, 3),
        "\u03B2", round(parentState[["prior"]][["description"]]$beta, 3)
      )
    )
  }

  table$addFootnote(message)

  n <- parentState[["n"]]
  x <- if (options[["expected_type"]] == "expected_all") paste0("0 - ", n) else parentState[["x"]]
  row <- data.frame(x = x, n = n)

  if (options[["materiality_test"]] && !options[["min_precision_test"]]) {
    materiality <- if (options[["display"]] == "percent") paste0(round(parentOptions[["materiality_val"]] * 100, 2), "%") else parentOptions[["materiality_val"]]
    row <- cbind(row, materiality = materiality)
  } else if (!options[["materiality_test"]] && options[["min_precision_test"]]) {
    min_precision <- if (options[["display"]] == "percent") paste0(round(options[["min_precision_rel_val"]] * 100, 2), "%") else parentOptions[["min_precision_rel_val"]]
    row <- cbind(row, precision = min_precision)
  } else if (options[["materiality_test"]] && options[["min_precision_test"]]) {
    materiality <- if (options[["display"]] == "percent") paste0(round(parentOptions[["materiality_val"]] * 100, 2), "%") else parentOptions[["materiality_val"]]
    min_precision <- if (options[["display"]] == "percent") paste0(round(options[["min_precision_rel_val"]] * 100, 2), "%") else parentOptions[["min_precision_rel_val"]]
    row <- cbind(row, materiality = materiality, precision = min_precision)
  }

  if (options[["materiality_test"]] && options[["prior_method"]] == "arm") {
    row <- cbind(row,
      ir = if (options[["display"]] == "percent") paste0(round(ir * 100, 2), "%") else ir,
      cr = if (options[["display"]] == "percent") paste0(round(cr * 100, 2), "%") else cr,
      dr = if (options[["display"]] == "percent") paste0(round(dr * 100, 2), "%") else dr
    )
  } else {
    row <- cbind(row, ar = if (options[["display"]] == "percent") paste0(round((1 - options[["conf_level"]]) * 100, 2), "%") else 1 - options[["conf_level"]])
  }

  table$addRows(cbind(null = "Value", row))

  if (parentState[["n"]] > parentState[["N.units"]]) {
    table$addFootnote(gettextf("The minimum sample size (%1$s) is larger than the number of units in the population (%2$s).", parentState[["n"]], ceiling(parentState[["N.units"]])), symbol = "\u26A0")
  }

  if (options[["bayesian"]] && options[["separateMisstatement"]] && options[["values"]] != "") {
    message <- gettextf("The value %1$s is automatically used as a starting point for the fixed interval selection.", parentState[["start"]])
    table$addFootnote(message, symbol = gettextf("%1$s", "\u26A0"))
  }
}

.jfaCriticalTransactionsInit <- function(options, jaspResults) {
  if (options[["id"]] == "" || options[["values"]] == "" || options[["critical_name"]] == "") {
    return()
  }

  dataset <- .jfaReadData(options, jaspResults, stage = "procedure")

  if (options[["critical_negative"]]) {
    criticalTransactions <- rep(0, nrow(dataset))
    criticalTransactions[which(dataset[[options[["values"]]]] < 0)] <- 1
  } else {
    criticalTransactions <- rep(NA, nrow(dataset))
  }

  if (is.null(jaspResults[["criticalTransactions"]])) {
    jaspResults[["criticalTransactions"]] <- createJaspColumn(columnName = options[["critical_name"]], dependencies = "critical_name")
  }

  jaspResults[["criticalTransactions"]]$setOrdinal(criticalTransactions)
}

.jfaAddCriticalTransactions <- function(options, sample) {
  if (options[["workflow"]] && options[["critical_negative"]] && options[["critical_action"]] == "inspect" && options[["critical_name"]] != "") {
    values <- .jfaReadVariableFromOptions(options, type = "values")
    values_audit <- .jfaReadVariableFromOptions(options, type = "values.audit")
    values_critical <- .jfaReadVariableFromOptions(options, type = "critical")
    variables <- c(values, values_audit, values_critical)

    critical <- .readDataSetToEnd(columns.as.numeric = variables)
    critical <- subset(critical, critical[[values_critical]] > 0)

    if (nrow(critical) == 0) {
      return(sample)
    }

    criticalData <- data.frame(
      x = as.numeric(rownames(critical)),
      y = critical[[values]],
      l = rep(1, nrow(critical)),
      m = critical[[values_audit]],
      z = rep(1, nrow(critical))
    )
    colnames(criticalData) <- colnames(sample)
    rownames(criticalData) <- rownames(critical)

    sample <- rbind(sample, criticalData)
    return(sample)
  } else {
    return(sample)
  }
}

.jfaPlotSampleSizes <- function(options, parentOptions, parentState, parentContainer, jaspResults, ready, positionInContainer) {
  if (!options[["plotSampleSizes"]] || !options[["materiality_test"]] || options[["separateMisstatement"]]) {
    return()
  }

  .jfaFigureNumberUpdate(jaspResults)

  if (is.null(parentContainer[["decisionPlot"]])) {
    collection <- createJaspContainer(gettext("Minimum Sample Sizes"))
    collection$dependOn(options = c("plotSampleSizes"))
    collection$position <- positionInContainer

    parentContainer[["decisionPlot"]] <- collection

    if (!ready || parentContainer$getError()) {
      return()
    }

    confidence <- if (options[["bayesian"]]) options[["conf_level"]] else 1 - .jfaAuditRiskModelCalculation(options)
    min_precision <- if (options[["min_precision_test"]]) options[["min_precision_rel_val"]] else NULL
    materiality <- if (options[["materiality_test"]]) parentState[["materiality"]] else NULL

    N <- parentState[["N.units"]]
    if (options[["workflow"]] && options[["values"]] != "") {
      N <- ceiling(parentState[["N.units"]])
    }
    if (!options[["workflow"]] && parentState[["N.units"]] > 0) {
      N <- ceiling(parentState[["N.units"]])
    }

    if (options[["bayesian"]]) {
      dist <- switch(options[["likelihood"]],
        "binomial" = "Beta",
        "poisson" = "Gamma",
        "hypergeometric" = "Beta-binomial"
      )
    } else {
      dist <- switch(options[["likelihood"]],
        "binomial" = "Binomial",
        "poisson" = "Poisson",
        "hypergeometric" = "Hypergeometric"
      )
    }

    if (is.null(collection[["comparisonDistributions"]])) {
      # First plot: Comparison across probability distributions
      figure <- createJaspPlot(
        plot = NULL, title = gettextf("Across Probability Distributions (Current: %1$s)", dist),
        width = 600, height = 300
      )

      collection[["comparisonDistributions"]] <- figure

      likelihoods <- if (parentState[["N.units"]] > 0) c("poisson", "binomial", "hypergeometric") else c("poisson", "binomial")
      n <- numeric(length(likelihoods))
      k <- numeric(length(likelihoods))

      startProgressbar(length(likelihoods))

      leftPlotError <- try({
        for (i in 1:length(likelihoods)) {
          if (options[["bayesian"]]) {
            names <- if (parentState[["N.units"]] > 0) c("Gamma", "Beta", "Beta-binomial") else c("Gamma", "Beta")
            ir <- switch(options[["ir"]],
              "high" = 1,
              "medium" = 0.60,
              "low" = 0.36,
              "custom" = options[["irCustom"]]
            )
            cr <- switch(options[["cr"]],
              "high" = 1,
              "medium" = 0.60,
              "low" = 0.36,
              "custom" = options[["crCustom"]]
            )

            # Create a prior distribution that incorporates the existing information
            prior <- jfa::auditPrior(
              conf.level = options[["conf_level"]], materiality = parentState[["materiality"]],
              expected = parentOptions[["expected_val"]], likelihood = likelihoods[i],
              N.units = N, ir = ir, cr = cr, method = options[["prior_method"]],
              n = options[["n_prior"]], x = options[["x_prior"]], alpha = options[["alpha"]], beta = options[["beta"]]
            )
          } else {
            names <- if (parentState[["N.units"]] > 0) c("Poisson", "Binomial", "Hypergeometric") else c("Poisson", "Binomial")
            prior <- FALSE
          }

          result <- jfa::planning(
            conf.level = confidence, materiality = materiality, min.precision = min_precision,
            expected = parentOptions[["expected_val"]], likelihood = likelihoods[i], N.units = N,
            by = options[["by"]], max = options[["max"]], prior = prior
          )
          n[i] <- result[["n"]]
          k[i] <- result[["x"]]
          progressbarTick()
        }
      })

      if (!jaspBase::isTryError(leftPlotError)) {
        dPlot <- data.frame(y = c(n, k), x = rep(names, 2), type = rep(c(gettext("Expected error-free"), gettext("Expected errors")), each = length(n)))
        if (parentState[["N.units"]] == 0) {
          dPlot$x <- factor(x = dPlot$x, levels = levels(factor(dPlot$x))[c(1, 2)])
        } else {
          dPlot$x <- factor(x = dPlot$x, levels = levels(factor(dPlot$x))[c(2, 1, 3)])
        }
        dPlot$type <- factor(x = dPlot$type, levels = levels(factor(dPlot$type))[c(1, 2)])

        yBreaks <- jaspGraphs::getPrettyAxisBreaks(0:(ceiling(1.1 * max(n))), min.n = 4)
        yLimits <- c(0, ceiling(1.2 * max(n)))

        plot <- ggplot2::ggplot(data = dPlot, mapping = ggplot2::aes(x = x, y = y, fill = type)) +
          ggplot2::geom_bar(stat = "identity", col = "black", size = 1) +
          ggplot2::scale_y_continuous(name = gettext("Minimum sample size"), breaks = yBreaks, limits = yLimits) +
          ggplot2::coord_flip() +
          ggplot2::annotate("text", y = k, x = length(n):1, label = k, size = 6, vjust = 0.5, hjust = -0.25) +
          ggplot2::annotate("text", y = n, x = length(n):1, label = n, size = 6, vjust = 0.5, hjust = -0.75) +
          ggplot2::xlab("") +
          ggplot2::labs(fill = "") +
          ggplot2::scale_fill_manual(values = c("#7FE58B", "#FF6666"), guide = ggplot2::guide_legend(reverse = TRUE)) +
          jaspGraphs::geom_rangeframe(sides = "") +
          jaspGraphs::themeJaspRaw(legend.position = "top") +
          ggplot2::theme(
            axis.ticks.x = ggplot2::element_blank(),
            axis.ticks.y = ggplot2::element_blank(),
            axis.text.y = ggplot2::element_text(hjust = 0),
            panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb", size = 0.5),
            legend.text = ggplot2::element_text(margin = ggplot2::margin(l = 0, r = 30))
          )

        figure$plotObject <- plot
      } else {
        if (jaspBase:::.extractErrorMessage(leftPlotError) == "the sample size is lower than 'max'") {
          figure$setError(gettextf("You cannot achieve your current sampling objectives with this population. The resulting sample size exceeds the maximum of %1$s. Adjust the maximum option accordingly.", options[["max"]]))
        } else {
          figure$setError(gettextf("An error occurred in a call to the jfa package: %1$s", jaspBase:::.extractErrorMessage(leftPlotError)))
        }
      }
    }

    if (is.null(collection[["comparisonErrors"]])) {
      # Second plot: Comparison across expected errors
      figure <- createJaspPlot(
        plot = NULL, title = gettextf("Across Expected Errors (Current: %1$s)", round(parentState[["x"]], 2)),
        width = 150, height = 200
      )
      collection[["comparisonErrors"]] <- figure

      rightPlotError <- try({
        if (options[["bayesian"]]) {
          # Create a prior distribution that incorporates the existing information
          prior <- jfa::auditPrior(
            conf.level = options[["conf_level"]], materiality = materiality, expected = parentOptions[["expected_val"]],
            likelihood = options[["likelihood"]], N.units = N, ir = ir, cr = cr, method = options[["prior_method"]],
            n = options[["n_prior"]], x = options[["x_prior"]], alpha = options[["alpha"]], beta = options[["beta"]]
          )
        } else {
          prior <- FALSE
        }

        n <- numeric(length(1:4))
        for (i in 1:4) {
          result <- jfa::planning(
            conf.level = confidence, materiality = materiality, min.precision = min_precision,
            likelihood = options[["likelihood"]], expected = i - 1,
            N.units = N, by = options[["by"]], max = options[["max"]], prior = prior
          )
          n[i] <- result[["n"]]
        }
      })

      if (!jaspBase::isTryError(rightPlotError)) {
        dPlot <- data.frame(x = c("0", "1", "2", "3"), y = c(2, 2, 2, 2))
        dPlot$x <- factor(dPlot$x, levels = c("3", "2", "1", "0"))

        plot <- ggplot2::ggplot(data = dPlot, mapping = ggplot2::aes(x = x, y = y, fill = x)) +
          ggplot2::geom_bar(stat = "identity", col = "black", size = 1) +
          ggplot2::scale_y_continuous(name = "", breaks = NULL, limits = c(0, 2.3)) +
          ggplot2::scale_x_discrete(name = "") +
          ggplot2::scale_fill_manual(values = c("red", "darkorange1", "orange", "#7FE58B")) +
          ggplot2::coord_flip() +
          ggplot2::labs(fill = "") +
          ggplot2::annotate("text",
            y = c(0.5, 0.5, 0.5, 0.5), x = c(4, 3, 2, 1),
            label = paste0("n = ", n), size = 6, vjust = 0.5, hjust = 0.2, fontface = "italic"
          ) +
          jaspGraphs::geom_rangeframe(sides = "") +
          jaspGraphs::themeJaspRaw(legend.position = "none") +
          ggplot2::theme(
            axis.ticks.x = ggplot2::element_blank(),
            axis.ticks.y = ggplot2::element_blank(),
            axis.text.y = ggplot2::element_text(hjust = 0),
            panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb", size = 0.5),
            legend.text = ggplot2::element_text(margin = ggplot2::margin(l = 0, r = 30))
          )

        figure$plotObject <- plot
      } else {
        if (jaspBase:::.extractErrorMessage(rightPlotError) == "the sample size is lower than 'max'") {
          figure$setError(gettextf("You cannot achieve your current sampling objectives with this population. The resulting sample size exceeds the maximum of %1$s. Adjust the maximum option accordingly.", options[["max"]]))
        } else {
          figure$setError(gettextf("An error occurred in a call to the jfa package: %1$s", jaspBase:::.extractErrorMessage(rightPlotError)))
        }
      }
    }

    if (options[["explanatoryText"]] && ready) {
      caption <- createJaspHtml(gettextf(
        "<b>Figure %1$i.</b> The first panel shows a comparison of the minimum sample sizes under different probability distributions. The bars represent the minimum sample sizes for the current expected errors in the sample. The number of expected errors in each bar is colored in red and the number of expected error-free items is colored in green. The second panel shows a comparison of the minimum sample sizes under different expected errors for the current probability distribution.",
        jaspResults[["figNumber"]]$object
      ), "p")

      caption$position <- positionInContainer + 1
      caption$dependOn(optionsFromObject = parentContainer[["decisionPlot"]])
      caption$dependOn(options = "explanatoryText")
      parentContainer[["decisionPlotText"]] <- caption
    }
  }
}

.plotErrorDist <- function(options, parentOptions, parentState, parentContainer, jaspResults, ready, positionInContainer) {
  if (!options[["plotErrorDist"]]) {
    return()
  }

  .jfaFigureNumberUpdate(jaspResults)

  if (is.null(parentContainer[["samplingDistribution"]])) {
    
	likelihood <- switch(options[["likelihood"]],
      "poisson" = "Poisson",
      "binomial" = "Binomial",
      "hypergeometric" = "Hypergeometric"
    )
    title <- gettextf("Presumed %1$s Distribution", likelihood)
    fg <- createJaspPlot(plot = NULL, title = title, width = 530, height = 350)
    fg$position <- positionInContainer
    fg$dependOn(options = c("likelihood", "plotErrorDist"))
    parentContainer[["samplingDistribution"]] <- fg

    if (!ready || parentContainer$getError()) {
      return()
    }

    fg$plotObject <- plot(parentState) +
      jaspGraphs::geom_rangeframe() +
      jaspGraphs::themeJaspRaw(legend.position = "none")
  }

  if (options[["explanatoryText"]] && ready) {
    caption <- createJaspHtml(gettextf(
      "<b>Figure %1$i.</b> The assumed %2$s distribution. The number of expected errors in the selection is colored in red. The total probability of the errors does not exceed the detection risk as specified through the audit risk model.",
      jaspResults[["figNumber"]]$object,
      options[["likelihood"]]
    ), "p")
    caption$position <- positionInContainer + 1
    caption$dependOn(optionsFromObject = parentContainer[["samplingDistribution"]])
    caption$dependOn(options = "explanatoryText")
    parentContainer[["samplingDistributionText"]] <- caption
  }
}

################################################################################
################## Common functions for the selection stage ####################
################################################################################

.jfaAddSelectionResult <- function(options, jaspResults) {
  dataset <- .jfaReadData(options, jaspResults, stage = "procedure")
  rank <- .jfaReadVariableFromOptions(options, type = "rank")
  additional <- .jfaReadVariableFromOptions(options, type = "additional")
  additional <- additional[!(additional %in% colnames(dataset))]
  if (length(additional) == 0) {
    additional <- NULL
  }
  variables <- c(rank, additional)
  if (!is.null(variables)) {
    extraCol <- .readDataSetToEnd(columns.as.numeric = variables)
    dataset <- cbind(dataset, extraCol)
    return(dataset)
  } else {
    return(dataset)
  }
}

.jfaAddSelectionIndicator <- function(options, prevOptions, parentState, jaspResults) {
  if (options[["name_indicator"]] == "" || is.null(parentState)) {
    return()
  }

  sample <- parentState[["sample"]]

  if (is.null(jaspResults[["name_indicator"]])) {
    indicator <- numeric(length = parentState[["N.items"]])
    rows <- sample[["row"]]
    times <- sample[["times"]]
    indicator[rows] <- times
    jaspResults[["name_indicator"]] <- createJaspColumn(columnName = options[["name_indicator"]])
    jaspResults[["name_indicator"]]$dependOn(options = c(
      "id", "values", "variables", "rank", "sampling_method", "units",
      "start", "seed", "n", "export_sample", "name_indicator"
    ))
    jaspResults[["name_indicator"]]$setOrdinal(indicator)
  }

  # Export sample
  if (options[["export_sample"]] && options[["file"]] != "") {
    export <- data.frame(row = sample[["row"]])
    export <- cbind(export, times = sample[["times"]])
    export <- cbind(export, id = sample[[options[["id"]]]])
    colnames(export) <- c("Row", decodeColNames(options[["name_indicator"]]), decodeColNames(options[["id"]]))
    if (options[["values"]] != "") {
      export <- cbind(export, values = sample[[options[["values"]]]])
      colnames(export)[length(colnames(export))] <- decodeColNames(options[["values"]])
    }
    if (options[["rank"]] != "") {
      export <- cbind(export, sample[[options[["rank"]]]])
      colnames(export)[length(colnames(export))] <- decodeColNames(options[["rank"]])
    }
    if (length(unlist(options[["variables"]])) >= 1 && unlist(options[["variables"]]) != "") {
      export <- cbind(export, sample[[unlist(options[["variables"]])]])
      colnames(export)[(length(colnames(export)) - length(unlist(options[["variables"]]))):length(colnames(export))] <- decodeColNames(unlist(options[["variables"]]))
    }
    export <- cbind(export, rep(NA, nrow(export)))
    colnames(export)[length(colnames(export))] <- "auditResult"
    utils::write.csv(x = export, file = options[["file"]], row.names = FALSE, na = "", quote = FALSE)
  }
}

.jfaSelectionState <- function(options, dataset, prevState, parentContainer) {
  if (!is.null(parentContainer[["selectionState"]])) {
    return(parentContainer[["selectionState"]]$object)
  } else if (!is.null(prevState)) {
    result <- try({
      .jfaSelectionCalculation(options, dataset, prevState, parentContainer)
    })

    if (isTryError(result)) {
      if (options[["units"]] == "values") {
        # MUS has failed for some reason, fall back to record sampling
        result <- try({
          .jfaSelectionCalculation(options, dataset, prevState, parentContainer, unitsExtra = "records")
        })
      }
      if (isTryError(result)) {
        parentContainer$setError(gettextf("An error occurred: %1$s", jaspBase:::.extractErrorMessage(result)))
        return()
      } else {
        # MUS has failed for some reason, return an indication for this
        result[["musFailed"]] <- TRUE
      }
    }

    parentContainer[["selectionState"]] <- createJaspState(result)
    return(result)
  }
}

.jfaSelectionCalculation <- function(options, dataset, prevState, parentContainer, unitsExtra = NULL) {
  if (options[["id"]] == "" || prevState[["n"]] == 0 || is.null(dataset)) {
    return()
  }

  units <- if (!is.null(unitsExtra)) unitsExtra else options[["units"]]

  if (options[["sampling_method"]] == "interval") {
    interval <- if (units == "items") length(dataset[[options[["id"]]]]) / prevState[["n"]] else sum(dataset[[options[["values"]]]]) / prevState[["n"]]
    if (!options[["randomStart"]] && options[["start"]] > interval) {
      parentContainer$setError(gettextf("Starting point is outside the range of the selection interval of 1 to %1$s. Please choose a starting point < %1$s.", round(interval, 3)))
      return()
    }
  }

  start <- if (!is.null(prevState[["start"]])) prevState[["start"]] else options[["start"]]
  if (options[["sampling_method"]] == "interval" && options[["randomStart"]]) {
    start <- sample(1:floor(interval), size = 1)
  }
  if (options[["sampling_method"]] != "interval" || options[["randomize"]]) {
    set.seed(options[["seed"]])
  }

  jfaresult <- jfa::selection(
    data = as.data.frame(dataset), size = prevState[["n"]], units = units, method = options[["sampling_method"]],
    values = if (options[["values"]] != "") options[["values"]] else NULL,
    order = if (options[["rank"]] != "") options[["rank"]] else NULL,
    start = start, replace = TRUE, randomize = options[["randomize"]]
  )
  return(jfaresult)
}

.jfaTableSelection <- function(options, dataset, prevOptions, prevState, parentState, parentContainer,
                               jaspResults, positionInContainer) {
  .jfaTableNumberUpdate(jaspResults)

  if (!is.null(parentContainer[["tableSelection"]])) {
    return()
  }

  title <- gettextf("<b>Table %1$i.</b> Selection Summary", jaspResults[["tabNumber"]]$object)

  table <- createJaspTable(title)
  table$position <- positionInContainer
  table$dependOn(options = c("tableBookDist", "tableDescriptives", "tableSample", "samplingChecked", "evaluationChecked", "export_sample"))

  table$addColumnInfo(name = "size", title = gettext("No. units"), type = "integer")
  table$addColumnInfo(name = "items", title = gettext("No. items"), type = "integer")
  if (options[["units"]] == "values") {
    table$addColumnInfo(name = "value", title = gettext("Selection value"), type = "number")
    table$addColumnInfo(name = "percentage", title = gettextf("%% of population value"), type = "string")
  } else {
    table$addColumnInfo(name = "percentage", title = gettextf("%% of population size"), type = "string")
  }

  parentContainer[["tableSelection"]] <- table

  if (is.null(parentState)) {
    return()
  }

  message <- switch(options[["sampling_method"]],
    "interval" = gettextf("From each of the intervals of size %1$s, unit %2$s is selected.", round(parentState[["interval"]], 2), if (!is.null(prevState[["start"]])) prevState[["start"]] else if (!is.null(parentState[["start"]])) parentState[["start"]] else options[["start"]]),
    "cell" = gettextf("The sample is drawn with seed %1$s and intervals of size %2$s.", options[["seed"]], round(parentState[["interval"]], 2)),
    "random" = gettextf("The sample is drawn with seed %1$s.", options[["seed"]])
  )
  table$addFootnote(message)
  if (!options[["workflow"]] && options[["file"]] != "" && !options[["export_sample"]]) {
    table$addFootnote(gettext("The sample is not exported until the 'Synchronize' option is checked."))
  }

  row <- list()
  row[["size"]] <- parentState[["n.units"]]
  row[["items"]] <- parentState[["n.items"]]
  if (options[["units"]] == "values") {
    row[["value"]] <- sum(abs(parentState[["sample"]][[options[["values"]]]]))
  }
  row[["percentage"]] <- if (options[["units"]] == "values") paste0(round(row[["value"]] / parentState[["N.units"]] * 100, 2), "%") else paste0(round(parentState[["n.units"]] / parentState[["N.units"]] * 100, 2), "%")

  table$addRows(row)
}

.jfaTableInterval <- function(options, dataset, prevOptions, prevState, parentContainer, parentState, jaspResults, positionInContainer) {
  if (options[["id"]] == "") {
    return()
  }

  if (options[["units"]] == "values" && options[["sampling_method"]] != "random") {
    .jfaTableNumberUpdate(jaspResults)

    if (!is.null(parentContainer[["tableInterval"]])) {
      return()
    }

    title <- gettextf("<b>Table %1$i.</b> Information about Monetary Interval Selection", jaspResults[["tabNumber"]]$object)
    table <- createJaspTable(title)
    table$position <- positionInContainer + 1
    # table$transpose <- TRUE
    table$dependOn(options = c("tableBookDist", "tableDescriptives", "tableSample", "samplingChecked", "evaluationChecked"))

    table$addColumnInfo(name = "stratum", title = "", type = "string")
    table$addColumnInfo(name = "N.items", title = gettext("Items"), type = "integer")
    table$addColumnInfo(name = "N.units", title = gettext("Value"), type = "number")
    table$addColumnInfo(name = "n.items", title = gettext("Selected items"), type = "integer")
    table$addColumnInfo(name = "n.units", title = gettext("Selected units"), type = "integer")
    table$addColumnInfo(name = "value", title = gettext("Selection value"), type = "number")
    table$addColumnInfo(name = "percentage", title = gettextf("%% of total value"), type = "string")

    intervalFactor <- if (options[["sampling_method"]] == "cell") gettext("twice the") else gettext("a single")
    table$addFootnote(message = gettextf("The top stratum consists of all items with a book value larger than %1$s interval.", intervalFactor))
    parentContainer[["tableInterval"]] <- table

    if (is.null(parentState)) {
      row <- data.frame(
        stratum = c("Total", "Top stratum", "Bottom stratum"),
        N.items = c(nrow(dataset), NA, NA),
        N.units = c(sum(dataset[[options[["values"]]]]), NA, NA),
        n.items = rep(".", 3), n.units = rep(".", 3), value = rep(".", 3), percentage = rep(".", 3)
      )
      table$setData(row)
      return()
    }

    selection <- parentState[["sample"]]
    interval <- parentState[["interval"]]

    if (options[["sampling_method"]] == "cell") {
      interval <- interval * 2
    }

    top_stratum <- dataset[which(dataset[[options[["values"]]]] > interval), ]
    bottom_stratum <- dataset[which(dataset[[options[["values"]]]] <= interval), ]
    bottom_stratum_sample <- selection[which(selection[[options[["values"]]]] <= interval), ]

    top_stratum_value <- sum(top_stratum[[options[["values"]]]])
    bottom_stratum_value_pop <- sum(bottom_stratum[[options[["values"]]]])
    bottom_stratum_value <- sum(bottom_stratum_sample[[options[["values"]]]])

    row <- data.frame(
      stratum = c("Total", "Top stratum", "Bottom stratum"),
      N.items = c(nrow(dataset), nrow(top_stratum), nrow(dataset) - nrow(top_stratum)),
      N.units = c(parentState[["N.units"]], top_stratum_value, bottom_stratum_value_pop),
      n.units = c(parentState[["n.units"]], parentState[["n.units"]] - nrow(bottom_stratum_sample), nrow(bottom_stratum_sample)),
      n.items = c(nrow(top_stratum) + nrow(bottom_stratum_sample), nrow(top_stratum), nrow(bottom_stratum_sample)),
      value = c(bottom_stratum_value + top_stratum_value, top_stratum_value, bottom_stratum_value),
      percentage = c(
        paste0(round((bottom_stratum_value + top_stratum_value) / parentState[["N.units"]] * 100, 2), "%"),
        if (nrow(top_stratum) == 0) "0%" else "100%",
        paste0(round(bottom_stratum_value / bottom_stratum_value_pop * 100, 2), "%")
      )
    )

    table$setData(row)
  }
}

.jfaTableSample <- function(options, prevOptions, parentState, parentContainer, jaspResults, positionInContainer) {
  if (!options[["tableSample"]]) {
    return()
  }

  .jfaTableNumberUpdate(jaspResults)

  if (is.null(parentContainer[["tableSample"]])) {
    title <- gettextf("<b>Table %1$i.</b> Selected Items", jaspResults[["tabNumber"]]$object)
    table <- createJaspTable(title)
    table$position <- positionInContainer
    table$dependOn(options = c("tableBookDist", "tableDescriptives", "tableSample", "samplingChecked", "evaluationChecked"))

    id <- .jfaReadVariableFromOptions(options, type = "id")
    values <- .jfaReadVariableFromOptions(options, type = "values")
    rank <- .jfaReadVariableFromOptions(options, type = "rank")
    additional <- .jfaReadVariableFromOptions(options, type = "additional")
    variables <- c(gettext("Row"), gettext("Selected"), unique(c(id, values, rank, additional)))

    for (i in 1:length(variables)) {
      if (i %in% c(1, 2)) {
        table$addColumnInfo(name = variables[i], type = "integer", title = variables[i])
      } else if (variables[i] == options[["values"]] || variables[i] == options[["rank"]]) {
        table$addColumnInfo(name = variables[i], type = "number", title = variables[i])
      } else {
        table$addColumnInfo(name = variables[i], type = "string", title = variables[i])
      }
    }

    parentContainer[["tableSample"]] <- table

    if (is.null(parentState) || parentContainer$getError()) {
      return()
    }

    selection <- as.data.frame(parentState[["sample"]])

    columns <- data.frame("Row" = selection[, "row"], "Selected" = selection[, "times"])
    colnames(columns) <- c(gettext("Row"), gettext("Selected"))
    for (i in 3:length(variables)) {
      columns[[variables[i]]] <- selection[[variables[i]]]
    }

    table$setData(columns)
  }
}

.jfaTableSampleDescriptives <- function(options, parentState, parentContainer, jaspResults, positionInContainer) {
  if (!options[["tableDescriptives"]]) {
    return()
  }

  .jfaTableNumberUpdate(jaspResults)

  if (is.null(parentContainer[["tableDescriptives"]])) {
    id <- .jfaReadVariableFromOptions(options, type = "id")
    rank <- .jfaReadVariableFromOptions(options, type = "rank")
    values <- .jfaReadVariableFromOptions(options, type = "values")
    additional <- .jfaReadVariableFromOptions(options, type = "additional")
    variables <- unique(c(rank, values, additional))

    title <- gettextf(
      "<b>Table %1$i.</b> Descriptive Statistics for Sample",
      jaspResults[["tabNumber"]]$object
    )

    table <- createJaspTable(title)
    table$transpose <- TRUE
    table$position <- positionInContainer
    table$dependOn(options = c("tableDescriptives", "tableBookDist", "tableSample", "samplingChecked", "evaluationChecked"))

    table$addColumnInfo(name = "name", title = "", type = "string")
    table$addColumnInfo(name = "cases", title = gettext("Valid cases"), type = "integer")
    table$addColumnInfo(name = "mean", title = gettext("Mean"), type = "number")
    table$addColumnInfo(name = "median", title = gettext("Median"), type = "number")
    table$addColumnInfo(name = "sd", title = gettext("Std. deviation"), type = "number")
    table$addColumnInfo(name = "var", title = gettext("Variance"), type = "number")
    table$addColumnInfo(name = "range", title = gettext("Range"), type = "number")
    table$addColumnInfo(name = "minimum", title = gettext("Minimum"), type = "number")
    table$addColumnInfo(name = "maximum", title = gettext("Maximum"), type = "number")

    parentContainer[["tableDescriptives"]] <- table

    if (is.null(parentState) || parentContainer$getError()) {
      return()
    }

    row <- list(name = "Items", cases = parentState[["n.items"]])
    table$addRows(row)

    for (variable in variables) {
      column <- parentState[["sample"]][[variable]]
      row <- list()
      row[["name"]] <- variable
      row[["cases"]] <- length(column)
      if (!is.factor(column)) {
        row[["mean"]] <- mean(column, na.rm = TRUE)
        row[["sd"]] <- sd(column, na.rm = TRUE)
        row[["var"]] <- var(column, na.rm = TRUE)
        row[["median"]] <- median(column, na.rm = TRUE)
        row[["range"]] <- abs(range(column, na.rm = TRUE)[1] - range(column, na.rm = TRUE)[2])
        row[["minimum"]] <- min(column, na.rm = TRUE)
        row[["maximum"]] <- max(column, na.rm = TRUE)
      }
      table$addRows(row)
    }
  }
}

################################################################################
################## Common functions for the evaluation #########################
################################################################################

.jfaAddEvaluationResult <- function(options, jaspResults) {
  dataset <- .jfaAddSelectionResult(options, jaspResults)

  sampleFilter <- options[["indicator_col"]]
  auditResult <- options[["values.audit"]]
  critical <- options[["critical_name"]]
  variables <- c(sampleFilter, auditResult, critical)

  if (!("" %in% variables)) {
    additionalColumns <- .readDataSetToEnd(columns.as.numeric = variables)
    dataset <- cbind(dataset, additionalColumns)
    return(dataset)
  } else {
    return(dataset)
  }
}

.jfaEvaluationState <- function(options, sample, prevOptions, parentContainer, prevState) {
  if (options[["values.audit"]] == "") {
    return()
  }

  if (!is.null(parentContainer[["evaluationState"]])) {
    return(parentContainer[["evaluationState"]]$object)
  } else {
    # Add critical transactions to the sample
    sample <- .jfaAddCriticalTransactions(options, sample)

    materiality <- if (options[["materiality_test"]]) prevOptions[["materiality_val"]] else NULL
    min_precision <- if (options[["min_precision_test"]]) options[["min_precision_rel_val"]] else NULL

    if (options[["prior_method"]] == "arm") {
      ir <- switch(options[["ir"]],
        "high" = 1,
        "medium" = 0.60,
        "low" = 0.36,
        "custom" = options[["irCustom"]]
      )
      cr <- switch(options[["cr"]],
        "high" = 1,
        "medium" = 0.60,
        "low" = 0.36,
        "custom" = options[["crCustom"]]
      )
      dr <- (1 - options[["conf_level"]]) / (ir * cr)
      conf_level <- 1 - dr
    }

    if (options[["bayesian"]]) {
      prior <- jfa::auditPrior(
        conf.level = options[["conf_level"]], materiality = materiality, expected = prevOptions[["expected_val"]],
        likelihood = options[["likelihood"]], N.units = prevOptions[["N.units"]], ir = ir, cr = cr,
        method = options[["prior_method"]], n = options[["n_prior"]], x = options[["x_prior"]],
        alpha = options[["alpha"]], beta = options[["beta"]]
      )

      conf_level <- options[["conf_level"]]

      if (options[["separateMisstatement"]] && options[["values"]] != "") {
        result <- .jfaSeparatedMisstatementEvaluationState(options, sample, prior, prevOptions, prevState, parentContainer)
        return(result)
      }
    } else {
      prior <- FALSE
    }

    # Select evaluation method
    if (options[["annotation"]] == "binary") {
      if (!all(sample[[options[["values.audit"]]]] %in% c(0, 1))) {
        parentContainer$setError(gettext("The audit result variable should contain only 0's (correct) and 1's (incorrect)."))
        return()
      }
      result <- try({
        jfa::evaluation(
          conf.level = conf_level, materiality = materiality,
          n = nrow(sample), x = length(which(sample[[options[["values.audit"]]]] == 1)),
          method = options[["method"]], N.units = prevOptions[["N.units"]],
          prior = prior, alternative = if (options[["area"]] == "area_bound") "less" else "two.sided"
        )
      })
    } else if (options[["annotation"]] == "continuous") {
      method <- options[["method"]]
      if (method == "stringer" && options[["lta"]]) {
        method <- "stringer.lta"
      }
      result <- try({
        jfa::evaluation(
          data = sample, times = options[["indicator_col"]], conf.level = conf_level,
          materiality = materiality, alternative = if (options[["method"]] %in% c("direct", "difference", "quotient", "regression")) "two.sided" else if (options[["area"]] == "area_bound") "less" else "two.sided",
          values = options[["values"]], values.audit = options[["values.audit"]],
          method = method, N.items = prevOptions[["N.items"]], N.units = prevOptions[["N.units"]],
          prior = prior
        )
      })
    }

    if (isTryError(result)) {
      parentContainer$setError(paste0("An error occurred: ", jaspBase:::.extractErrorMessage(result)))
      return()
    }

    parentContainer[["evaluationState"]] <- createJaspState(result)
    return(result)
  }
}

.jfaAddExplanatoryTextEvaluation <- function(options, planningOptions, planningState, selectionState,
                                             evaluationContainer, positionInContainer = 1) {
  if (options[["explanatoryText"]]) {
    ready <- FALSE
    if (!is.null(evaluationContainer[["evaluationState"]]$object) && ((options[["dataType"]] %in% c("data", "pdata") && options[["values.audit"]] != "" && options[["id"]] != "" && ((options[["materiality_test"]] && planningOptions[["materiality_val"]] > 0) || (options[["min_precision_test"]] && options[["min_precision_rel_val"]] > 0))) ||
      (options[["dataType"]] == "stats" && options[["n"]] > 0 && ((options[["materiality_test"]] && planningOptions[["materiality_val"]] > 0) || (options[["min_precision_test"]] && options[["min_precision_rel_val"]] > 0))))) {
      ready <- TRUE
    }

    if (ready) {
      state <- evaluationContainer[["evaluationState"]]$object
      errors <- state[["x"]]

      if (options[["display"]] == "number") {
        if (options[["method"]] %in% c("direct", "difference", "quotient", "regression")) {
          boundLabel <- round(state[["ub"]], 3)
          mleLabel <- round(state[["mle"]], 3)
          precisionLabel <- round(state[["precision"]], 3)
        } else {
          boundLabel <- round(state[["ub"]], 3)
          mleLabel <- round(state[["mle"]], 3)
          precisionLabel <- round(state[["precision"]], 3)
        }
      } else if (options[["display"]] == "percent") {
        if (options[["method"]] %in% c("direct", "difference", "quotient", "regression")) {
          boundLabel <- paste0(round(state[["ub"]] / planningOptions[["N.units"]] * 100, 3), "%")
          mleLabel <- paste0(round(state[["mle"]] / planningOptions[["N.units"]] * 100, 3), "%")
          precisionLabel <- paste0(round(state[["precision"]] / planningOptions[["N.units"]] * 100, 3), "%")
        } else {
          boundLabel <- paste0(round(state[["ub"]] * 100, 3), "%")
          mleLabel <- paste0(round(state[["mle"]] * 100, 3), "%")
          precisionLabel <- paste0(round(state[["precision"]] * 100, 3), "%")
        }
      } else if (options[["display"]] == "amount") {
        if (options[["method"]] %in% c("direct", "difference", "quotient", "regression")) {
          boundLabel <- round(state[["ub"]], 3)
          mleLabel <- round(state[["mle"]], 3)
          precisionLabel <- round(state[["precision"]], 3)
        } else {
          boundLabel <- round(state[["ub"]] * planningOptions[["N.units"]], 3)
          mleLabel <- round(state[["mle"]] * planningOptions[["N.units"]], 3)
          precisionLabel <- round(state[["precision"]] * planningOptions[["N.units"]], 3)
        }
      }
    } else {
      boundLabel <- errors <- mleLabel <- precisionLabel <- "..."
    }

    if (selectionState[["n.units"]] > selectionState[["n.items"]]) {
      sampleSizeMessage <- paste0(planningState[["n"]], " (", selectionState[["n.items"]], " + ", sum(selectionState$sample[["times"]][which(selectionState$sample[["times"]] != 1)] - 1), ")")
    } else {
      sampleSizeMessage <- planningState[["n"]]
    }

    message <- gettextf(
      "The purpose of the evaluation stage is to infer the misstatement \u03B8 in the population on the basis of a sample.\n\nThe population consisted of %1$s items and %2$s units. The sample consisted of %3$s sampling units, of which a total of %4$s were misstated. The information from this sample %5$s results in a most likely misstatement in the population of %6$s and an %7$s upper bound of %8$s.",
      if (planningOptions[["N.items"]][1] == 0) "..." else format(sum(planningOptions[["N.items"]]), scientific = FALSE),
      if (planningOptions[["N.units"]][1] == 0) "..." else format(sum(planningOptions[["N.units"]]), scientific = FALSE),
      sampleSizeMessage,
      errors,
      if (options[["bayesian"]]) "combined with the information in the prior distribution " else "",
      mleLabel,
      planningOptions[["conf_level_label"]],
      boundLabel
    )

    evaluationContainer[["evaluationParagraph"]] <- createJaspHtml(message, "p")
    evaluationContainer[["evaluationParagraph"]]$position <- positionInContainer
    evaluationContainer[["evaluationParagraph"]]$dependOn(options = "explanatoryText")
  }
}

.jfaGetPreviousPlanningStateFromOptions <- function(options, dataset, evaluationOptions) {
  if (((options[["id"]] != "" && options[["values"]] != "" && options[["values.audit"]] != "") ||
    (options[["id"]] != "" && options[["values.audit"]] != "") ||
    (options[["dataType"]] == "stats" && options[["n"]] > 0)) &&
    ((options[["materiality_test"]] && evaluationOptions[["materiality_val"]] != 0) || (options[["min_precision_test"]] && options[["min_precision_rel_val"]] > 0))) {
    materiality <- if (options[["materiality_test"]]) evaluationOptions[["materiality_val"]] else NULL
    min_precision <- if (options[["min_precision_test"]]) options[["min_precision_rel_val"]] else NULL

    if (!options[["bayesian"]]) {
      planningState <- list()
      planningState[["n"]] <- if (options[["dataType"]] == "stats") options[["n"]] else nrow(dataset)
      return(planningState)
    } else if (options[["bayesian"]]) {
      ir <- switch(options[["ir"]],
        "high" = 1,
        "medium" = 0.60,
        "low" = 0.36,
        "custom" = options[["irCustom"]]
      )
      cr <- switch(options[["cr"]],
        "high" = 1,
        "medium" = 0.60,
        "low" = 0.36,
        "custom" = options[["crCustom"]]
      )

      N_units <- if (evaluationOptions[["N.units"]][1] == 0) NULL else evaluationOptions[["N.units"]]
      prior <- jfa::auditPrior(
        conf.level = options[["conf_level"]], materiality = materiality, expected = evaluationOptions[["expected_val"]],
        likelihood = options[["method"]], N.units = sum(N_units), ir = ir,
        cr = cr, method = options[["prior_method"]], n = options[["n_prior"]], x = options[["x_prior"]],
        alpha = options[["alpha"]], beta = options[["beta"]]
      )

      if (options[["separateMisstatement"]] && options[["values"]] != "" && options[["values.audit"]] != "") {
        result <- .jfaSeparatedMisstatementPlanningState(options, dataset, prior, evaluationOptions)
        return(result)
      }

      planningState <- jfa::planning(
        conf.level = options[["conf_level"]], materiality = materiality, min.precision = min_precision,
        expected = evaluationOptions[["expected_val"]], N.units = evaluationOptions[["N.units"]], prior = prior
      )

      planningState[["n"]] <- if (options[["dataType"]] == "stats") options[["n"]] else nrow(dataset)

      return(planningState)
    }
  } else {
    planningState <- list()
    planningState[["n"]] <- "..."
    return(planningState)
  }
}

.jfaEvaluationAnalysisState <- function(options, sample, planningOptions, evaluationContainer) {
  # Check whether there is enough data to perform an analysis
  if (!options[["materiality_test"]] && !options[["min_precision_test"]]) {
    return()
  } else if (options[["materiality_test"]] && planningOptions[["materiality_val"]] == 0) {
    return()
  } else if (options[["dataType"]] %in% c("data", "pdata") && (options[["values.audit"]] == "" || options[["id"]] == "")) {
    return()
  } else if (options[["dataType"]] == "stats" && options[["n"]] == 0) {
    return()
  }
  if (options[["dataType"]] %in% c("data", "pdata") && options[["values.audit"]] != "" && !all(unique(sample[[options[["values.audit"]]]]) %in% c(0, 1)) && options[["values"]] == "") {
    return()
  }

  if (!is.null(evaluationContainer[["evaluationState"]])) {
    return(evaluationContainer[["evaluationState"]]$object)
  } else {
    ir <- switch(options[["ir"]],
      "high" = 1,
      "medium" = 0.60,
      "low" = 0.36,
      "custom" = options[["irCustom"]]
    )
    cr <- switch(options[["cr"]],
      "high" = 1,
      "medium" = 0.60,
      "low" = 0.36,
      "custom" = options[["crCustom"]]
    )
    prior <- FALSE
    N_units <- if (planningOptions[["N.units"]][1] == 0) NULL else planningOptions[["N.units"]]
    N_items <- if (planningOptions[["N.items"]][1] == 0) NULL else planningOptions[["N.items"]]
    materiality <- if (options[["materiality_test"]]) planningOptions[["materiality_val"]] else NULL
    conf_level <- if (!options[["bayesian"]]) 1 - .jfaAuditRiskModelCalculation(options) else options[["conf_level"]]

    if (options[["bayesian"]]) {
      prior <- jfa::auditPrior(
        method = options[["prior_method"]], conf.level = conf_level, materiality = materiality,
        expected = planningOptions[["expected_val"]], likelihood = options[["method"]],
        N.units = N_units, ir = ir, cr = cr, n = options[["n_prior"]],
        x = options[["x_prior"]], alpha = options[["alpha"]], beta = options[["beta"]]
      )
    }
    if (options[["dataType"]] == "stats") {
      result <- try({
        jfa::evaluation(
          conf.level = conf_level, materiality = materiality,
          n = options[["n"]], x = options[["x"]], method = options[["method"]],
          prior = prior, N.units = N_units,
          alternative = if (options[["area"]] == "area_bound") "less" else "two.sided"
        )
      })
    } else if (all(unique(sample[[options[["values.audit"]]]]) %in% c(0, 1))) {
      result <- try({
        jfa::evaluation(
          conf.level = conf_level, materiality = materiality,
          n = nrow(sample), x = length(which(sample[[options[["values.audit"]]]] == 1)),
          method = options[["method"]], N.units = N_units,
          prior = prior,
          alternative = if (options[["area"]] == "area_bound") "less" else "two.sided"
        )
      })
    } else {
      method <- options[["method"]]
      if (options[["method"]] == "stringer" && options[["lta"]]) {
        method <- "stringer.lta"
      }

      if (options[["separateMisstatement"]] && options[["values"]] != "" && options[["values.audit"]] != "") {
        result <- .jfaSeparatedMisstatementEvaluationState(options, sample, prior, planningOptions, selectionState, evaluationContainer)
        return(result)
      } else {
        result <- try({
          jfa::evaluation(
            data = sample, times = if (options[["times"]] != "" && (!options[["bayesian"]] || options[["pooling"]] != "partial")) options[["times"]] else NULL, conf.level = conf_level, materiality = materiality,
            values = options[["values"]], values.audit = options[["values.audit"]], alternative = if (options[["method"]] %in% c("direct", "difference", "quotient", "regression")) "two.sided" else if (options[["area"]] == "area_bound") "less" else "two.sided",
            method = method, N.items = N_items, N.units = N_units,
            prior = prior, strata = if (options[["stratum"]] != "") options[["stratum"]] else NULL,
            pooling = if (options[["bayesian"]]) if (options[["pooling"]]) "partial" else "none" else "none"
          )
        })
      }
    }
    if (isTryError(result)) {
      evaluationContainer$setError(paste0("An error occurred: ", jaspBase:::.extractErrorMessage(result)))
      return()
    }

    evaluationContainer[["evaluationState"]] <- createJaspState(result)
    return(result)
  }
}

.jfaTableEvaluation <- function(options, prevOptions, parentState, parentContainer, jaspResults, positionInContainer) {
  .jfaTableNumberUpdate(jaspResults)

  if (!is.null(parentContainer[["evaluationTable"]])) {
    return()
  }

  title <- gettextf("<b>Table %1$i.</b> Evaluation Summary", jaspResults[["tabNumber"]]$object)
  table <- createJaspTable(title)
  table$position <- positionInContainer
  table$transpose <- TRUE
  table$dependOn(options = c(
    "tableBookDist", "tableDescriptives", "tableSample",
    "samplingChecked", "evaluationChecked", "display",
    "values.audit", "ir", "irCustom", "cr", "crCustom"
  ))

  columnType <- if (options[["display"]] == "percent") "string" else "number"
  table$addColumnInfo(name = "null", title = "", type = "string")
  if (options[["materiality_test"]]) {
    table$addColumnInfo(name = "materiality", title = gettext("Performance materiality"), type = columnType)
  }
  if (options[["min_precision_test"]]) {
    table$addColumnInfo(name = "min_precision", title = gettext("Min. precision"), type = columnType)
  }
  table$addColumnInfo(name = "n", title = gettext("Sample size"), type = "integer")
  table$addColumnInfo(name = "x", title = gettext("Misstatements"), type = "integer")
  table$addColumnInfo(name = "t", title = gettext("Taint"), type = columnType)
  table$addColumnInfo(name = "mle", title = gettext("Most likely misstatement"), type = columnType)

  if (!options[["bayesian"]]) {
    dr <- .jfaAuditRiskModelCalculation(options)
    if (options[["method"]] %in% c("direct", "difference", "quotient", "regression") || options[["area"]] == "area_interval") {
      uppertitle <- round((1 - (1 - (1 - dr)) / 2) * 100, 2)
      table$addColumnInfo(name = "lb", title = gettextf("%1$s%% Lower bound", 100 - uppertitle), type = columnType)
      table$addColumnInfo(name = "ub", title = gettextf("%1$s%% Upper bound", uppertitle), type = columnType)
    } else {
      title <- round((1 - dr) * 100, 2)
      table$addColumnInfo(name = "ub", title = gettextf("%1$s%% Upper bound", title), type = columnType)
    }
  } else {
    if (options[["area"]] == "area_bound") {
      ubtitle <- round(options[["conf_level"]] * 100, 2)
      table$addColumnInfo(name = "ub", title = gettextf("%1$s%% Upper bound", ubtitle), type = columnType)
    } else if (options[["area"]] == "area_interval") {
      ubtitle <- round((1 - (1 - options[["conf_level"]]) / 2) * 100, 2)
      table$addColumnInfo(name = "lb", title = gettextf("%1$s%% Lower bound", 100 - ubtitle), type = columnType)
      table$addColumnInfo(name = "ub", title = gettextf("%1$s%% Upper bound", ubtitle), type = columnType)
    }
  }

  table$addColumnInfo(name = "precision", title = gettext("Precision"), type = columnType)
  if (!options[["bayesian"]] && options[["materiality_test"]] && options[["method"]] %in% c("poisson", "binomial", "hypergeometric")) {
    table$addColumnInfo(name = "p", title = gettext("p-value"), type = "pvalue")
  }
  if (options[["bayesian"]] && options[["materiality_test"]] && options[["method"]] %in% c("poisson", "binomial", "hypergeometric")) {
    bftitle <- if (options[["area"]] == "area_bound") gettextf("BF%1$s", "\u208B\u208A") else gettextf("BF%1$s", "\u2081\u2080")
    table$addColumnInfo(name = "bf", title = bftitle, type = "number")
  }

  if (!options[["bayesian"]]) {
    message <- switch(options[["method"]],
      "poisson" = gettext("The results are computed using the Poisson distribution."),
      "binomial" = gettext("The results are computed using the binomial distribution."),
      "hypergeometric" = gettext("The results are computed using the hypergeometric distribution."),
      "stringer" = gettext("The results are computed using the Stringer method."),
      "regression" = gettext("The results are computed using the regression estimator."),
      "direct" = gettext("The results are computed using the direct estimator."),
      "difference" = gettext("The results are computed using the difference estimator."),
      "quotient" = gettext("The results are computed using the ratio estimator."),
      "mpu" = gettext("The results are computed using the mean-per-unit estimator")
    )
  } else {
    message <- switch(options[["method"]],
      "binomial" = gettext("The results are computed using the beta distribution."),
      "poisson" = gettext("The results are computed using the gamma distribution."),
      "hypergeometric" = gettext("The results are computed using the beta-binomial distribution.")
    )
  }

  # Custom message for stringer bound with LTA
  if (options[["method"]] == "stringer" && options[["lta"]]) {
    message <- gettext("The results are computed using the Stringer method with LTA adjustment.")
  }

  # Custom message for efficiency technique
  if (options[["separateMisstatement"]] && options[["values"]] != "") {
    message <- gettext("The results are computed using the beta distribution and require the assumption that the population taints are homogeneous.")
  }

  table$addFootnote(message)

  parentContainer[["evaluationTable"]] <- table

  if (is.null(parentState) || (options[["values.audit"]] == "" && options[["dataType"]] %in% c("data", "pdata"))) {
    if (options[["workflow"]]) {
      table$addFootnote(
        message = gettext("The audit result column is empty."),
        symbol = gettextf("%1$s <b>Insufficient information.</b>", "\u26A0")
      )
    } else {
      table$addFootnote(
        message = gettext("Either the materiality, the population size, or the population value is defined as zero, or one of the required variables is missing."),
        symbol = gettextf("%1$s <b>Insufficient information.</b>", "\u26A0")
      )
    }
    return()
  }

  table[["null"]] <- "Value"
  table[["n"]] <- parentState[["n"]]
  table[["x"]] <- parentState[["x"]]
  table[["t"]] <- if (options[["display"]] == "percent") paste0(round(parentState[["t"]] / parentState[["n"]] * 100, 3), "%") else parentState[["t"]]

  if (options[["materiality_test"]]) {
    table[["materiality"]] <- switch(options[["display"]],
      "number" = prevOptions[["materiality_val"]],
      "percent" = paste0(round(prevOptions[["materiality_val"]] * 100, 3), "%"),
      "amount" = prevOptions[["materiality_val"]] * parentState[["N.units"]]
    )
  }

  if (options[["min_precision_test"]]) {
    table[["min_precision"]] <- switch(options[["display"]],
      "number" = options[["min_precision_rel_val"]],
      "percent" = paste0(round(options[["min_precision_rel_val"]] * 100, 3), "%"),
      "amount" = options[["min_precision_rel_val"]] * parentState[["N.units"]]
    )
  }

  if (parentState[["method"]] %in% c("direct", "difference", "quotient", "regression")) {
    table[["mle"]] <- switch(options[["display"]],
      "number" = parentState[["mle"]],
      "percent" = paste0(round(parentState[["mle"]] / parentState[["N.units"]] * 100, 3), "%"),
      "amount" = parentState[["mle"]]
    )
  } else {
    table[["mle"]] <- switch(options[["display"]],
      "number" = parentState[["mle"]],
      "percent" = paste0(round(parentState[["mle"]] * 100, 3), "%"),
      "amount" = parentState[["mle"]] * parentState[["N.units"]]
    )
  }

  if (parentState[["method"]] %in% c("direct", "difference", "quotient", "regression")) {
    table[["lb"]] <- switch(options[["display"]],
      "number" = parentState[["lb"]],
      "percent" = paste0(round(parentState[["lb"]] / parentState[["N.units"]] * 100, 3), "%"),
      "amount" = parentState[["lb"]]
    )
    table[["ub"]] <- switch(options[["display"]],
      "number" = parentState[["ub"]],
      "percent" = paste0(round(parentState[["ub"]] / parentState[["N.units"]] * 100, 3), "%"),
      "amount" = parentState[["ub"]]
    )
  } else if (options[["area"]] == "area_interval") {
    table[["lb"]] <- switch(options[["display"]],
      "number" = parentState[["lb"]],
      "percent" = paste0(round(parentState[["lb"]] * 100, 3), "%"),
      "amount" = parentState[["lb"]] * parentState[["N.units"]]
    )
    table[["ub"]] <- switch(options[["display"]],
      "number" = parentState[["ub"]],
      "percent" = paste0(round(parentState[["ub"]] * 100, 3), "%"),
      "amount" = parentState[["ub"]] * parentState[["N.units"]]
    )
  } else {
    table[["ub"]] <- switch(options[["display"]],
      "number" = parentState[["ub"]],
      "percent" = paste0(round(parentState[["ub"]] * 100, 3), "%"),
      "amount" = parentState[["ub"]] * parentState[["N.units"]]
    )
  }

  if (parentState[["method"]] %in% c("direct", "difference", "quotient", "regression")) {
    table[["precision"]] <- switch(options[["display"]],
      "number" = parentState[["precision"]],
      "percent" = paste0(round(parentState[["precision"]] / parentState[["N.units"]] * 100, 3), "%"),
      "amount" = parentState[["precision"]]
    )
  } else {
    table[["precision"]] <- switch(options[["display"]],
      "number" = parentState[["precision"]],
      "percent" = paste0(round(parentState[["precision"]] * 100, 3), "%"),
      "amount" = parentState[["precision"]] * parentState[["N.units"]]
    )
  }

  if (!options[["bayesian"]] && options[["materiality_test"]] && options[["method"]] %in% c("poisson", "binomial", "hypergeometric")) {
    table[["p"]] <- parentState[["p.value"]]
  }
  if (options[["bayesian"]] && options[["materiality_test"]] && options[["method"]] %in% c("poisson", "binomial", "hypergeometric")) {
    table[["bf"]] <- parentState[["posterior"]][["hypotheses"]]$bf.h1
  }
}

.jfaTableStratum <- function(options, sample, parentState, parentContainer, jaspResults, positionInContainer = 3) {
  if (options[["id"]] == "" || options[["stratum"]] == "" || !is.null(parentContainer[["tableStratum"]])) {
    return()
  }

  .jfaTableNumberUpdate(jaspResults)

  title <- gettextf("<b>Table %1$i.</b> Stratum Summary", jaspResults[["tabNumber"]]$object)
  tb <- createJaspTable(title)
  tb$position <- positionInContainer
  tb$transpose <- TRUE

  tb$addColumnInfo(name = "stratum", title = gettext("Stratum"), type = "string")
  tb$addColumnInfo(name = "n", title = gettext("Sample size"), type = "integer")
  tb$addColumnInfo(name = "k", title = gettext("Misstatements"), type = "integer")
  tb$addColumnInfo(name = "t", title = gettext("Taint"), type = "number")
  tb$addColumnInfo(name = "mle", title = gettext("Most likely misstatement"), type = "number")
  if (options[["area"]] == "area_bound") {
    ubtitle <- round(options[["conf_level"]] * 100, 2)
    tb$addColumnInfo(name = "ub", title = gettextf("%1$s%% Upper bound", ubtitle), type = "number")
  } else {
    ubtitle <- round((1 - (1 - options[["conf_level"]]) / 2) * 100, 2)
    tb$addColumnInfo(name = "lb", title = gettextf("%1$s%% Lower bound", 100 - ubtitle), type = "number")
    tb$addColumnInfo(name = "ub", title = gettextf("%1$s%% Upper bound", ubtitle), type = "number")
  }
  tb$addColumnInfo(name = "precision", title = gettext("Precision"), type = "number")
  parentContainer[["tableStratum"]] <- tb

  if (is.null(parentState) || parentContainer$getError()) {
    return()
  }

  tb[["stratum"]] <- rownames(parentState[["strata"]])
  tb[["n"]] <- parentState[["strata"]]$n
  tb[["k"]] <- parentState[["strata"]]$x
  tb[["t"]] <- parentState[["strata"]]$t
  tb[["mle"]] <- parentState[["strata"]]$mle
  if (options[["area"]] == "area_interval") {
    tb[["lb"]] <- parentState[["strata"]]$lb
  }
  tb[["ub"]] <- parentState[["strata"]]$ub
  tb[["precision"]] <- parentState[["strata"]]$precision
}

.jfaTableTaints <- function(options, sample, parentContainer, jaspResults, positionInContainer = 3) {
  if (!options[["tableTaints"]] || options[["dataType"]] == "stats") {
    return()
  }

  .jfaTableNumberUpdate(jaspResults)

  title <- gettextf("<b>Table %1$i.</b> Misstated Items", jaspResults[["tabNumber"]]$object)
  tb <- createJaspTable(title)
  tb$position <- positionInContainer
  tb$dependOn(options = "tableTaints")

  tb$addColumnInfo(name = "id", title = gettext("ID"), type = "string")
  tb$addColumnInfo(name = "values", title = gettext("Book value"), type = "number")
  tb$addColumnInfo(name = "values.audit", title = gettext("Audit value"), type = "number")
  tb$addColumnInfo(name = "diff", title = gettext("Difference"), type = "number")
  tb$addColumnInfo(name = "taint", title = gettext("Taint"), type = "number")
  tb$addColumnInfo(name = "times", title = gettext("Counted"), type = "string")
  parentContainer[["tableTaints"]] <- tb

  if (options[["values.audit"]] == "" || options[["values"]] == "") {
    return()
  }

  errors <- sample[sample[[options[["values"]]]] != sample[[options[["values.audit"]]]], ]
  if (nrow(errors) == 0) {
    table$addFootnote(message = gettext("No misstatements were identified in the sample."))
    return()
  }

  id <- errors[[options[["id"]]]]
  ist <- errors[[options[["values"]]]]
  soll <- errors[[options[["values.audit"]]]]
  if (options[["workflow"]]) {
    times <- errors[[options[["indicator_col"]]]]
  } else {
    if (options[["times"]] == "") {
      times <- rep(1, nrow(errors))
    } else {
      times <- errors[[options[["times"]]]]
    }
  }
  tb[["id"]] <- c(id, "Total")
  tb[["values"]] <- c(ist, NA)
  tb[["values.audit"]] <- c(soll, NA)
  tb[["diff"]] <- c(ist - soll, sum(ist - soll))
  tb[["taint"]] <- c((ist - soll) / ist, sum(((ist - soll) / ist) * times))
  tb[["times"]] <- c(paste0("x", times), NA)
}

.jfaTableAssumptions <- function(options, sample, parentContainer, jaspResults, positionInContainer = 3) {
  if (!options[["tableAssumptions"]] || !options[["separateMisstatement"]] || options[["values"]] == "") {
    return()
  }

  .jfaTableNumberUpdate(jaspResults)

  title <- gettextf("<b>Table %1$i.</b> Assumption Checks", jaspResults[["tabNumber"]]$object)
  table <- createJaspTable(title)
  table$position <- positionInContainer
  table$dependOn(options = c("tableAssumptions"))

  table$addColumnInfo(name = "type", title = "", type = "string")
  table$addColumnInfo(name = "n", title = "n", type = "integer")
  table$addColumnInfo(name = "correlation", title = gettext("Pearson's r"), type = "number")
  table$addColumnInfo(name = "upperCI", title = gettextf("%1$s%% Upper bound", options[["tableAssumptionsConfidence"]] * 100), type = "number")
  table$addColumnInfo(name = "pvalue", title = "p", type = "pvalue")
  table$addColumnInfo(name = "bayesfactor", title = "BF\u208B\u2080", type = "number")

  table$addFootnote(gettext("The null hypotheses H\u2080: \u03C1 \u2265 0 is tested against the alternative hypothesis H\u208B: \u03C1 < 0"))

  parentContainer[["assumptionTable"]] <- table

  if (options[["values.audit"]] == "") {
    row <- list(type = gettext("Book values - Taints"))
    table$addRows(row)
    return()
  }

  # Extract Ist values and taints
  ist <- sample[[options[["values"]]]]
  soll <- sample[[options[["values.audit"]]]]
  taint <- (ist - soll) / ist

  # Select only the non-zero taints for the correlation
  ist <- ist[taint != 0]
  taint <- taint[taint != 0]

  if (length(taint) == 0) {
    table$addFootnote(gettext("There were no misstatements found in the sample."))
    row <- list(type = gettext("Book values - Taints"), n = length(taint))
    table$addRows(row)
    return()
  }

  p <- try({
    test <- stats::cor.test(
      x = ist, y = taint, alternative = "less", method = "pearson",
      conf.level = options[["tableAssumptionsConfidence"]]
    )
    btest <- bstats::bcor.test(x = ist, y = taint, alternative = "less", method = "pearson")
  })

  if (isTryError(p)) {
    table$addFootnote(gettext("An error occurred while calculating the correlation."))
    return()
  }

  row <- list(
    type = gettext("Book values - Taints"),
    n = length(taint),
    correlation = test[["estimate"]],
    upperCI = as.numeric(test[["conf.int"]])[2],
    pvalue = test[["p.value"]],
    bayesfactor = btest[["less"]]$bf
  )

  table$addRows(row)
}

.jfaPlotObjectives <- function(options, prevOptions, parentState, parentContainer, jaspResults, positionInContainer = 5) {
  if (!options[["plotObjectives"]]) {
    return()
  }

  .jfaFigureNumberUpdate(jaspResults)

  if (is.null(parentContainer[["plotObjectives"]])) {
    figure <- createJaspPlot(
      plot = NULL, title = gettext("Evaluation of Sampling Objectives"),
      width = 600, height = 300
    )
    figure$position <- positionInContainer
    figure$dependOn(options = c("plotObjectives", "display"))

    parentContainer[["plotObjectives"]] <- figure

    if (is.null(parentState)) {
      return()
    }

    if (((options[["values.audit"]] == "" || options[["id"]] == "") && options[["dataType"]] %in% c("data", "pdata")) ||
      (options[["dataType"]] == "stats" && options[["n"]] == 0) ||
      (prevOptions[["materiality_val"]] == 0 && options[["materiality_test"]]) ||
      parentContainer$getError()) {
      return()
    }

    if (any(is.na(parentState[["ub"]]) || is.na(parentState[["mle"]]) || is.na(parentState[["precision"]]))) {
      figure$setError(gettext("An error occurred while creating this plot: The results contain NAs"))
      return()
    }

    plotError <- try({
      materiality <- parentState[["materiality"]]
      min_precision <- options[["min_precision_rel_val"]]

      if (options[["method"]] %in% c("direct", "difference", "quotient", "regression")) {
        bound <- parentState[["ub"]] / parentState[["N.units"]]
        mle <- parentState[["mle"]] / parentState[["N.units"]]
        precision <- parentState[["precision"]] / parentState[["N.units"]]
      } else {
        bound <- parentState[["ub"]]
        mle <- parentState[["mle"]]
        precision <- parentState[["precision"]]
      }

      objectiveColor <- "orange"
      boundColor <- if (bound < materiality) rgb(0, 1, .7, 1) else rgb(1, 0, 0, 1)
      precisionColor <- if (precision < min_precision) rgb(0, 1, .7, 1) else rgb(1, 0, 0, 1)

      if (options[["materiality_test"]] && !options[["min_precision_test"]]) {
        label <- rev(c(gettext("Performance materiality"), gettext("Upper bound"), gettext("Most likely error")))
        values <- rev(c(materiality, bound, mle))
        fill <- rev(c(objectiveColor, boundColor, "#1380A1"))
      } else if (!options[["materiality_test"]] && options[["min_precision_test"]]) {
        label <- rev(c(gettext("Minimum precision"), gettext("Obtained precision"), gettext("Upper bound"), gettext("Most likely error")))
        values <- rev(c(min_precision, precision, bound, mle))
        fill <- rev(c(objectiveColor, precisionColor, "#1380A1", "#1380A1"))
      } else if (options[["materiality_test"]] && options[["min_precision_test"]]) {
        label <- rev(c(gettext("Minimum precision"), gettext("Obtained precision"), gettext("Performance materiality"), gettext("Upper bound"), gettext("Most likely error")))
        values <- rev(c(min_precision, precision, materiality, bound, mle))
        fill <- rev(c(objectiveColor, precisionColor, objectiveColor, boundColor, "#1380A1"))
      }

      if (options[["display"]] == "amount") {
        values <- values * prevOptions[["N.units"]]
      }

      plotData <- data.frame(x = label, y = values)
      plotData$x <- factor(plotData$x, levels = plotData$x)

      if (all(plotData$y > 0)) {
        yBreaks <- jaspGraphs::getPrettyAxisBreaks(c(0, 1.2 * max(values)), min.n = 4)
        yLimits <- c(0, max(yBreaks))
      } else {
        yBreaks <- jaspGraphs::getPrettyAxisBreaks(c(min(values), 1.2 * max(values)), min.n = 4)
        yLimits <- range(yBreaks)
      }

      if (options[["display"]] == "amount") {
        yLabels <- format(yBreaks, scientific = FALSE)
        valueLabels <- ceiling(values)
      } else {
        yLabels <- paste0(round(yBreaks * 100, 2), "%")
        valueLabels <- paste0(round(values * 100, 2), "%")
      }
    })

    if (!jaspBase::isTryError(plotError)) {
      plot <- ggplot2::ggplot(data = plotData, mapping = ggplot2::aes(x = x, y = y)) +
        ggplot2::geom_bar(stat = "identity", col = "black", size = 1, fill = fill) +
        ggplot2::coord_flip() +
        ggplot2::xlab(NULL) +
        ggplot2::annotate(
          geom = "text",
          y = values, x = 1:length(values), label = valueLabels,
          size = 6, vjust = 0.5, hjust = -0.1
        ) +
        ggplot2::scale_y_continuous(name = "", breaks = yBreaks, limits = yLimits, labels = yLabels) +
        jaspGraphs::geom_rangeframe(sides = "") +
        jaspGraphs::themeJaspRaw(legend.position = "none") +
        ggplot2::theme(
          axis.ticks.x = ggplot2::element_blank(),
          axis.ticks.y = ggplot2::element_blank(),
          axis.text.y = ggplot2::element_text(hjust = 0),
          panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb", size = 0.5)
        )

      figure$plotObject <- plot
    } else {
      figure$setError(gettextf("An error occurred while creating this plot: %1$s", jaspBase:::.extractErrorMessage(plotError)))
    }
  }

  if (options[["explanatoryText"]]) {
    figureCaption <- createJaspHtml(gettextf(
      "<b>Figure %1$i.</b> Evaluation information for the current annotated selection. The materiality is compared with the maximum misstatement and the most likely misstatement. The most likely misstatement is the best estimate of the true misstatement in the population. The upper bound is an estimate of the maximum misstatement in the population.",
      jaspResults[["figNumber"]]$object
    ), "p")

    figureCaption$position <- positionInContainer + 1
    figureCaption$dependOn(optionsFromObject = parentContainer[["plotObjectives"]])
    figureCaption$dependOn(options = "explanatoryText")
    parentContainer[["evaluationInformationText"]] <- figureCaption
  }
}

.jfaAddCorrelationLineToPlot <- function(fit, plot = NULL, xMin, xMax, lwd) {
  # create function formula
  f <- vector("character", 0)
  for (i in seq_along(coef(fit))) {
    if (i == 1) {
      temp <- paste(coef(fit)[[i]])
      f <- paste(f, temp, sep = "")
    }
    if (i > 1) {
      temp <- paste("(", coef(fit)[[i]], ")*", "x^", i - 1, sep = "")
      f <- paste(f, temp, sep = "+")
    }
  }

  x <- seq(xMin, xMax, length.out = 100)
  predY <- eval(parse(text = f))

  plot <- plot + ggplot2::geom_line(data = data.frame(x, predY), mapping = ggplot2::aes(x = x, y = predY), size = lwd, lty = 1)
  return(plot)
}

.jfaPlotScatter <- function(options, sample, prevOptions, parentContainer, jaspResults, positionInContainer) {
  if (!options[["plotScatter"]] || options[["dataType"]] == "stats") {
    return()
  }

  .jfaFigureNumberUpdate(jaspResults)

  if (is.null(parentContainer[["plotScatter"]])) {
    figure <- createJaspPlot(
      plot = NULL, title = gettext("Scatter Plot of Book and Audit Values"),
      width = 500, height = 400
    )
    figure$position <- positionInContainer
    figure$dependOn(options = c("plotScatter", "plotScatterId", "plotScatterCorrelation"))

    parentContainer[["plotScatter"]] <- figure

    if (options[["values.audit"]] == "" || options[["values"]] == "" || parentContainer$getError()) {
      return()
    }

    plotData <- data.frame(
      ist = sample[[options[["values"]]]],
      soll = sample[[options[["values.audit"]]]]
    )
    plotData <- na.omit(plotData) # Just to be sure

    ist <- plotData[["ist"]]
    soll <- plotData[["soll"]]
    corResult <- cor(x = ist, y = soll, method = "pearson")

    fit <- vector("list", 1)
    fit[[1]] <- lm(soll ~ poly(ist, 1, raw = TRUE), data = plotData)
    bestModel <- 1 # which.min(Bic)

    # format ticks and labels
    ticks <- pretty(c(ist, soll), min.n = 4)
    minTicks <- min(ticks)
    maxTicks <- max(ticks)
    labs <- format(ticks, digits = 3, scientific = FALSE)

    corResult <- round(corResult, 3)

    cols <- rep("gray", nrow(plotData))
    cols[which(plotData$ist != plotData$soll)] <- rgb(0.9, 0, 0, 1)

    plot <- ggplot2::ggplot(data = plotData, mapping = ggplot2::aes(x = ist, y = soll)) +
      ggplot2::geom_line(
        data = data.frame(x = c(minTicks, maxTicks), y = c(minTicks, maxTicks)),
        mapping = ggplot2::aes(x = x, y = y), size = 0.35, linetype = "dashed"
      ) +
      ggplot2::scale_x_continuous(
        name = gettextf("Book value (%1$s)", prevOptions[["valuta"]]),
        breaks = ticks, labels = labs, limits = range(ticks)
      ) +
      ggplot2::scale_y_continuous(
        name = gettextf("Audit value (%1$s)", prevOptions[["valuta"]]),
        breaks = ticks, labels = labs, limits = range(ticks)
      ) +
      jaspGraphs::geom_point(size = 3, fill = cols)

    if (options[["plotScatterCorrelation"]]) {
      plot <- .jfaAddCorrelationLineToPlot(fit = fit[[bestModel]], plot = plot, xMin = minTicks, xMax = maxTicks, lwd = 1)
      plot <- plot + ggplot2::annotate("text",
        x = ticks[1], y = (ticks[length(ticks)] - ((ticks[length(ticks)] - ticks[length(ticks) - 1]) / 2)),
        label = paste0("italic(r) == ", corResult), size = 8, parse = TRUE, hjust = -0.5, vjust = 0.5
      )
    }

    if (options[["plotScatterId"]]) {
      plot <- plot + ggrepel::geom_text_repel(ggplot2::aes(label = sample[[options[["id"]]]], x = ist, y = soll), hjust = -1, vjust = 1, data = plotData)
    }

    plot <- plot +
      jaspGraphs::geom_rangeframe() +
      jaspGraphs::themeJaspRaw(legend.position = "none") +
      ggplot2::theme(
        panel.grid.major.x = ggplot2::element_line(color = "#cbcbcb", size = 0.5),
        panel.grid.major.y = ggplot2::element_line(color = "#cbcbcb", size = 0.5)
      )

    figure$plotObject <- plot
  }

  if (options[["explanatoryText"]]) {
    figureCaption <- createJaspHtml(gettextf(
      "<b>Figure %1$i.</b> Scatter plot of the book values in the selection and their corresponding audit values. Grey dots on the diagonal (dashed line) indicate matching book and audit values. Red dots off the diagonal indicate items whose audit value did not match their original book value. If these red dots lie below the diagonal, the items are overstated. If these red dots lie above the diagonal they are understated. %2$s",
      jaspResults[["figNumber"]]$object,
      if (options[["plotScatterCorrelation"]]) "The value <i>r</i> is the Pearson correlation coefficient of the book values and the audit values, an indicator of the strength of the linear relationship (solid line) between the two." else ""
    ), "p")

    figureCaption$position <- positionInContainer + 1
    figureCaption$dependOn(optionsFromObject = parentContainer[["plotScatter"]])
    figureCaption$dependOn(options = "explanatoryText")
    parentContainer[["correLationPlotText"]] <- figureCaption
  }
}

################################################################################
################## Common functions for the conclusion #########################
################################################################################

.jfaCorrectionsTable <- function(options, jaspResults, workflow, positionInContainer) {
  prevContainer <- jaspResults[["evaluationContainer"]]
  prevState <- prevContainer[["evaluationState"]]$object
  parentContainer <- jaspResults[["conclusionContainer"]]

  if (!options[["tableCorrections"]] || is.null(prevState) || !is.null(parentContainer[["tableCorrections"]])) {
    return()
  }

  .jfaTableNumberUpdate(jaspResults)

  title <- gettextf(
    "<b>Table %i.</b> Corrections to Population",
    jaspResults[["tabNumber"]]$object
  )
  table <- createJaspTable(title)
  table$position <- positionInContainer
  table$dependOn(options = c("tableCorrections", "display"))
  columnType <- if (options[["display"]] == "percent") "string" else "number"

  table$addColumnInfo(name = "name", title = "", type = columnType)
  table$addColumnInfo(name = "correction", title = gettext("Correction"), type = columnType)

  message <- if (!options[["materiality_test"]] && options[["min_precision_test"]]) " minus the minimum precision" else ""
  table$addFootnote(gettextf("The correction to achieve no misstatements is the upper bound%1$s.", message))

  parentContainer[["tableCorrections"]] <- table

  if (parentContainer$getError()) {
    return()
  }

  stage <- if (workflow) "planning" else "evaluation"
  prevOptions <- .jfaInputOptionsGather(options, dataset = NULL, jaspResults, stage = stage, rawData = TRUE)

  N <- ceiling(prevOptions[["N.units"]])

  if (!options[["materiality_test"]] && options[["min_precision_test"]]) {
    name <- gettextf("No misstatements with %1$s%% precision", round(options[["min_precision_rel_val"]] * 100, 2))
    correction <- prevState[["ub"]] - options[["min_precision_rel_val"]]
  } else if (options[["materiality_test"]] && !options[["min_precision_test"]]) {
    name <- gettextf("No misstatements with %1$s%% confidence", round(options[["conf_level"]] * 100, 2))
    correction <- prevState[["ub"]]
  } else if (options[["materiality_test"]] && options[["min_precision_test"]]) {
    name <- gettextf("No misstatements with %1$s%% confidence and %2$s%% precision", round(options[["conf_level"]] * 100, 2), round(options[["min_precision_rel_val"]] * 100, 2))
    correction <- prevState[["ub"]]
  }

  correction <- switch(options[["display"]],
    "number" = correction,
    "percent" = paste0(round(correction * 100, 3), "%"),
    "amount" = correction * N
  )

  rows <- data.frame(name = name, correction = correction)
  table$addRows(rows)
}

################################################################################
################## Common functions for the separate misstatement methods ######
################################################################################

.jfaSeparatedMisstatementPlanningState <- function(options, dataset, prior, parentOptions) {
  # Plan a sample for the efficiency technique Separate known and unknown misstatement
  for (n in seq(options[["by"]], options[["max"]], by = options[["by"]])) {
    interval <- (parentOptions[["N.units"]] / n)
    topStratum <- subset(dataset, dataset[[options[["values"]]]] > interval)
    bottomStratum <- subset(dataset, dataset[[options[["values"]]]] <= interval)

    m_seen <- sum(topStratum[[options[["values"]]]])

    # We choose a pseudo-random seed to get the impression of a random starting point
    # It is unlikely that two populations or users have the same seed
    set.seed(-0.4083114 + options[["by"]] + parentOptions[["N.units"]]) # -0.4083114 for backwards compatibility

    intervalStartingPoint <- sample(1:(interval - 1), size = 1)
    intervalSelection <- intervalStartingPoint + 0:(n - 1) * interval
    index <- NULL
    for (i in 1:n) {
      index <- c(index, which(intervalSelection[i] < cumsum(dataset[[options[["values"]]]]))[1])
    }
    sample <- dataset[index, ]
    sample <- unique(sample)

    bottomStratumSample <- sample[which(sample[[options[["values"]]]] <= interval), ]

    m_seen <- m_seen + sum(bottomStratumSample[[options[["values"]]]])
    m_seen_percentage <- m_seen / parentOptions[["N.units"]]

    m_unseen <- parentOptions[["N.units"]] - m_seen

    if (options[["expected_type"]] == "expected_all") {
      a <- prior[["description"]]$alpha + 0:n
      b <- prior[["description"]]$beta + n - 0:n
    } else if (options[["expected_type"]] == "expected_rel") {
      a <- prior[["description"]]$alpha + 0:ceiling(n * (parentOptions[["expected_val"]]))
      b <- prior[["description"]]$beta + n - 0:ceiling(n * (parentOptions[["expected_val"]]))
    } else if (options[["expected_type"]] == "expected_abs") {
      a <- prior[["description"]]$alpha + 0:ceiling(parentOptions[["expected_val"]])
      b <- prior[["description"]]$beta + n - 0:ceiling(parentOptions[["expected_val"]])
    }

    v95 <- qbeta(options[["conf_level"]], a, b)
    v <- ((a - 1) / (a + b - 2))
    relativeInaccuracy <- v95 - v
    correctedInaccuracy <- options[["min_precision_rel_val"]] * (1 / (1 - m_seen_percentage))
    diff <- relativeInaccuracy - correctedInaccuracy

    # Sampling objectives
    if (options[["min_precision_test"]] && !options[["materiality_test"]]) {
      if (all(diff <= 0)) {
        break
      }
    } else if (!options[["min_precision_test"]] && options[["materiality_test"]]) {
      if (all(v95 < (parentOptions[["materiality_val"]] / (1 - (m_seen / parentOptions[["N.units"]]))))) {
        break
      }
    } else if (options[["min_precision_test"]] && options[["materiality_test"]]) {
      if (all(diff <= 0) && all(v95 < (parentOptions[["materiality_val"]] / (1 - (m_seen / parentOptions[["N.units"]]))))) {
        break
      }
    }
  }

  adjustedMateriality <- (parentOptions[["materiality_val"]] / (1 - (m_seen / parentOptions[["N.units"]])))
  expErrors <- ceiling(n * (parentOptions[["expected_val"]] * 2))
  alphaPosterior <- prior[["description"]]$alpha + expErrors
  betaPosterior <- prior[["description"]]$beta + n - expErrors
  expectedPosterior <- list(
    description = list(alpha = alphaPosterior, beta = betaPosterior),
    statistics = list(
      mean = alphaPosterior / (alphaPosterior + betaPosterior),
      mode = (alphaPosterior - 1) / (alphaPosterior + betaPosterior - 2),
      ub = qbeta(options[["conf_level"]], alphaPosterior, betaPosterior),
      precision = qbeta(options[["conf_level"]], alphaPosterior, betaPosterior) - ((alphaPosterior - 1) / (alphaPosterior + betaPosterior - 2))
    ),
    hypotheses = list(
      p.h1 = pbeta(adjustedMateriality, alphaPosterior, betaPosterior),
      p.h0 = pbeta(adjustedMateriality, alphaPosterior, betaPosterior, lower.tail = FALSE),
      odds.h1 = pbeta(adjustedMateriality, alphaPosterior, betaPosterior) / pbeta(adjustedMateriality, alphaPosterior, betaPosterior, lower.tail = FALSE)
    )
  )
  expectedPosterior[["hypotheses"]]$bf.h1 <- expectedPosterior[["hypotheses"]]$odds.h1 / prior[["hypotheses"]]$odds.h1


  result <- list(
    n = n, x = parentOptions[["expected_val"]] * n,
    conf.level = options[["conf_level"]],
    materiality = parentOptions[["materiality_val"]],
    adjustedMateriality = adjustedMateriality,
    N.units = parentOptions[["N.units"]],
    N.items = parentOptions[["N.items"]],
    expected = expErrors,
    likelihood = "binomial",
    prior = prior,
    posterior = expectedPosterior,
    start = intervalStartingPoint
  )

  return(result)
}

.jfaSeparatedMisstatementEvaluationState <- function(options, sample, prior, prevOptions, prevState, parentContainer) {
  k <- length(which(sample[[options[["values"]]]] != sample[[options[["values.audit"]]]]))
  if (options[["workflow"]]) {
    n <- sum(sample[[options[["indicator_col"]]]])
  } else {
    if (options[["times"]] == "") {
      n <- nrow(sample)
    } else {
      n <- sum(sample[[options[["times"]]]])
    }
  }

  overstatements <- (sample[[options[["values"]]]] - sample[[options[["values.audit"]]]])
  unseen_value <- prevOptions[["N.units"]] - sum(sample[[options[["values"]]]])

  taintings <- overstatements / sample[[options[["values"]]]]
  if (options[["workflow"]]) {
    t <- sum(taintings * sample[[options[["indicator_col"]]]])
  } else {
    if (options[["times"]] == "") {
      t <- sum(taintings)
    } else {
      t <- sum(taintings * sample[[options[["times"]]]])
    }
  }
  avgTaint <- t / n
  posteriorMode <- (prior[["description"]]$alpha + t - 1) / (prior[["description"]]$alpha + t + prior[["description"]]$beta + n - t - 2)

  # Find out the total error in the critital transactions (if needed)
  if (options[["workflow"]] && options[["critical_negative"]] && options[["critical_action"]] == "inspect") {
    criticalTransactions <- subset(sample, sample[[options[["critical_name"]]]] > 0)
    if (nrow(criticalTransactions) == 0) {
      Vk <- 0
    } else {
      Vk <- sum(criticalTransactions[[options[["values"]]]] - criticalTransactions[[options[["values.audit"]]]]) # No absolute value
    }
    sample <- subset(sample, sample[[options[["critical_name"]]]] == 0)
  } else if (!options[["workflow"]] && options[["critical_negative"]] && options[["critical_action"]] == "inspect") {
    criticalTransactions <- subset(sample, sample[[options[["values"]]]] < 0)
    Vk <- sum(criticalTransactions[[options[["values"]]]] - criticalTransactions[[options[["values.audit"]]]]) # No absolute value
  } else {
    Vk <- 0
  }

  Vs <- sum(overstatements) # The total error in the sample (known error)
  Vt <- posteriorMode * unseen_value # The total error in the unseen observations (unknown error)
  Vt95 <- qbeta(options[["conf_level"]], shape1 = prior[["description"]]$alpha + t, shape2 = prior[["description"]]$beta + n - t) * unseen_value # The upper bound on the total error in the unseen observations

  # The inferred total error and upper bound for the population
  V <- Vk + Vs + Vt
  VAsFraction <- V / prevOptions[["N.units"]]

  V95 <- Vk + Vs + Vt95
  V95AsFraction <- V95 / prevOptions[["N.units"]]

  # The total obtained precision
  precisionAsFraction <- (V95 - V) / prevOptions[["N.units"]]

  adjustedMateriality <- (prevOptions[["materiality_val"]] / (1 - (sum(sample[[options[["values"]]]]) / prevOptions[["N.units"]])))
  alphaPosterior <- prior[["description"]]$alpha + t
  betaPosterior <- prior[["description"]]$beta + n - t
  posterior <- list(
    description = list(alpha = alphaPosterior, beta = betaPosterior),
    statistics = list(
      median = qbeta(0.5, alphaPosterior, betaPosterior),
      mean = alphaPosterior / (alphaPosterior + betaPosterior),
      mode = (alphaPosterior - 1) / (alphaPosterior + betaPosterior - 2),
      ub = qbeta(options[["conf_level"]], alphaPosterior, betaPosterior),
      precision = qbeta(options[["conf_level"]], alphaPosterior, betaPosterior) - ((alphaPosterior - 1) / (alphaPosterior + betaPosterior - 2))
    ),
    hypotheses = list(
      p.h1 = pbeta(adjustedMateriality, alphaPosterior, betaPosterior),
      p.h0 = pbeta(adjustedMateriality, alphaPosterior, betaPosterior, lower.tail = FALSE),
      odds.h1 = pbeta(adjustedMateriality, alphaPosterior, betaPosterior) / pbeta(adjustedMateriality, alphaPosterior, betaPosterior, lower.tail = FALSE),
      bf.h1 = (pbeta(adjustedMateriality, alphaPosterior, betaPosterior) / pbeta(adjustedMateriality, alphaPosterior, betaPosterior, lower.tail = FALSE)) / prior[["hypotheses"]]$odds.h1
    )
  )

  result <- list(
    ub = V95AsFraction,
    ubUnseen = Vt95 / unseen_value,
    min.precision = options[["min_precision_rel_val"]],
    precision = precisionAsFraction,
    precisionUnseen = qbeta(options[["conf_level"]], shape1 = prior[["description"]]$alpha + t, shape2 = prior[["description"]]$beta + n - t) - posteriorMode,
    unseenValue = unseen_value,
    x = k, t = t, n = n,
    prior = prior,
    posterior = posterior,
    conf.level = options[["conf_level"]],
    method = "binomial",
    likelihood = "binomial",
    mle = VAsFraction,
    mleUnseen = posteriorMode,
    materiality = prevOptions[["materiality_val"]],
    N.units = prevOptions[["N.units"]],
    adjustedMateriality = (prevOptions[["materiality_val"]] / (1 - (sum(sample[[options[["values"]]]]) / prevOptions[["N.units"]])))
  )

  parentContainer[["evaluationState"]] <- createJaspState(result)

  return(result)
}

################################################################################
################## End functions ###############################################
################################################################################
