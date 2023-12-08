
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
	columns:						1
	info:							qsTr("Benford's law states that the distribution of leading digits in a population naturally follows a certain distribution. In auditing, assessing whether a distribution of digits in the population conforms to Benford's law may provide additional evidence that the transactions in the population might need further investigation. Non-conformity to Benford's law does not necessarily indicate fraud. A Benford's law analysis should therefore only be used to acquire insight into whether a population might need further investigation.")

	VariablesForm
	{
		id: 						variablesFormBenfordsLaw
		preferredHeight:			jaspTheme.smallDefaultVariablesFormHeight

		AvailableVariablesList
		{
			name: 					"variablesFormBenfordsLaw"
		}

		AssignedVariablesList
		{
			id: 					values
			name: 					"values"
			title: 					qsTr("Variable")
			singleVariable:			true
			allowedColumns:			["scale"]
			info:					qsTr("In this box the variable is selected whose digits should be tested against the reference distribution. The value zero (0) will be omitted from the data.")
		}
	}

	CIField
	{
		name: 						"confidence"
		label: 						qsTr("Confidence")
		info:						qsTr("The confidence level used. The confidence level is the complement of the audit risk: the risk that the user is willing to take to give an incorrect judgment about the population. For example, if you want to use an audit risk of 5%, this equals 95% confidence.")
	}

	RadioButtonGroup
	{
		name:						"distribution"
		title: 						qsTr("Reference")
		info:						qsTr("Choose the distribution to test against.")

		RadioButton
		{
			name:					"benford"
			text:					qsTr("Benford's law")
			checked:				true
			info:					qsTr("Test the specified digits against Benford's law.")
		}

		RadioButton
		{
			name:					"uniform"
			text:					qsTr("Uniform distribution")
			info:					qsTr("Test the specified digits against the uniform distribution.")
		}
	}

	RadioButtonGroup
	{
		name:						"digits"
		title: 						qsTr("Digits")
		info:						qsTr("Specify which digits to extract from the data and test.")

		RadioButton
		{
			name:					"first"
			text:					qsTr("First")
			checked:				true
			info:					qsTr("Extract and test the first digit of the items against the specified reference distribution.")
		}

		RadioButton
		{
			name:					"firsttwo"
			text:					qsTr("First and second")
			info:					qsTr("Extract and test the first and second digit of the items against the specified reference distribution.")
		}

		RadioButton
		{
			name:					"last"
			text:					qsTr("Last")
			info:					qsTr("Extract and test the last digit of the items against the specified reference distribution.")
		}
	}

	RadioButtonGroup
	{
		name:						"bayesFactorType"
		title:						"Bayes Factor"
		info:						qsTr("Choose which type of Bayes factor to display.")

		RadioButton
		{
			name:					"BF10"
			text:					qsTr("BF\u2081\u2080")
			checked:				true
			info:					qsTr("Bayes factor to quantify evidence for the alternative hypothesis relative to the null hypothesis.")
		}

		RadioButton
		{
			name:					"BF01"
			text:					qsTr("BF\u2080\u2081")
			info:					qsTr("Bayes factor to quantify evidence for the null hypothesis relative to the alternative hypothesis.")
		}

		RadioButton
		{
			name:					"logBF10"
			text:					qsTr("Log(BF\u2081\u2080)")
			info:					qsTr("Natural logarithm of BF10.")
		}
	}

	Group
	{
		title: 						qsTr("Display")
		info:						qsTr("Specify options that have an effect on the look and feel of the audit report.")

		Row
		{
			CheckBox
			{
				id: 				explanatoryText
				text: 				qsTr("Explanatory text")
				name: 				"explanatoryText"
				checked: 			true
				info:				qsTr("When checked, enables explanatory text in the analysis to help interpret the procedure and the statistical results.")
			}

			HelpButton
			{
				helpPage:			"Audit/explanatoryText"
				toolTip: 			qsTr("Show explanatory text at each step of the analysis")
			}
		}
	}

	Section
	{
		title:						qsTr("Report")
		columns:					2

		Group
		{
			title: 					qsTr("Tables")
			info:					qsTr("Add additional tables about the analysis to the report.")

			CheckBox
			{
				text: 				qsTr("Frequency table")
				name: 				"summaryTable"
				checked: 			true
				info:				qsTr("Produces a table showing the relative frequency of the digits.")

				CheckBox
				{
					text:			qsTr("Confidence interval")
					name:			"confidenceInterval"
				}
			}

			CheckBox
			{
				text: 				qsTr("Matched rows")
				name: 				"matchTable"
				info:				qsTr("Produces a table showing the rows matched to a certain digit.")

				IntegerField
				{
					name:			"match"
					text:			qsTr("Digit")
					defaultValue:	1
					min:			1
					max:			99
					info:			qsTr("For which digit should matched rows be displayed?")
				}
			}
		}

		Group
		{
			title:					qsTr("Plots")
			info:					qsTr("Add additional figures about the analysis to the report.")

			CheckBox
			{
				text:				qsTr("Observed vs. expected")
				name:				"benfordsLawPlot"
				info:				qsTr("Produces a figure that shows the observed distribution of digits in the population compared to the expected distribution under the Benford's law or the uniform distribution.")
			}

			CheckBox
			{
				text:				qsTr("Bayes factor robustness check")
				name:				"robustnessPlot"
				info:				qsTr("Produces a figure that shows the robustness of the Bayes factor to the prior distribution.")
			}

			CheckBox
			{
				text:				qsTr("Sequential analysis")
				name:				"sequentialPlot"
				info:				qsTr("Produces a figure that shows the Bayes factor as a function of the sample size.")
			}
		}
	}

	Section
	{
		columns:					1
		title: 						qsTr("Advanced")

		Group
		{
			title:					qsTr("Prior Distribution")

			DoubleField
			{
				name: 				"concentration"
				label: 				qsTr("Concentration")
				defaultValue: 		1
				decimals:			2
				min:				1
				info:				qsTr("Specifies the concentration parameter for the Dirichlet prior.")
			}
		}
	}

	Common.DownloadReport { }
}
