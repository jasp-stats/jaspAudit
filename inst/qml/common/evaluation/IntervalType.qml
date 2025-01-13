
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
	readonly	property bool	use_right:		less.checked
	readonly	property bool	use_twosided:	less.checked
	readonly	property bool	use_left:		greater.checked
				property bool	bayesian:		false
				property bool	test:			false
				property bool	enable:			true

	title: 			test ? (bayesian ? qsTr("Credible Interval (Alt. Hypothesis)") : qsTr("Confidence Interval (Alt. Hypothesis)")) : (bayesian ? qsTr("Credible Interval") : qsTr("Confidence Interval"))
	name: 			"area"
	info:			qsTr("Specify the type of interval and the alternative hypothesis.")

	RadioButton
	{
		id:			less
		text: 		test ? qsTr("Upper bound (< materiality)") : qsTr("Upper bound")
		name: 		"less"
		checked:	true
		info:		qsTr("Produces a one-sided upper bound for the misstatement in the population.")
	}

	RadioButton
	{
		id:			twosided
		text: 		test ? qsTr("Two-sided (\u2260 materiality)") : qsTr("Two-sided")
		name: 		"two.sided"
		info:		qsTr("Produces a two-sided interval for the misstatement in the population.")
		enabled:	enable
	}

	RadioButton
	{
		id:			greater
		text: 		test ? qsTr("Lower bound (> materiality)") : qsTr("Lower bound")
		name: 		"greater"
		info:		qsTr("Produces a one-sided lower bound for the misstatement in the population.")
		enabled:	enable
	}
}
