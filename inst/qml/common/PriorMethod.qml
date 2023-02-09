
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
	readonly	property bool	use_expected:		prior_method.value == "impartial" || prior_method.value == "arm"
				property bool	use_materiality:	false

	title:					qsTr("Elicitation")
	info:					qsTr("Choose how to construct the prior distribution.")

	DropDown
	{
		id: 				prior_method
		name: 				"prior_method"
		indexDefaultValue: 	 0
		startValue:			"default"
		label: 				qsTr("Method")
		values: use_materiality ? [
			{ label: qsTr("Default"),			value: "default" },
			{ label: qsTr("Manual"), 			value: "param" },
			{ label: qsTr("Earlier sample"), 	value: "sample" },
			{ label: qsTr("Impartial"), 		value: "impartial"},
			{ label: qsTr("Risk assessments"), 	value: "arm"}
		] : [
			{ label: qsTr("Default"),			value: "default" },
			{ label: qsTr("Manual"), 			value: "param" },
			{ label: qsTr("Earlier sample"), 	value: "sample" }
		]
		info:				qsTr("Indicate the type of available audit information that should be incorporated into the prior distribution.")
	}

	DoubleField
	{
		name: 				"alpha"
		label:				qsTr("Prior parameter \u03B1")
		min:				1
		defaultValue: 		1
		visible:			prior_method.value == "param"
		info:				qsTr("The \u03B1 parameter of the prior distribution.")
	}

	DoubleField
	{
		name: 				"beta"
		label:				qsTr("Prior parameter \u03B2")
		min:				0
		defaultValue: 		1
		visible:			prior_method.value == "param"
		info:				qsTr("The \u03B2 parameter of the prior distribution.")
	}

	IntegerField
	{
		id:					n_prior
		name: 				"n_prior"
		label:				qsTr("Sample size")
		min:				x_prior.value
		defaultValue: 		1
		visible:			prior_method.value == "sample"
		info:				qsTr("The number of sampling units audited through an earlier sample.")
	}

	DoubleField
	{
		id:					x_prior
		name: 				"x_prior"
		label:				qsTr("Misstatements")
		min:				0
		max:				n_prior.value
		defaultValue: 		0
		decimals:			3
		visible:			prior_method.value == "sample"
		info:				qsTr("The number of misstatements found through an earlier sample.")
	}

	Common.AuditRiskModel { hide: prior_method.value != "arm" }
}
