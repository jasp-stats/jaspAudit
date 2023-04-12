
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
	readonly	property bool 	use_pooling:	pooling.checked
	readonly	property bool 	use_partial:	partial.checked
				property bool	enable:			true
				property bool	hide_pooling:	true
				property bool	enable_pooling:	true
				property bool	enable_partial:	true

	title:				qsTr("Algorithm")
	enabled:			enable

	Row
	{
		spacing: 		5 * preferencesModel.uiScale

		CheckBox
		{
			id:			partial
			text: 		qsTr("Partial projection")
			name: 		"separateMisstatement"
			info:		qsTr("This algorithm enables you to separate the known and the unknown misstatement in the population to be more efficient. Note that this requires the assumption that the taints in the sample are representative of the taints in the unseen part of the population.")
			enabled:	enable_partial && !pooling.checked
		}

		HelpButton
		{
			toolTip: 	qsTr("Click to learn more about this algorithm")
			helpPage:	"Audit/extrapolation"
		}
	}

	Row
	{
		spacing: 		5 * preferencesModel.uiScale
		enabled:		enable_pooling
		visible:		!hide_pooling

		CheckBox
		{
			id:			pooling
			text:		qsTr("Share information")
			name:		"pooling"
			enabled:	!partial.checked
			info:		qsTr("This algorithm enables you to share information about the misstatement across different subgroups in the population (strata).")
		}

		HelpButton
		{
			toolTip: 	qsTr("Click to learn more about this algorithm")
			helpPage:	"Audit/pooling"
		}
	}
}
