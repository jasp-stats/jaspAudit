
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
// <http://www.gnu.org/licenses/>.\
//

// When making changes to this file always mention @koenderks as a
// reviewer in the Pull Request

import QtQuick
import QtQuick.Layouts
import JASP
import JASP.Controls
import JASP.Widgets

import "./common" as Common
import "./common/planning" as Planning

Form 
{
	columns: 1
	info: qsTr("The Bayesian planning analysis allows the user to calculate a minimum sample size given a set of sampling objectives and summary statistics of the population. Note that when you have access to the raw population data you may want to use the audit workflow, an analysis that guides you through the sampling process.\n\n![Audit sampling workflow](%HELP_FOLDER%/img/workflowPlanning.png)\n\nPlease see the manual of the Audit module (download [here](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) for more detailed information about this analysis.")

	// Hidden option(s)
	CheckBox { name: "workflow"; checked: false; visible: false }
	CheckBox { name: "bayesian"; checked: true; visible: false }
	CheckBox { name: "separateMisstatement"; checked: false; visible: false }
	RadioButtonGroup { name: "area"; visible: false; RadioButton { name: "less"; checked: true } }

	// Visible options
	Planning.SamplingObjectives { id: objectives }
	Planning.ExpectedErrors { }
	Planning.Population { id: population; optional: !objectives.absolute_materiality }
	Common.ExplanatoryText { }

	Section
	{
		title: qsTr("Prior")
		columns: 3
		Planning.Likelihood { id: likelihood; bayesian: true; enable_hypergeometric: population.n_units > 0 }
		Planning.PriorMethod { id: method; use_materiality: objectives.use_materiality }
		Planning.ExpectedPopRate { enable: method.use_expected }
	}

	Section
	{
		title: qsTr("Report")
		Planning.PlanningOutput { bayesian: true; disable_predictive: likelihood.use_hypergeometric }
		Common.Display { }
	}

	Section
	{
		title: qsTr("Advanced")
		Planning.Iterations { }
	}

	Common.DownloadReport { }
}
