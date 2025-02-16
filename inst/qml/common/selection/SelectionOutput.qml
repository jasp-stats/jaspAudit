
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

Group
{
	property bool	enable_order:	false

	title:						qsTr("Tables")

	CheckBox
	{
		text:					qsTr("Descriptive statistics")
		name:					"tableDescriptives"
		info:					qsTr("Produces a table containing descriptive information about numerical variables in the selection. Statistics that are included are the mean, the median, the standard deviation, the variance, the minimum, the maximum, and the range.")
	}

	CheckBox
	{
		text:					qsTr("Selected items")
		name:					"tableSample"
		info:					qsTr("Produces a table containing the selected transactions along with any additional observations provided in the additional variables field.")

		CheckBox 
		{
			text:				qsTr("Order by book value")
			name:				"tableSampleSort"
			info:				qstr("Order the selected transactions in the table from largest to smallest based on their book value.")
			enabled:			enable_order

			RadioButtonGroup
			{
				name:			"tableSampleSortOrder"
				
				RadioButton
				{
					text:		qsTr("Descending")
					name:		"descending"
					checked:	true
				}

				RadioButton
				{
					text:		qsTr("Ascending")
					name:		"ascending"
				}
			}
		}
	}
}
