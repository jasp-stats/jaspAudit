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

  .jfaFairnessProcedure(options, jaspResults, position = 1)
   
  fairnessContainer <- .jfaFairnessStage(options, jaspResults, position = 1)

   # Display the selected fairness measure
  .showFairnessMetric(options, jaspResults, fairnessContainer, positionInContainer = 2)

  # Display the theoretical information of the selected fairness measure
  .showExplanationText(options, jaspResults, fairnessContainer, positionInContainer = 3)

  .jfaFigureNumberInit(jaspResults) # Initialize figure numbers

  # Display the decision-making workflow plot
  .jfaPlot(options, jaspResults, fairnessContainer, positionInContainer = 4)

}

.jfaFairnessStage <- function(options, jaspResults, position) {
  title <- gettext("<u>Obtaining a Fairness Measure</u>")
  container <- createJaspContainer(title = title)
  container$position <- position
  container$dependOn(options = c("firstquestion", "secondquestion", "thirdquestion", "fourthquestion_caseA", "fourthquestion_caseB", "fourthquestion_casec"))
  jaspResults[["fairnessContainer"]] <- container
  return(container)
}

.jfaFairnessProcedure <- function(options, jaspResults, position) {
  if (options[["explanatoryText"]] && is.null(jaspResults[["procedureContainer"]])) {
    procedureContainer <- createJaspContainer(title = gettext("<u>Introduction</u>"))
    procedureContainer$position <- position
    procedureText <- gettextf("The goal of this procedure is to determine to what extent the predictions of an algorithm are fair towards protected groups on a sensitive attribute. Fairness -ore discrimination- can be quantified using so-called fairness measures. There are various fairness measures, and different measures can lead to different conclusions about fairness. Therefore, selecting the most appropriate fairness measure for the context at hand is crucial. The decision-making workflow allows for determining the most suitable fairness measure by answering the necessary questions.")
    procedureContainer[["procedureParagraph"]] <- createJaspHtml(procedureText, "p")
    procedureContainer[["procedureParagraph"]]$position <- 1
    procedureContainer$dependOn(options = c("explanatoryText"))
    jaspResults[["procedureContainer"]] <- procedureContainer
  }
}

.determineFairnessMetric <- function(options, jaspResults, fairnessContainer, positionInContainer)
{

   if (!is.null(jaspResults[["state"]])) {
      return(jaspResults[["state"]]$object)
   }

   metric <- name <- q1 <- q2 <- q3 <- q4 <- NULL

   if(options[["firstquestion"]]=="firstquestion_no"){
   q1 <- 2
   }else{
    q1 <- 1
    if(options[["secondquestion"]]=="secondquestion_both"){
    q2 <- 3
   }else if (options[["secondquestion"]]=="secondquestion_incorrect") {
    q2 <- 2 
    if(options[["fourthquestion_caseC"]]=="fourthquestion_caseC_FP"){
      q4 <- 1
    }else if (options[["fourthquestion_caseC"]]=="fourthquestion_caseC_FN"){
      q4 <- 2
    }
   }else if (options[["secondquestion"]]=="secondquestion_correct") {
    q2 <- 1
    if(options[["thirdquestion"]]=="thirdquestion_both") {
      q3 <- 3
    }else if(options[["thirdquestion"]]=="thirdquestion_positive"){
      q3 <- 1
      if(options[["fourthquestion_caseA"]]=="fourthquestion_caseA_FP"){
        q4 <- 1 
      }else if (options[["fourthquestion_caseA"]]=="fourthquestion_caseA_FN") {
         q4 <- 2
      }
    }else if(options[["thirdquestion"]]=="thirdquestion_negative"){
      q3 <- 2 
      if(options[["fourthquestion_caseB"]]=="fourthquestion_caseB_FP"){
        q4 <- 1
      }else if(options[["fourthquestion_caseB"]]=="fourthquestion_caseB_FN"){
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

.determineExplanationText <- function(options, metric, fairnessContainer, positionInContainer){

   name <- metric$name
   if(!options[["explanatoryText"]]){
    ExplanationText <- gettext(" ")
  }else {
   if(name == "Disparate Impact"){
      ExplanationText <- gettext("
      <u>Fairness Definition:</u> 
    The AI system is fair if its use results in the same ratio of items from two different groups experiencing a change in the status quo (i.e., being classified as Positive).
    The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 

    <u>Formula:</u>
    Disparate Impact is obtained by dividing the Positive Rate of the unprivileged group by that of the privileged group. The Positive Rate is equal to (TP+FP)/N, where TP denotes True Positives (items correctly classified as positive), FP denotes False Positives (items incorrectly classified as positive), and N represents the total number of items classified by the AI.
    
    <u>Further Details:</u>
    The most common use of Disparate Impact is linked to the U.S. Equal Employment Opportunity Commission (EEOC) guidelines, particularly the 80% rule. According to this rule, if Disparate Impact is higher than 0.80, there is no discrimination.
    This method has limitations, as the threshold value is not based on the measure's properties, data characteristics, or statistical considerations. Originally derived from U.S. employment hiring rates, the rule lacks theoretical rigor for broader applications.
      ")
   }else if(name == "Equalized Odds"){
      ExplanationText <- gettext("<u>Fairness Definition:</u> 
      The AI system is fair if its use results in the same number of items from different groups experiencing correct and incorrect changes in the status quo (i.e, being, correctly and incorrectly, classified as Positive).
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
      
       <u>Formula:</u>
      Equalized Odds combines the True Positive Rate (TPR) and the False Positive Rate (FPR). The TPR is calculated as TP/(TP+FP) and the FPR as FP/(TN+FP), applied to both privileged and unprivileged groups. Here, TP denotes True Positives (correctly classified positive items), TN denotes True Negatives (correctly classified negative items), and FP denotes False Positives (incorrectly classified positive items).
      
      <u>Further Details: :</u>
   It is important to note that this is the only measure in the decision-making workflow that addresses both the correct classification of the positive class and the incorrect classification of the negative class.")
   }else if(name == "Predictive Rate Parity"){
      ExplanationText <- gettext(" <u>Fairness Definition:</u> 
      The AI system is fair if its use results in the same number of items from different groups experiencing correct changes in the status quo (i.e., being correctly classified as Positive).
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
              
      <u>Formula:</u> 
      Predictive Rate Parity is based on Precision, calculated as TP/(TP+FP), applied to both the privileged and unprivileged groups. Here, TP denotes True Positives (correctly classified positive items) and FP denotes False Positives (incorrectly classified positive items).")
   }else if (name == "Equal Opportunity"){
      ExplanationText <- gettext("<u>Fairness Definition:</u>
      The AI system is fair if its use results in the same number of items from different groups experiencing correct changes in the status quo (i.e., being correctly classified as Positive).
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
        
      <u>Formula:</u>
      Equal Opportunity is based on the True Positive Rate, calculated as TP/(TP+FN), applied to both privileged and unprivileged groups. Here, TP denotes True Positives (correctly classified positive items) and FN denotes False Negatives (incorrectly classified negative items).")
   }else if (name =="Specificity Parity"){
      ExplanationText <- gettext("<u>Fairness Definition:</u>
      The AI system is fair if its use results in the same number of items from different groups correctly experiencing no changes in the status quo (i.e., being correctly classified as Negative).
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
      
      <u>Formula:</u>
      Specificity Parity is based on the True Negative Rate, calculated as TN/(TN+FP), applied to both privileged and unprivileged groups. Here, TN denotes True Negatives (correctly classified negative items) and FP denotes False Positives (incorrectly classified positive items).") 
      }else if (name =="Negative Predictive Value Parity") {
      ExplanationText <- gettext("<u>Fairness Definition:</u>
      The AI system is fair if its use results in the same number of items from different groups correctly experiencing no changes in the status quo (i.e., being correctly classified as Negative).
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
      
      <u>Formula:</u>
      Negative Predictive Value Parity is based on the Negative Predictive Value, calculated as TN/(TN+FN), applied to both privileged and unprivileged groups. Here, TN denotes True Negatives (correctly classified negative items) and FN denotes False Negatives (incorrectly classified negative items).")
   }else if(name =="Accuracy Parity"){
      ExplanationText <- gettext("<u>Fairness Definition:</u>
      The AI system is fair if its use results in the same number of items from different groups correctly experiencing changes and correctly experiencing no changes in the status quo (i.e., being correctly classified as Positive and being correctly classified as Negative).
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
      
      <u>Formula:</u>
      Accuracy Parity is based on Accuracy, calculated as (TP+TN)/N, applied to both privileged and unprivileged groups. Here, TP denotes True Positives (correctly classified positive items), TN denotes True Negatives (correctly classified negative items), and N represents the total number of items classified by the AI. The sum of TP and TN reflects the total number of correct classifications made by the AI.
                    
      <u>Further Details:</u>
      Accuracy Parity, like Accuracy as a model evaluation metric, has a major flaw when applied to cases where the positive class is a small minority. For example, if 3% of the privileged group and 6% of the unprivileged group commit fraud, accuracy may seem high overall (96.7%), but masks disparities, with the unprivileged group having lower accuracy (94%) compared to the privileged group (97%). Unlike other measures, Accuracy Parity does not consider varying error costs. It fails to detect increases in false negatives or false positives, missing the associated rise in costs.")
   }else if(name =="False Positive Rate Parity") {
      ExplanationText <- gettext("<u>Fairness Definition:</u>
      The AI system is fair if its use results in the same number of items from different groups experiencing incorrect changes in the status quo (i.e., being incorrectly classified as Positive).
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
      
      <u>Formula:</u>
      False Positive Rate Parity is based on the False Positive Rate, calculated as FP/(TN+FP), applied to both privileged and unprivileged groups. Here, FP denotes False Positives (incorrectly classified positive items), and TN denotes True Negatives (correctly classified negative items).")
   }else if(name =="False Negative Rate Parity"){
       ExplanationText <- gettext("<u>Fairness Definition:</u>
      The AI system is fair if its use results in the same number of items from different groups incorrectly experiencing no changes in the status quo (i.e., being incorrectly classified as Negative).
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
      
      <u>Formula:</u>
      False Negative Rate Parity is based on the False Negative Rate, calculated as FN/(TP+FN), applied to both privileged and unprivileged groups. Here, FN denotes False Negatives (incorrectly classified negative items), and TP denotes True Positives (correctly classified positive items).")
   }
   }

  return(ExplanationText) 
}

.jfaPlot <- function(options, jaspResults, positionInContainer, metric, fairnessContainer) {
  if (!options[["workflowfigure"]]) {
    return()
  }

  .jfaFigureNumberUpdate(jaspResults)

  if (is.null(jaspResults[["workflowfigure"]])) {
    plot <- createJaspPlot(title = gettext("<u>Graphical Representation of the Decision-Making Workflow</u>"), width = 800, height = 800)
    plot$position <- positionInContainer
    plot$dependOn(options = c("workflowfigure", "firstquestion", "secondquestion", "thirdquestion", "fourthquestion_caseA", "fourthquestion_caseB", "fourthquestion_caseC"))
    jaspResults[["workflowfigure"]] <- plot
    result <- .determineFairnessMetric(options, jaspResults, positionInContainer, fairnessContainer)
    plot$plotObject <- plot(result)
  }

  if (options[["explanatoryText"]]) {
    caption <- createJaspHtml(gettextf("<b>Figure %1$i.</b> Graphical representation of the decision-making workflow obtained after answering the questions. The label “FP” indicates “False Positives” and the label “FN indicates “False Negatives”. The white rectangles indicate the followed path based on the answers provided to the necessary questions of the workflow, the gray rectangles represent the ignored path.", jaspResults[["figNumber"]]$object), "p")
    caption$position <- positionInContainer + 1
    caption$dependOn(optionsFromObject = jaspResults[["workflowfigure"]])
    caption$dependOn(options = c("explanatoryText"))
    jaspResults[["workflowfigureText"]] <- caption
  }
}

.showFairnessMetric <- function(options, jaspResults, positionInContainer, fairnessContainer)
{

  if(!is.null(jaspResults[["selectedFairnessMeatric"]])){
    return()
  }

  state <- .determineFairnessMetric(options, jaspResults, positionInContainer, fairnessContainer )

  htmlText <- createJaspHtml(gettextf("<h2><b><u><small>Obtaining a Fairness Measure Tailored to the Context</small></u></b></h2>
  
  The most suitable fairness measure is %1$s", state[["name"]]))

  htmlText$dependOn(options = c("firstquestion", "secondquestion", "thirdquestion", "fourthquestion_caseA", "fourthquestion_caseB", "fourthquestion_caseC"))

  htmlText$position <- positionInContainer


  jaspResults[["selectedFairnessMetric"]] <- htmlText
}

.showExplanationText <- function(options, jaspResults, positionInContainer, fairnessContainer)
{

  if(!is.null(jaspResults[["selectedExplanationText"]])){
    return()
  }

  state <- .determineFairnessMetric(options, jaspResults, positionInContainer, fairnessContainer)
  details <- .determineExplanationText(options, state, positionInContainer, fairnessContainer)
  if(!options[["explanatoryText"]]){
    return()
  }else{
  htmlText <- createJaspHtml(gettextf("<h2><b><u><small>Theoretical Details and Formulas of Fairness Measures</small></u></b></h2>
   %1$s
   
   <h2><b><u><small>Conclusion</small></u></b></h2>
   After identifying the most appropriate fairness measure (<i>%2$s</i>) for the context through the decision-making workflow, it is essential to calculate its values using the available data in order to assess the fairness—or discrimination—of the AI.", details, state[["name"]]))
  htmlText$dependOn(options = c("firstquestion", "secondquestion", "thirdquestion", "fourthquestion_caseA", "fourthquestion_caseB", "fourthquestion_caseC", "explanatoryText"))
  htmlText$position <- positionInContainer
  jaspResults[["selectedExplanationText"]] <- htmlText
  }
}
