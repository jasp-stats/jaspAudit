
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

	// Hidden option(s)
	CheckBox { name: "workflow"; checked: false; visible: false }

	// Visible options
	VariablesForm
	{
		id:										variablesFormSampling
		preferredHeight: 						jaspTheme.smallDefaultVariablesFormHeight

		AvailableVariablesList
		{
			name:								"variablesFormSampling"
		}

		AssignedVariablesList
		{
			id:									id
			name:								"id"
			title:								qsTr("Item ID (required)")
			singleVariable:						true
			allowedColumns:						["nominal", "nominalText", "ordinal", "scale"]
			allowAnalysisOwnComputedColumns:	false
		}

		AssignedVariablesList
		{
			id:									values
			name:								"values"
			title:								units.use_mus ? qsTr("Book Value (required)") : qsTr("Book Value (optional)")
			singleVariable:						true
			allowedColumns:						["scale"]
			allowAnalysisOwnComputedColumns:	false
		}

		AssignedVariablesList
		{
			id:									rank
			name:								"rank"
			title: 								qsTr("Ranking Variable")
			singleVariable:						true
			allowedColumns:						["scale"]
			allowAnalysisOwnComputedColumns: 	false
			debug:								true
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

	Group
	{
		IntegerField
		{
			id:								sample_size
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
			enabled:						randomize.checked || !method.use_interval
		}

		CheckBox
		{
			id:								randomize
			name:							"randomize"
			text:							qsTr("Randomize item order")
			enabled:						rank.count == 0
		}
	}

	Common.SamplingUnits { id: units; enable_mus: values.count > 0}
	Common.SelectionMethod { id: method }
	Common.ExplanatoryText { }

	Section
	{
		title:			qsTr("Report")
		Group
		{
			Common.SelectionOutput { }
		}
	}

	Common.ExportSample { enable: id.count > 0 && sample_size.value > 0 }
	Common.DownloadReport { }
}
