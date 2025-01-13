
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
	property bool	enable:	true

	title:				qsTr("Iterations")
	enabled:			enable
	info:				qsTr("Specify how the sample size is computed.")
	
	IntegerField
	{
		name: 			"by"
		text: 			qsTr("Increment")
		min: 			1
		max:			50
		defaultValue: 	1
		info:			qsTr("The increment alows you to limit the possible sample sizes to a multiple of its value. For example, an increment of 5 allows only sample sizes of 5, 10, 15, 20, 25, etc.")
	}

	IntegerField
	{
		name: 			"max"
		text: 			qsTr("Maximum")
		min: 			2
		defaultValue: 	5000
		info:			qsTr("The maximum sample size after which the algorithm terminates.")
	}
}
