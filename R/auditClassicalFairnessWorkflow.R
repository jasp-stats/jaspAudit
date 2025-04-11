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

auditClassicalFairnessWorkflow <- function(jaspResults, dataset, options, ...) {
  # Create the procedure paragraph
  .jfaFairnessWorkflowProcedureContainer(options, jaspResults, position = 1)

  selectionContainer <- .jfaFairnessWorkflowSelectionContainer(options, jaspResults, position = 2)

  # Display the theoretical information of the selected fairness measure
  .jfaSelectedFairnessMetric(options, jaspResults, selectionContainer, positionInContainer = 2)

  # --- PLOTS

  .jfaFigureNumberInit(jaspResults) # Initialize figure numbers

  # Display the decision-making workflow plot
  .jfaWorkflowPlot(options, jaspResults, selectionContainer, positionInContainer = 3)
}

.jfaFairnessWorkflowCommonOptions <- function(stage) {
  if (stage == "selection") {
    opt <- c("firstquestion", "secondquestion", "thirdquestion", "fourthquestion_caseA", "fourthquestion_caseB", "fourthquestion_caseC")
  }
  return(opt)
}

.jfaFairnessWorkflowProcedureContainer <- function(options, jaspResults, position) {
  if (options[["explanatoryText"]] && is.null(jaspResults[["procedureContainer"]])) {
    container <- createJaspContainer(title = gettext("<u>Procedure</u>"))
    container$position <- position
    text <- gettextf("The goal of this procedure is to determine to what extent the predictions of an algorithm are fair towards protected groups on a sensitive attribute. Fairness -ore discrimination- can be quantified using so-called fairness measures. There are various fairness measures, and different measures can lead to different conclusions about fairness. Therefore, selecting the most appropriate fairness measure for the context at hand is crucial. The decision-making workflow allows for determining the most suitable fairness measure by answering the necessary questions.")
    container[["procedureText"]] <- createJaspHtml(text, "p")
    container[["procedureText"]]$position <- 1
    container$dependOn(options = "explanatoryText")
    jaspResults[["procedureContainer"]] <- container
  }
}

.jfaFairnessWorkflowSelectionContainer <- function(options, jaspResults, position) {
  container <- createJaspContainer(title = gettext("<u>Selection</u>"))
  container$position <- position
  container$dependOn(options = .jfaFairnessWorkflowCommonOptions("selection"))
  jaspResults[["selectionContainer"]] <- container
  return(container)
}

.jfaClassicalFairnessWorkflowSelectionState <- function(options, jaspResults) {
  if (!is.null(jaspResults[["state"]])) {
    return(jaspResults[["state"]]$object)
  }
  metric <- q1 <- q2 <- q3 <- q4 <- NULL
  if (options[["firstquestion"]] == "firstquestion_no") {
    q1 <- 2
  } else {
    q1 <- 1
    if (options[["secondquestion"]] == "secondquestion_both") {
      q2 <- 3
    } else if (options[["secondquestion"]] == "secondquestion_incorrect") {
      q2 <- 2
      if (options[["fourthquestion_caseC"]] == "fourthquestion_caseC_FP") {
        q4 <- 1
      } else if (options[["fourthquestion_caseC"]] == "fourthquestion_caseC_FN") {
        q4 <- 2
      }
    } else if (options[["secondquestion"]] == "secondquestion_correct") {
      q2 <- 1
      if (options[["thirdquestion"]] == "thirdquestion_both") {
        q3 <- 3
      } else if (options[["thirdquestion"]] == "thirdquestion_positive") {
        q3 <- 1
        if (options[["fourthquestion_caseA"]] == "fourthquestion_caseA_FP") {
          q4 <- 1
        } else if (options[["fourthquestion_caseA"]] == "fourthquestion_caseA_FN") {
          q4 <- 2
        }
      } else if (options[["thirdquestion"]] == "thirdquestion_negative") {
        q3 <- 2
        if (options[["fourthquestion_caseB"]] == "fourthquestion_caseB_FP") {
          q4 <- 1
        } else if (options[["fourthquestion_caseB"]] == "fourthquestion_caseB_FN") {
          q4 <- 2
        }
      }
    }
  }
  metric <- jfa::fairness_selection(q1, q2, q3, q4)
  jaspResults[["state"]] <- createJaspState(metric)
  jaspResults[["state"]]$dependOn(options = .jfaFairnessWorkflowCommonOptions("selection"))
  return(jaspResults[["state"]]$object)
}

.jfaSelectedFairnessMetric <- function(options, jaspResults, container, positionInContainer) {
  if (!is.null(container[["selectedFairnessMeasureText"]])) {
    return()
  }
  state <- .jfaClassicalFairnessWorkflowSelectionState(options, jaspResults)
  details <- .jfaCreateFairnessWorkflowExplanationText(options, state)
  text <- createJaspHtml(details)
  text$position <- positionInContainer
  text$dependOn(options = c("explanatoryText", .jfaFairnessWorkflowCommonOptions("selection")))
  container[["selectedFairnessMeasureText"]] <- text
}

.jfaCreateFairnessWorkflowExplanationText <- function(options, state) {
  message <- gettextf("The most suitable fairness measure is <b>%1$s</b>.", tolower(state[["name"]]))
  if (options[["explanatoryText"]]) {
    if (state$name == "Disparate Impact") {
      explanationText <- gettextf("<u>Fairness Definition:</u>\nThe algorithm is fair if its use results in the same ratio of items from two different groups experiencing a change in the status quo (i.e., being classified as positive). The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts.\n\n<u>Formula:</u>\nDisparate impact is obtained by dividing the positive rate of the unprivileged group by that of the privileged group. The positive rate is equal to (TP+FP)/N, where TP denotes true positives (items correctly classified as positive), FP denotes false positives (items incorrectly classified as positive), and N represents the total number of items classified by the algorithm.\n\n<u>Further Details:</u>\nThe most common use of disparate impact is linked to the U.S. Equal Employment Opportunity Commission (EEOC) guidelines, particularly the %1$s%% rule. According to this rule, if disparate impact is higher than 0.80, there is no discrimination. This method has limitations, as the threshold value is not based on the measure's properties, data characteristics, or statistical considerations. Originally derived from U.S. employment hiring rates, the rule lacks theoretical rigor for broader applications.", 80)
    } else if (state$name == "Equalized Odds") {
      explanationText <- gettext("<u>Fairness Definition:</u>\nThe algorithm is fair if its use results in the same number of items from different groups experiencing correct and incorrect changes in the status quo (i.e, being, correctly and incorrectly, classified as positive). The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts.\n\n<u>Formula:</u>\nEqualized odds combines the true positive rate (TPR) and the false positive rate (FPR). The TPR is calculated as TP/(TP+FP) and the FPR as FP/(TN+FP), applied to both privileged and unprivileged groups. Here, TP denotes true positives (correctly classified positive items), TN denotes true negatives (correctly classified negative items), and FP denotes false positives (incorrectly classified positive items).\n\n<u>Further Details:</u>\nIt is important to note that this is the only measure in the decision-making workflow that addresses both the correct classification of the positive class and the incorrect classification of the negative class.")
    } else if (state$name == "Predictive Rate Parity") {
      explanationText <- gettext(" <u>Fairness Definition:</u>\n\nThe algorithm is fair if its use results in the same number of items from different groups experiencing correct changes in the status quo (i.e., being correctly classified as positive). The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts.\n\n<u>Formula:</u>\nPredictive rate parity is based on precision, calculated as TP/(TP+FP), applied to both the privileged and unprivileged groups. Here, TP denotes true positives (correctly classified positive items) and FP denotes false positives (incorrectly classified positive items).")
    } else if (state$name == "Equal Opportunity") {
      explanationText <- gettext("<u>Fairness Definition:</u>\nThe algorithm is fair if its use results in the same number of items from different groups experiencing correct changes in the status quo (i.e., being correctly classified as positive). The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts.\n\n<u>Formula:</u>\nEqual opportunity is based on the true positive rate, calculated as TP/(TP+FN), applied to both privileged and unprivileged groups. Here, TP denotes true positives (correctly classified positive items) and FN denotes false negatives (incorrectly classified negative items).")
    } else if (state$name == "Specificity Parity") {
      explanationText <- gettext("<u>Fairness Definition:</u>\nThe algorithm is fair if its use results in the same number of items from different groups correctly experiencing no changes in the status quo (i.e., being correctly classified as negative). The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts.\n\n<u>Formula:</u>\nSpecificity parity is based on the true negative rate, calculated as TN/(TN+FP), applied to both privileged and unprivileged groups. Here, TN denotes true negatives (correctly classified negative items) and FP denotes false positives (incorrectly classified positive items).")
    } else if (state$name == "Negative Predictive Value Parity") {
      explanationText <- gettext("<u>Fairness Definition:</u>\nThe algorithm is fair if its use results in the same number of items from different groups correctly experiencing no changes in the status quo (i.e., being correctly classified as negative). The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts.\n\n<u>Formula:</u>\nNegative predictive value parity is based on the negative predictive value, calculated as TN/(TN+FN), applied to both privileged and unprivileged groups. Here, TN denotes true negatives (correctly classified negative items) and FN denotes false negatives (incorrectly classified negative items).")
    } else if (state$name == "Accuracy Parity") {
      explanationText <- gettextf("<u>Fairness Definition:</u>\nThe algorithm is fair if its use results in the same number of items from different groups correctly experiencing changes and correctly experiencing no changes in the status quo (i.e., being correctly classified as positive and being correctly classified as negative). The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts.\n\n<u>Formula:</u>\nAccuracy parity is based on accuracy, calculated as (TP+TN)/N, applied to both privileged and unprivileged groups. Here, TP denotes true positives (correctly classified positive items), TN denotes true negatives (correctly classified negative items), and N represents the total number of items classified by the algorithm. The sum of TP and TN reflects the total number of correct classifications made by the algorithm.\n\n<u>Further Details:</u>\nAccuracy parity, like accuracy as a model evaluation metric, has a major flaw when applied to cases where the positive class is a small minority. For example, if %1$s%% of the privileged group and %2$s%% of the unprivileged group commit fraud, accuracy may seem high overall (%3$s%%), but masks disparities, with the unprivileged group having lower accuracy (%4$s%%) compared to the privileged group (%5$s%%). Unlike other measures, accuracy parity does not consider varying error costs. It fails to detect increases in false negatives or false positives, missing the associated rise in costs.", 3, 6, 96.7, 94, 97)
    } else if (state$name == "False Positive Rate Parity") {
      explanationText <- gettext("<u>Fairness Definition:</u>\nThe algorithm is fair if its use results in the same number of items from different groups experiencing incorrect changes in the status quo (i.e., being incorrectly classified as positive). The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts.\n\n<u>Formula:</u>\nFalse positive rate parity is based on the false positive rate, calculated as FP/(TN+FP), applied to both privileged and unprivileged groups. Here, FP denotes false positives (incorrectly classified positive items), and TN denotes true negatives (correctly classified negative items).")
    } else if (state$name == "False Negative Rate Parity") {
      explanationText <- gettext("<u>Fairness Definition:</u>\nThe algorithm is fair if its use results in the same number of items from different groups incorrectly experiencing no changes in the status quo (i.e., being incorrectly classified as negative). The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts.\n\n<u>Formula:</u>\nFalse negative rate parity is based on the false negative rate, calculated as FN/(TP+FN), applied to both privileged and unprivileged groups. Here, FN denotes false negatives (incorrectly classified negative items), and TP denotes true positives (correctly classified positive items).")
    }
  }
  if (options[["explanatoryText"]]) {
    message <- paste0(message, "\n\n", explanationText)
  }
  return(message)
}

.jfaWorkflowPlot <- function(options, jaspResults, container, positionInContainer) {
  if (!options[["workflowPlot"]]) {
    return()
  }
  .jfaFigureNumberUpdate(jaspResults)
  if (is.null(container[["fairnessWorkflowPlot"]])) {
    fg <- createJaspPlot(title = gettext("Decision-Making Workflow Plot"), width = 800, height = 800)
    fg$position <- positionInContainer
    fg$dependOn(options = c("workflowPlot", .jfaFairnessWorkflowCommonOptions("selection")))
    container[["fairnessWorkflowPlot"]] <- fg
    state <- .jfaClassicalFairnessWorkflowSelectionState(options, jaspResults)
    fg$plotObject <- plot(state)
  }
  if (options[["explanatoryText"]]) {
    caption <- createJaspHtml(gettextf("<b>Figure %1$i.</b> Graphical representation of the decision-making workflow. The label 'FP' indicates 'False Positives' and the label 'FN' indicates 'False Negatives'. The white rectangles indicate the followed path based on the answers provided to the necessary questions of the workflow, the gray rectangles represent the ignored path.", jaspResults[["figNumber"]]$object), "p")
    caption$position <- positionInContainer + 1
    caption$dependOn(optionsFromObject = container[["fairnessWorkflowPlot"]])
    container[["fairnessWorkflowPlotText"]] <- caption
  }
}
