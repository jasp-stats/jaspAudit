
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
	name:			"bayesFactorType"
	title:			"Bayes Factor"
	info:			qsTr("Choose which type of Bayes factor to display.")
	debug:			true

	RadioButton
	{
		name:		"BF10"
		text:		qsTr("BF\u2081\u2080")
		checked:	true
		info:		qsTr("Bayes factor to quantify evidence for the alternative hypothesis relative to the null hypothesis.")
	}

	RadioButton
	{
		name:		"BF01"
		text:		qsTr("BF\u2080\u2081")
		info:		qsTr("Bayes factor to quantify evidence for the null hypothesis relative to the alternative hypothesis.")
	}

	RadioButton
	{
		name:		"logBF10"
		text:		qsTr("Log(BF\u2081\u2080)")
		info:		qsTr("Natural logarithm of BF10.")
	}
}
