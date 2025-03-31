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

auditFairnessWorkflow <- function(jaspResults, dataset, options, ...) {
  # Create the procedure paragraph
  .jfaFairnessProcedure(options, jaspResults, position = 1)

  fairnessMeasureContainer <- .jfaFairnessMeasureStage(options, jaspResults, position = 2)

  # Display the selected fairness measure
  .showFairnessMetric(options, jaspResults, fairnessMeasureContainer, positionInContainer = 1)

  # Display the theoretical information of the selected fairness measure
  .showWorkflowExplanationText(options, jaspResults, fairnessMeasureContainer, positionInContainer = 2)

  # --- PLOTS

  .jfaFigureNumberInit(jaspResults) # Initialize figure numbers

  # Display the decision-making workflow plot
  .jfaworkflowPlot(options, jaspResults, fairnessMeasureContainer, positionInContainer = 3)
}

.jfaFairnessMeasureStage <- function(options, jaspResults, position) {
  fairnessContainer <- createJaspContainer(title = gettext("<u>Obtaining a Fairness Measure</u>"))
  fairnessContainer$position <- position
  fairnessContainer$dependOn(options = c("firstquestion", "secondquestion", "thirdquestion", "fourthquestion_caseA", "fourthquestion_caseB", "fourthquestion_casec"))
  jaspResults[["fairnessMeasureContainer"]] <- fairnessContainer
  return(fairnessContainer)
}

.jfaFairnessProcedure <- function(options, jaspResults, position) {
  if (options[["explanatoryText"]] && is.null(jaspResults[["FairnessProcedureContainer"]])) {
    FairnessProcedureContainer <- createJaspContainer(title = gettext("<u>Introduction</u>"))
    FairnessProcedureContainer$position <- position
    procedureText <- gettextf("The goal of this procedure is to determine to what extent the predictions of an algorithm are fair towards protected groups on a sensitive attribute. Fairness -ore discrimination- can be quantified using so-called fairness measures. There are various fairness measures, and different measures can lead to different conclusions about fairness. Therefore, selecting the most appropriate fairness measure for the context at hand is crucial. The decision-making workflow allows for determining the most suitable fairness measure by answering the necessary questions.")
    FairnessProcedureContainer[["FairnessProcedureParagraph"]] <- createJaspHtml(procedureText, "p")
    FairnessProcedureContainer[["FairnessProcedureParagraph"]]$position <- 1
    FairnessProcedureContainer$dependOn(options = c("explanatoryText"))
    jaspResults[["FairnessProcedureContainer"]] <- FairnessProcedureContainer
  }
}

.determineFairnessMetric <- function(options, jaspResults, fairnessMeasureContainer, positionInContainer) {
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
  jaspResults[["state"]]$dependOn(options = c("firstquestion", "secondquestion", "thirdquestion", "fourthquestion_caseA", "fourthquestion_caseB", "fourthquestion_casec"))
  return(metric)
}

.determineWorkflowExplanationText <- function(options, metric, fairnessMeasureContainer, positionInContainer, jaspResults) {
  name <- metric$name
  if (!options[["explanatoryText"]]) {
    explanationText <- ""
  } else {
    if (name == "Disparate Impact") {
      explanationText <- gettextf("
      <u>Fairness Definition:</u>
    The algorithm is fair if its use results in the same ratio of items from two different groups experiencing a change in the status quo (i.e., being classified as positive).
    The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts.

    <u>Formula:</u>
    Disparate impact is obtained by dividing the positive rate of the unprivileged group by that of the privileged group. The positive rate is equal to (TP+FP)/N, where TP denotes true positives (items correctly classified as positive), FP denotes false positives (items incorrectly classified as positive), and N represents the total number of items classified by the AI.

    <u>Further Details:</u>
    The most common use of disparate impact is linked to the U.S. Equal Employment Opportunity Commission (EEOC) guidelines, particularly the 80%% rule. According to this rule, if disparate impact is higher than 0.80, there is no discrimination.
    This method has limitations, as the threshold value is not based on the measure's properties, data characteristics, or statistical considerations. Originally derived from U.S. employment hiring rates, the rule lacks theoretical rigor for broader applications.
      ")
    } else if (name == "Equalized Odds") {
      explanationText <- gettext("<u>Fairness Definition:</u>
      The algorithm is fair if its use results in the same number of items from different groups experiencing correct and incorrect changes in the status quo (i.e, being, correctly and incorrectly, classified as positive).
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts.

       <u>Formula:</u>
      Equalized odds combines the true positive rate (TPR) and the false positive rate (FPR). The TPR is calculated as TP/(TP+FP) and the FPR as FP/(TN+FP), applied to both privileged and unprivileged groups. Here, TP denotes true positives (correctly classified positive items), TN denotes true negatives (correctly classified negative items), and FP denotes false positives (incorrectly classified positive items).

      <u>Further Details: :</u>
   It is important to note that this is the only measure in the decision-making workflow that addresses both the correct classification of the positive class and the incorrect classification of the negative class.")
    } else if (name == "Predictive Rate Parity") {
      explanationText <- gettext(" <u>Fairness Definition:</u>
      The algorithm is fair if its use results in the same number of items from different groups experiencing correct changes in the status quo (i.e., being correctly classified as positive).
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts.

      <u>Formula:</u>
      Predictive rate parity is based on precision, calculated as TP/(TP+FP), applied to both the privileged and unprivileged groups. Here, TP denotes true positives (correctly classified positive items) and FP denotes false positives (incorrectly classified positive items).")
    } else if (name == "Equal Opportunity") {
      explanationText <- gettext("<u>Fairness Definition:</u>
      The algorithm is fair if its use results in the same number of items from different groups experiencing correct changes in the status quo (i.e., being correctly classified as positive).
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts.

      <u>Formula:</u>
      Equal opportunity is based on the true positive rate, calculated as TP/(TP+FN), applied to both privileged and unprivileged groups. Here, TP denotes true positives (correctly classified positive items) and FN denotes false negatives (incorrectly classified negative items).")
    } else if (name == "Specificity Parity") {
      explanationText <- gettext("<u>Fairness Definition:</u>
      The algorithm is fair if its use results in the same number of items from different groups correctly experiencing no changes in the status quo (i.e., being correctly classified as negative).
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts.

      <u>Formula:</u>
      Specificity parity is based on the true negative rate, calculated as TN/(TN+FP), applied to both privileged and unprivileged groups. Here, TN denotes true negatives (correctly classified negative items) and FP denotes false positives (incorrectly classified positive items).")
    } else if (name == "Negative Predictive Value Parity") {
      explanationText <- gettext("<u>Fairness Definition:</u>
      The algorithm is fair if its use results in the same number of items from different groups correctly experiencing no changes in the status quo (i.e., being correctly classified as negative).
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts.

      <u>Formula:</u>
      Negative predictive value parity is based on the negative predictive value, calculated as TN/(TN+FN), applied to both privileged and unprivileged groups. Here, TN denotes true negatives (correctly classified negative items) and FN denotes false negatives (incorrectly classified negative items).")
    } else if (name == "Accuracy Parity") {
      explanationText <- gettextf("<u>Fairness Definition:</u>
      The algorithm is fair if its use results in the same number of items from different groups correctly experiencing changes and correctly experiencing no changes in the status quo (i.e., being correctly classified as positive and being correctly classified as negative).
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts.

      <u>Formula:</u>
      Accuracy parity is based on accuracy, calculated as (TP+TN)/N, applied to both privileged and unprivileged groups. Here, TP denotes true positives (correctly classified positive items), TN denotes true negatives (correctly classified negative items), and N represents the total number of items classified by the AI. The sum of TP and TN reflects the total number of correct classifications made by the AI.

      <u>Further Details:</u>
      Accuracy parity, like accuracy as a model evaluation metric, has a major flaw when applied to cases where the positive class is a small minority. For example, if 3%% of the privileged group and 6%% of the unprivileged group commit fraud, accuracy may seem high overall (96.7%%), but masks disparities, with the unprivileged group having lower accuracy (94%) compared to the privileged group (97%%). Unlike other measures, accuracy parity does not consider varying error costs. It fails to detect increases in false negatives or false positives, missing the associated rise in costs.")
    } else if (name == "False Positive Rate Parity") {
      explanationText <- gettext("<u>Fairness Definition:</u>
      The algorithm is fair if its use results in the same number of items from different groups experiencing incorrect changes in the status quo (i.e., being incorrectly classified as positive).
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts.

      <u>Formula:</u>
      False positive rate parity is based on the false positive rate, calculated as FP/(TN+FP), applied to both privileged and unprivileged groups. Here, FP denotes false positives (incorrectly classified positive items), and TN denotes true negatives (correctly classified negative items).")
    } else if (name == "False Negative Rate Parity") {
      explanationText <- gettext("<u>Fairness Definition:</u>
      The algorithm is fair if its use results in the same number of items from different groups incorrectly experiencing no changes in the status quo (i.e., being incorrectly classified as negative).
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts.

      <u>Formula:</u>
      False negative rate parity is based on the false negative rate, calculated as FN/(TP+FN), applied to both privileged and unprivileged groups. Here, FN denotes false negatives (incorrectly classified negative items), and TP denotes true positives (correctly classified positive items).")
    }
  }
  return(explanationText)
}

.jfaworkflowPlot <- function(options, jaspResults, positionInContainer, fairnessMeasureContainer) {
  if (!options[["workflowfigure"]]) {
    return()
  }

  .jfaFigureNumberUpdate(jaspResults)

  if (is.null(fairnessMeasureContainer[["workflowfigure"]])) {
    plot <- createJaspPlot(title = gettext("<u>Graphical Representation of the Decision-Making Workflow</u>"), width = 800, height = 800)
    plot$position <- positionInContainer
    plot$dependOn(options = c("workflowfigure", "firstquestion", "secondquestion", "thirdquestion", "fourthquestion_caseA", "fourthquestion_caseB", "fourthquestion_caseC"))
    fairnessMeasureContainer[["workflowfigure"]] <- plot
    result <- .determineFairnessMetric(options, jaspResults, positionInContainer, fairnessMeasureContainer)
    plot$plotObject <- plot(result)
  }

  if (options[["explanatoryText"]]) {
    caption <- createJaspHtml(gettextf("<b>Figure %1$i.</b> Graphical representation of the decision-making workflow obtained after answering the questions. The label “FP” indicates “False Positives” and the label “FN indicates “False Negatives”. The white rectangles indicate the followed path based on the answers provided to the necessary questions of the workflow, the gray rectangles represent the ignored path.", jaspResults[["figNumber"]]$object), "p")
    caption$position <- positionInContainer + 1
    caption$dependOn(optionsFromObject = fairnessMeasureContainer[["workflowfigure"]])
    fairnessMeasureContainer[["workflowfigureText"]] <- caption
  }
}

.showFairnessMetric <- function(options, jaspResults, positionInContainer, fairnessMeasureContainer) {
  if (!is.null(fairnessMeasureContainer[["selectedFairnessMeatric"]])) {
    return()
  }

  state <- .determineFairnessMetric(options, jaspResults, positionInContainer, fairnessMeasureContainer)

  htmlText <- createJaspHtml(gettextf("The most suitable fairness measure is %1$s.", state[["name"]]))

  htmlText$position <- positionInContainer

  htmlText$dependOn(options = c("firstquestion", "secondquestion", "thirdquestion", "fourthquestion_caseA", "fourthquestion_caseB", "fourthquestion_caseC"))

  fairnessMeasureContainer[["selectedFairnessMetric"]] <- htmlText
}

.showWorkflowExplanationText <- function(options, jaspResults, positionInContainer, fairnessMeasureContainer) {
  if (!is.null(fairnessMeasureContainer[["selectedExplanationText"]])) {
    return()
  }
  state <- .determineFairnessMetric(options, jaspResults, positionInContainer, fairnessMeasureContainer)

  details <- .determineWorkflowExplanationText(options, state, positionInContainer, fairnessMeasureContainer, jaspResults)

  if (!options[["explanatoryText"]]) {
    return()
  } else {
    htmlText <- createJaspHtml(details)

    htmlText$position <- positionInContainer

    htmlText$dependOn(options = c("firstquestion", "secondquestion", "thirdquestion", "fourthquestion_caseA", "fourthquestion_caseB", "fourthquestion_caseC", "explanatoryText"))

    fairnessMeasureContainer[["selectedExplanationText"]] <- htmlText
  }
}
