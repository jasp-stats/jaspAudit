
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
	property bool	show_title:	true

	columns:					2
	title:						show_title ? qsTr("Audit Risk Model") : ""

	DropDown
	{
		id: 					ir
		name: 					"ir"
		indexDefaultValue: 	 	0
		startValue:				"high"
		label: 					qsTr("Inherent risk")
		values: [
			{ label: qsTr("High"),	value: "high"},
			{ label: qsTr("Medium"), value: "medium"},
			{ label: qsTr("Low"), 		value: "low"},
			{ label: qsTr("Manual"), 	value: "custom"}
		]
	}

	PercentField
	{
		name: 					"irCustom"
		defaultValue: 			ir.value == "high" ? 100 : (ir.value == 'medium' ? 60 : (ir.value == "low" ? 36 : 100))
		min: 					25
		enabled: 				ir.value == "custom"
	}

	DropDown
	{
		id: 					cr
		name: 					"cr"
		indexDefaultValue:		0
		startValue:				"high"
		label: 					qsTr("Control risk")
		values: [
			{ label: qsTr("High"),		value: "high"},
			{ label: qsTr("Medium"), 	value: "medium"},
			{ label: qsTr("Low"), 		value: "low"},
			{ label: qsTr("Manual"), 	value: "custom"}
		]
	}

	PercentField
	{
		name: 					"crCustom"
		defaultValue:			cr.value == "high" ? 100 : (cr.value == 'medium' ? 60 : (cr.value == "low" ? 36 : 100))
		min: 					25
		enabled: 				cr.value == "custom"
	}
}
