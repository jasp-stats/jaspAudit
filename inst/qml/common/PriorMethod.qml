
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

import "./" as Common

Group
{
	property bool	use_materiality:	false

	title:					qsTr("Elicitation")

	DropDown
	{
		id: 				prior_method
		name: 				"prior_method"
		indexDefaultValue: 	 0
		startValue:			"default"
		label: 				qsTr("Method")
		values: [
			{ label: qsTr("Default"),			value: "default"},
			{ label: qsTr("Manual"), 			value: "param"},
			{ label: qsTr("Earlier sample"), 	value: "sample"},
			{ label: qsTr("Impartial"), 		value: "impartial"},
			{ label: qsTr("Risk assessments"), 	value: "arm"}
		]
	}

	DoubleField
	{
		name: 				"alpha"
		label:				qsTr("Prior parameter \u03B1")
		min:				1
		defaultValue: 		1
		visible:			prior_method.value == "param"
	}

	DoubleField
	{
		name: 				"beta"
		label:				qsTr("Prior parameter \u03B2")
		min:				0
		defaultValue: 		1
		visible:			prior_method.value == "param"
	}

	IntegerField
	{
		id:					n_prior
		name: 				"n_prior"
		label:				qsTr("Sample size")
		min:				x_prior.value
		defaultValue: 		0
		visible:			prior_method.value == "sample"
	}

	DoubleField
	{
		id:					x_prior
		name: 				"x_prior"
		label:				qsTr("Number of misstatements")
		min:				0
		max:				n_prior.value
		defaultValue: 		0
		decimals:			3
		visible:			prior_method.value == "sample"
	}

	Common.AuditRiskModel { hide: prior_method.value != "arm" }
}
