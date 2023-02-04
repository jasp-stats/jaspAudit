
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

		CheckBox
		{
			text: 			qsTr("Misstated items")
			name: 			"tableTaints"
			enabled:		enable_taints
		}

		CheckBox
		{
			text: 			qsTr("Prior and posterior")
			name: 			"tablePriorPosterior"
			visible:		bayesian
		}

		CheckBox
		{
			text: 			qsTr("Corrections to population")
			name: 			"tableCorrections"
			enabled:		enable_corrections
		}

		CheckBox
		{
			text: 			qsTr("Assumption checks")
			name: 			"tableAssumptions"
			checked: 		enable_assumptions
			enabled: 		enable_assumptions
			visible:		bayesian

			CIField
			{
				name: 		"tableAssumptionsConfidence"
				label: 		qsTr("Confidence interval")
			}
		}
	}

	Group
	{
		title: 				qsTr("Plots")

		CheckBox
		{
			text: 			qsTr("Sampling objectives")
			name: 			"plotObjectives"
			enabled:		enable_objectives
		}

		CheckBox
		{
			text: 			qsTr("Estimates")
			name: 			"plotEstimates"
			enabled:		enable_estimates
		}

		CheckBox
		{
			text: 			qsTr("Prior and posterior")
			name: 			"plotPosterior"
			visible:		bayesian

			CheckBox
			{
				text: 		qsTr("Additional info")
				name: 		"plotPosteriorInfo"
				checked:	true
			}
		}

		CheckBox
		{
			text: 			qsTr("Posterior predictive")
			name: 			"plotPosteriorPredictive"
			visible:		bayesian
			enabled:		enable_predictive
			debug:			true
		}

		CheckBox
		{
			text: 			qsTr("Scatter plot")
			name: 			"plotScatter"
			enabled: 		enable_scatter
			debug:			true

			CheckBox
			{
				text: 		qsTr("Display correlation")
				name:		"plotScatterCorrelation"
			}

			CheckBox
			{
				text: 		qsTr("Display item ID's")
				name:		"plotScatterId"
			}
		}
	}
}
