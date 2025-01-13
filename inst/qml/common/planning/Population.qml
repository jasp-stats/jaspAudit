
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
	readonly	property alias	n_items:		nitems.value
	readonly	property alias	n_units:		nunits.value
				property bool	optional:		false
				property bool 	enable:			true
				property bool	show_items:		false

	title: 				optional ? qsTr("Population (optional)") : qsTr("Population (required)")
	enabled:			enable
	info:				qsTr("Provide information about the population.")

	IntegerField
	{
		id: 			nitems
		name: 			"n_items"
		text: 			qsTr("No. items")
		defaultValue: 	0
		fieldWidth: 	100 * preferencesModel.uiScale
		min: 			0
		visible:		show_items
		info:			qsTr("The total number of items (rows) in the population.")
	}

	DoubleField
	{
		id: 			nunits
		name: 			"n_units"
		text: 			qsTr("No. units")
		defaultValue: 	0
		fieldWidth: 	100 * preferencesModel.uiScale
		min: 			0
		decimals: 		2
		info:			qsTr("The total number of units in the population. Note that the units can be items (rows) or monetary units (values) depending on the audit question.")
	}
}
