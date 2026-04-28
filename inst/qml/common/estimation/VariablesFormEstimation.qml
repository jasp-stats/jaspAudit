
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

VariablesForm
{
	id: 						variablesFormEstimation
	preferredHeight: 			jaspTheme.smallDefaultVariablesFormHeight

	AvailableVariablesList
	{
		name: 					"variablesFormEstimation"
	}

	AssignedVariablesList
	{
		id: 					bookValues
		name: 					"bookValues"
		title: 					qsTr("Book Value")
		singleVariable:			true
		allowedColumns:			["scale"]
		minNumericLevels:		1
		enabled: 				!mpu.checked
		info:					qsTr("A numeric variable that contains the book (recorded) values of the items in the population.")
	}

	AssignedVariablesList
	{
		id: 					auditValues
		name: 					"auditValues"
		title: 					qsTr("Audit Value")
		singleVariable: 		true
		allowedColumns: 		["scale"]
		minNumericLevels:		1
		info:					qsTr("A numeric variable that contains the audited (true) values of the items in the population.")
	}
}
