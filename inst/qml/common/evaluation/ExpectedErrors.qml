
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
	property bool	enable:					true
	property bool	show_all:				false
	property bool   enable_all:				false

	id: 					expected
	name: 					"expected_type"
	title: 					qsTr("Expected Misstatements")
	enabled:				enable
	info:					qsTr("The expected misstatements are the tolerable misstatements that can be found in the sample while still achieving the conditions outlined in the sampling objectives. It is advised to set this value conservatively to minimize the probability of the observed misstatements exceeding the expected misstatements, which would imply that insufficient work has been done in the end.")

	RadioButton
	{
		id: 				expected_rel
		name: 				"expected_rel"
		text: 				qsTr("Relative")
		checked: 			true
		childrenOnSameRow: 	true
		info:				qsTr("Enter the expected misstatements as a percentage.")

		PercentField
		{
			id:				expected_rel_val
			name: 			"expected_rel_val"
			enabled: 		expected_rel.checked
			decimals: 		3
			defaultValue: 	0
			visible: 		expected_rel.checked
			info:			qsTr("The percentage of expected misstatements in the population.")
		}
	}

	RadioButton
	{
		name:				"expected_all"
		text:				qsTr("All possible")
		enabled:			enable_all
		visible:			show_all
		info:				qsTr("Do not make an assumption about the expected misstatements in the population.")
	}
}
