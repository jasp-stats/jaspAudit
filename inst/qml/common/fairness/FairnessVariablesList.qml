
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
	preferredHeight:		jaspTheme.smallDefaultVariablesFormHeight

	AvailableVariablesList
	{
		name: 				"variablesFormFairness"
	}
	AssignedVariablesList
	{
		name: 				"target"
		title: 				qsTr("Ground Truth Information")
		singleVariable:		true
		allowedColumns:		["nominal"]
		minLevels:			2
		info:				qsTr("In this column, the ground truth information (i.e., the target to be predicted) variable should be entered.")
	}
	AssignedVariablesList
	{
		name: 				"predictions"
		title: 				qsTr("Predictions")
		singleVariable:		true
		allowedColumns:		["nominal"]
		minLevels:			2
		info:				qsTr("In this column, the predictions of the algorithm should be entered.")
	}
	AssignedVariablesList
	{
		name: 				"protected"
		title: 				qsTr("Sensitive Attribute")
		singleVariable:		true
		allowedColumns:		["nominal"]
		minLevels:			2
		info:				qsTr("In this column, the protected (i.e., sensitive) attribute should be entered.")
	}
}
