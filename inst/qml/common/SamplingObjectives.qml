
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
	info:								qsTr("Specify the objectives for the sampling procedure.")

	CIField
	{
		name: 							"conf_level"
		label: 							qsTr("Confidence")
		Layout.columnSpan:				2
		info:							qsTr("The confidence level used. The confidence level is the complement of the audit risk: the risk that the user is willing to take to give an incorrect judgment about the population. For example, if you want to use an audit risk of 5%, this equals 95% confidence.")
	}

	CheckBox
	{
		id: 							materiality_test
		text: 							qsTr("Performance materiality")
		name: 							"materiality_test"
		info:							qsTr("The performance materiality, also known the intolerable deviation rate or intolerable misstatement (sometimes tolerable deviation rate or misstatement), is a value established by the auditor that is below, or equal to, the overall materiality of the financial statements. Typically in an audit, the performance materiality is set lower than the overall materiality to reduce the chance that the total of undetected misstatements exceeds the materiality of the financial statements as a whole.\n\nIn this analysis, the performance materiality represents the lowest unacceptable level of misstatement in the population being tested. By enabling this sampling objective, you can design a sample to determine whether the population as a whole contain misstatements that are deemed material (i.e. are greater or equal to the performance materiality) while respecting a certain audit risk (1 - confidence level).\n\nThe value of the performance materiality affects the minimum sample size. A lower performance materiality requires a relatively larger minimum sample size to reduce the audit risk to an acceptably low level, while a higher performance materiality requires a relatively smaller sample size to reduce the audit risk to an acceptably low level.")

		RadioButtonGroup
		{
			id: 						materiality_type
			name: 						"materiality_type"
			info:						qsTr("Specify how the performance materiality is defined.")

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
					info:				qsTr("Specify the performance materiality as a percentage relative to the total number of units in the population.")

					PercentField
					{
						id:				materiality_relative_value
						visible: 		materiality_relative.checked
						decimals: 		2
						defaultValue: 	1
						min:			0.01
						max:			99.99
						name: 			"materiality_rel_val"
						info:			qsTr("The percentage associated with the performance materiality.")
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
					info:				qsTr("Specify the performance materiality as an absolute value in monetary units.")

					DoubleField
					{
						id:				materiality_absolute_value
						visible: 		materiality_absolute.checked
						name: 			"materiality_abs_val"
						defaultValue: 	0
						min: 			0
						fieldWidth: 	90 * preferencesModel.uiScale
						decimals: 		2
						info:			qsTr("The value associated with the performance materiality.")
					}
				}
			}
		}
	}

	HelpButton
	{
		toolTip: 						qsTr("Click to learn more about this objective")
		helpPage:						"Audit/performanceMateriality"
	}

	CheckBox
	{
		id: 							min_precision_test
		text: 							qsTr("Minimum precision")
		name: 							"min_precision_test"
		info:							qsTr("The precision is a measure of how much uncertainty there is in the estimate of the misstatement in the population at a given level of sampling risk. Typically in an audit, the precision is used to determine if enough work has been performed to effectively estimate the misstatement in the population.\n\nIn this analysis, the precision represents the difference between the estimated most likely misstatement in the population and the upper bound of the misstatement in the population. By enabling this sampling objective, you can design a sample that minimizes the difference between the estimated most likely misstatement and the upper bound of the misstatement to a certain percentage.\n\nThe value of the minimum precision affects the minimum sample size. A smaller minimum required precision will result in a larger sample size, while a higher minimum required precision will result in a smaller sample size.")

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
			info:						qsTr("The percentage associated with the minimum precision.")
		}
	}

	HelpButton
	{
		toolTip: 						qsTr("Click to learn more about this objective")
		helpPage:						"Audit/minimumPrecision"
	}
}
