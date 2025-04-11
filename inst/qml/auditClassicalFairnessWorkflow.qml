
// Copyright (C) 2013-2018 University of Amsterdam
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.
//

// When making changes to this file always mention @koenderks as a
// reviewer in the Pull Request

import QtQuick
import QtQuick.Layouts
import JASP
import JASP.Controls

import "./common" as Common
import "./common/fairness" as Fairness

Form 
{
	columns: 1
	info:								qsTr("The fairness measures analysis enables the user to assess fairness and discrimination regarding specific groups in the data in algorithmic decision-making systems. Considering a certain positive class in the data, fairness -or discrimination- can be quantified using model-agnostic fairness metrics. There are various fairness measures, and different measures can lead to different conclusions about fairness. Therefore, selecting the most appropriate fairness measure for the context at hand is crucial. The decision-making workflow allows for determining the most suitable fairness measure by answering the necessary questions.")

	// Hidden option(s)
	CheckBox { name: "workflow"; checked: true; visible: false }

	Section
	{
		id:								selectionStage
		title: 							selectionStage.expanded ? qsTr("<b>1. Selection</b>") : qsTr("1. Selection")
		columns:						1
		expanded:						!evaluationChecked.checked

		RadioButtonGroup
		{
			id:							firstquestion
			name:						"firstquestion"
			title:						qsTr("Is the ground thruth information relevant in your context?")
			info:						qsTr("In this question, it must be specified whether the ground truth information (i.e., the target to be predicted) is relevant or not for the analysis context. In the context of item classification, the term ground truth information refers to the true classification of items, obtained from reliable sources or domain experts.")
			enabled:					!evaluationChecked.checked
	
			RadioButton
			{
				text: 					qsTr("Yes")
				name: 					"firstquestion_yes"
				info:					qsTr("This option is selected if it is useful to know whether the classification is done correctly or not.")
			}

			RadioButton
			{
				text: 					qsTr("No")
				name: 					"firstquestion_no"
				checked:				true
				info:					qsTr("This option is selected if the interest is in the algorithm predicted classification only.")
			}
		}

		RadioButtonGroup
		{
			id:							secondquestion
			name:						"secondquestion"
			title:						qsTr("In which type of classification are you interested?")
			visible:					firstquestion.value == "firstquestion_yes"
			info:						qsTr("In this question, it must be specified whether the focus is on correct classifications, incorrect classifications, or both. The focus is on the items' correct classification when evaluating the reliability of the audit process in accurately identifying situations that conform to established rules and procedures. The focus is on the items' incorrect classification when addressing potential anomalies or irregularities, or when identifying areas for improvement within the audit process. ")
			enabled:					!evaluationChecked.checked

			RadioButton
			{
				text: 					qsTr("Correct classification")
				name: 					"secondquestion_correct"
				info:					qsTr("This option is selected if the interest is in the algorithm's correct classifications of items.")
			}

			RadioButton
			{
				text: 					qsTr("Incorrect classification")
				name: 					"secondquestion_incorrect"
				info:					qsTr("This option is selected if the interest is in the algorithm's incorrect classifications of items.")
			}

			RadioButton
			{
				text: 					qsTr("Both")
				name: 					"secondquestion_both"
				checked:				true
				info:					qsTr("This option is selected if the interest is in both the algorithm's correct and incorrect classifications of items.")
			}
		}

		RadioButtonGroup
		{
			id:							thirdquestion
			name:						"thirdquestion"
			title:						qsTr("What is more important?")
			visible:					secondquestion.value == "secondquestion_correct" & firstquestion.value == "firstquestion_yes"
			info:						qsTr("In this question, it must be specified whether the focus is on correctly classifying items into the positive class, the negative class, or both.")
			enabled:					!evaluationChecked.checked

			RadioButton
			{
				text: 					qsTr("Correctly classifying the positive class")
				name: 					"thirdquestion_positive"
				info:					qsTr("This option is selected if the interest is on correctly classifying items into the positive class.")
			}

			RadioButton
			{
				text: 					qsTr("Correctly classifying the negative class")
				name: 					"thirdquestion_negative"
				checked:				true
				info:					qsTr("This option is selected if the interest is on correctly classifying items into the negative class.")
			}

			RadioButton
			{
				text: 					qsTr("Both")
				name: 					"thirdquestion_both"
				checked:				true
				info:					qsTr("This option is selected if the interest is on correctly classifying items into both the positive and the negative class.")
			}
		}

		RadioButtonGroup
		{
			id:							fourthquestion_caseA
			name:						"fourthquestion_caseA"
			title:						qsTr("What are the most costly errors?")
			visible:					thirdquestion.value == "thirdquestion_positive" & secondquestion.value == "secondquestion_correct" & firstquestion.value == "firstquestion_yes"
			info:						qsTr("In this question, it must be specified which classification errors (incorrect classification of items in the positive class or incorrect classification of items in the negative class) result in the greatest losses (economic, social, etc.).")
			enabled:					!evaluationChecked.checked

			RadioButton
			{
				text: 					qsTr("False positives")
				name: 					"fourthquestion_caseA_FP"
				checked:				true
				info:					qsTr("This option is selected if false positives (incorrectly classifying an item in the positive class when it belongs to the negative class) result in greater losses.")
			}

			RadioButton
			{
				text: 					qsTr("False negatives")
				name: 					"fourthquestion_caseA_FN"
				info:					qsTr("This option is selected if false negatives (incorrectly classifying an item in the negative class when it belongs to the positive class) result in greater losses.")
			}
		}

		RadioButtonGroup
		{
			id:							fourthquestion_caseB
			name:						"fourthquestion_caseB"
			title:						qsTr("What are the most costly errors?")
			visible:					thirdquestion.value == "thirdquestion_negative" & secondquestion.value == "secondquestion_correct" & firstquestion.value == "firstquestion_yes"
			enabled:					!evaluationChecked.checked

			RadioButton
			{
				text: 					qsTr("False positives")
				name: 					"fourthquestion_caseB_FP"
				checked:				true
			}

			RadioButton
			{
				text: 					qsTr("False negatives")
				name: 					"fourthquestion_caseB_FN"
			}
		}

		RadioButtonGroup
		{
			id:							fourthquestion_caseC
			name:						"fourthquestion_caseC"
			title:						qsTr("What are the most costly errors?")
			visible:					secondquestion.value == "secondquestion_incorrect" & firstquestion.value == "firstquestion_yes"
			enabled:					!evaluationChecked.checked

			RadioButton
			{
				text: 					qsTr("False positives")
				name: 					"fourthquestion_caseC_FP"
				checked:				true
			}

			RadioButton
			{
				text: 					qsTr("False negatives")
				name: 					"fourthquestion_caseC_FN"
			}
		}

		Common.ExplanatoryText { }

		Section
		{
			title:						qsTr("Report")

			Group
			{
				title: 					qsTr("Plots")
				info:					qsTr("Add additional figures about the evaluation to the report.")

				CheckBox
				{
					text: 				qsTr("Decision-making workflow")
					name: 				"workflowPlot"
					info:				qsTr("Produces a figure showing the resulting path through the decision-making workflow.")
				}	
			}
		}

		Item
		{
			Layout.preferredHeight: 	toEvaluation.height
			Layout.fillWidth: 			true
			Layout.columnSpan:			1

			Button
			{
				anchors.right:	 		toEvaluation.left
				anchors.rightMargin:	jaspTheme.generalAnchorMargin
				text:					qsTr("<b>Download Report</b>")
				onClicked: 				form.exportResults()
			}

			CheckBox
			{
				id: 					evaluationChecked
				name: 					"evaluationChecked"
				anchors.right:			toEvaluation.left
				width:					0
				visible: 				false
				checked: 				false
			}

			Button
			{
				id: 					toEvaluation
				anchors.right:			parent.right
				text: 					qsTr("<b>To Evaluation</b>")
				enabled: 				!evaluationChecked.checked
				onClicked:				evaluationChecked.checked = true
			}
		}
	}

	Section
	{
		id:								evaluationStage
		title: 							evaluationStage.expanded ? qsTr("<b>2. Evaluation</b>") : qsTr("2. Evaluation")
		columns:						1
		enabled: 						evaluationChecked.checked
		expanded: 						evaluationChecked.checked
		
		Fairness.FairnessVariablesList { }
		Fairness.ConfidenceLevel { }
		Fairness.Levels { }
		Fairness.Hypotheses { }
		Fairness.BayesFactorType { }

		Section
		{
			title: qsTr("Report")
			Fairness.FairnessOutput { }
		}

		Section
		{
			title: qsTr("Advanced")
			debug: true
			Fairness.PriorDistribution { }
		}

		Common.DownloadReport { }
	}
}
