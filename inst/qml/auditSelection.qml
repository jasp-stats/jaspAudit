
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

Form 
{

	columns:									1

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

	GridLayout
	{
		columns:								2

		Group
		{
			IntegerField
			{
				id:								nobs
				text: 							qsTr("Sample size")
				name: 							"n"
				defaultValue: 					0
				min: 							0
			}

			IntegerField
			{
				id: 							seed
				text: 							qsTr("Seed")
				name: 							"seed"
				defaultValue: 					1
				min: 							1
				max: 							99999
				enabled:						randomize.checked || method.value != "interval"
			}

			CheckBox
			{
				id:								randomize
				name:							"randomize"
				text:							qsTr("Randomize item order")
				enabled:						rank.count == 0
			}
		}

		Common.ExplanatoryText { }
		Common.SelectionMethod { }

		Group
		{
			title: 								qsTr("Tables")

			CheckBox
			{
				text: 							qsTr("Descriptive statistics")
				name: 							"tableDescriptives"
			}

			CheckBox
			{
				text: 							qsTr("Selected items")
				name: 							"tableSample"
			}
		}

		Common.SamplingUnits { enable_mus: values.count > 0 }

	}
	Common.ExportSample { enabled: id.count > 0 && nobs.value > 0 }
	Common.DownloadReport { }
}
