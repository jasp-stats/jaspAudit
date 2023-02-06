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
	columns: 1
	info: qsTr("The Bayesian evaluation analysis allows the user to perform inference about the total misstatement in the population on the basis of an audit sample.\n\n<img src='%HELP_FOLDER%/img/workflowEvaluation.png'/>\n\nPlease see the manual of the Audit module (download [here](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) for more detailed information about this analysis.")

	// Hidden option(s)
	CheckBox { name: "workflow"; checked: false; visible: false }
	CheckBox { name: "bayesian"; checked: true; visible: false }
	IntegerField { name: "by"; defaultValue: 1; visible: false }
	IntegerField { name: "max"; defaultValue: 5000; visible: false }

	// Visible options
	Common.EvaluationVariablesList { id: variables; use_population: data.use_population; use_sample: data.use_sample }
	Common.SamplingObjectives { id: objectives }
	Common.DataType { id: data }
	Common.Population { id: population; optional: !objectives.absolute_materiality; enable: !data.use_population; show_items: true }
	Common.ExplanatoryText { }

	Section
	{
		title: qsTr("Prior")
		Group
		{
			columns: 3
			Common.Likelihood { id:likelihood; bayesian: true; evaluation: true; enable_hypergeometric: population.n_units > 0 || data.use_population }
			Common.PriorMethod { use_materiality: objectives.use_materiality}
			Common.ExpectedErrors { show_all: true; enable_all: algorithm.use_partial }
		}
	}

	Section
	{
		title: qsTr("Report")
		Group
		{
			columns: 2
			Common.EvaluationOutput
			{
				bayesian: true
				enable_taints: !data.use_stats && variables.use_book && variables.use_real
				enable_corrections: population.n_units > 0 || data.use_population
				enable_assumptions: algorithm.use_partial
				enable_objectives: objectives.use_materiality || objectives.use_precision
				enable_predictive: !likelihood.use_hypergeometric
				enable_scatter: !data.use_stats
				enable_estimates: true
			}
			Common.Display { show_monetary: true; enable_monetary: population.n_units > 0 || data.use_population }
		}
	}

	Section
	{
		title: qsTr("Advanced")
		Group
		{
			columns: 3
			Common.CriticalItems { workflow: false; enable: !data.use_stats && variables.use_book }
			Common.Algorithm
			{
				id: 			algorithm
				hide_pooling:	false
				enable:			!data.use_stats
				enable_pooling: variables.use_strata
				enable_partial: !variables.use_strata && variables.use_id && variables.use_book && variables.use_real && ((population.n_items > 0 && population.n_units > 0) || data.use_population) && likelihood.use_binomial
			}
			Common.IntervalType { bayesian: true; test: objectives.use_materiality }
		}
	}

	Common.DownloadReport { }
}
