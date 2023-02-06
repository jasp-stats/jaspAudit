
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
	title: 			qsTr("Display")

	Row
	{
		spacing: 		5 * preferencesModel.uiScale

		CheckBox
		{
			text: 		qsTr("Explanatory text")
			name: 		"explanatoryText"
			checked: 	true
			info:		qsTr("When checked, enables explanatory text in the analysis to help interpret the procedure and the statistical results.")
		}

		HelpButton
		{
			helpPage:	"Audit/explanatoryText"
			toolTip: 	qsTr("Show explanatory text in the audit report")
		}
	}
}
