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
	columns: 							1

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
			allowedColumns:				["nominal", "nominalText"]
			info:						qsTr("")
		}
		AssignedVariablesList
		{
			name: 						"predictions"
			title: 						qsTr("Predictions")
			singleVariable:				true
			allowedColumns:				["nominal", "nominalText"]
			info:						qsTr("")
		}
		AssignedVariablesList
		{
			name: 						"protected"
			title: 						qsTr("Sensitive Attribute")
			singleVariable:				true
			allowedColumns:				["nominal", "nominalText"]
			info:						qsTr("")
		}
	}

	CIField
	{
		name: 							"conf_level"
		label: 							qsTr("Confidence")
		info:							qsTr("The confidence level used. The confidence level is the complement of the audit risk: the risk that the user is willing to take to give an incorrect judgment about the population. For example, if you want to use an audit risk of 5%, this equals 95% confidence.")
	}

	Group 
	{
		title:							qsTr("Factor Levels")
		info:							qsTr("")

		DropDown
		{
			label: 						qsTr("Privileged group")
			name: 						"privileged"
			indexDefaultValue: 			0
			addEmptyValue: 				true
			placeholderText: 			qsTr("None")
			source: 					[ { name: "protected", use: "levels" } ]
			info:						qsTr("")
		}

		DropDown
		{
			label: 						qsTr("Positive class")
			name: 						"positive"
			indexDefaultValue: 			0
			addEmptyValue: 				true
			placeholderText: 			qsTr("None")
			source: 					[ { name: "target", use: "levels" } ]
			info:						qsTr("")
		}
	}

	RadioButtonGroup
	{
		title: 							qsTr("Alt. Hypothesis")
		name: 							"alternative"
		info:							qsTr("")

		RadioButton
		{
			text: 						qsTr("Unprivileged \u2260 Privileged")
			name: 						"two.sided"
			checked:					true
			info:						qsTr("")
		}

		RadioButton
		{
			text: 						qsTr("Unprivileged < Privileged")
			name: 						"less"
			info:						qsTr("")
		}

		RadioButton
		{
			text: 						qsTr("Unprivileged > Privileged")
			name: 						"greater"
			info:						qsTr("")
		}
	}

	RadioButtonGroup
	{
		name:							"bayesFactorType"
		title:							"Bayes Factor"
		info:							qsTr("Choose which type of Bayes factor to display.")

		RadioButton
		{
			name:						"BF10"
			text:						qsTr("BF\u2081\u2080")
			checked:					true
			info:						qsTr("Bayes factor to quantify evidence for the alternative hypothesis relative to the null hypothesis.")
		}

		RadioButton
		{
			name:						"BF01"
			text:						qsTr("BF\u2080\u2081")
			info:						qsTr("Bayes factor to quantify evidence for the null hypothesis relative to the alternative hypothesis.")
		}

		RadioButton
		{
			name:						"logBF10"
			text:						qsTr("Log(BF\u2081\u2080)")
			info:						qsTr("Natural logarithm of BF10.")
		}
	}

	Section
	{
		title: 							qsTr("Report")
		columns: 						2
		info:							qsTr("")

		Group
		{
			title: 						qsTr("Tables")
			info:						qsTr("")

			CheckBox
			{
				text:					qsTr("Model performance")
				name:					"performanceTable"
				info:					qsTr("")
			}
		}

		Group
		{
			title: 						qsTr("Plots")
			info:						qsTr("")

			CheckBox
			{
				text:					qsTr("Parity estimates")
				name:					"parityPlot"
				info:						qsTr("")
			}

			CheckBox
			{
				text:					qsTr("Prior and posterior distribution")
				name:					"posteriorPlot"
				enabled:				metric.value != "dp"
				info:					qsTr("")
			}
		}
	}

	Section
	{
		columns:						1
		title: 							qsTr("Advanced")
		info:							qsTr("")

		IntegerField
		{
			name: 						"seed"
			label: 						qsTr("Seed")
			defaultValue: 				1
			info:						qsTr("Selects the seed for the random number generator in order to reproduce results.")
		}

		RadioButtonGroup 
		{
			name: 						"chooseMeasure"
			title:						qsTr("Fairness metric")
			info:						qsTr("")

			RadioButton
			{
				id:						chooseManual
				name:					"chooseManual"
				label:					qsTr("Manual")
				checked:				true
				childrenOnSameRow: 		true
				info:					qsTr("")

				DropDown
				{
					id:					metric
					name: 				"metric"
					visible:			chooseManual.checked
					indexDefaultValue: 	0
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
			}

			RadioButton
			{
				id:						chooseGuided
				name:					"chooseGuided"
				label:					qsTr("Decision-tree")
				info:					qsTr("")

				Row
				{
					visible:			chooseGuided.checked
					Layout.leftMargin:  5 * preferencesModel.uiScale

					RadioButtonGroup
					{
						id: 			q1
						name:			"q1"
						title:			qsTr("1. Should the ground truth labels be considered?")
						
						RadioButton
						{
							id:			q1option1
							label:		qsTr("Yes")
							name:		"q1option1"
							checked:	true
							value:		"yes"
						}
						RadioButton
						{
							id:			q1option2
							label: 		qsTr("No")
							name:		"q1option1"
							value:		"no"
						}
					}
					
					HelpButton
					{
						toolTip:		qsTr("Click to learn more about Q1.")
						helpPage:		"auditFairness"
					}
				}

				Row
				{
					visible:			chooseGuided.checked
					Layout.leftMargin:  20 * preferencesModel.uiScale

					RadioButtonGroup
					{
						id:				q2
						name:			"q2"
						title: 			q1option1.checked ? qsTr("2. Should all elements of the confusion matrix be considered?") : qsTr("2. Should the absolute values or the proportions of the favorable predictions be used?")

						RadioButton
						{
							id:			q2option1
							name:		"q2option1"
							label: 		q1option1.checked ? qsTr("Yes"): qsTr("Absolute")
							value:		q1option1.checked ? "yes": "abs"
						}
						
						RadioButton
						{
							id:			q2option2
							name:		"q2option2"
							label: 		q1option1.checked ? qsTr("No"): qsTr("Proportional")
							value:		q1option1.checked ? "no": "prop"
							checked: 	true
						}
					}

					HelpButton
					{
						toolTip:		qsTr("Click to learn more about Q2.")
						helpPage:		"auditQ2Helper"
					}
				}

				Row
				{
					id: 				g3
					visible: 			chooseGuided.checked && (q1option1.checked && q2option2.value == "no" && q2option2.checked) ? true: false
					Layout.leftMargin:  35 * preferencesModel.uiScale

					RadioButtonGroup
					{
						id: 			q3
						name: 			"q3"
						title: 			qsTr("3. Should we focus on correctly or incorrectly classified instances?")
	
						RadioButton
						{
							id:			q3option1
							name:		"q3option1"
							label: 		qsTr("Correctly")
							value:		g3.visible ? "corr": ""
							checked: 	true
						}

						RadioButton
						{
							id:			q3option2
							name:		"q3option2"
							label:		qsTr("Incorrectly")
							value:		g3.visible ? "incorr": ""
						}
					}
		
					HelpButton
					{
						toolTip:		qsTr("Click to learn more about Q3.")
						helpPage:		"auditQ2Helper"
					}
				}

				Row
				{
					visible: 			chooseGuided.checked && g3.visible ? true: false
					Layout.leftMargin:  50 * preferencesModel.uiScale

					RadioButtonGroup
					{
						id: 			q4
						name:			"q4"
						title: 			q3option1.checked ? qsTr("4. Should we focus on true positive or true negative rates?") : qsTr("4. Should we focus on false positive or false negative rates?")
	
						RadioButton
						{
							id:			q4option1
							name:		"q4option1"
							label: 		q3option1.checked ? qsTr("True Positives"): qsTr("False Positives")
							value: 		g3.visible ? (q3option1.checked ? "tp" : "fp") : ""
						}

						RadioButton
						{
							id:			q4option2
							name:		"q4option2"
							label: 		q3option1.checked ? qsTr("True Negatives"): qsTr("False Negatives")
							value: 		g3.visible ? (q3option1.checked ? "tn" : "fn") : ""
							checked: 	true
						}
					}
		
					HelpButton
					{
						toolTip:		qsTr("Click to learn more about Q4.")
						helpPage:		"auditQ2Helper"
					}
				}
			}
		}
	}

	Common.DownloadReport { }
}