
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
	property bool	enable_taints:		false
	property bool	enable_corrections:	false
	property bool	enable_assumptions:	false
	property bool	enable_predictive:	false
	property bool	enable_scatter:		false
	property bool	enable_objectives:	false
	property bool	enable_estimates:	false

	columns:				2

	Group
	{
		title: 				qsTr("Tables")
		info:				qsTr("Add additional tables about the evaluation to the report.")

		CheckBox
		{
			text: 			qsTr("Misstated items")
			name: 			"tableTaints"
			enabled:		enable_taints
			info:			qsTr("Produces a table containing the items in the sample for which the booked (recorded) value does not equal the audit (true) value.")
		}

		CheckBox
		{
			text: 			qsTr("Prior and posterior")
			name: 			"tablePriorPosterior"
			visible:		bayesian
			info:			qsTr("Produces a table that shows statistics for the prior distribution and the posterior distribution.")
		}

		CheckBox
		{
			text: 			qsTr("Corrections to population")
			name: 			"tableCorrections"
			enabled:		enable_corrections
			info:			qsTr("Produces a table that shows the required corrections to the population (in monetary units) after which the conditions outlined in the sampling objectives have been met.")
		}

		CheckBox
		{
			text: 			qsTr("Assumption checks")
			name: 			"tableAssumptions"
			checked: 		enable_assumptions
			enabled: 		enable_assumptions
			visible:		bayesian
			info:			qsTr("Produces a table that displays inference for the correlation between the book values and the taints.")

			CIField
			{
				name: 		"tableAssumptionsConfidence"
				label: 		qsTr("Confidence interval")
				info:		qsTr("Width of the one-sided confidence interval for the population correlation.")
			}
		}
	}

	Group
	{
		title: 				qsTr("Plots")
		info:				qsTr("Add additional figures about the evaluation to the report.")

		CheckBox
		{
			text: 			qsTr("Sampling objectives")
			name: 			"plotObjectives"
			enabled:		enable_objectives
			info:			qsTr("Produces a horizontal bar chart comparing the most likely misstatement (MLE) and quantities relevant to the sampling objectives.")
		}

		CheckBox
		{
			text: 			qsTr("Estimates")
			name: 			"plotEstimates"
			enabled:		enable_estimates
			info:			qsTr("Produces a figure showing the range of plausible values for the misstatement for the population and all subpopulations (if applicable).")
		}

		CheckBox
		{
			text: 			qsTr("Prior and posterior")
			name: 			"plotPosterior"
			visible:		bayesian
			info:			qsTr("Produces a figure that shows the posterior and the posterior distribution.")

			CheckBox
			{
				text: 		qsTr("Additional info")
				name: 		"plotPosteriorInfo"
				checked:	true
				info:		qsTr("Add additional information to the figure, namely a visualization of the Bayes factor and the estimates in text.")
			}
		}

		CheckBox
		{
			text: 			qsTr("Posterior predictive")
			name: 			"plotPosteriorPredictive"
			visible:		bayesian
			enabled:		enable_predictive
			debug:			true
			info:			qsTr("Produces a figure that shows the predictions of the posterior distribution on the data level.")
		}

		CheckBox
		{
			text: 			qsTr("Scatter plot")
			name: 			"plotScatter"
			enabled: 		enable_scatter
			debug:			true
			info:			qsTr("Produces a scatter plot comparing the book values in the sample against their audit values. Items for which these two values do not match are colored in red.")

			CheckBox
			{
				text: 		qsTr("Display correlation")
				name:		"plotScatterCorrelation"
				info:		qsTr("Add a correlation line to the figure.")
			}

			CheckBox
			{
				text: 		qsTr("Display item ID's")
				name:		"plotScatterId"
				info:		qsTr("Display the row number of the misstated items in the figure.")
			}
		}
	}
}
