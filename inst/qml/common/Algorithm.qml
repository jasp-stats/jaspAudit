
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

Group
{
	readonly	property bool 	use_pooling:	pooling.checked
	readonly	property bool 	use_partial:	partial.checked
				property bool	enable:			true
				property bool	hide_pooling:	true
				property bool	enable_pooling:	true
				property bool	enable_partial:	true

	title:							qsTr("Algorithm")
	enabled:						enable

	Row
	{
		spacing: 					5 * preferencesModel.uiScale
		enabled:					enable_partial && !pooling.checked

		CheckBox
		{
			id:						partial
			text: 					qsTr("Partial projection")
			name: 					"separateMisstatement"
		}

		HelpButton
		{
			toolTip: 				qsTr("Click to learn more about this algorithm")
			helpPage:				"Audit/extrapolation"
		}
	}

	Row
	{
		spacing: 					5 * preferencesModel.uiScale
		enabled:					enable_pooling
		visible:					!hide_pooling

		CheckBox
		{
			id:						pooling
			text:					qsTr("Share information")
			name:					"pooling"
			enabled:				!partial.checked

			Group
			{
				IntegerField
				{
					id:				mciterations
					name:			"mc_iterations"
					text:			qsTr("Iterations")
					visible:		pooling.checked
					defaultValue:	2000
					min:			200
				}

				IntegerField
				{
					name:			"mc_warmup"
					text:			qsTr("Burnin")
					visible:		pooling.checked
					defaultValue:	1000
					min:			100
					max:			mciterations.value - 1
				}

				IntegerField
				{
					name:			"mc_chains"
					text:			qsTr("Chains")
					visible:		pooling.checked
					defaultValue:	4
					min:			1
					max:			4
				}
			}
		}

		HelpButton
		{
			toolTip: 				qsTr("Click to learn more about this algorithm")
			helpPage:				"Audit/pooling"
		}
	}
}
