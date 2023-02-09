
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

import "../selection" as Selection
import "./" as Evaluation

VariablesForm
{
	readonly	property bool	use_id:			id.use_id
	readonly	property bool	use_book:		values.use_book
	readonly	property bool	use_real:		audit_values.use_values
	readonly	property bool	use_strata:		stratum_indicator.count > 0
				property bool	use_population: false
				property bool	use_sample:		false
				property bool	show_strata:	true

	preferredHeight: 		260 * preferencesModel.uiScale
	enabled:				use_population || use_sample
	visible:				use_population || use_sample

	AvailableVariablesList
	{
		name: 				"variables"
	}

	Selection.IdVariable { id: id }
	Selection.BookVariable { id: values }
	Evaluation.AuditVariable { id: audit_values; binary: true }

	AssignedVariablesList
	{
		id: 				sample_indicator
		name: 				"times"
		title: 				use_sample ? qsTr("Selection Counter (optional)") : qsTr("Selection Counter (required)")
		singleVariable: 	true
		allowedColumns: 	["nominal", "ordinal", "scale"]
		info:				qsTr("An ordinal variable that indicates how many sampling units are selected for each item and thus how many times the item should be counted in the evaluation.")
	}
	
	AssignedVariablesList
	{
		id: 				stratum_indicator
		name: 				"stratum"
		title: 				qsTr("Stratum (optional)")
		singleVariable: 	true
		allowedColumns: 	["nominal", "nominalText", "ordinal"]
		visible:			show_strata
		info:				qsTr("A nominal variable that indicates to which subgroup (strata) of the population an item belongs.")
	}
}
