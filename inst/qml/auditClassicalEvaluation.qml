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

import QtQuick									2.8
import QtQuick.Layouts							1.3
import JASP.Controls							1.0
import JASP.Widgets								1.0

Form
{

	columns: 									2

	// Extra options
	CheckBox
	{
		name: 									"workflow"
		checked: 								false
		visible: 								false
	}

	CheckBox
	{
		name: 									"bayesian"
		checked: 								false
		visible: 								false
	}

	CheckBox
	{
		name: 									"separateMisstatement"
		checked: 								false
		visible: 								false
	}

	RadioButtonGroup
	{
		name: 									"prior_method"
		visible: 								false

		RadioButton
		{
			name: 								"arm"
			checked: 							true
		}
	}

	IntegerField
	{
		name: 									"by"
		defaultValue: 							1
		visible:								false
	}

	// Start analysis
	GridLayout
	{
		columns: 								3
		Layout.columnSpan: 						2

		Group
		{
			title: 								qsTr("Sampling Objectives")
			columns:							2

			CheckBox
			{
				id: 							materiality_test
				text: 							qsTr("Performance materiality")
				name: 							"materiality_test"

				RadioButtonGroup
				{
					id: 						materiality_type
					name: 						"materiality_type"

					Row
					{
						visible: 				materiality_test.checked

						RadioButton
						{
							id: 				materiality_rel
							name: 				"materiality_rel"
							text: 				qsTr("Relative")
							checked:			true
							childrenOnSameRow: 	true

							PercentField
							{
								id: 			materiality_rel_val
								visible: 		materiality_rel.checked
								decimals: 		2
								defaultValue: 	0
								min:			0
								max:			99
								name: 			"materiality_rel_val"
							}
						}
					}

					Row
					{
						visible: 				materiality_test.checked

						RadioButton
						{
							id: 				materiality_abs
							name: 				"materiality_abs"
							text: 				qsTr("Absolute")
							childrenOnSameRow: 	true
							onCheckedChanged:	if (checked) poisson.click()

							DoubleField
							{
								id: 			materiality_abs_val
								visible: 		materiality_abs.checked
								name: 			"materiality_abs_val"
								defaultValue: 	0
								min: 			0
								fieldWidth: 	90 * preferencesModel.uiScale
								decimals: 		2
							}
						}
					}
				}
			}

			HelpButton
			{
				toolTip: 						qsTr("Click to learn more about performance materiality.")
				helpPage:						"Audit/performanceMateriality"
			}

			CheckBox
			{
				id: 							min_precision_test
				text: 							qsTr("Minimum precision")
				name: 							"min_precision_test"

				PercentField
				{
					id: 						min_precision_rel_val
					name: 						"min_precision_rel_val"
					decimals: 					2
					defaultValue: 				2
					min:						0.1
					max:						99.9
					label: 						qsTr("Relative")
					visible: 					min_precision_test.checked
				}
			}

			HelpButton
			{
				toolTip: 						qsTr("Click to learn more about the precision.")
				helpPage:						"Audit/minimumPrecision"
			}
		}

		Group
		{
			title: 								qsTr("Population")

			DoubleField
			{
				id: 							n_items
				name: 							"n_items"
				text: 							qsTr("No. items")
				defaultValue: 					0
				fieldWidth: 					100 * preferencesModel.uiScale
				min: 							0
				decimals: 						2
			}

			DoubleField
			{
				id: 							n_units
				name: 							"n_units"
				text: 							qsTr("No. units")
				defaultValue: 					0
				fieldWidth: 					100 * preferencesModel.uiScale
				min: 							0
				decimals: 						2
			}
		}

		CIField
		{
			name: 								"conf_level"
			label: 								qsTr("Confidence")
		}
	}

	Divider { }

	VariablesForm
	{
		preferredHeight: 						jaspTheme.smallDefaultVariablesFormHeight
		enabled:								!stats.checked
		visible:								!stats.checked

		AvailableVariablesList
		{
			id: 								evaluationVariables
			name: 								"evaluationVariables"
		}

		AssignedVariablesList
		{
			id: 								id
			name: 								"id"
			title: 								qsTr("Item ID")
			singleVariable: 					true
			allowedColumns: 					["nominal", "nominalText", "ordinal", "scale"]
		}

		AssignedVariablesList
		{
			id: 								values
			name: 								"values"
			title: 								qsTr("Book Value")
			singleVariable: 					true
			allowedColumns: 					["scale"]
		}

		AssignedVariablesList
		{
			id: 								auditResult
			name: 								"values.audit"
			title: 								qsTr("Audit Result")
			singleVariable: 					true
			allowedColumns: 					["nominal", "scale"]
		}

		AssignedVariablesList
		{
			id: 								sampleCounter
			name: 								"times"
			title: 								qsTr("Selection Counter")
			singleVariable: 					true
			allowedColumns: 					["nominal", "ordinal", "scale"]
		}
	}

	RadioButtonGroup
	{
		name:									"dataType"
		title:									qsTr("Data")

		RadioButton
		{
			id: 								data
			name: 								"data"
			label:								qsTr("Raw")
			checked: 							mainWindow.dataAvailable
			enabled:							mainWindow.dataAvailable
		}

		RadioButton
		{
			id: 								stats
			name: 								"stats"
			label:								qsTr("Summary statistics")
			checked: 							!mainWindow.dataAvailable

			Group
			{
				IntegerField
				{
					id: 						nobs
					name: 						"n"
					text: 						qsTr("Sample size")
					defaultValue: 				0
					min: 						xobs.value
					visible:					stats.checked
				}

				IntegerField
				{
					id:							xobs
					name: 						"x"
					text: 						qsTr("Number of errors")
					defaultValue: 				0
					min: 						0
					visible:					stats.checked
					max:						nobs.value
				}
			}
		}
	}

	Group
	{
		title: 									qsTr("Display")
		columns: 								2

		CheckBox
		{
			id: 								explanatoryText
			text: 								qsTr("Explanatory text")
			name: 								"explanatoryText"
			checked: 							true
		}

		HelpButton
		{
			helpPage:							"Audit/explanatoryText"
			toolTip: 							qsTr("Show explanatory text at each step of the analysis")
		}
	}

	Group
	{
		title: 									qsTr("Audit Risk Model")
		enabled:								materiality_test.checked

		Group
		{
			columns:							2

			DropDown
			{
				id: 						ir
				name: 						"ir"
				indexDefaultValue: 	 		0
				startValue:					"high"
				label: 						qsTr("Inherent risk")
				values: 					[
					{ label: qsTr("High"),	value: "high"},
					{ label: qsTr("Medium"), value: "medium"},
					{ label: qsTr("Low"), 		value: "low"},
					{ label: qsTr("Manual"), 	value: "custom"}
				]
			}

			PercentField
			{
				name: 							"irCustom"
				defaultValue: 					ir.value == "high" ? 100 : (ir.value == 'medium' ? 60 : (ir.value == "low" ? 36 : 100))
				min: 							25
				enabled: 						ir.value == "custom"
			}

			DropDown
			{
				id: 							cr
				name: 							"cr"
				indexDefaultValue:				0
				startValue:						"high"
				label: 							qsTr("Control risk")
				values: 						[
					{ label: qsTr("High"),		value: "high"},
					{ label: qsTr("Medium"), 	value: "medium"},
					{ label: qsTr("Low"), 		value: "low"},
					{ label: qsTr("Manual"), 	value: "custom"}
				]
			}

			PercentField
			{
				name: 							"crCustom"
				defaultValue:					cr.value == "high" ? 100 : (cr.value == 'medium' ? 60 : (cr.value == "low" ? 36 : 100))
				min: 							25
				enabled: 						cr.value == "custom"
			}
		}
	}

	Group
	{
		title: 							qsTr("Tables")

		CheckBox
		{
			text: 						qsTr("Corrections to population")
			name: 						"tableCorrections"
			enabled:					n_units.value > 0
		}
	}

	RadioButtonGroup
	{
		title: 								qsTr("Method")
		name: 								"method"

		RadioButton
		{
			name: 							"poisson"
			text: 							qsTr("Poisson")
			checked:						true
		}

		RadioButton
		{
			name: 							"binomial"
			text: 							qsTr("Binomial")
		}

		RadioButton
		{
			name: 							"hypergeometric"
			text: 							qsTr("Hypergeometric")
			enabled:						n_units.value > 0
		}

		RadioButton
		{
			id: 							stringer
			name: 							"stringer"
			text: 							qsTr("Stringer")
			enabled: 						!stats.checked && values.count > 0 && auditResult.count > 0

			CheckBox
			{
				name: 						"lta"
				text: 						qsTr("LTA adjustment")
				checked: 					true
			}
		}

		RadioButton
		{
			name: 							"mpu"
			text: 							qsTr("Mean-per-unit estimator")
			enabled: 						!stats.checked && values.count > 0 && auditResult.count > 0
		}

		RadioButton
		{
			name: 							"direct"
			text: 							qsTr("Direct estimator")
			enabled: 						!stats.checked && n_units.value != 0 && n_items.value != 0 && values.count > 0 && auditResult.count > 0
		}

		RadioButton
		{
			name: 							"difference"
			text: 							qsTr("Difference estimator")
			enabled: 						!stats.checked && n_units.value != 0 && n_items.value != 0 && values.count > 0 && auditResult.count > 0
		}

		RadioButton
		{
			name: 							"quotient"
			text: 							qsTr("Ratio estimator")
			enabled: 						!stats.checked && n_units.value != 0 && n_items.value != 0 && values.count > 0 && auditResult.count > 0
		}

		RadioButton
		{
			name: 							"regression"
			text: 							qsTr("Regression estimator")
			enabled: 						!stats.checked && n_units.value != 0 && n_items.value != 0 && values.count > 0 && auditResult.count > 0
		}
	}

	Group
	{
		title: 								qsTr("Plots")

		CheckBox
		{
			text: 							qsTr("Sampling objectives")
			name: 							"plotObjectives"
		}

		CheckBox
		{
			text: 							qsTr("Scatter plot")
			name: 							"plotScatter"
			enabled:						!stats.checked

			CheckBox
			{
				text: 						qsTr("Display correlation")
				name:						"plotScatterCorrelation"
			}

			CheckBox
			{
				text: 						qsTr("Display item ID's")
				name:						"plotScatterId"
			}
		}
	}

	Section
	{
		title:									qsTr("Advanced Options")
		columns:								2

		Group
		{
			name:							"critical_items"
			title:							qsTr("Critical Items")
			enabled:						!stats.checked && values.count > 0

			CheckBox
			{
				id: 						flagNegativeValues
				name:						"critical_negative"
				text:						qsTr("Negative book values")
				enabled:					values.count > 0
				checked:					true

				RadioButtonGroup
				{
					name: 							"critical_action"

					RadioButton
					{
						text: 						qsTr("Keep")
						name: 						"inspect"
						checked: 					true
					}

					RadioButton
					{
						text: 						qsTr("Remove")
						name: 						"remove"
					}
				}
			}
		}

		RadioButtonGroup
		{
			name: 								"display"
			title:								qsTr("Format Tables")

			RadioButton
			{
				text: 							qsTr("Numbers")
				name: 							"number"
				checked: 						true
			}

			RadioButton
			{
				text: 							qsTr("Percentages")
				name: 							"percent"
			}

			RadioButton
			{
				text: 							qsTr("Extrapolated amounts")
				name: 							"amount"
				enabled:						n_units.value != 0
			}
		}
	}

	Item
	{
		Layout.preferredHeight: 				download.height
		Layout.fillWidth: 						true
		Layout.columnSpan:						2

		Button
		{
			id: 								download
			anchors.right:						parent.right
			text:								qsTr("<b>Download Report</b>")
			onClicked:							form.exportResults()
		}
	}
}
