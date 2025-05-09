
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

import "./common" as Common
import "./common/estimation" as Estimation

Form
{
	columns:						1
	info:							qsTr("The Bayesian estimation analysis allows the user to estimate the true value of a population on the basis of a sample.")

	Estimation.VariablesFormEstimation { }
	Estimation.Confidence { }
	Estimation.Population { disableValues: estimator.useMpu }
	Estimation.Estimator { id: estimator }
	Common.ExplanatoryText { }

	Section
	{
		title:						qsTr("Prior")
		columns:					1

		Group
		{
			DoubleField
			{
				name: 				"priorMu"
				text: 				qsTr("Prior mean \u03BC")
				defaultValue: 		0
				negativeValues:		true
				decimals: 			2
				info:				qsTr("The prior parameter for the mean.")
			}

			DoubleField
			{
				name: 				"priorKappa"
				text: 				qsTr("Prior mean weight \u03BA")
				defaultValue: 		0
				min: 				0
				decimals: 			2
				info:				qsTr("The prior parameter for the implicit sample size of the mean.")
			}

			DoubleField
			{
				name: 				"priorSigma2"
				text: 				qsTr("Prior variance \u03C32")
				defaultValue: 		0
				min: 				0
				decimals: 			2
				info:				qsTr("The prior parameter for the variance.")
			}

			DoubleField
			{
				name: 				"priorNu"
				text: 				qsTr("Prior variance weight \u03BD")
				defaultValue: 		0
				min: 				0
				decimals: 			2
				info:				qsTr("The prior parameter for the implicit sample size of the variance.")
			}
		}
	}

	Section
	{
		title:						qsTr("Report")
		columns:					1

		Group
		{
			title: 					qsTr("Plots")
			info:					qsTr("Add additional figures about the analysis to the report.")
			Estimation.Scatterplot { disable: estimator.useMpu }

			CheckBox
			{
				text: 		qsTr("Prior and posterior")
				name: 		"priorAndPosteriorPlot"
				info:		qsTr("Produces a figure showing the prior and posterior distributions for the true population value.")
			}
		}

	}

	Common.DownloadReport { }
}
