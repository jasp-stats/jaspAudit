
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
	readonly	property bool	use_negative:	critical_negative.checked
	readonly	property bool	use_inspect:	critical_inspect.checked
				property bool	enable:			false
				property bool	workflow:		true
				property string	use_name:		critical_name.value

	name:					"critical_items"
	title:					qsTr("Critical Items")
	enabled:				enable
	info:					qsTr("Choose how to handle critical items in the data set.")

	CheckBox
	{
		id:					critical_negative
		name:				"critical_negative"
		text:				qsTr("Negative book values")
		checked:			true
		info:				qsTr("Isolates negative book values from the population.")

		ComputedColumnField
		{
			id:				critical_name
			name: 			"critical_name"
			text: 			qsTr("Column name")
			fieldWidth: 	120 * preferencesModel.uiScale
			value: 			workflow ? qsTr("critical") : ""
			visible:		workflow
			info:			qsTr("Name for the column containing the critical item indicator to be added to the data set.")
		}

		RadioButtonGroup
		{
			name: 			"critical_action"

			RadioButton
			{
				id:			critical_inspect
				text: 		qsTr("Keep")
				name: 		"inspect"
				checked: 	true
				info:		qsTr("Retains the critical items to be inspected as part of the sample.")
			}

			RadioButton
			{
				text: 		qsTr("Remove")
				name: 		"remove"
				info:		qsTr("Removes the critical items in the analysis.")
			}
		}
	}
}
