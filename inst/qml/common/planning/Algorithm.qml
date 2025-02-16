
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
	readonly	property bool 	use_pooling:	pooling.checked
	readonly	property bool 	use_partial:	partial.checked
	readonly	property bool 	use_hurdle:		hurdle.checked
				property bool	enable:			true
				property bool	hide_pooling:	true
				property bool	hide_hurdle:	true
				property bool	enable_pooling:	true
				property bool	enable_partial:	true
				property bool	enable_hurdle:	true

	title:				qsTr("Algorithm")
	enabled:			enable

	Row
	{
		spacing: 		5 * preferencesModel.uiScale

		CheckBox
		{
			id:			partial
			text: 		qsTr("Partial projection")
			name: 		"separateMisstatement"
			info:		qsTr("This algorithm enables you to separate the known and the unknown misstatement in the population to be more efficient. Note that this requires the assumption that the taints in the sample are representative of the taints in the unseen part of the population.")
			enabled:	enable_partial && !pooling.checked
		}

		HelpButton
		{
			toolTip: 	qsTr("Click to learn more about this algorithm")
			helpPage:	"Audit/extrapolation"
		}
	}

	Row
	{
		spacing: 		5 * preferencesModel.uiScale
		enabled:		enable_pooling
		visible:		!hide_pooling

		CheckBox
		{
			id:			pooling
			text:		qsTr("Share information")
			name:		"pooling"
			enabled:	!partial.checked
			info:		qsTr("This algorithm enables you to share information about the misstatement across different subgroups in the population (strata).")
		}

		HelpButton
		{
			toolTip: 	qsTr("Click to learn more about this algorithm")
			helpPage:	"Audit/pooling"
		}
	}

	Row
	{
		spacing: 		5 * preferencesModel.uiScale
		enabled:		enable_hurdle
		visible:		!hide_hurdle

		CheckBox
		{
			id:			hurdle
			text:		qsTr("Hurdle model")
			name:		"hurdle"
			enabled:	!partial.checked
			info:		qsTr("This algoritm enables you to consider the individal taints.")
		}

		HelpButton
		{
			toolTip: 	qsTr("Click to learn more about this algorithm")
			helpPage:	"Audit/hurdle"
		}
	}

	Section
	{
		title:						qsTr("MCMC Options")
		enabled:					hurdle.checked || enable_pooling
		info:						qsTr("Options to customize the MCMC sampling process.")
		visible:					!(hide_hurdle && hide_pooling)

		Group
		{
			IntegerField
			{
				id:					warmup
				name:				"warmup"
				text:				qsTr("Warmup")
				defaultValue:		1000
				min:				100
				max:				iter.value
				fieldWidth:			60 * preferencesModel.uiScale
				Layout.leftMargin:	15 * preferencesModel.uiScale
				info:				qsTr("Sets the number of warmup MCMC iterations.")
			}

			IntegerField
			{
				id:					iter
				name:				"iter"
				text:				qsTr("Iterations")
				defaultValue:		2000
				min:				warmup.value
				max:				10000
				fieldWidth:			60 * preferencesModel.uiScale
				Layout.leftMargin:	15 * preferencesModel.uiScale
				info:				qsTr("Sets the total number of MCMC iterations.")
			}

			IntegerField
			{
				name:				"chains"
				text:				qsTr("Chains")
				defaultValue:		4
				min:				1
				max:				10
				fieldWidth:			60 * preferencesModel.uiScale
				Layout.leftMargin:	15 * preferencesModel.uiScale
				info:				qsTr("Sets the number of MCMC chains.")
			}

			IntegerField
			{
				name:				"mcmc.seed"
				text:				qsTr("Seed")
				defaultValue:		Math.floor(Math.random() * 1000) // Init with random integer in [1,...,999]
				min:				-999
				max:				999
				fieldWidth:			60 * preferencesModel.uiScale
				Layout.leftMargin:	15 * preferencesModel.uiScale
				info:				qsTr("Selects the seed for the random number generator in order to reproduce results.")
			}
		}
	}
}
