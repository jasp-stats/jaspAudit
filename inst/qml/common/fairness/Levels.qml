
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
	title:					qsTr("Levels")
	info:					qsTr("These options allow specification of the privileged group and the positive class.")

	DropDown
	{
		label: 				qsTr("Privileged group")
		name: 				"privileged"
		indexDefaultValue: 	0
		addEmptyValue: 		true
		placeholderText:	qsTr("None")
		source: 			[ { name: "protected", use: "levels" } ]
		info:				qsTr("The privileged group refers to the class in the protected variable that historically or systematically experiences certain advantages, benefits, or privileges.")
	}

	DropDown
	{
		label: 				qsTr("Positive class")
		name: 				"positive"
		indexDefaultValue: 	0
		addEmptyValue: 		true
		placeholderText:	qsTr("None")
		source: 			[ { name: "target", use: "levels" } ]
		info:				qsTr("The positive class in the target variable.")
	}
}
