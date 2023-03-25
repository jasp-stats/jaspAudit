
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
	readonly	property bool	use_values:		continuous.checked
				property bool	enable:			true
				property bool	enable_values:	false
				property bool	enable_binary:	true

	name: 			"annotation"
	title: 			qsTr("Annotation")
	enabled:		enable
	columns:		2
	info:			qsTr("Specify how to annotate your data set.")

	RadioButton
	{
		id: 		continuous
		text: 		qsTr("Audit value")
		name: 		"continuous"
		checked:	enable_values
		enabled: 	enable_values
		info:		qsTr("Annotate the items in the selection with their audit (true) values. This approach is recommended (and automatically selected) when the items have a monetary value.")
	}

	HelpButton
	{
		toolTip: 	qsTr("Adds a column to specify the audit values of the items.")
		helpPage: 	"?"
	}

	RadioButton
	{
		id: 		binary
		text: 		qsTr("Correct / Incorrect")
		name: 		"binary"
		checked: 	!enable_values
		enabled: 	enable_binary
		info:		qsTr("Annotate the items in the selection with correct (0) or incorrect (1). This approach is recommended (and automatically selected) when your items do not have a monetary value.")
	}

	HelpButton
	{
		toolTip:	qsTr("Adds a column to specify the items as correct (0) or misstated (1).")
		helpPage: 	"?"
	}
}
