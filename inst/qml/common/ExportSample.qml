
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

Section
{
	property bool	enabled:	false
	
	title: 							qsTr("Export")

	Group
	{
		enabled: 					enabled

		ComputedColumnField
		{
			id:						name_indicator
			name: 					"name_indicator"
			text: 					qsTr("Column name selection result")
			placeholderText: 		qsTr("e.g. selected")
			fieldWidth: 			120 * preferencesModel.uiScale
		}

		Row 
		{
			spacing: 				5 * preferencesModel.uiScale

			FileSelector
			{
				id:					file
				name:				"file"
				label:				qsTr("Save as")
				placeholderText: 	qsTr("e.g. sample.csv")
				filter:				"*.csv"
				save:				true
				fieldWidth:			180 * preferencesModel.uiScale
			}

			CheckBox
			{
				name: 				"export_sample"
				text: 				qsTr("Export sample to file")
				enabled:			name_indicator.value != "" && file.value != ""
			}
		}
	}
}
