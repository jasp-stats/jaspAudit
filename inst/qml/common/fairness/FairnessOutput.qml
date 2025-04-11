
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

Group
{
	columns:			2

	Group
	{
		title: 			qsTr("Tables")
		info:			qsTr("Add additional tables about the evaluation to the report.")

		CheckBox
		{
			text:		qsTr("Individual comparisons")
			name:		"comparisonsTable"
			info:		qsTr("Produces a table comparing the unprivileged groups against the privileged group.")
		}

		CheckBox
		{
			text:		qsTr("Model performance")
			name:		"performanceTable"
			info:		qsTr("Produces a table containing the performance measures for the classification, including support, accuracy, precision, recall and F1-score.")
		}

		CheckBox
		{
			text:		qsTr("Confusion matrix")
			name:		"confusionTable"
			info:		qsTr("Produces the confusion matrix for each group.")
			checked: 	true

			CheckBox 
			{
				text:	qsTr("Display proportions")
				name:	"confusionTableProportions"
				info:	qsTr("Displays proportions in the confusion table.")
			}

			CheckBox
			{
				name:	"confusionTableTransposed"
				text:	qsTr("Transpose matrix")
				info:	qsTr("Transposes the confusion matrix.")
			}
		}
	}

	Group
	{
		title: 			qsTr("Plots")
		info:			qsTr("Add additional figures about the evaluation to the report.")

		CheckBox
		{
			text:		qsTr("Parity estimates")
			name:		"parityPlot"
			info:		qsTr("Produces a plot showing the parity statistics for each unprivileged group against the privileged group.")
		}

		CheckBox
		{
			text:		qsTr("Prior and posterior distribution")
			name:		"posteriorPlot"
			info:		qsTr("Produces a figure that shows the prior and posterior distribution.")
			debug:		true
		}

		CheckBox
		{
			text:		qsTr("Bayes factor robustness check")
			name:		"robustnessPlot"
			info:		qsTr("Produces a figure that shows the robustness of the Bayes factor to the prior distribution.")
			debug:		true
		}

		CheckBox
		{
			text:		qsTr("Sequential analysis")
			name:		"sequentialPlot"
			info:		qsTr("Produces a figure that shows the Bayes factor as a function of the sample size.")
			debug:		true
		}
	}
}
