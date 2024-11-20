
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
	columns: 							1
	info:								qsTr("This analysis analyzes the frequency with which values get repeated within a dataset (called “number-bunching”) to statistically identify whether the data were likely tampered with. Unlike Benford’s law this approach examines the entire number at once, not only the first or last digit (Simonsohn, 2019).\n\nTo determine whether the data show an excessive amount of bunching, the null hypothesis that the data do not contain an unexpected amount of repeated values is tested. To quantify what is expected, this test requires the assumption that the integer portions of the numbers are not associated with their decimal portions.")

	VariablesForm
	{
		id: 							variablesFormNumberBunching
		preferredHeight:				jaspTheme.smallDefaultVariablesFormHeight

		AvailableVariablesList
		{
			name: 						"variablesFormNumberBunching"
		}

		AssignedVariablesList
		{
			id: 						values
			name: 						"values"
			title: 						qsTr("Variable")
			singleVariable:				true
			allowedColumns:				["scale"]
			minNumericLevels:			1
			info:						qsTr("In this box the variable is selected whose digits should be analyzed for repeated values.")
		}
	}

	Group
	{
		title:							qsTr("Tests")
		info:							qsTr("Indicate which type of quantity is calculated from the data.")

		CheckBox
		{
			name:						"avgFrequency"
			text:						qsTr("Average frequency")
			checked:					true
			info:						qsTr("Compute the average frequency of the data.")
		}

		CheckBox
		{
			name:						"entropy"
			text:						qsTr("Entropy")
			info:						qsTr("Compute the entropy of the data.")
		}
	}

	RadioButtonGroup
	{
		name:							"shuffle"
		title: 							qsTr("Shuffle Decimal Digits")
		info:							qsTr("Indicate which decimals are shuffled in the analysis.")

		RadioButton
		{
			name:						"last"
			text:						qsTr("Last")
			info:						qsTr("Last decimal digit is shuffled.")
		}

		RadioButton
		{
			name:						"lasttwo"
			text:						qsTr("Last two")
			checked:					true
			info:						qsTr("Last two decimal digits are shuffled.")
		}

		RadioButton
		{
			name:						"all"
			text:						qsTr("All")
			info:						qsTr("All decimal digits are shuffled.")
		}
	}

	Group
	{
		title: 							qsTr("Display")
		info:							qsTr("Specify options that have an effect on the look and feel of the audit report.")

		Row
		{
			CheckBox
			{
				id: 					explanatoryText
				text: 					qsTr("Explanatory text")
				name: 					"explanatoryText"
				checked: 				true
				info:					qsTr("When checked, enables explanatory text in the analysis to help interpret the procedure and the statistical results.")

				CIField
				{
					name: 				"confidence"
					label: 				qsTr("Confidence")
					info:				qsTr("The confidence level used. The confidence level is the complement of the audit risk: the risk that the user is willing to take to give an incorrect judgment about the population. For example, if you want to use an audit risk of 5%, this equals 95% confidence.")
				}
			}

			HelpButton
			{
				helpPage:				"Audit/explanatoryText"
				toolTip: 				qsTr("Show explanatory text at each step of the analysis")
			}
		}
	}

	Section
	{
		title:							qsTr("Report")
		Group
		{
			columns:					2

			Group
			{
				title: 					qsTr("Tables")
				info:					qsTr("Add additional tables about the analysis to the report.")

				CheckBox
				{
					text: 				qsTr("Assumption checks")
					name: 				"correlationTable"
					checked: 			true
					info:				qsTr("This table shows the correlation between the integer portions of the numbers and their decimal counterparts. To meet the required assumptions for this procedure, this correlation must be non-existent. This table also displays the correlation between the samples of the two simulation runs (average frequency and entropy).")
				}

				CheckBox
				{
					text: 				qsTr("Frequency table")
					name: 				"summaryTable"
					info:				qsTr("Produces a table containing the count and the percentage for every unique value in the data set.")
				}
			}

			Group
			{
				title: 					qsTr("Plots")
				info:					qsTr("Add additional figures about the analysis to the report.")

				CheckBox
				{
					text: 				qsTr("Observed vs. expected")
					name: 				"numberBunchingSimulationPlots"
					info:				qsTr("Produces a histogram of the expected average frequencies and / or entropy vs. the observed average frequency and / or entropy.")
				}

				CheckBox
				{
					text: 				qsTr("Histogram")
					name: 				"numberBunchingHistogram"
					info:				qsTr("Produces a histogram with a single bin for each observed value.")

					IntegerField
					{
						name: 			"noHeads"
						label: 			qsTr("Label")
						afterLabel:		qsTr("with highest occurrence")
						min: 			0
						defaultValue:	0
						max:			20
						info:			qsTr("Indicate how many items labels to display.")
					}
				}
			}
		}
	}

	Section
	{
		title:							qsTr("Advanced")
		info:							qsTr("Adjust advanced options for this analysis.")

		Group
		{
			columns:					1
			title:						qsTr("Bootstrap")
			info:						qsTr("Options related to the bootstrapping procedure of the p-value.")

			IntegerField
			{
				name: 					"noSamples"
				label: 					qsTr("Number of samples")
				min: 					100
				defaultValue: 			500
				max: 					500000
				fieldWidth:				70
				info:					qsTr("The number of samples to use for simulating the p value.")
			}

			IntegerField
			{
				name:					"seed"
				label:					qsTr("Seed")
				defaultValue:			Math.floor(Math.random() * 1000); // Init with random integer in [1,...,999]
				min:					-999
				max:					999
				info:					qsTr("Selects the seed for the random number generator in order to reproduce results.")
			}
		}
	}

	Common.DownloadReport { }
}
