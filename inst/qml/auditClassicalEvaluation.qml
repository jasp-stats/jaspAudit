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
	CheckBox { name: "bayesian"; checked: false; visible: false }
	CheckBox { name: "separateMisstatement"; checked: false; visible: false }
	RadioButtonGroup { name: "prior_method"; visible: false; RadioButton { name: "arm"; checked: true } }
	IntegerField { name: "by"; defaultValue: 1; visible: false }
	IntegerField { name: "max"; defaultValue: 5000; visible: false }

	// Visible options
	Common.EvaluationVariablesList { id: variables; use_population: data.use_population; use_sample: data.use_sample }
	Common.SamplingObjectives { id: objectives }
	Common.DataType { id: data }
	Common.Population { id: population; optional: !objectives.absolute_materiality; enable: !data.use_population; show_items: true }
	Common.AuditRiskModel { enable: objectives.use_materiality }
	Common.ExplanatoryText { }

	Section
	{
		title:			qsTr("Report")

		Group
		{
			columns:	2

			Common.EvaluationOutput 
			{
				bayesian: false
				enable_taints: !data.use_stats && variables.use_book && variables.use_real
				enable_corrections: n_units.value > 0 || data.use_population
				enable_objectives: objectives.use_materiality || objectives.use_precision
				enable_scatter: !data.use_stats
			}
		}
	}

	Section
	{
		title:									qsTr("Advanced")

		Group
		{
			columns:								3

			RadioButtonGroup
			{
				title: 								qsTr("Method")
				name: 								"method"

				RadioButton
				{
					name: 							"hypergeometric"
					text: 							qsTr("Hypergeometric")
					enabled:						population.n_units > 0 || data.use_population
				}

				RadioButton
				{
					name: 							"binomial"
					text: 							qsTr("Binomial")
					checked:						true
				}

				RadioButton
				{
					name: 							"poisson"
					text: 							qsTr("Poisson")
				}

				RadioButton
				{
					id: 							stringer
					name: 							"stringer"
					text: 							qsTr("Stringer")
					enabled: 						!stats.checked && values.count > 0 && auditResult.count > 0

					CheckBox
					{
						name: 						"lta"
						text: 						qsTr("LTA adjustment")
						checked: 					true
					}
				}

				RadioButton
				{
					name: 							"mpu"
					text: 							qsTr("Mean-per-unit estimator")
					enabled: 						!stats.checked && values.count > 0 && auditResult.count > 0
				}

				RadioButton
				{
					name: 							"direct"
					text: 							qsTr("Direct estimator")
					enabled: 						!stats.checked && ((n_units.value != 0 && n_items.value != 0) || pdata.checked) && values.count > 0 && auditResult.count > 0
				}

				RadioButton
				{
					name: 							"difference"
					text: 							qsTr("Difference estimator")
					enabled: 						!stats.checked && ((n_units.value != 0 && n_items.value != 0) || pdata.checked) && values.count > 0 && auditResult.count > 0
				}

				RadioButton
				{
					name: 							"quotient"
					text: 							qsTr("Ratio estimator")
					enabled: 						!stats.checked && ((n_units.value != 0 && n_items.value != 0) || pdata.checked) && values.count > 0 && auditResult.count > 0
				}

				RadioButton
				{
					name: 							"regression"
					text: 							qsTr("Regression estimator")
					enabled: 						!stats.checked && ((n_units.value != 0 && n_items.value != 0) || pdata.checked) && values.count > 0 && auditResult.count > 0
				}
			}

			Common.CriticalItems { enable: !data.use_stats && values.count > 0 }
			Common.Display { show_monetary: true; enable_monetary: population.n_units > 0 || data.use_population }
		}
	}

	Common.DownloadReport { }
}
