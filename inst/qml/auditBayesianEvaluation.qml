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
	info: qsTr("The Bayesian evaluation analysis allows the user to perform inference about the total misstatement in the population on the basis of an audit sample.\n\n![Audit sampling workflow](%1)\n\nPlease see the manual of the Audit module (read [here](%2)) for more detailed information about this analysis.").arg("%HELP_FOLDER%/img/workflowEvaluation.png").arg("https://koenderks.github.io/jaum/")

	// Hidden option(s)
	CheckBox { name: "workflow"; checked: false; visible: false }
	CheckBox { name: "bayesian"; checked: true; visible: false }
	IntegerField { name: "by"; defaultValue: 1; visible: false }
	IntegerField { name: "max"; defaultValue: 5000; visible: false }

	// Visible options
	Evaluation.EvaluationVariablesList { id: variables; use_population: data.use_population; use_sample: data.use_sample }
	Planning.SamplingObjectives { id: objectives }
	Evaluation.DataType { id: data }
	Planning.Population { id: population; optional: !objectives.absolute_materiality; enable: !data.use_population; show_items: true }
	Common.ExplanatoryText { }

	Section
	{
		title: qsTr("Prior")
		columns: 3
		Planning.Likelihood { id:likelihood; bayesian: true; evaluation: true; enable_hypergeometric: (population.n_units > 0 || data.use_population) && !algorithm.use_partial; enable_poisson: !algorithm.use_partial }
		Planning.PriorMethod { id: method; use_materiality: objectives.use_materiality}
		Evaluation.ExpectedErrors { show_all: true; enable: method.use_expected; enable_all: algorithm.use_partial }
	}

	Section
	{
		title: qsTr("Report")
		Evaluation.EvaluationOutput
		{
			bayesian: true
			enable_taints: !data.use_stats
			enable_corrections: population.n_units > 0 || data.use_population
			enable_assumptions: algorithm.use_partial
			enable_objectives: objectives.use_materiality || objectives.use_precision
			enable_predictive: !likelihood.use_hypergeometric
			enable_scatter: !data.use_stats
			enable_estimates: true
			show_seqbf: true
			enable_seqbf: !data.use_stats && !algorithm.use_partial && !variables.use_strata  && !algorithm.use_hurdle
		}
		Common.Display { show_monetary: true; enable_monetary: population.n_units > 0 || data.use_population }
	}

	Section
	{
		title: qsTr("Advanced")
		columns: 3
		Planning.CriticalItems { workflow: false; enable: !data.use_stats && variables.use_book }
		Planning.Algorithm
		{
			id: 			algorithm
			hide_pooling:	false
			enable:			!data.use_stats
			enable_pooling: variables.use_strata
			enable_partial: !variables.use_strata && variables.use_id && variables.use_book && variables.use_real && ((population.n_items > 0 && population.n_units > 0) || data.use_population) && likelihood.use_binomial
			hide_hurdle:	false
			enable_hurdle:	!algorithm.use_partial && !variables.use_strata && variables.use_id && variables.use_book && variables.use_real && likelihood.use_binomial
		}
		Evaluation.IntervalType { bayesian: true; test: objectives.use_materiality }
	}

	Common.DownloadReport { }
}
