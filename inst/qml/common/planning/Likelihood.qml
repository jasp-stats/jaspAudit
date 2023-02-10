
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
				property bool	enable:					true
				property bool	evaluation:				false
				property bool	enable_hypergeometric: 	false
				property bool	enable_poisson: 		true
	
	title: 			bayesian ? qsTr("Distribution") : qsTr("Likelihood")
	name: 			evaluation ? "method" : "likelihood"
	enabled:		enable
	info:			qsTr("The likelihood is a function that relates the statistical model to the observed data. Specifically, it quantifies the probability of observing the data given the parameters of the model.")

	RadioButton
	{
		id: 		hypergeometric
		text: 		bayesian ? qsTr("Beta-binomial") : qsTr("Hypergeometric")
		name: 		"hypergeometric"
		enabled:	enable_hypergeometric
		info:		qsTr("The hypergeometric distribution assumes a finite population size and is therefore generally used when the population size is small. It is a probability distribution that models the number of errors (*K*) in the population as a function of the population size (*N*), the number of observed found errors (*k*) and the number of correct transactions (*n*). In a Bayesian analysis, the conjugate prior for the hypergeometric likelihood is the beta-binomial distribution.")
	}

	RadioButton
	{
		id: 		binomial
		text: 		bayesian ? qsTr("Beta") : qsTr("Binomial")
		name: 		"binomial"
		checked: 	true
		info:		qsTr("The binomial distribution assumes an infinite population size and is therefore generally used when the population size is large. It is a probability distribution that models the rate of misstatement (*\u03B8*) as a function of the observed number of errors (*k*) and the number of correct transactions (*n - k*). In a Bayesian analysis, the conjugate prior for the binomial likelihood is the beta distribution.")
	}

	RadioButton
	{
		id: 		poisson
		text: 		bayesian ? qsTr("Gamma") : qsTr("Poisson")
		name: 		"poisson"
		enabled:	enable_poisson
		info:		qsTr("The Poisson distribution assumes an infinite population size and is therefore generally used when the population size is large. It is a probability distribution that models the rate of misstatement (*\u03B8*) as a function of the observed sample size (*n*) and the sum of the proportional errors (*t*). In a Bayesian analysis, the conjugate prior for the Poisson likelihood is the gamma distribution.")
	}
}
