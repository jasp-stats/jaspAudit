
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

AssignedVariablesList
{
	readonly	property bool	use_id:	id.count > 0

	id:									id
	name:								"id"
	title:								qsTr("Item ID (required)")
	singleVariable:						true
	allowedColumns:						["nominal", "ordinal", "scale"]
	allowAnalysisOwnComputedColumns:	false
	info:								qsTr("A unique non-missing identifier for every item in the population. The row number of the items is sufficient.")
}
