
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
	readonly	property bool	use_hypergeometric: 	hypergeometric.checked
	readonly	property bool	use_binomial: 			binomial.checked
	readonly	property bool	use_poisson: 			poisson.checked
				property bool	bayesian:				false
				property bool	evaluation:				false
				property bool	enable_hypergeometric: 	false
	
	title: 			bayesian ? qsTr("Distribution") : qsTr("Likelihood")
	name: 			evaluation ? "method" : "likelihood"

	RadioButton
	{
		id: 		hypergeometric
		text: 		bayesian ? qsTr("Beta-binomial") : qsTr("Hypergeometric")
		name: 		"hypergeometric"
		enabled:	enable_hypergeometric
	}

	RadioButton
	{
		id: 		binomial
		text: 		bayesian ? qsTr("Beta") : qsTr("Binomial")
		name: 		"binomial"
		checked: 	true
	}

	RadioButton
	{
		id: 		poisson
		text: 		bayesian ? qsTr("Gamma") : qsTr("Poisson")
		name: 		"poisson"
	}
}