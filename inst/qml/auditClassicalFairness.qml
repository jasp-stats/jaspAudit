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
import "./common/fairness" as Fairness

Form 
{
	columns: 1
	info: qsTr("The fairness measures analysis enables the user to assess fairness and discrimination regarding specific groups in the data in algorithmic decision-making systems. Considering a certain positive class in the data, fairness -or discrimination- can be quantified using model-agnostic fairness metrics. The ratio of two fairness metrics is called parity, which is a well-known concept in algorithmic fairness.")

	// Hidden option(s)
	CheckBox { name: "workflow"; checked: false; visible: false }

	Fairness.FairnessVariablesList { }

	Group
	{
		Fairness.ConfidenceLevel { }

		DropDown
		{
			id:					metric
			name: 				"metric"
			label: 				qsTr("Fairness measure")
			indexDefaultValue: 	0
			values: [
				{ label: qsTr("Predictive rate parity"),			value: "prp"},
				{ label: qsTr("Negative predictive value parity"),	value: "npvp"},
				{ label: qsTr("False positive rate parity"),		value: "fprp"},
				{ label: qsTr("False negative rate parity"),		value: "fnrp"},
				{ label: qsTr("Equal opportunity"),					value: "tprp"},
				{ label: qsTr("Specificity parity"), 				value: "sp"},
				{ label: qsTr("Disparate impact"),					value: "pp"},
				{ label: qsTr("Equalized odds"), 					value: "eo"},
				{ label: qsTr("Accuracy parity"),					value: "ap"}
			]
			info: qsTr("Select the fairness metric for evaluating discrimination against the unprivileged group(s).")
		}
	}

	Fairness.Levels { }
	Fairness.Hypotheses { }
	Fairness.BayesFactorType { }
	Common.ExplanatoryText { }

	Section
	{
		title: qsTr("Report")
		Fairness.FairnessOutput { }
	}

	Section
	{
		title: qsTr("Advanced")
		debug: true
		Fairness.PriorDistribution { }
	}

	Common.DownloadReport { }
}
