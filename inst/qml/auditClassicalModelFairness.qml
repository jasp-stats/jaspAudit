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

import "./common"	as Common

Form 
{
	columns: 1

	VariablesForm
	{
		preferredHeight:		jaspTheme.smallDefaultVariablesFormHeight

		AvailableVariablesList
		{
			name: 				"variablesFormFairness"
		}
		AssignedVariablesList
		{
			id: 				actual
			name: 				"target"
			title: 				qsTr("Target")
			singleVariable:		true
			allowedColumns:		["nominal", "nominalText"]
		}
		AssignedVariablesList
		{
			id: 				predicted
			name: 				"predictions"
			title: 				qsTr("Predictions")
			singleVariable:		true
			allowedColumns:		["nominal", "nominalText"]
		}
		AssignedVariablesList
		{
			id: 				group
			name: 				"protected"
			title: 				qsTr("Sensitive Attribute")
			singleVariable:		true
			allowedColumns:		["nominal", "nominalText"]
		}
	}

	Group 
	{

	CIField
	{
		name: 					"conf_level"
		label: 					qsTr("Confidence")
		info:					qsTr("The confidence level used. The confidence level is the complement of the audit risk: the risk that the user is willing to take to give an incorrect judgment about the population. For example, if you want to use an audit risk of 5%, this equals 95% confidence.")
	}

	DropDown
	{
		id:						metric
		label: 					qsTr("Fairness metric")
		name: 					"metric"
		indexDefaultValue: 		0
		values: [
			{ label: qsTr("Predictive rate parity"),			value: "prp"},
			{ label: qsTr("Demographic parity"),				value: "dp"},
			{ label: qsTr("Proportional parity"),				value: "pp"},
			{ label: qsTr("Accuracy parity"),					value: "ap"},
			{ label: qsTr("False negative rate parity"),		value: "fnrp"},
			{ label: qsTr("False positive rate parity"),		value: "fprp"},
			{ label: qsTr("True positive rate parity"),			value: "tprp"},
			{ label: qsTr("Negative predicted value parity"),	value: "npvp"},
			{ label: qsTr("Specificity parity"), 				value: "sp"}
		]
	}

	DropDown
	{
		label: 					qsTr("Privileged group")
		name: 					"privileged"
		indexDefaultValue: 		0
		addEmptyValue: 			true
		placeholderText: 		qsTr("None")
		source: 				[ {name: "protected", use: "levels"} ]
	}

	DropDown
	{
		label: 					qsTr("Positive class")
		name: 					"positive"
		indexDefaultValue: 		0
		addEmptyValue: 			true
		placeholderText: 		qsTr("None")
		source: 				[ {name: "target", use: "levels"} ]
	}
	}

	Section
	{
		title: 					qsTr("Report")
		columns: 				2

		Group
		{
			title: 				qsTr("Tables")

			CheckBox
			{
				text:			qsTr("Model performance")
				name:			"performanceTable"
			}
		}

		Group
		{
			title: 				qsTr("Plots")

			CheckBox
			{
				text:			qsTr("Parity")
				name:			"parityPlot"
			}

			CheckBox
			{
				text:			qsTr("Prior and posterior distribution")
				name:			"posteriorPlot"
				enabled:		metric.value != "dp"
			}
		}
	}


// Section
//  {
//   columns: 1 
//   title: qsTr("Fairness Measures")
    
//   Group
//   {
//     HelpButton
//   	{
//   		toolTip:			qsTr("Click to learn more about Q1.")
//   		helpPage:			"auditFairness"
//   		Layout.columnSpan:	1
//   	}
  	
//     RadioButtonGroup
//     {
//     name: "q1"
//     id: "q1"
//     title: qsTr("Should the ground truth labels be considered?")
//     RadioButton{id:"q1option1"; label: qsTr("Yes"); name:"q1option1"; value:"yes";  checked: true}
//     RadioButton{id:"q1option2"; label: qsTr("No"); value:"no"}
//     }
//    }
  
//   Group
//   {
  
//     HelpButton
//   	{
//   		toolTip:			qsTr("Click to learn more about Q2.")
//   		helpPage:			"auditQ2Helper"
//   		Layout.columnSpan:	1
//   	}

//     RadioButtonGroup
//     {
//     name: "q2"
//     id: "q2"
//     title: q1option1.checked ? qsTr("Should all elements of the confusion matrix be considered?") : qsTr("Should the absolute values or the proportions of the favorable predictions be used?")
//     RadioButton{id:"q2option1"; label: q1option1.checked ? qsTr("Yes"): qsTr("Absolute"); name:"q2option1"; value:q1option1.checked ? "yes": "abs";  checked: true}
//     RadioButton{id:"q2option2"; label: q1option1.checked ? qsTr("No"): qsTr("Proportional"); name:"q2option2"; value:q1option1.checked ? "no": "prop";  checked: true}
//     }
//    }
   
//   Group
//   {
//     id: "g3"
//     visible: (q1option1.checked && q2option2.value == "no" && q2option2.checked) ? true: false
//     HelpButton
//   	{
//   		toolTip:			qsTr("Click to learn more about Q3.")
//   		helpPage:			"auditQ2Helper"
//   		Layout.columnSpan:	1
//   	}

//     RadioButtonGroup
//     {
//     name: "q3"
//     id: "q3"
//     title: qsTr("Should we focus on correctly or incorrectly classified instances?")
//     RadioButton{id:"q3option1"; label: qsTr("Correctly"); name:"q3option1"; value:(g3.visible) ? "corr": "";  checked: true}
//     RadioButton{id:"q3option2"; label: qsTr("Incorrectly"); name:"q3option2"; value:(g3.visible) ? "incorr": "";  checked: true}
//     }
//    }
   
//   Group
//   {
//     visible: (g3.visible) ? true: false
//     HelpButton
//   	{
//   		toolTip:			qsTr("Click to learn more about Q4.")
//   		helpPage:			"auditQ2Helper"
//   		Layout.columnSpan:	1
//   	}

//     RadioButtonGroup
//     {
//     name: "q4"
//     id: "q4"
//     title: q3option1.checked ? qsTr("Should we focus on true positive or true negative rates?") : qsTr("Should we focus on false positive or false negative rates?")
//     RadioButton{id:"q4option1"; label: q3option1.checked ? qsTr("True Positives"): qsTr("False Positives"); name:"q3option1"; value: (g3.visible) ? q3option1.checked ? "tp" : "fp": ""; checked: true}
//     RadioButton{id:"q4option2"; label: q3option1.checked ? qsTr("True Negatives"): qsTr("False Negatives"); name:"q3option2"; value: (g3.visible) ? q3option1.checked ? "tn" : "fn": "";  checked: true}
//     }
//    }
    
//   }

	Common.DownloadReport { }
}
