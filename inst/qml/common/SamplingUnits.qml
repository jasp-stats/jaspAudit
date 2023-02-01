
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
	readonly	property bool	use_mus:		values_sampling.checked
				property bool	enable:			true
				property bool	enable_mus:		false
				property bool	force_mus:		false

	id: 			units
	title:			qsTr("Sampling Units")
	name: 			"units"
	columns:		2
	enabled:		enable

	RadioButton
	{
		id: 		rows_sampling
		text: 		qsTr("Items")
		name: 		"items"
		checked:	!enable_mus
		enabled:	!force_mus
	}

	HelpButton
	{
		toolTip: 	qsTr("Click to learn more about record sampling.")
		helpPage:	"Audit/recordSampling"
	}

	RadioButton
	{
		id: 		values_sampling
		text: 		qsTr("Monetary units")
		name: 		"values"
		enabled: 	enable_mus
		checked:	enable_mus
	}

	HelpButton
	{
		helpPage:	"Audit/monetaryUnitSampling"
		toolTip: 	qsTr("Click to learn more about monetary unit sampling.")
	}
}
