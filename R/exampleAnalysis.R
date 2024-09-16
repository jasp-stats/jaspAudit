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

exampleAnalysis <- function(jaspResults, dataset, options, ...) {

  .showFairnessMetric(options, jaspResults)

  .showExplanationText(options, jaspResults)

}

.determineFairnessMetric <- function(options)
{
  if(options[["firstquestion"]]=="firstquestion_no"){
    metric <- gettext("Disparate Impact")
  }
  else {
     if(options[["secondquestion"]]=="secondquestion_both"){
      metric <- gettext("Equalized Odds")
     }
     else {
        if(options[["secondquestion"]]=="secondquestion_correct"){
          if(options[["thirdquestion"]]=="thirdquestion_enp"){
            if(options[["fourthquestion_caseA"]]=="fourthquestion_caseA_FP"){
              metric <- gettext("Predictive Rate Parity")
            }
            else {
               metric <- gettext("Equal Opportunity")
            }
          }
          else {
             if (options[["fourthquestion_caseB"]]=="fourthquestion_caseB_FP") {
                metric <- gettext("Specificity Parity")
             }
             else {
                if (options[["fourthquestion_caseB"]]=="fourthquestion_caseB_FN") {
                   metric <- gettext("Negative Predictive Value Parity")
                }
                else {
                    metric <- gettext("Accuracy Parity")
                }
             }
          }
        }
        else {
           if(options[["fourthquestion_caseC"]]=="fourthquestion_caseC_FP"){
              metric <- gettext("False Positive Rate Parity")
           }
           else {
              metric <- gettext("False Negative Rate Parity")
           }
        }
     }
  }
  return(metric) 
}

.determineExplanationText <- function(options){

   if(!options[["explanatoryText"]]){
    ExplanationText <- gettext("NOT requested.")
  }
  else {
   if(options[["firstquestion"]]=="firstquestion_no"){
    ExplanationText <- gettext("Fairness Definition: 
    AI is considered fair if it produces the same ratio of positive predictions for both privileged and unprivileged groups. In other words, AI fairness is achieved when the same ratio of items from these two groups experience a change from the status quo. This change in status quo can refer to favorable outcomes, such as being selected for a job interview or receiving reimbursement for medical expenses. However, it can also represent negative outcomes, such as being deemed high risk for reoffending within two years of release or defaulting on a bank loan. 
    The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
    The term positive prediction refers to one of the two possible predictions the AI can make: positive or negative. This is because we are working within the framework of binary classification, where there are only two possible classes for items to be categorized: positive or negative.

    Fairness Measure Formula:
    Disparate Impact is based on the Positive Rate. Therefore, the Positive Rate, whose formula is (TP+FP)/N, is applied to both the privileged group and the unprivileged group. 
    TP indicates the number of True Positives, meaning the number of items with a true positive classification that the AI also classifies as positive, and FP indicates the number of False Positives, meaning the number of items with a true negative classification that the AI classifies as positive. N indicates the total number of items classified by AI. Then, the Positive Rate of the privileged group is divided by the Positive Rate of the unprivileged group (PP_privileged/PP_unprivileged). After calculating this ratio, Disparate Impact is obtained.
    
    Further Details:
    DETAILS")
  }
  else {
     if(options[["secondquestion"]]=="secondquestion_both"){
      ExplanationText <- gettext("Fairness Definition: 
      AI is considered fair if it provides the same amount of correct and incorrect positive predictions for both privileged and unprivileged groups. In other words, AI fairness is achieved when the same number of items from these two groups experience correct and incorrect changes from the status quo. This change in status quo can refer to favorable outcomes, such as being selected for a job interview or receiving reimbursement for medical expenses. However, it can also represent negative outcomes, such as being deemed high risk for reoffending within two years of release or defaulting on a bank loan. 
      The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
      The term positive predictions refers to one of the two possible predictions the AI can make: positive or negative. This is because we are working within the framework of binary classification, where there are only two possible classes for items to be categorized: positive or negative.
      
      Fairness Measure Formula:
      Equalized Odds is based on a combination of the True Positive Rate and the False Positive Rate. Therefore, both the True Positive Rate, whose formula is TP/(TP+FP), and the False Positive Rate, whose formula is FP/(TN+FP), are applied to both the privileged group and the unprivileged group. 
      TP indicates the number of True Positives, meaning the number of items with a true positive classification that the AI also classifies as positive, TN indicates the number of True Negatives, meaning the number of items with a true negative classification that the AI also classifies as negative, and FP indicates the number of False Positives, meaning the number of items with a true negative classification that the AI classifies as positive.
      
      Further Details:
      DETAILS")
     }

     else {
        if(options[["secondquestion"]]=="secondquestion_correct"){
          if(options[["thirdquestion"]]=="thirdquestion_enp"){
            if(options[["fourthquestion_caseA"]]=="fourthquestion_caseA_FP"){
              ExplanationText <- gettext("Fairness Definition: 
              AI is considered fair if it provides the same amount of correct positive predictions for both privileged and unprivileged groups. In other words, AI fairness is achieved when the same number of items from these two groups correctly experience changes from the status quo. This change in status quo can refer to favorable outcomes, such as being selected for a job interview or receiving reimbursement for medical expenses. However, it can also represent negative outcomes, such as being deemed high risk for reoffending within two years of release or defaulting on a bank loan. 
              The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
              The term positive predictions refers to one of the two possible predictions the AI can make: positive or negative. This is because we are working within the framework of binary classification, where there are only two possible classes for items to be categorized: positive or negative.
              
              Fairness Measure Formula:
              The Predictive Rate Parity is based on the Precision. Therefore, the Precision, whose formula is TP/(TP+FP), is applied to both the privileged group and the unprivileged group. 
              TP indicates the number of True Positives, meaning the number of items with a true positive classification that AI also classifies as positive, and FP indicates the number of False Positives, meaning the number of items with a true negative classification that AI classifies as positive.
              
              Further Details:
              DETAILS")
            }
            else {
               ExplanationText <- gettext("Fairness Definition: 
               AI is considered fair if it provides the same amount of correct positive predictions for both privileged and unprivileged groups. In other words, AI fairness is achieved when the same number of items from these two groups correctly experience  changes from the status quo. This change in status quo can refer to favorable outcomes, such as being selected for a job interview or receiving reimbursement for medical expenses. However, it can also represent negative outcomes, such as being deemed high risk for reoffending within two years of release or defaulting on a bank loan. 
               The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
               The term positive predictions refers to one of the two possible predictions the AI can make: positive or negative. This is because we are working within the framework of binary classification, where there are only two possible classes for items to be categorized: positive or negative.
               
               Fairness Measure Formula:
               Equal Opportunity is based on the True Positive Rate. Therefore, the True Positive Rate, whose formula is TP/(TP+FN), is applied to both the privileged group and the unprivileged group. 
               TP indicates the number of True Positives, meaning the number of items with a true positive classification that AI also classifies as positive, and FN indicates the number of False Negatives, meaning the number of items with a true positive classification that AI classifies as negative.
               
               Further Details:
               DETAILS")
            }
          }
          else {
             if (options[["fourthquestion_caseB"]]=="fourthquestion_caseB_FP") {
                ExplanationText <- gettext("Fairness Definition: 
                AI is considered fair if it provides the same amount of correct negative predictions for both privileged and unprivileged groups. In other words, AI fairness is achieved when the same number of items from these two groups correctly experience  no changes from the status quo. This change in status quo can refer to favorable outcomes, such as being selected for a job interview or receiving reimbursement for medical expenses. However, it can also represent negative outcomes, such as being deemed high risk for reoffending within two years of release or defaulting on a bank loan. 
                The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
                The term negative predictions refers to one of the two possible predictions the AI can make: positive or negative. This is because we are working within the framework of binary classification, where there are only two possible classes for items to be categorized: positive or negative.
                
                Fairness Measure Formula:
                The Specificity Parity is based on the True Negative Rate. Therefore, the True Negative Rate, whose formula is TN/(TN+FP), is applied to both the privileged group and the unprivileged group. 
                FP indicates the number of False Positives, meaning the number of items with a true negative classification that AI classifies as positive, and TN indicates the number of True Negatives, meaning the number of items with a true negative classification that AI also classifies as negative.
                
                Further Details:
                DETAILS")
             }
             else {
                if (options[["fourthquestion_caseB"]]=="fourthquestion_caseB_FN") {
                   ExplanationText <- gettext("Fairness Definition: 
                   AI is considered fair if it provides the same amount of correct negative predictions for both privileged and unprivileged groups. In other words, AI fairness is achieved when the same number of items from these two groups correctly experience no changes from the status quo. This change in status quo can refer to favorable outcomes, such as being selected for a job interview or receiving reimbursement for medical expenses. However, it can also represent negative outcomes, such as being deemed high risk for reoffending within two years of release or defaulting on a bank loan. 
                   The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
                   The term negative predictions refers to one of the two possible predictions the AI can make: positive or negative. This is because we are working within the framework of binary classification, where there are only two possible classes for items to be categorized: positive or negative.
                   
                   Fairness Measure Formula:
                   The Negative Predictive Rate Parity is based on the Negative Predictive Rate. Therefore, the Negative Predictive Rate, whose formula is TN/(TN+FN), is applied to both the privileged group and the unprivileged group. 
                   FN indicates the number of False Negatives, meaning the number of items with a true positive classification that the AI classifies as negative, and TN indicates the number of True Negatives, meaning the number of items with a true negative classification that AI also classifies as negative.
                   
                   Further Details:
                   DETAILS")
                }
                else {
                    ExplanationText <- gettext("Fairness Definition: 
                    AI is considered fair if it provides the same amount of correct positive and correct negative predictions for both privileged and unprivileged groups. In other words, AI fairness is achieved when the same number of items from these two groups correctly experience changes and no changes from the status quo. This change in status quo can refer to favorable outcomes, such as being selected for a job interview or receiving reimbursement for medical expenses. However, it can also represent negative outcomes, such as being deemed high risk for reoffending within two years of release or defaulting on a bank loan. 
                    The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
                    We refer to positive and negative predictions because, in the framework of binary classification, where there are only two possible classes for items to be categorized: positive or negative.
                    
                    Fairness Measure Formula:
                    The Accuracy Parity is based on Accuracy. Therefore, the Accuracy, whose formula is (TP+TN)/N, is applied to both the privileged group and the unprivileged group. 
                    TP indicates the number of True Positives, meaning the number of items with a true positive classification that the AI also classifies as positive, and TN indicates the number of True Negatives, meaning the number of items with a true negative classification that the AI also classifies as negative. The sum of TP and TN is therefore the total number of correct classifications made by the AI. N indicates the total number of items classified by AI.
                    
                    Further Details:
                    DETAILS")
                }
             }
          }
        }
        else {
           if(options[["fourthquestion_caseC"]]=="fourthquestion_caseC_FP"){
              ExplanationText <- gettext("Fairness Definition: 
              AI is considered fair if it provides the same amount of incorrect positive predictions for both privileged and unprivileged groups. In other words, AI fairness is achieved when the same number of items from these two groups incorrectly experience changes from the status quo. This change in status quo can refer to favorable outcomes, such as being selected for a job interview or receiving reimbursement for medical expenses. However, it can also represent negative outcomes, such as being deemed high risk for reoffending within two years of release or defaulting on a bank loan. 
              The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
              The term positive predictions refers to one of the two possible predictions the AI can make: positive or negative. This is because we are working within the framework of binary classification, where there are only two possible classes for items to be categorized: positive or negative.
              
              Fairness Measure Formula:
              The False Positive Rate Parity is based on the False Positive Rate. Therefore, the False Positive Rate, whose formula is FP/(TN+FP), is applied to both the privileged group and the unprivileged group. 
              FP indicates the number of False Positives, meaning the number of items with a true negative classification that AI classifies as positive, and TN indicates the number of True Negatives, meaning the number of items with a true negative classification that AI also classifies as negative. 
              
              Further Details:
              DETAILS")
           }
           else {
              ExplanationText <- gettext("Fairness Definition: 
              AI is considered fair if it provides the same amount of incorrect negative predictions for both privileged and unprivileged groups. In other words, AI fairness is achieved when the same number of items from these two groups incorrectly experience no changes from the status quo. This change in status quo can refer to favorable outcomes, such as being selected for a job interview or receiving reimbursement for medical expenses. However, it can also represent negative outcomes, such as being deemed high risk for reoffending within two years of release or defaulting on a bank loan. 
              The term items refers to what is being classified; these items can be people, like job applicants, or objects, such as bank accounts. 
              The term negative predictions refers to one of the two possible predictions the AI can make: positive or negative. This is because we are working within the framework of binary classification, where there are only two possible classes for items to be categorized: positive or negative.
              
              Fairness Measure Formula:
             The False Negative Rate Parity is based on the False Negative Rate. Therefore, the False Negative Rate, whose formula is FN/(TP+FN), is applied to both the privileged group and the unprivileged group. 
             FN indicates the number of False Negatives, meaning the number of items with a true positive classification that the AI classifies as negative, and TP indicates the number of True Positives, meaning the number of items with a true positive classification that the AI also classifies as positive.
             
             Further Details:
             DETAILS")
           }
        }
     }
  }
  }
  return(ExplanationText) 
}

.showFairnessMetric <- function(options, jaspResults)
{

  if(!is.null(jaspResults[["selectedFairnessMeatric"]])){
    return()
  }

  metricname <- .determineFairnessMetric(options)
  htmlText <- createJaspHtml(gettextf("The selected Fairness Metric is %1$s", metricname))

  htmlText$dependOn(options = c("firstquestion", "secondquestion", "thirdquestion", "fourthquestion_caseA", "fourthquestion_caseB", "fourthquestion_caseC"))

  htmlText$position <- 2

  jaspResults[["selectedFairnessMetric"]] <- htmlText
}

.showExplanationText <- function(options, jaspResults)
{

  if(!is.null(jaspResults[["selectedExplanationText"]])){
    return()
  }

  details <- .determineExplanationText(options)
  htmlText <- createJaspHtml(gettextf("Details regarding the fairness measure 

  %1$s", details))

  htmlText$dependOn(options = c("firstquestion", "secondquestion", "thirdquestion", "fourthquestion_caseA", "fourthquestion_caseB", "fourthquestion_caseC", "explanatoryText"))

  htmlText$position <- 3

  jaspResults[["selectedExplanationText"]] <- htmlText
}
