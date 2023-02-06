
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

Form 
{
	columns: 1

	// Hidden option(s)
	CheckBox { name: "workflow"; checked: false; visible: false }
	CheckBox { name: "bayesian"; checked: true; visible: false }
	CheckBox { name: "separateMisstatement"; checked: false; visible: false }

	// Visible options
	Common.SamplingObjectives { id: objectives }
	Common.ExpectedErrors { }
	Common.Population { id: population; optional: !objectives.absolute_materiality }
	Common.ExplanatoryText { }

	Section
	{
		title: qsTr("Prior")
		Group
		{
			columns: 2
			Common.Likelihood { id: likelihood; bayesian: true; enable_hypergeometric: population.n_units > 0 }
			Common.PriorMethod { use_materiality: objectives.use_materiality }
		}
	}

	Section
	{
		title: qsTr("Report")
		columns: 2
		Common.PlanningOutput { bayesian: true; disable_predictive: likelihood.use_hypergeometric }
		Common.Display { }
	}

	Section
	{
		title: qsTr("Advanced")
		Group
		{
			Common.Iterations { }
		}
	}

	Common.DownloadReport { }
}
