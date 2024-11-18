
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
import JASP.Widgets

import "./common" as Common
import "./common/planning" as Planning

Form 
{

	columns:1

	Section
	{
		title: qsTr("Selecting a Group Fairness Measure")
		columns:1
		expanded: true 

		RadioButtonGroup
	{
		id: firstquestion
		name: "firstquestion"
		title:qsTr("Is the information on the true values of the classification relevant in your context?")
		

		
		Group{
		columns:2

		RadioButton
		{
			text: 						qsTr("Yes")
			name: 						"firstquestion_yes"
		}

		HelpButton
		{
			toolTip: 	qsTr("Click to learn more about the ground thruth information")
			helpPage:					"Audit/groundtruthinformation"
		}

		}

		RadioButton
		{
			text: 						qsTr("No")
			name: 						"firstquestion_no"
			checked:					true
		}

	
	}

	RadioButtonGroup
	{
		id: secondquestion
		name: "secondquestion"
		title:qsTr("In what type of classification are you interested in")
		// enabled: false, diventa grigio
		visible: firstquestion.value == "firstquestion_yes"

		Group{

		columns:2

		RadioButton
		{
			text: 						qsTr("Correct")
			name: 						"secondquestion_correct"
		}

		HelpButton
		{
			toolTip: 	qsTr("Click to learn more about the correct classification")
			helpPage:					"Audit/correctclassification"
		}

		}

		Group{	

		columns:2

		RadioButton
		{
			text: 						qsTr("Incorrect")
			name: 						"secondquestion_incorrect"
		}

		HelpButton
		{
			toolTip: 	qsTr("Click to learn more about the incorrect classification")
			helpPage:					"Audit/incorrectclassification"
		}

		}

		RadioButton
		{
			text: 						qsTr("Both")
			name: 						"secondquestion_both"
			checked:					true
		}
	}

	RadioButtonGroup
	{
		id: thirdquestion
		name: "thirdquestion"
		title:qsTr("What Is More Important: a Correct Classification of the Positive Class or a Correct Classification of the Negative Class?")
		visible: secondquestion.value == "secondquestion_correct" & firstquestion.value == "firstquestion_yes"

			RadioButton
		{
			text: 						qsTr("The correct classification in the positive class")
			name: 						"thirdquestion_positive"
		}

			RadioButton
		{
			text: 						qsTr("The correct classification in the negative class")
			name: 						"thirdquestion_negative"
			checked:					true
		}

	}

	RadioButtonGroup
	{
		id: fourthquestion_caseA
		name: "fourthquestion_caseA"
		title:qsTr("What are the errors with the highest cost?")
		visible: thirdquestion.value == "thirdquestion_enp" & secondquestion.value == "secondquestion_correct" & firstquestion.value == "firstquestion_yes"

		RadioButton
		{
			text: 						qsTr("False Positive")
			name: 						"fourthquestion_caseA_FP"
			checked:					true
		}

		RadioButton
		{
			text: 						qsTr("False Negative")
			name: 						"fourthquestion_caseA_FN"
		}
	}

	RadioButtonGroup
	{
		id: fourthquestion_caseB
		name: "fourthquestion_caseB"
		title:qsTr("What are the errors with the highest cost?")
		visible: thirdquestion.value == "thirdquestion_wd" & secondquestion.value == "secondquestion_correct" & firstquestion.value == "firstquestion_yes"

		RadioButton
		{
			text: 						qsTr("False Positive")
			name: 						"fourthquestion_caseB_FP"
			checked:					true
		}

		RadioButton
		{
			text: 						qsTr("False Negative")
			name: 						"fourthquestion_caseB_FN"
		}

		RadioButton
		{
			text: 						qsTr("I do not have a preference")
			name: 						"fourthquestion_caseB_NOPREFERENCE"
		}
	}
	RadioButtonGroup
	{
		id: fourthquestion_caseC
		name: "fourthquestion_caseC"
		title:qsTr("What are the errors with the highest cost?")
		visible: secondquestion.value == "secondquestion_incorrect" & firstquestion.value == "firstquestion_yes"

		RadioButton
		{
			text: 						qsTr("False Positive")
			name: 						"fourthquestion_caseC_FP"
			checked:					true
		}

		RadioButton
		{
			text: 						qsTr("False Negative")
			name: 						"fourthquestion_caseC_FN"
		}
	}



	}

	Section
	{
		title:qsTr("Additional Options")
		columns:1

	
	Group
	{
		title: 							qsTr("Display")
		info:							qsTr("Specify options that have an effect on the look and feel of the audit report.")

		Row
		{
			CheckBox
			{
				id: 					explanatoryText
				text: 					qsTr("Fairness measure explanatory text")
				name: 					"explanatoryText"
				checked: 				true
				info:					qsTr("When checked, enables explanatory text in the analysis to help interpret the procedure and the statistical results.")
			}

			HelpButton
			{
				helpPage:				"Audit/ExplanatorytextFairnessDecisionWorkflow"
				toolTip: 				qsTr("Show explanatory text for the selected fairness measure")
			}
		}

		CheckBox
			{
				id: 					workflowfigure
				text: 					qsTr("Decision-Making Workflow Plot")
				name: 					"workflowfigure"
				checked: 				true
				info:					qsTr("When checked, enables the representation of the decision-making workflow that is obtained after answering all the question within it.")
			}

	}

	}

	Section
	{
		title:qsTr("Fairness Measure Calculation")
		columns:1
		info:								qsTr("The fairness measures analysis enables the user to assess fairness and discrimination against specific groups in AI-predicted classification.")

	VariablesForm
	{
		preferredHeight:				jaspTheme.smallDefaultVariablesFormHeight

		AvailableVariablesList
		{
			name: 						"variablesFormFairness"
		}
		AssignedVariablesList
		{
			name: 						"target"
			title: 						qsTr("Target")
			singleVariable:				true
			allowedColumns:				["nominal"]
			minLevels:					2
			info:						qsTr("In this column, the target (i.e., to be predicted) variable should be entered.")
		}
		AssignedVariablesList
		{
			name: 						"predictions"
			title: 						qsTr("Predictions")
			singleVariable:				true
			allowedColumns:				["nominal"]
			minLevels:					2
			info:						qsTr("In this column, the predictions of the algorithm should be entered.")
		}
		AssignedVariablesList
		{
			name: 						"protected"
			title: 						qsTr("Sensitive Attribute")
			singleVariable:				true
			allowedColumns:				["nominal"]
			minLevels:					2
			info:						qsTr("In this column, the protected (i.e., sensitive) attribute should be entered.")
		}
	}

	Group 
	{
		title:							qsTr("Factor Levels")
		info:							qsTr("These options allow specification of the privileged group and the positive class.")

		DropDown
		{
			label: 						qsTr("Privileged group")
			name: 						"privileged"
			indexDefaultValue: 			0
			addEmptyValue: 				true
			placeholderText: 			qsTr("None")
			source: 					[ { name: "protected", use: "levels" } ]
			info:						qsTr("The privileged group refers to the class in the protected variable that historically or systematically experiences certain advantages, benefits, or privileges.")
		}

		DropDown
		{
			label: 						qsTr("Positive class")
			name: 						"positive"
			indexDefaultValue: 			0
			addEmptyValue: 				true
			placeholderText: 			qsTr("None")
			source: 					[ { name: "target", use: "levels" } ]
			info:						qsTr("The positive class in the target variable.")
		}
	}

	Group
	{
		title: 							qsTr("Display")
		info:							qsTr("Specify options that have an effect on the look and feel of the audit report.")

		Row
		{
			CheckBox
			{
				id: 					analysisexplanatoryText
				text: 					qsTr("Analysis explanatory text")
				name: 					"analysisexplanatoryText"
				checked: 				true
				info:					qsTr("When checked, enables explanatory text in the analysis to help interpret the procedure and the statistical results.")
			}

			HelpButton
			{
				helpPage:				"Audit/explanatoryText"
				toolTip: 				qsTr("Show explanatory text at each step of the analysis")
			}
		}
	}

	}

	Section
	{
		title: 							qsTr("Report")
		columns: 						1

		Group
		{
			title: 						qsTr("Tables")
			info:						qsTr("Add additional tables about the evaluation to the report.")

			CheckBox
			{
				text:					qsTr("Individual comparisons")
				name:					"comparisonsTable"
				info:					qsTr("Produces a table comparing the unprivileged groups against the privileged group.")
				checked:				true
			}

			CheckBox
			{
				text:					qsTr("Model performance")
				name:					"performanceTable"
				info:					qsTr("Produces a table containing the performance measures for the classification, including support, accuracy, precision, recall and F1-score.")
			}

			CheckBox
			{
				text:					qsTr("Confusion matrix")
				name:					"confusionTable"
				info:					qsTr("Produces the confusion matrix for each group.")
				checked:				true

				CheckBox {
					text:				qsTr("Display proportions")
					name:				"confusionTableProportions"
					info:				qsTr("Displays proportions in the confusion table.")
				}
			}
		}



	}

	
}



