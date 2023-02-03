
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
	property bool	bayesian:	false

	title: 			bayesian ? qsTr("Credible Interval") : qsTr("Confidence Interval")
	name: 			"area"

	RadioButton
	{
		text: 		qsTr("One-sided upper bound")
		name: 		"area_bound"
		checked:	true
	}

	RadioButton
	{
		text: 		qsTr("Two-sided interval")
		name: 		"area_interval"
	}
}
