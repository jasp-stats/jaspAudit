
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

import QtQuick							2.8
import QtQuick.Layouts					1.3
import JASP.Controls					1.0
import JASP.Widgets						1.0

Form {
	
	columns: 1

	GridLayout
	{
		columns: 						2
		columnSpacing:					150 * preferencesModel.uiScale

		GroupBox
		{
			id: 						auditRisk
			title: 						qsTr("Audit Risk")

			PercentField
			{
				name: 					"confidence"
				label: 					qsTr("Confidence")
				decimals: 				2
				defaultValue: 			95
				min:					0.1
				max:					99.9
			}
		}

		GroupBox
		{
			title: 						qsTr("Explanatory Text")

			RowLayout
			{
				CheckBox
				{
					id: 				explanatoryText
					text:	 			qsTr("Enable")
					name: 				"explanatoryText"
					checked: 			true
				}

				HelpButton
				{
					helpPage:			"Audit/explanatoryText"
					toolTip: 			qsTr("Click to learn more about the explanatory text.")
				}
			}
		}
	}

	Divider { }

	VariablesForm
	{
		id: 							variablesFormBenfordsLaw
		preferredHeight:				jaspTheme.smallDefaultVariablesFormHeight

		AvailableVariablesList
		{
			name: 						"variablesFormBenfordsLaw"
		}

		AssignedVariablesList
		{
			id: 						values
			name: 						"values"
			title: 						qsTr("Variable")
			singleVariable:				true
			allowedColumns:				["scale"]
		}
	}

	GridLayout
	{
		columns: 						2
		columnSpacing:					150 * preferencesModel.uiScale

		ColumnLayout
		{

			RadioButtonGroup
			{
				name:					"distribution"
				title: 					qsTr("Reference Distribution")

				RadioButton
				{
					name:				"benford"
					text:				qsTr("Benford's law")
					checked:			true
				}

				RadioButton
				{
					name:				"uniform"
					text:				qsTr("Uniform distribution")
				}
			}

			RadioButtonGroup
			{
				name:					"digits"
				title: 					qsTr("Check Digits")

				RadioButton
				{
					name:				"first"
					text:				qsTr("First digit")
					checked:			true
				}

				RadioButton
				{
					name:				"firstsecond"
					text:				qsTr("First and second digits")
				}

				RadioButton
				{
					name:				"last"
					text:				qsTr("Last digit")
				}
			}

			RadioButtonGroup
			{
				name:					"bayesFactorType"
				title:					"Bayes Factor"

				RadioButton
				{
					name:				"BF10"
					text:				qsTr("BF\u2081\u2080")
					checked:			true
				}

				RadioButton
				{
					name:				"BF01"
					text:				qsTr("BF\u2080\u2081")
				}

				RadioButton
				{
					name:				"logBF10"
					text:				qsTr("Log(BF\u2081\u2080)")
				}
			}
		}

		ColumnLayout
		{

			GroupBox
			{
				title: 					qsTr("Tables")

				CheckBox
				{
					text: 				qsTr("Frequency statistics")
					name: 				"summaryTable"
					checked: 			true
				}
			}

			GroupBox
			{
				title: 					qsTr("Plots")

				CheckBox
				{
					text: 				qsTr("Compare to reference distribution")
					name: 				"benfordsLawPlot"
				}
			}
		}
	}

	Item
	{
		Layout.preferredHeight: 		downloadReportBenfordsLaw.height
		Layout.fillWidth: 				true

		Button
		{
			id: 						downloadReportBenfordsLaw
			enabled: 					values.count > 0
			anchors.right:				parent.right
			anchors.bottom:				parent.bottom
			text: 						qsTr("<b>Download Report</b>")
			onClicked: 					form.exportResults()
		}
	}
}
