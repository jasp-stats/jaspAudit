
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
import "./common/selection" as Selection

Form 
{
	columns: 1
	info: qsTr("The selection analysis allows the user to select a number of sampling units (items or monetary units) from a population using a variety of sampling methods (random sampling, cell sampling, fixed interval sampling) that are standard in an auditing context.\n\n![Audit sampling workflow](%HELP_FOLDER%/img/workflowSelection.png)\n\nPlease see the manual of the Audit module (download [here](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) for more detailed information about this analysis.")

	// Hidden option(s)
	CheckBox { name: "workflow"; checked: false; visible: false }

	// Visible options
	VariablesForm
	{
		id:	variablesFormSampling
		preferredHeight: jaspTheme.smallDefaultVariablesFormHeight

		AvailableVariablesList { name: "variablesFormSampling" }
		Selection.IdVariable { id: id }
		Selection.BookVariable { id: values; required: units.use_mus }
		Selection.RankVariable { id: rank }
		Selection.AdditionalVariables { }
	}

	Group
	{
		IntegerField
		{
			id:				sample_size
			text: 			qsTr("Sample size")
			name: 			"n"
			defaultValue: 	0
			min: 			0
			info:			qsTr("The required number of sampling units that should be selected from the population, which are determined by the *units* option. By default, when no book values are provided, the sampling units are items (rows). When book values are provided, the ideal sampling units to use are monetary units.")
		}
		Selection.Seed { enable: randomize.checked || !method.use_interval || method.use_random_start }
		Selection.Randomize { id: randomize; enable: !rank.use_rank }
	}

	Selection.SamplingUnits { id: units; enable_mus: values.use_book }
	Selection.SelectionMethod { id: method; enable_sieve: values.use_book && units.use_mus }
	Common.ExplanatoryText { }

	Section
	{
		title: qsTr("Report")
		Selection.SelectionOutput { enable_order: values.count > 0 }
	}

	Selection.ExportSample { enable: id.count > 0 && sample_size.value > 0 }
	Common.DownloadReport { }
}
