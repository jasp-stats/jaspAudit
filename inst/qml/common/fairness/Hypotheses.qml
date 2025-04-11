
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

RadioButtonGroup
{
	title: 			qsTr("Alt. Hypothesis")
	name: 			"alternative"
	info:			qsTr("Specify the alternative hypothesis.")

	RadioButton
	{
		text: 		qsTr("Unprivileged \u2260 Privileged")
		name: 		"two.sided"
		checked:	true
		info:		qsTr("Test the alternative hypothesis that the fairness metric of an unprivileged group is not equal to the fairness metric in the privileged group.")
	}

	RadioButton
	{
		text: 		qsTr("Unprivileged < Privileged")
		name: 		"less"
		info:		qsTr("Test the alternative hypothesis that the fairness metric of an unprivileged group is lower than the fairness metric in the privileged group.")
	}

	RadioButton
	{
		text: 		qsTr("Unprivileged > Privileged")
		name: 		"greater"
		info:		qsTr("Test the alternative hypothesis that the fairness metric of an unprivileged group is higher than the fairness metric in the privileged group.")
	}
}
