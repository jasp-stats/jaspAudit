
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

	columns: 							2

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

	Group
	{
		title:							qsTr("Tests")

		CheckBox
		{
			name:						"avgFrequency"
			text:						qsTr("Average frequency")
			checked:					true
		}

		CheckBox
		{
			name:						"entropy"
			text:						qsTr("Entropy")
		}
	}

	Group
	{
		title: 							qsTr("Display")
		columns: 						2

		Row
		{
			CheckBox
			{
				id: 					explanatoryText
				text: 					qsTr("Explanatory text")
				name: 					"explanatoryText"
				checked: 				true

				CIField
				{
					name: 				"confidence"
					label: 				qsTr("Confidence")
				}
			}

			HelpButton
			{
				helpPage:				"Audit/explanatoryText"
				toolTip: 				qsTr("Show explanatory text at each step of the analysis")
			}
		}
	}

	RadioButtonGroup
	{
		name:							"shuffle"
		title: 							qsTr("Shuffle Decimal Digits")

		RadioButton
		{
			name:						"last"
			text:						qsTr("Last")
		}

		RadioButton
		{
			name:						"lasttwo"
			text:						qsTr("Last two")
			checked:					true
		}

		RadioButton
		{
			name:						"all"
			text:						qsTr("All")
		}
	}

	Group
	{
		Group
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

		Group
		{
			title: 						qsTr("Plots")

			CheckBox
			{
				text: 					qsTr("Observed vs. expected")
				name: 					"numberBunchingSimulationPlots"
			}

			CheckBox
			{
				text: 					qsTr("Histogram")
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

	Section
	{
		title:							qsTr("Advanced Options")
		columns:						2

		IntegerField
		{
			name: 						"noSamples"
			label: 						qsTr("Number of samples")
			min: 						100
			defaultValue: 				500
			max: 						500000
			fieldWidth:					70
		}

		IntegerField
		{
			name: 						"seed"
			label: 						qsTr("Seed")
			defaultValue: 				1
		}
	}

	Item
	{
		Layout.preferredHeight: 		download.height
		Layout.preferredWidth: 			parent.width
		Layout.columnSpan:				2

		Button
		{
			id: 						download
			enabled: 					values.count > 0
			anchors.right:				parent.right
			text: 						qsTr("<b>Download Report</b>")
			onClicked: 					form.exportResults()
		}
	}
}
