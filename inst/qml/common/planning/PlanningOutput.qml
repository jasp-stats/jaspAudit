
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

Group
{
	property bool	bayesian:			false
	property bool	disable_predictive: true
	property bool	workflow:			false
	property bool   enable_values:		false

	columns:			2
	
	Group
	{
		title: 			qsTr("Tables")
		visible:		bayesian || workflow
		info:			qsTr("Add additional tables about the planning to the report.")

		CheckBox
		{
			text: 		qsTr("Prior and posterior")
			name: 		"tablePrior"
			visible:	bayesian
			info:		qsTr("Produces a table that shows statistics for the prior distribution and the posterior distribution.")
		}

		CheckBox
		{
			text: 		qsTr("Descriptive statistics")
			name: 		"tableBookDist"
			visible:	workflow
			enabled:	enable_values
			info:		qsTr("Produces a table showing descriptive statistics of the *Book Value* column in the data set.")
		}
	}

	Group
	{
		title: 			qsTr("Plots")
		info:			qsTr("Add additional figures about the planning to the report.")

		CheckBox
		{
			text: 		qsTr("Compare sample sizes")
			name: 		"plotSampleSizes"
			debug:		true
			info:		qsTr("Produces a plot that compares the sample size 1) across probability distributions, and 2) across the number of expected errors in the sample.")
		}

		CheckBox
		{
			text: 		qsTr("Presumed data distribution")
			name: 		"plotErrorDist"
			visible:	!bayesian
			info:		qsTr("Produces a figure that displays the probability distribution implied by the input options and the calculated sample size.")
		}

		CheckBox
		{
			name: 		"plotBookDist"
			text: 		qsTr("Distribution of book values")
			visible:	workflow
			enabled:	enable_values
			info:		qsTr("Produces a histogram of the *Book Value* column in the data set.")
		}

		CheckBox
		{
			text: 		qsTr("Prior distribution")
			name: 		"plotPrior"
			visible:	bayesian
			info:		qsTr("Produces a figure that shows the prior distribution.")

			CheckBox
			{
				text: 		qsTr("Posterior distribution")
				name: 		"plotPriorWithPosterior"
				checked:	true
				info:		qsTr("Produces a figure that shows the prior distribution and the intended posterior distribution.")
			}
		}

		CheckBox
		{
			text: 		qsTr("Prior predictive distribution")
			name: 		"plotPriorPredictive"
			visible:	bayesian
			enabled:	!disable_predictive
			info:		qsTr("Produces a figure that shows the predictions of the prior distribution on the data level for the intended sample.")
		}
	}
}
