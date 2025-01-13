
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
	readonly	property bool	use_values:	audit_values.count > 0
				property bool	binary:		false

	id: 			audit_values
	name: 			"values.audit"
	title: 			binary ? qsTr("Audit Result (required)") : qsTr("Audit Values (required)")
	singleVariable: true
	allowedColumns: ["nominal", "scale"]
	info:			qsTr("A numeric variable that contains the audited (true) values of the items in the population, or a binary variable that contains a 0 (correct item) or a 1 (misstated item) for each row.")
}
