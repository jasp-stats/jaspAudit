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
   
   # Display the selected fairness measure
  .showFairnessMetric(options, jaspResults)

  # Display the theoretical information of the selected fairness measure
  .showExplanationText(options, jaspResults)

  .jfaFigureNumberInit(jaspResults) # Initialize figure numbers

  # Display the decision-making workflow plot
  .jfaPlot(options, jaspResults, positionInContainer = 3)

}

.determineFairnessMetric <- function(options, jaspResults)
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

.determineExplanationText <- function(options, metric){

   name <- metric$name
   if(!options[["explanatoryText"]]){
    ExplanationText <- gettext("NOT requested.")
  }else {
   if(name == "Disparate Impact"){
      ExplanationText <- gettext("Fairness Definition: 
    AI is considered fair if it produces the same ratio of positive predictions for both privileged and unprivileged groups. In other words, AI fairness is achieved when the same ratio of items from these two groups experience a change from the status quo. This change in status quo can refer to favorable outcomes, such as being selected for a job interview or receiving reimbursement for medical expenses. However, it can also represent negative outcomes, such as being deemed high risk for reoffending within two years of release or defaulting on a bank loan. 
    The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
    The term positive prediction refers to one of the two possible predictions the AI can make: positive or negative. This is because we are working within the framework of binary classification, where there are only two possible classes for items to be categorized: positive or negative.

    Fairness Measure Formula:
    Disparate Impact is based on the Positive Rate. Therefore, the Positive Rate, whose formula is (TP+FP)/N, is applied to both the privileged group and the unprivileged group. 
    TP indicates the number of True Positives, meaning the number of items with a true positive classification that the AI also classifies as positive, and FP indicates the number of False Positives, meaning the number of items with a true negative classification that the AI classifies as positive. N indicates the total number of items classified by AI. Then, the Positive Rate of the privileged group is divided by the Positive Rate of the unprivileged group (PP_privileged/PP_unprivileged). After calculating this ratio, Disparate Impact is obtained.
    
    Further Details:
    The most common use of Disparate Impact is tied to the U.S. Equal Employment Opportunity Commission (EEOC) guidelines. Specifically, the EEOC established the 80% rule. Based on this rule, unlike other fairness measures, this one uses a fixed threshold, equal to 0.80, that is neither 0 nor 1 and does not involve statistical testing to assess AI fairness. Instead, the auditor directly compares the ratio of the positive rates between the two groups to the threshold value, where the positive rate is the model evaluation metric on which Disparate Impact is based. In fact, when the value of the Disparate Impact is higher than 0.80, the use of AI is fair. 
    This deterministic approach is chosen because the measure is applied across the entire dataset, which usually has a large enough size that makes statistical significance less of a concern. However, this method has its limitations. The threshold value is not grounded in the properties of the measure, the nature of the data, or any other statistical considerations. The rule was originally based on the hiring rates in the U.S. employment context, which lacks theoretical rigor for broader applications. Additionally, when the ratio is close to the threshold, such as 0.79 or 0.81, drawing definitive conclusions about discrimination becomes uncertain.")
   }else if(name == "Equalized Odds"){
      ExplanationText <- gettext("Fairness Definition: 
      AI is considered fair if it provides the same amount of correct and incorrect positive predictions for both privileged and unprivileged groups. In other words, AI fairness is achieved when the same number of items from these two groups experience correct and incorrect changes from the status quo. This change in status quo can refer to favorable outcomes, such as being selected for a job interview or receiving reimbursement for medical expenses. However, it can also represent negative outcomes, such as being deemed high risk for reoffending within two years of release or defaulting on a bank loan. 
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
      The term positive predictions refers to one of the two possible predictions the AI can make: positive or negative. This is because we are working within the framework of binary classification, where there are only two possible classes for items to be categorized: positive or negative.
      
      Fairness Measure Formula:
      Equalized Odds is based on a combination of the True Positive Rate and the False Positive Rate. Therefore, both the True Positive Rate, whose formula is TP/(TP+FP), and the False Positive Rate, whose formula is FP/(TN+FP), are applied to both the privileged group and the unprivileged group. 
      TP indicates the number of True Positives, meaning the number of items with a true positive classification that the AI also classifies as positive, TN indicates the number of True Negatives, meaning the number of items with a true negative classification that the AI also classifies as negative, and FP indicates the number of False Positives, meaning the number of items with a true negative classification that the AI classifies as positive.
      
      Further Details:
      It is important to note that this is the only measure that focuses on both the correct classification of the positive class and the incorrect classification of the negative class. Its formula considers how many observations known to be true positives were correctly identified and classified by the AI, and among all observations known to be true negatives, how many were incorrectly identified and classified by the AI. For this reason, it is completely different from all other fairness measures.")
   }else if(name == "Predictive Rate Parity"){
      ExplanationText <- gettext("Fairness Definition: 
      AI is considered fair if it provides the same amount of correct positive predictions for both privileged and unprivileged groups. In other words, AI fairness is achieved when the same number of items from these two groups correctly experience changes from the status quo. This change in status quo can refer to favorable outcomes, such as being selected for a job interview or receiving reimbursement for medical expenses. However, it can also represent negative outcomes, such as being deemed high risk for reoffending within two years of release or defaulting on a bank loan. 
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
      The term positive predictions refers to one of the two possible predictions the AI can make: positive or negative. This is because we are working within the framework of binary classification, where there are only two possible classes for items to be categorized: positive or negative.
              
      Fairness Measure Formula:
      The Predictive Rate Parity is based on the Precision. Therefore, the Precision, whose formula is TP/(TP+FP), is applied to both the privileged group and the unprivileged group. 
      TP indicates the number of True Positives, meaning the number of items with a true positive classification that AI also classifies as positive, and FP indicates the number of False Positives, meaning the number of items with a true negative classification that AI classifies as positive.")
   }else if (name == "Equal Opportunity"){
      ExplanationText <- gettext("Fairness Definition: 
      AI is considered fair if it provides the same amount of correct positive predictions for both privileged and unprivileged groups. In other words, AI fairness is achieved when the same number of items from these two groups correctly experience  changes from the status quo. This change in status quo can refer to favorable outcomes, such as being selected for a job interview or receiving reimbursement for medical expenses. However, it can also represent negative outcomes, such as being deemed high risk for reoffending within two years of release or defaulting on a bank loan. 
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
      The term positive predictions refers to one of the two possible predictions the AI can make: positive or negative. This is because we are working within the framework of binary classification, where there are only two possible classes for items to be categorized: positive or negative.
               
      Fairness Measure Formula:
      Equal Opportunity is based on the True Positive Rate. Therefore, the True Positive Rate, whose formula is TP/(TP+FN), is applied to both the privileged group and the unprivileged group. 
      TP indicates the number of True Positives, meaning the number of items with a true positive classification that AI also classifies as positive, and FN indicates the number of False Negatives, meaning the number of items with a true positive classification that AI classifies as negative.")
   }else if (name =="Specificity Parity"){
      ExplanationText <- gettext("Fairness Definition: 
      AI is considered fair if it provides the same amount of correct negative predictions for both privileged and unprivileged groups. In other words, AI fairness is achieved when the same number of items from these two groups correctly experience  no changes from the status quo. This change in status quo can refer to favorable outcomes, such as being selected for a job interview or receiving reimbursement for medical expenses. However, it can also represent negative outcomes, such as being deemed high risk for reoffending within two years of release or defaulting on a bank loan. 
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
      The term negative predictions refers to one of the two possible predictions the AI can make: positive or negative. This is because we are working within the framework of binary classification, where there are only two possible classes for items to be categorized: positive or negative.
                
      Fairness Measure Formula:
      The Specificity Parity is based on the True Negative Rate. Therefore, the True Negative Rate, whose formula is TN/(TN+FP), is applied to both the privileged group and the unprivileged group. 
      FP indicates the number of False Positives, meaning the number of items with a true negative classification that AI classifies as positive, and TN indicates the number of True Negatives, meaning the number of items with a true negative classification that AI also classifies as negative.")
   }else if (name =="Negative Predictive Value Parity") {
      ExplanationText <- gettext("Fairness Definition: 
      AI is considered fair if it provides the same amount of correct negative predictions for both privileged and unprivileged groups. In other words, AI fairness is achieved when the same number of items from these two groups correctly experience no changes from the status quo. This change in status quo can refer to favorable outcomes, such as being selected for a job interview or receiving reimbursement for medical expenses. However, it can also represent negative outcomes, such as being deemed high risk for reoffending within two years of release or defaulting on a bank loan. 
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
      The term negative predictions refers to one of the two possible predictions the AI can make: positive or negative. This is because we are working within the framework of binary classification, where there are only two possible classes for items to be categorized: positive or negative.
                   
      Fairness Measure Formula:
      The Negative Predictive Value Parity is based on the Negative Predictive Value. Therefore, the Negative Predictive Values, whose formula is TN/(TN+FN), is applied to both the privileged group and the unprivileged group. 
      FN indicates the number of False Negatives, meaning the number of items with a true positive classification that the AI classifies as negative, and TN indicates the number of True Negatives, meaning the number of items with a true negative classification that AI also classifies as negative.")
   }else if(name =="Accuracy Parity"){
      ExplanationText <- gettext("Fairness Definition: 
      AI is considered fair if it provides the same amount of correct positive and correct negative predictions for both privileged and unprivileged groups. In other words, AI fairness is achieved when the same number of items from these two groups correctly experience changes and no changes from the status quo. This change in status quo can refer to favorable outcomes, such as being selected for a job interview or receiving reimbursement for medical expenses. However, it can also represent negative outcomes, such as being deemed high risk for reoffending within two years of release or defaulting on a bank loan. 
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
      We refer to positive and negative predictions because, in the framework of binary classification, where there are only two possible classes for items to be categorized: positive or negative.
                    
      Fairness Measure Formula:
      The Accuracy Parity is based on Accuracy. Therefore, the Accuracy, whose formula is (TP+TN)/N, is applied to both the privileged group and the unprivileged group. 
      TP indicates the number of True Positives, meaning the number of items with a true positive classification that the AI also classifies as positive, and TN indicates the number of True Negatives, meaning the number of items with a true negative classification that the AI also classifies as negative. The sum of TP and TN is therefore the total number of correct classifications made by the AI. N indicates the total number of items classified by AI.
                    
      Further Details:
      Accuracy Parity has, just like Accuracy as a model evaluation metric, a sever deficit when applied to cases were the positive class consists of just a small minority. Consider a scenario where 3% of the privileged group (90% of the population) commits fraud, compared to 6% of the unprivileged group (10% of the population). Without applying a fraud detection AI, the overall accuracy seems high at 96.7%, but this masks a disparity: accuracy for the unprivileged group is lower at 94%, while for the privileged group it is 97%.
      It should be noted that, unlike all other measures, Accuracy Parity does not account for varying error costs related to misclassifications. If there is an increase in false negatives, false positives, or both, and there are associated costs that need to be minimized, Accuracy Parity will fail to detect these increases in errors, and as a result, it will not capture the associated rise in costs.")
   }else if(name =="False Positive Rate Parity") {
      ExplanationText <- gettext("Fairness Definition: 
      AI is considered fair if it provides the same amount of incorrect positive predictions for both privileged and unprivileged groups. In other words, AI fairness is achieved when the same number of items from these two groups incorrectly experience changes from the status quo. This change in status quo can refer to favorable outcomes, such as being selected for a job interview or receiving reimbursement for medical expenses. However, it can also represent negative outcomes, such as being deemed high risk for reoffending within two years of release or defaulting on a bank loan. 
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
      The term positive predictions refers to one of the two possible predictions the AI can make: positive or negative. This is because we are working within the framework of binary classification, where there are only two possible classes for items to be categorized: positive or negative.
              
      Fairness Measure Formula:
      The False Positive Rate Parity is based on the False Positive Rate. Therefore, the False Positive Rate, whose formula is FP/(TN+FP), is applied to both the privileged group and the unprivileged group. 
      FP indicates the number of False Positives, meaning the number of items with a true negative classification that AI classifies as positive, and TN indicates the number of True Negatives, meaning the number of items with a true negative classification that AI also classifies as negative. ")
   }else if(name =="False Negative Rate Parity"){
       ExplanationText <- gettext("Fairness Definition: 
      AI is considered fair if it provides the same amount of incorrect negative predictions for both privileged and unprivileged groups. In other words, AI fairness is achieved when the same number of items from these two groups incorrectly experience no changes from the status quo. This change in status quo can refer to favorable outcomes, such as being selected for a job interview or receiving reimbursement for medical expenses. However, it can also represent negative outcomes, such as being deemed high risk for reoffending within two years of release or defaulting on a bank loan. 
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
      The term negative predictions refers to one of the two possible predictions the AI can make: positive or negative. This is because we are working within the framework of binary classification, where there are only two possible classes for items to be categorized: positive or negative.
              
      Fairness Measure Formula:
      The False Negative Rate Parity is based on the False Negative Rate. Therefore, the False Negative Rate, whose formula is FN/(TP+FN), is applied to both the privileged group and the unprivileged group. 
      FN indicates the number of False Negatives, meaning the number of items with a true positive classification that the AI classifies as negative, and TP indicates the number of True Positives, meaning the number of items with a true positive classification that the AI also classifies as positive.")
   }
   }

  return(ExplanationText) 
}

.jfaPlot <- function(options, jaspResults, positionInContainer) {
  if (!options[["workflowfigure"]]) {
    return()
  }

  .jfaFigureNumberUpdate(jaspResults)

  if (is.null(jaspResults[["workflowfigure"]])) {
    plot <- createJaspPlot(title = gettext("Parity Estimates Plot"), width = 800, height = 800)
    plot$position <- positionInContainer
    plot$dependOn(options = c("workflowfigure"))
    jaspResults[["workflowfigure"]] <- plot
    result <- .determineFairnessMetric(options, jaspResults)
    plot$plotObject <- plot(result)
  }

  if (options[["explanatoryText"]]) {
    caption <- createJaspHtml(gettextf("<b>Figure %1$i.</b> Graphical representation of the decision-making workflow obtained after answering the questions. The label “FP” indicates “False Positives” and the label “FN indicates “False Negatives”.", jaspResults[["figNumber"]]$object), "p")
    caption$position <- positionInContainer + 1
    caption$dependOn(optionsFromObject = jaspResults[["workflowfigure"]])
    jaspResults[["workflowfigureText"]] <- caption
  }
}

.showFairnessMetric <- function(options, jaspResults)
{

  if(!is.null(jaspResults[["selectedFairnessMeatric"]])){
    return()
  }

  state <- .determineFairnessMetric(options, jaspResults)
  htmlText <- createJaspHtml(gettextf("The selected Fairness Metric is %1$s", state[["name"]]))

  htmlText$dependOn(options = c("firstquestion", "secondquestion", "thirdquestion", "fourthquestion_caseA", "fourthquestion_caseB", "fourthquestion_caseC"))

  htmlText$position <- 2

  jaspResults[["selectedFairnessMetric"]] <- htmlText
}

.showExplanationText <- function(options, jaspResults)
{

  if(!is.null(jaspResults[["selectedExplanationText"]])){
    return()
  }

   state <- .determineFairnessMetric(options, jaspResults)
  details <- .determineExplanationText(options, state)
  htmlText <- createJaspHtml(gettextf("Details regarding the fairness measure %1$s", details))

  htmlText$dependOn(options = c("firstquestion", "secondquestion", "thirdquestion", "fourthquestion_caseA", "fourthquestion_caseB", "fourthquestion_caseC", "explanatoryText"))

  htmlText$position <- 3

  jaspResults[["selectedExplanationText"]] <- htmlText
}
