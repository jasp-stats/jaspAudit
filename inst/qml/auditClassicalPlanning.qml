
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

import "./common" as Common

Form 
{
	columns:		1

	// Hidden option(s)
	CheckBox { name: "workflow"; checked: false; visible: false }
	CheckBox { name: "bayesian"; checked: false; visible: false }
	CheckBox { name: "separateMisstatement"; checked: false; visible: false }
	RadioButtonGroup { name: "prior_method"; visible: false; RadioButton { name: "arm"; checked: true } }

	// Visible options
	Common.SamplingObjectives { id: objectives }
	Common.ExpectedErrors { }
	Common.Population { id: population; optional: !objectives.absolute_materiality }
	Common.AuditRiskModel { enable: objectives.use_materiality }
	Common.ExplanatoryText { }

	Group
	{
		title: 		qsTr("Plots")
		debug:		true

		CheckBox
		{
			text: 	qsTr("Compare sample sizes")
			name: 	"plotSampleSizes"
		}

		CheckBox
		{
			text: 	qsTr("Assumed error distribution")
			name: 	"plotErrorDist"
		}
	}

	Section
	{
		title:		qsTr("Advanced")
		columns:	3

		Common.Likelihood { bayesian: false; enable_hypergeometric: population.n_units > 0 }
		Common.Iterations { }
		Common.Display { }
	}

	Common.DownloadReport { }
}
