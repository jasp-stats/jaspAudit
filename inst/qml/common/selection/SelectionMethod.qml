
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

RadioButtonGroup
{
	readonly	property bool	use_interval:		interval.checked
	readonly	property bool	use_random_start:	interval.checked && randomize.checked
	readonly	property bool	use_cell:			cell.checked
	readonly	property bool	use_random:			random.checked
				property bool	enable:				true
				property bool	force_interval:		false
				property bool	enable_sieve:		false

	id: 							method
	title:							qsTr("Selection Method")
	name: 							"sampling_method"
	columns:						2
	enabled:						enable
	info:							qsTr("Choose the method by which sampling units are selected from the population.")

	RadioButton
	{
		id: 						interval
		text: 						qsTr("Fixed interval sampling")
		name: 						"interval"
		checked: 					true
		info:						qsTr("Performs selection by dividing the population in equal intervals and selecting a fixed unit in each interval. Any item with a value larger than the interval will always be included in the sample.")

		RadioButtonGroup
		{
			name:					"startMethod"
			text:					qsTr("Starting point")
			info:					qsTr("Selects which sampling unit is selected from each interval.")
			visible:				interval.checked
			enabled:				!force_interval

			RadioButton
			{
				text: 				qsTr("User-specified")
				name: 				"fixedStart"
				info:				qsTr("Set a starting point using to a user-specified value.")
				childrenOnSameRow: 	true
				
				IntegerField
				{
					id: 			start
					name: 			"start"
					defaultValue: 	1
					min: 			1
					info:			qsTr("Selects which sampling unit is selected from each interval.")
				}
			}

			RadioButton
			{
				id:					randomize
				text: 				qsTr("Random")
				name: 				"randomStart"
				checked:			true
				info:				qsTr("Set a starting point via random number generation according to a user-specified seed.")
			}
		}
	}

	HelpButton
	{
		toolTip: 					qsTr("Click to learn more about this method")
		helpPage:					"Audit/fixedIntervalSampling"
	}

	RadioButton
	{
		id: 						cell
		text: 						qsTr("Cell sampling")
		name: 						"cell"
		enabled:					!force_interval
		info:						qsTr("Performs selection by dividing the population in equal intervals and selecting a variable unit in each interval. Any item with a value larger than twice the interval will always be included in the sample.")
	}

	HelpButton
	{
		toolTip: 					qsTr("Click to learn more about this method")
		helpPage:					"Audit/cellSampling"
	}

	RadioButton
	{
		id: 						random
		text: 						qsTr("Random sampling")
		name: 						"random"
		enabled:					!force_interval
		info:						qsTr("Performs random selection in which each sampling unit has an equal chance of being selected.")
	}

	HelpButton
	{
		toolTip: 					qsTr("Click to learn more about this method")
		helpPage:					"Audit/randomSampling"
	}

	RadioButton
	{
		id: 						sieve
		text: 						qsTr("Modified sieve sampling")
		name: 						"sieve"
		enabled:					!force_interval && enable_sieve
		info:						qsTr("Performs modified sieve sampling.")
		debug:						true
	}

	HelpButton
	{
		toolTip: 					qsTr("Click to learn more about this method")
		helpPage:					"Audit/sieveSampling"
		visible:					false
	}
}
