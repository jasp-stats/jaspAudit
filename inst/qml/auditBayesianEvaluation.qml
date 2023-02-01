//
// Copyright (C) 2013-2018 University of Amsterdam
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
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

import "./common" as Common

Form
{

	columns: 									1

	// Hidden option(s)
	CheckBox { name: "workflow"; checked: false; visible: false }
	CheckBox { name: "bayesian"; checked: true; visible: false }
	IntegerField { name: "by"; defaultValue: 1; visible: false }
	IntegerField { name: "max"; defaultValue: 5000; visible: false }

	// Visible options
	Common.EvaluationVariablesList { id: variables; use_population: data.use_population; use_sample: data.use_sample }
	Common.SamplingObjectives { id: objectives }
	Common.DataType { id: data }
	Common.Population { id: population; enable: !data.use_population; show_items: true }
	Common.ExplanatoryText { }

	Section
	{
		title: 									qsTr("Prior")
		columns:								3

		Common.Likelihood { id:likelihood; bayesian: true; evaluation: true; enable_hypergeometric: population.n_units > 0 || data.use_population }
		Common.PriorMethod { use_materiality: objectives.use_materiality}
		Common.ExpectedErrors { show_all: true; enable_all: separate.checked }
	}

	Section
	{
		title:											qsTr("Report")
		columns:										2

		Group
		{
			title: 									qsTr("Tables")

			CheckBox
			{
				text: 								qsTr("Misstated items")
				name: 								"tableTaints"
				enabled:							!data.use_stats && variables.use_book && variables.use_real
			}

			CheckBox
			{
				text: 								qsTr("Prior and posterior")
				name: 								"tablePriorPosterior"
			}

			CheckBox
			{
				text: 								qsTr("Corrections to population")
				name: 								"tableCorrections"
				enabled:							n_units.value > 0 || data.use_population
			}

			CheckBox
			{
				text: 								qsTr("Assumption checks")
				name: 								"tableAssumptions"
				checked: 							separate.checked
				enabled: 							separate.checked

				CIField
				{
					name: 							"tableAssumptionsConfidence"
					label: 							qsTr("Confidence interval")
				}
			}
		}

		Group
		{
			title: 									qsTr("Plots")

			CheckBox
			{
				text: 								qsTr("Sampling objectives")
				name: 								"plotObjectives"
				enabled:							objectives.use_materiality || objectives.use_precision
			}

			CheckBox
			{
				text: 								qsTr("Prior and posterior")
				name: 								"plotPosterior"

				CheckBox
				{
					id: 							plotPosteriorInfo
					text: 							qsTr("Additional info")
					name: 							"plotPosteriorInfo"
					checked:						true
				}
			}

			CheckBox
			{
				text: 								qsTr("Posterior predictive")
				name: 								"plotPosteriorPredictive"
				enabled:							!likelihood.use_hypergeometric
				debug:								true
			}

			CheckBox
			{
				text: 								qsTr("Scatter plot")
				name: 								"plotScatter"
				enabled: 							!data.use_stats
				debug:								true

				CheckBox
				{
					text: 							qsTr("Display correlation")
					name:							"plotScatterCorrelation"
				}

				CheckBox
				{
					text: 							qsTr("Display item ID's")
					name:							"plotScatterId"
				}
			}
		}
	}

	Section
	{
		title: 									qsTr("Advanced")
		columns: 								3

		Group
		{
			name:								"critical_items"
			title:								qsTr("Critical Items")
			enabled:							!data.use_stats && values.count > 0

			CheckBox
			{
				id: 							flagNegativeValues
				name:							"critical_negative"
				text:							qsTr("Negative book values")
				enabled:						values.count > 0
				checked:						true

				RadioButtonGroup
				{
					name: 						"critical_action"

					RadioButton
					{
						text: 					qsTr("Keep")
						name: 					"inspect"
						checked: 				true
					}

					RadioButton
					{
						text: 					qsTr("Remove")
						name: 					"remove"
					}
				}
			}
		}

		Group
		{

			CheckBox
			{
				text:							qsTr("Share information")
				name:							"pooling"
				enabled:						stratum.count > 0
			}

			Group
			{
				columns: 2
				CheckBox
				{
					id: 						separate
					text: 						qsTr("Assume homogeneous taints")
					name: 						"separateMisstatement"
					enabled:					id.count > 0 && values.count > 0 && auditResult.count > 0 && ((population.n_items > 0 && population.n_units > 0) || data.use_population) && likelihood.use_binomial
				}

				HelpButton
				{
					toolTip: 					qsTr("Click to learn more about this assumption")
					helpPage:					"Audit/separateKnownAndUnknownMisstatement"
				}
			}
		}

		Common.Display { show_monetary: true; enable_monetary: population.n_units > 0 || data.use_population }
		Common.EstimateType { }
	}

	Common.DownloadReport { }
}
