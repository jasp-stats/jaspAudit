
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

	id: 					method
	title:					qsTr("Selection Method")
	name: 					"sampling_method"
	columns:				2
	enabled:				enable

	RadioButton
	{
		id: 				interval
		text: 				qsTr("Fixed interval sampling")
		name: 				"interval"
		checked: 			true

		IntegerField
		{
			id: 			start
			text: 			qsTr("Starting point")
			name: 			"start"
			defaultValue: 	1
			min: 			1
			visible:		interval.checked
			enabled:		!force_interval && !randomize.checked
		}

		CheckBox
		{
			id:				randomize
			text: 			qsTr("Random")
			name: 			"randomStart"
			visible:		interval.checked
			enabled:		!force_interval
		}
	}

	HelpButton
	{
		toolTip: 			qsTr("Click to learn more about this method")
		helpPage:			"Audit/fixedIntervalSampling"
	}

	RadioButton
	{
		id: 				cell
		text: 				qsTr("Cell sampling")
		name: 				"cell"
		enabled:			!force_interval
	}

	HelpButton
	{
		toolTip: 			qsTr("Click to learn more about this method")
		helpPage:			"Audit/cellSampling"
	}

	RadioButton
	{
		id: 				random
		text: 				qsTr("Random sampling")
		name: 				"random"
		enabled:			!force_interval
	}

	HelpButton
	{
		toolTip: 			qsTr("Click to learn more about this method")
		helpPage:			"Audit/randomSampling"
	}

	RadioButton
	{
		id: 				sieve
		text: 				qsTr("Modified sieve sampling")
		name: 				"sieve"
		enabled:			!force_interval && enable_sieve
	}

	HelpButton
	{
		toolTip: 			qsTr("Click to learn more about this method")
		helpPage:			"Audit/sieveSampling"
	}
}
