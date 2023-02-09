
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
	readonly	property bool	use_population:	population.checked
	readonly	property bool	use_sample:		sample.checked
	readonly	property bool	use_stats:		stats.checked

	name:									"dataType"
	title:									qsTr("Data Type")
	info:									qsTr("The type of input data for the analysis.")

	RadioButton
	{
		id: 								population
		name: 								"pdata"
		label:								qsTr("Population")
		enabled:							mainWindow.dataAvailable
		info:								qsTr("Use the population as input data.")
	}

	RadioButton
	{
		id: 								sample
		name: 								"data"
		label:								qsTr("Sample")
		checked: 							mainWindow.dataAvailable
		enabled:							mainWindow.dataAvailable
		info:								qsTr("Use a sample of the population as input data.")
	}

	RadioButton
	{
		id: 								stats
		name: 								"stats"
		label:								qsTr("Summary statistics")
		checked: 							!mainWindow.dataAvailable
		info:								qsTr("Use summary statistics from a sample as input data.")

		Group
		{
			IntegerField
			{
				id: 						n
				name: 						"n"
				text: 						qsTr("Sample size")
				defaultValue: 				0
				min: 						x.value
				visible:					stats.checked
				info:						qsTr("The number of sampling units that have been audited.")
			}

			DoubleField
			{
				id:							x
				name: 						"x"
				text: 						qsTr("Misstatements")
				defaultValue: 				0
				min: 						0
				visible:					stats.checked
				max:						n.value
				decimals:					3
				info:						qsTr("The number of misstatements that have been found in the sample.")
			}
		}
	}
}
