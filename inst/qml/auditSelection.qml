
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
	info:										qsTr("The selection analysis allows the user to select a number of sampling units (items or monetary units) from a population using a variety of sampling methods (random sampling, cell sampling, fixed interval sampling) that are standard in an auditing context.\n\n<img src='%HELP_FOLDER%/img/workflowSelection.png'/>\n\nPlease see the manual of the Audit module (download [here](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) for more detailed information about this analysis.")

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
			info:								qsTr("A unique non-missing identifier for every item in the population. The row number of the items is sufficient.")
		}

		AssignedVariablesList
		{
			id:									values
			name:								"values"
			title:								units.use_mus ? qsTr("Book Value (required)") : qsTr("Book Value (optional)")
			singleVariable:						true
			allowedColumns:						["scale"]
			allowAnalysisOwnComputedColumns:	false
			info:								qsTr("A numeric variable that contains the book (recorded) values of the items in the population.")
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
			info:								qsTr("When provided, the population is first ranked in ascending order with respect to the values of this variable.")
		}

		AssignedVariablesList
		{
			name:								"variables"
			title: 								qsTr("Additional Variables")
			Layout.preferredHeight: 			140 * preferencesModel.uiScale
			allowedColumns: 					["scale", "ordinal", "nominal"]
			allowAnalysisOwnComputedColumns: 	false
			info:								qsTr("Any other variables that should be included in the sample.")
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
			info:							qsTr("The required number of sampling units that should be selected from the population. Be aware that the sampling units are determined by the *units* option. By default, when no book values are provided, the sampling units are items (rows). When book values are provided, the ideal sampling units to use are monetary units.")
		}

		IntegerField
		{
			id: 							seed
			text: 							qsTr("Seed")
			name: 							"seed"
			defaultValue: 					1
			min: 							1
			max: 							99999
			enabled:						randomize.checked || !method.use_interval || method.use_random_start
			info:							qsTr("Selects the seed for the random number generator in order to reproduce results.")
		}

		CheckBox
		{
			id:								randomize
			name:							"randomize"
			text:							qsTr("Randomize item order")
			enabled:						rank.count == 0
			info:							qsTr("Randomizes the items in the population before selection is performed.")
		}
	}

	Common.SamplingUnits { id: units; enable_mus: values.count > 0 }
	Common.SelectionMethod { id: method; enable_sieve: values.count > 0 && units.use_mus }
	Common.ExplanatoryText { }

	Section
	{
		title:								qsTr("Report")
		Group
		{
			columns:						1
			Common.SelectionOutput { }
		}
	}

	Common.ExportSample { enable: id.count > 0 && sample_size.value > 0 }
	Common.DownloadReport { }
}
