
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

RadioButtonGroup
{
	property bool	use_materiality:	false

	name: 						"prior_method"
	text:						qsTr("Construction Method")

	RadioButton
	{
		name: 					"default"
		label:					qsTr("Default")
		checked:				true
	}

	RadioButton
	{
		id: 					param
		name: 					"param"
		label: 					qsTr("Manual")
		childrenOnSameRow: 		true

		Row
		{
			spacing: 			10 * preferencesModel.uiScale

			DoubleField
			{
				name: 			"alpha"
				label:			qsTr("\u03B1")
				min:			1
				defaultValue: 	1
			}

			DoubleField
			{
				name: 			"beta"
				label:			qsTr("\u03B2")
				min:			0
				defaultValue: 	1
			}
		}
	}

	RadioButton
	{
		id: 					sample
		name: 					"sample"
		label: 					qsTr("Earlier sample")
		childrenOnSameRow: 		true

		Row
		{
			spacing: 			10 * preferencesModel.uiScale

			IntegerField
			{
				id:				n_prior
				name: 			"n_prior"
				label:			qsTr("Size")
				min:			x_prior.value
				defaultValue: 	0
			}

			DoubleField
			{
				id:				x_prior
				name: 			"x_prior"
				label:			qsTr("Errors")
				min:			0
				max:			n_prior.value
				defaultValue: 	0
				decimals:		3
			}
		}
	}

	RadioButton
	{
		name: 					"impartial"
		label:					qsTr("Impartial")
		enabled:				use_materiality
	}

	RadioButton
	{
		id: 					arm
		name: 					"arm"
		label:					qsTr("Risk assessments")
		enabled:				use_materiality

		Common.AuditRiskModel { show_title: false }
	}
}
