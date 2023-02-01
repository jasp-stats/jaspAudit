
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
	readonly	property alias	expected_is_relative:	expected_rel.checked

	id: 					expected
	name: 					"expected_type"
	title: 					qsTr("Expected Misstatements")

	RadioButton
	{
		id: 				expected_rel
		name: 				"expected_rel"
		text: 				qsTr("Relative")
		checked: 			true
		childrenOnSameRow: 	true

		PercentField
		{
			id:				expected_rel_val
			name: 			"expected_rel_val"
			enabled: 		expected_rel.checked
			decimals: 		2
			defaultValue: 	0
			visible: 		expected_rel.checked
		}
	}

	RadioButton
	{
		id: 				expected_abs
		name: 				"expected_abs"
		text: 				qsTr("Absolute")
		childrenOnSameRow: 	true

		DoubleField
		{
			id:				expected_abs_val
			name: 			"expected_abs_val"
			enabled: 		expected_abs.checked
			defaultValue: 	0
			min: 			0
			decimals: 		3
			visible: 		expected_abs.checked
		}
	}
}
