
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
	readonly	property bool	use_mus:		values_sampling.checked
				property bool	enable:			true
				property bool	enable_mus:		false
				property bool	force_mus:		false

	id: 			units
	title:			qsTr("Sampling Units")
	name: 			"units"
	columns:		2
	enabled:		enable
	info:			qsTr("Choose which type of units are eligible for selection.")

	RadioButton
	{
		id: 		rows_sampling
		text: 		qsTr("Items")
		name: 		"items"
		checked:	!enable_mus
		enabled:	!force_mus
		info:		qsTr("Performs selection using the items (rows) in the population as sampling units.")
	}

	HelpButton
	{
		toolTip: 	qsTr("Click to learn more about this method")
		helpPage:	"Audit/recordSampling"
	}

	RadioButton
	{
		id: 		values_sampling
		text: 		qsTr("Monetary units")
		name: 		"values"
		enabled: 	enable_mus
		checked:	enable_mus
		info:		qsTr("Performs selection using the monetary units in the population as sampling units. This method is preferred when you want to include more items with a high value in the sample.")
	}

	HelpButton
	{
		helpPage:	"Audit/monetaryUnitSampling"
		toolTip: 	qsTr("Click to learn more about this method")
	}
}
