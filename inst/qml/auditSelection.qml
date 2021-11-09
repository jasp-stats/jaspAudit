
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

import QtQuick 									2.8
import QtQuick.Layouts 							1.3
import JASP.Controls 							1.0
import JASP.Widgets 							1.0

Form 
{

	columns:									2

	// Extra options
	CheckBox
	{
		name:									"workflow"
		checked:								false
		visible:								false
	}

	VariablesForm
	{
		id:										variablesFormSampling

		AvailableVariablesList
		{
			name:								"variablesFormSampling"
		}

		AssignedVariablesList
		{
			id:									id
			name:								"id"
			title:								qsTr("Item ID")
			singleVariable:						true
			allowedColumns:						["nominal", "nominalText", "ordinal", "scale"]
			allowAnalysisOwnComputedColumns:	false
		}

		AssignedVariablesList
		{
			id:									values
			name:								"values"
			title:								qsTr("Book Value")
			singleVariable:						true
			allowedColumns:						["scale"]
			allowAnalysisOwnComputedColumns:	false
			onCountChanged:						values.count == 0 ? rows_sampling.click() : values_sampling.click()
		}

		AssignedVariablesList
		{
			id:									rank
			name:								"rank"
			title: 								qsTr("Ranking Variable")
			singleVariable:						true
			allowedColumns:						["scale"]
			allowAnalysisOwnComputedColumns: 	false
		}

		AssignedVariablesList
		{
			name:								"variables"
			title: 								qsTr("Additional Variables")
			Layout.preferredHeight: 			140 * preferencesModel.uiScale
			allowedColumns: 					["scale", "ordinal", "nominal"]
			allowAnalysisOwnComputedColumns: 	false
		}
	}

	IntegerField
	{
		id:										nobs
		text: 									qsTr("Sample size")
		name: 									"n"
		defaultValue: 							0
		min: 									0
		fieldWidth: 							60 * preferencesModel.uiScale
	}

	Group
	{
		title: 									qsTr("Display")
		columns: 2

		CheckBox
		{
			id: 								explanatoryText
			text: 								qsTr("Explanatory Text")
			name: 								"explanatoryText"
			checked: 							true
		}

		HelpButton
		{
			helpPage:							"Audit/explanatoryText"
			toolTip: 							qsTr("Show explanatory text at each step of the analysis")
		}
	}

	RadioButtonGroup
	{
		id: 									units
		title:									qsTr("Sampling Units")
		name: 									"units"
		columns:								2

		RadioButton
		{
			id: 								rows_sampling
			text: 								qsTr("Items")
			name: 								"items"
			checked: 							true
		}

		HelpButton
		{
			toolTip: 							qsTr("Click to learn more about record sampling.")
			helpPage:							"Audit/recordSampling"
		}

		RadioButton
		{
			id: 								values_sampling
			text: 								qsTr("Monetary units")
			name: 								"values"
			enabled: 							values.count > 0
		}

		HelpButton
		{
			helpPage:							"Audit/monetaryUnitSampling"
			toolTip: 							qsTr("Click to learn more about monetary unit sampling.")
		}
	}

	Group
	{
		title: 									qsTr("Tables")

		CheckBox
		{
			text: 								qsTr("Descriptive statistics")
			name: 								"tableDescriptives"
		}

		CheckBox
		{
			text: 								qsTr("Raw sample")
			name: 								"tableSample"
		}
	}

	Group
	{
		RadioButtonGroup
		{
			id: 								method
			title:								qsTr("Method")
			name: 								"sampling_method"

			Group
			{

				Row
				{
					RadioButton
					{
						id: 					interval
						text: 					qsTr("Fixed interval sampling")
						name: 					"interval"
						checked: 				true

						IntegerField
						{
							id: 				start
							text: 				qsTr("Starting point")
							name: 				"start"
							defaultValue: 		1
							min: 				1
							visible:			interval.checked
						}
					}

					HelpButton
					{
						toolTip: 				qsTr("Click to learn more about fixed interval sampling.")
						helpPage:				"Audit/fixedIntervalSampling"
					}
				}

				Row
				{
					RadioButton
					{
						id: 					cell
						text: 					qsTr("Cell sampling")
						name: 					"cell"

						IntegerField
						{
							id: 				seed_cell
							text: 				qsTr("Seed")
							name: 				"seed_cell"
							defaultValue: 		1
							min: 				1
							max: 				99999
							visible:			cell.checked
						}
					}

					HelpButton
					{
						toolTip: 				qsTr("Click to learn more about cell sampling.")
						helpPage:				"Audit/cellSampling"
					}
				}

				Row
				{
					RadioButton
					{
						id: 					random
						text: 					qsTr("Random sampling")
						name: 					"random"

						IntegerField
						{
							id: 				seed_random
							text: 				qsTr("Seed")
							name: 				"seed_random"
							defaultValue: 		1
							min: 				1
							max: 				99999
							visible:			random.checked
						}
					}

					HelpButton
					{
						toolTip: 				qsTr("Click to learn more about random sampling.")
						helpPage:				"Audit/randomSampling"
					}
				}
			}
		}

		CheckBox
		{
			name:								"randomize"
			text:								qsTr("Randomize items")
			enabled:							rank.count == 0
		}
	}

	Section
	{
		title: 									qsTr("Export")

		Group
		{
			enabled: 							id.count > 0 && nobs.value > 0

			ComputedColumnField
			{
				id:								name_indicator
				name: 							"name_indicator"
				text: 							qsTr("Column name selection result")
				placeholderText: 				qsTr("e.g. selected")
				fieldWidth: 					120 * preferencesModel.uiScale
			}

			FileSelector
			{
				id:                             file
				name:                           "file"
				label:                          qsTr("Save as")
				placeholderText: 				qsTr("e.g. sample.csv")
				filter:                         "*.csv"
				save:                           true
				fieldWidth:                     180 * preferencesModel.uiScale
			}

			CheckBox
			{
				name: 							"export_sample"
				text: 							qsTr("Export sample to file")
				enabled:						name_indicator.value != "" && file.value != ""
			}
		}
	}

	Item
	{
		Layout.preferredHeight: 				download.height
		Layout.preferredWidth:					parent.width
		Layout.columnSpan:						2

		Button
		{
			id: 								download
			anchors.right: 						parent.right
			text: 								qsTr("<b>Download Report</b>")
			onClicked: 							form.exportResults()
		}
	}
}
