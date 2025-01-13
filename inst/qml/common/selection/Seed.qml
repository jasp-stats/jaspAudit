
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

IntegerField
{
	property bool	enable:	false

	id:				seed
	text:			qsTr("Seed")
	name:			"seed"
	defaultValue:	Math.floor(Math.random() * 1000) // Init with random integer in [1,...,999]
	min:			-999
	max:			999
	enabled:		enable
	info:			qsTr("Selects the seed for the random number generator in order to reproduce results.")
}
