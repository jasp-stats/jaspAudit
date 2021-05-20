
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
		id: 							variablesFormNumberBunching
		preferredHeight:				jaspTheme.smallDefaultVariablesFormHeight

		AvailableVariablesList
		{
			name: 						"variablesFormNumberBunching"
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
		columns:						2
		columnSpacing:					100 * preferencesModel.uiScale

		ColumnLayout
		{

			GroupBox
			{
				title:					qsTr("Tests")

				CheckBox
				{
					name:				"avgFrequency"
					text:				qsTr("Average frequency")
					checked:			true
				}

				CheckBox
				{
					name:				"entropy"
					text:				qsTr("Entropy")
					checked:			true
				}
			}

			RadioButtonGroup
			{
				name:					"shuffle"
				title: 					qsTr("Shuffle Decimal Digits")

				RadioButton
				{
					name:				"lastTwo"
					text:				qsTr("First and second digit")
					checked:			true
				}

				RadioButton
				{
					name:				"last"
					text:				qsTr("Second digit")
				}

				RadioButton
				{
					name:				"all"
					text:				qsTr("All digits")
				}
			}

			GroupBox
			{
				title: 					qsTr("Bootstrap Options")

				IntegerField
				{
					name: 					"noSamples"
					label: 					qsTr("Number of samples")
					min: 					100
					defaultValue: 			500
					max: 					500000
					fieldWidth:				70
				}

				IntegerField
				{
					name: 					"seed"
					label: 					qsTr("Seed")
					min: 					1
					defaultValue: 			1
					max: 					500000
					fieldWidth:				70
				}
			}
		}

		ColumnLayout
		{
			GroupBox
			{
				title: 						qsTr("Tables")

				CheckBox
				{
					text: 					qsTr("Assumption checks")
					name: 					"correlationTable"
					checked: 				true
				}

				CheckBox
				{
					text: 					qsTr("Frequency table")
					name: 					"summaryTable"
				}
			}

			GroupBox
			{
				title: 						qsTr("Plots")

				CheckBox
				{
					text: 					qsTr("Observed vs. expected values")
					name: 					"numberBunchingSimulationPlots"
				}

				CheckBox
				{
					text: 					qsTr("Histogram of individual values")
					name: 					"numberBunchingHistogram"

					IntegerField
					{
						name: 				"noHeads"
						label: 				qsTr("Label")
						afterLabel:			qsTr("with highest occurrence")
						min: 				0
						defaultValue:		0
						max:				20
					}
				}
			}
		}
	}

	Item
	{
		Layout.preferredHeight: 		downloadReportNumberBunching.height
		Layout.fillWidth: 				true

		Button
		{
			id: 						downloadReportNumberBunching
			enabled: 					values.count > 0
			anchors.right:				parent.right
			anchors.bottom:				parent.bottom
			text: 						qsTr("<b>Download Report</b>")
			onClicked: 					form.exportResults()
		}
	}
}
