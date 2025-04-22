
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

Form
{
	columns:						1
	info:							qsTr("The estimation analysis allows the user to estimate the true value of a population on the basis of a sample.")

	VariablesForm
	{
		id: 						variablesFormEstimation
		preferredHeight: 			jaspTheme.smallDefaultVariablesFormHeight

		AvailableVariablesList
		{
			name: 					"variablesFormEstimation"
		}

		AssignedVariablesList
		{
			id: 					bookValues
			name: 					"bookValues"
			title: 					qsTr("Book Value")
			singleVariable:			true
			allowedColumns:			["scale"]
			minNumericLevels:		1
			enabled: 				!mpu.checked
			info:					qsTr("A numeric variable that contains the book (recorded) values of the items in the population.")
		}

		AssignedVariablesList
		{
			id: 					auditValues
			name: 					"auditValues"
			title: 					qsTr("Audit Value")
			singleVariable: 		true
			allowedColumns: 		["scale"]
			minNumericLevels:		1
			info:					qsTr("A numeric variable that contains the audited (true) values of the items in the population.")
		}
	}

	Group
	{
		title: 						qsTr("Population (required)")

		IntegerField
		{
			id: 					populationSize
			name: 					"populationSize"
			text: 					qsTr("No. items")
			fieldWidth: 			100 * preferencesModel.uiScale
			defaultValue: 			0
			min: 					0
			info:					qsTr("The total number of items (rows) in the population.")
		}

		DoubleField
		{
			id: 					populationValue
			name: 					"populationValue"
			text: 					qsTr("No. units")
			defaultValue: 			0
			fieldWidth: 			100 * preferencesModel.uiScale
			min: 					0
			decimals: 				2
			enabled:				!mpu.checked
			info:					qsTr("The total number of units in the population. Note that the units can be items (rows) or monetary units (values) depending on the audit question.")
		}
	}

	RadioButtonGroup
	{
		name:						"estimator"
		title: 						qsTr("Method")
		info:						qsTr("The type of method used to estimate the true value of the population.")

		RadioButton
		{
			id:						mpu
			name:					"mpu"
			text:					qsTr("Direct estimator")
			info:					qsTr("The direct estimator.")
		}

		RadioButton
		{
			name:					"difference"
			text:					qsTr("Difference estimator")
			info:					qsTr("The difference estimator.")
		}

		RadioButton
		{
			name:					"ratio"
			text:					qsTr("Ratio estimator")
			info:					qsTr("The ratio estimator.")
		}

		RadioButton
		{
			name:					"regression"
			text:					qsTr("Regression estimator")
			checked:				true
			info:					qsTr("The regression estimator.")
		}
	}

	Group
	{
		title: 						qsTr("Display")
		info:						qsTr("Specify options that have an effect on the look and feel of the audit report.")

		Row
		{
			CheckBox
			{
				id: 				explanatoryText
				text: 				qsTr("Explanatory text")
				name: 				"explanatoryText"
				checked: 			true
				info:				qsTr("When checked, enables explanatory text in the analysis to help interpret the procedure and the statistical results.")

				CIField
				{
					name: 			"confidence"
					label: 			qsTr("Confidence")
					info:			qsTr("The confidence level used. The confidence level is the complement of the audit risk: the risk that the user is willing to take to give an incorrect judgment about the population. For example, if you want to use an audit risk of 5%, this equals 95% confidence.")
				}
			}

			HelpButton
			{
				helpPage:			"Audit/explanatoryText"
				toolTip: 			qsTr("Show explanatory text at each step of the analysis")
			}
		}
	}

	Section
	{
		title:						qsTr("Report")
		columns:					2

		Group
		{
			title: 					qsTr("Tables")
			info:					qsTr("Add additional tables about the analysis to the report.")

			CheckBox
			{
				id: 				requiredSampleSize
				text:	 			qsTr("Required sample size")
				name: 				"requiredSampleSizeTable"
				info:				qsTr("Produces a table showing the required sample size to achive a desired precision.")

				DoubleField
				{
					name: 			"requiredUncertainty"
					visible: 		requiredSampleSize.checked
					text: 			qsTr("for an uncertainty of:")
					defaultValue: 	100000
					fieldWidth: 	100 * preferencesModel.uiScale
					min: 			1
					decimals: 		3
					info:			qsTr("The value of the precision.")
				}
			}
		}

		Group
		{
			title: 					qsTr("Plots")
			info:					qsTr("Add additional figures about the analysis to the report.")

			CheckBox
			{
				text: 				qsTr("Scatter plot")
				name: 				"correlationPlot"
				enabled: 			!mpu.checked
				info:				qsTr("Produces a scatter plot comparing the book values in the sample against their audit values. Items for which these two values do not match are colored in red.")
			}
		}

	}

	Common.DownloadReport { }
}
