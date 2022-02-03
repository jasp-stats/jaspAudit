
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

import QtQuick 									2.8
import QtQuick.Layouts 							1.3
import JASP.Controls 							1.0
import JASP.Widgets 							1.0

Form 
{

	columns:									2

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
		checked: 								true
		visible: 								false
	}

	CheckBox
	{
		name: 									"separateMisstatement"
		checked: 								false
		visible: 								false
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

	RadioButtonGroup
	{
		id: 									expected
		name: 									"expected_type"
		title: 									qsTr("Expected Errors in Sample")

		RadioButton
		{
			id: 								expected_rel
			name: 								"expected_rel"
			text: 								qsTr("Relative")
			checked: 							true
			childrenOnSameRow: 					true

			PercentField
			{
				id:								expected_rel_val
				name: 							"expected_rel_val"
				enabled: 						expected_rel.checked
				decimals: 						2
				defaultValue: 					0
				visible: 						expected_rel.checked
			}
		}

		RadioButton
		{
			id: 								expected_abs
			name: 								"expected_abs"
			text: 								qsTr("Absolute")
			childrenOnSameRow: 					true

			DoubleField
			{
				id:								expected_abs_val
				name: 							"expected_abs_val"
				enabled: 						expected_abs.checked
				defaultValue: 					0
				min: 							0
				decimals: 						3
				visible: 						expected_abs.checked
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

	RadioButtonGroup
	{
		title: 									qsTr("Probability Distribution")
		name: 									"likelihood"

		RadioButton
		{
			id: 								hypergeometric
			text: 								qsTr("Beta-binomial")
			name: 								"hypergeometric"
			enabled:							n_units.value > 0
		}

		RadioButton
		{
			id: 								binomial
			text: 								qsTr("Beta")
			name: 								"binomial"
			checked: 							true
		}

		RadioButton
		{
			id: 								poisson
			text: 								qsTr("Gamma")
			name: 								"poisson"
		}
	}

	Group
	{
		rowSpacing: 							15 * preferencesModel.uiScale

		Group
		{
			title: 								qsTr("Tables")

			CheckBox
			{
				text: 							qsTr("Prior and posterior")
				name: 							"tablePrior"
			}
		}

		Group
		{
			title: 								qsTr("Plots")

			CheckBox
			{
				text: 							qsTr("Compare sample sizes")
				name: 							"plotSampleSizes"
			}

			CheckBox
			{
				text: 							qsTr("Prior and posterior")
				name: 							"plotPrior"

				CheckBox
				{
					name: 						"plotPriorInfo"
					visible:					false
				}
			}

			CheckBox
			{
				text: 							qsTr("Prior predictive")
				name: 							"plotPriorPredictive"
				enabled:						!hypergeometric.checked
			}
		}
	}

	Section
	{
		title: 									qsTr("Prior")

		RadioButtonGroup
		{
			name: 								"prior_method"

			RadioButton
			{
				name: 							"default"
				label:							qsTr("Default")
				checked:						true
			}

			RadioButton
			{
				id: 							param
				name: 							"param"
				label: 							qsTr("Manual")
				childrenOnSameRow: 				true

				Row
				{
					spacing: 					10 * preferencesModel.uiScale

					DoubleField
					{
						name: 					"alpha"
						label:					qsTr("\u03B1")
						min:					1
						defaultValue: 			1
					}

					DoubleField
					{
						name: 					"beta"
						label:					qsTr("\u03B2")
						min:					0
						defaultValue: 			1
					}
				}
			}

			RadioButton
			{
				id: 							sample
				name: 							"sample"
				label: 							qsTr("Earlier sample")
				childrenOnSameRow: 				true

				Row
				{
					spacing: 					10 * preferencesModel.uiScale

					IntegerField
					{
						id:						prior_n
						name: 					"n"
						label:					qsTr("Size")
						min:					prior_x.value
						defaultValue: 			0
					}

					DoubleField
					{
						id:						prior_x
						name: 					"x"
						label:					qsTr("Errors")
						min:					0
						max:					prior_n.value
						defaultValue: 			0
						decimals:				3
					}
				}
			}

			RadioButton
			{
				name: 							"impartial"
				label:							qsTr("Impartial")
				enabled:						materiality_test.checked
			}

			RadioButton
			{
				id: 							arm
				name: 							"arm"
				label:							qsTr("Risk assessments")
				enabled:						materiality_test.checked

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
		}
	}

	Section
	{
		title:									qsTr("Advanced Options")
		columns:								2

		Group
		{
			title:								qsTr("Iterations")
			IntegerField
			{
				name: 							"by"
				text: 							qsTr("Increment")
				min: 							1
				max:							50
				defaultValue: 					1
			}

			IntegerField
			{
				name: 							"max"
				text: 							qsTr("Maximum")
				min: 							2
				defaultValue: 					5000
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
		}
	}

	Item
	{
		Layout.preferredHeight: 				download.height
		Layout.columnSpan: 2
		Layout.preferredWidth: 					parent.width

		Button
		{
			id: 								download
			anchors.right: 						parent.right
			text: 								qsTr("<b>Download Report</b>")
			onClicked: 							form.exportResults()
		}
	}
}
