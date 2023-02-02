
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

Group
{
	readonly	property bool	use_materiality:		materiality_test.checked
	readonly	property bool	absolute_materiality:	materiality_test.checked && materiality_absolute.checked
	readonly	property bool	absolute_value:			materiality_absolute_value.value
	readonly	property bool	relative_value:			materiality_relative_value.value
	readonly	property bool	precision_value:		min_precision_value.value
	readonly	property bool	use_precision:			min_precision_test.checked
				property bool	enable:					true

	title: 								qsTr("Sampling Objectives")
	columns:							2
	enabled:							enable

	CIField
	{
		name: 							"conf_level"
		label: 							qsTr("Confidence")
		Layout.columnSpan:				2
	}

	CheckBox
	{
		id: 							materiality_test
		text: 							qsTr("Performance materiality")
		name: 							"materiality_test"

		RadioButtonGroup
		{
			id: 						materiality_type
			name: 						"materiality_type"

			Row
			{
				visible: 				materiality_test.checked

				RadioButton
				{
					id:					materiality_relative
					name: 				"materiality_rel"
					text: 				qsTr("Relative")
					checked:			true
					childrenOnSameRow: 	true

					PercentField
					{
						id:				materiality_relative_value
						visible: 		materiality_relative.checked
						decimals: 		2
						defaultValue: 	1
						min:			0.01
						max:			99.99
						name: 			"materiality_rel_val"
					}
				}
			}

			Row
			{
				visible: 				materiality_test.checked

				RadioButton
				{
					id: 				materiality_absolute
					name: 				"materiality_abs"
					text: 				qsTr("Absolute")
					childrenOnSameRow: 	true

					DoubleField
					{
						id:				materiality_absolute_value
						visible: 		materiality_absolute.checked
						name: 			"materiality_abs_val"
						defaultValue: 	0
						min: 			0
						fieldWidth: 	90 * preferencesModel.uiScale
						decimals: 		2
					}
				}
			}
		}
	}

	HelpButton
	{
		toolTip: 						qsTr("Click to learn more about the performance materiality objective.")
		helpPage:						"Audit/performanceMateriality"
	}

	CheckBox
	{
		id: 							min_precision_test
		text: 							qsTr("Minimum precision")
		name: 							"min_precision_test"

		PercentField
		{
			id:							min_precision_value
			name: 						"min_precision_rel_val"
			decimals: 					2
			defaultValue: 				2
			min:						0.1
			max:						99.9
			label: 						qsTr("Relative")
			visible: 					min_precision_test.checked
		}
	}

	HelpButton
	{
		toolTip: 						qsTr("Click to learn more about the minimum precision objective.")
		helpPage:						"Audit/minimumPrecision"
	}
}
