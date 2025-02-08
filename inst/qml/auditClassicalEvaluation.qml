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

import "./common" as Common
import "./common/planning" as Planning
import "./common/evaluation" as Evaluation

Form
{
	columns: 1
	info: qsTr("The evaluation analysis allows the user to perform inference about the total misstatement in the population on the basis of an audit sample.\n\n![Audit sampling workflow](%HELP_FOLDER%/img/workflowEvaluation.png)Please see the manual of the Audit module (download [here](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) for more detailed information about this analysis.")

	// Hidden option(s)
	CheckBox { name: "workflow"; checked: false; visible: false }
	CheckBox { name: "bayesian"; checked: false; visible: false }
	CheckBox { name: "separateMisstatement"; checked: false; visible: false }
	RadioButtonGroup { name: "prior_method"; visible: false; RadioButton { name: "arm"; checked: true } }
	IntegerField { name: "by"; defaultValue: 1; visible: false }
	IntegerField { name: "max"; defaultValue: 5000; visible: false }

	// Visible options
	Evaluation.EvaluationVariablesList { id: variables; use_population: data.use_population; use_sample: data.use_sample }
	Planning.SamplingObjectives { id: objectives }
	Evaluation.DataType { id: data }
	Planning.Population { id: population; optional: !objectives.absolute_materiality; enable: !data.use_population; show_items: true }
	Planning.AuditRiskModel { enable: objectives.use_materiality }
	Common.ExplanatoryText { }

	Section
	{
		title: qsTr("Report")
		Evaluation.EvaluationOutput
		{
			bayesian: false
			enable_taints: !data.use_stats
			enable_corrections: population.n_units > 0 || data.use_population
			enable_objectives: objectives.use_materiality || objectives.use_precision
			enable_scatter: !data.use_stats
			enable_estimates: true
		}
		Common.Display { show_monetary: true; enable_monetary: population.n_units > 0 || data.use_population }
	}

	Section
	{
		title:					qsTr("Advanced")
		columns:				3

		RadioButtonGroup
		{
			title: 				qsTr("Method")
			name: 				"method"

			RadioButton
			{
				name: 			"hypergeometric"
				text: 			qsTr("Hypergeometric")
				enabled:		population.n_units > 0 || data.use_population
			}

			RadioButton
			{
				name: 			"binomial"
				text: 			qsTr("Binomial")
				checked:		true
			}

			RadioButton
			{
				name: 			"poisson"
				text: 			qsTr("Poisson")
			}

			RadioButton
			{
				id: 			stringer
				name: 			"stringer.binomial"
				text: 			qsTr("Stringer")
				enabled: 		!data.use_stats && variables.use_book && variables.use_real

				CheckBox
				{
					name: 		"lta"
					text: 		qsTr("LTA adjustment")
					checked: 	true
				}
			}

			RadioButton
			{
				name: 			"mpu"
				text: 			qsTr("Mean-per-unit estimator")
				enabled: 		!data.use_stats && variables.use_book && variables.use_real
			}

			RadioButton
			{
				name: 			"direct"
				text: 			qsTr("Direct estimator")
				enabled: 		!data.use_stats && ((population.n_units > 0 && population.n_items > 0) || data.use_population) && variables.use_book && variables.use_real
			}

			RadioButton
			{
				name: 			"difference"
				text: 			qsTr("Difference estimator")
				enabled: 		!data.use_stats && ((population.n_units > 0 && population.n_items > 0) || data.use_population) && variables.use_book && variables.use_real
			}

			RadioButton
			{
				name: 			"quotient"
				text: 			qsTr("Ratio estimator")
				enabled: 		!data.use_stats && ((population.n_units > 0 && population.n_items > 0) || data.use_population) && variables.use_book && variables.use_real
			}

			RadioButton
			{
				name: 			"regression"
				text: 			qsTr("Regression estimator")
				enabled: 		!data.use_stats && ((population.n_units > 0 && population.n_items > 0) || data.use_population) && variables.use_book && variables.use_real
			}
		}

		Planning.CriticalItems { workflow: false; enable: !data.use_stats && variables.use_book }
		Evaluation.IntervalType { bayesian: false; test: objectives.use_materiality }
	}

	Common.DownloadReport { }
}
