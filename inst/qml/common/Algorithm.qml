
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
	readonly	property bool 	use_algorithm1:		algorithm1.checked
	readonly	property bool 	use_algorithm2:		algorithm2.checked
				property bool	enable:				true
				property bool	hide_algorithm1:	true
				property bool	enable_algorithm1:	true
				property bool	enable_algorithm2:	true

	title:				qsTr("Algorithm")
	enabled:			enable

	Row
	{
		spacing: 		5 * preferencesModel.uiScale
		enabled:		enable_algorithm1
		visible:		!hide_algorithm1

		CheckBox
		{
			id:			algorithm1
			text:		qsTr("Share information")
			name:		"pooling"
		}

		HelpButton
		{
			toolTip: 	qsTr("Click to learn more about this algorithm")
			helpPage:	"Audit/pooling"
		}
	}

	Row
	{
		spacing: 		5 * preferencesModel.uiScale
		enabled:		enable_algorithm2

		CheckBox
		{
			id:			algorithm2
			text: 		qsTr("Partial projection")
			name: 		"separateMisstatement"
		}

		HelpButton
		{
			toolTip: 	qsTr("Click to learn more about this algorithm")
			helpPage:	"Audit/extrapolation"
		}
	}
}
