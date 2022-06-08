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

import QtQuick										2.8
import QtQuick.Layouts								1.3
import JASP.Controls								1.0
import JASP.Widgets									1.0
import JASP											1.0

// --------------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------  BEGIN WORKFLOW  -------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------------------

Form
{

	columns: 										2

	// Extra options
	CheckBox
	{
		name: 										"workflow"
		checked: 									true
		visible: 									false
	}

	CheckBox
	{
		name: 										"bayesian"
		checked: 									false
		visible: 									false
	}

	CheckBox
	{
		name: 										"separateMisstatement"
		checked: 									false
		visible: 									false
	}

	RadioButtonGroup
	{
		name:										"dataType"
		visible:									false

		RadioButton
		{
			id:										data
			name: 									"data"
			checked: 								true
		}
	}

	RadioButtonGroup
	{
		name: 										"prior_method"
		visible: 									false

		RadioButton
		{
			name: 									"arm"
			checked: 								true
		}
	}

	// --------------------------------------------------------------------------------------------------------------------------------------------
	// ---------------------------------------------------  PLANNING  -----------------------------------------------------------------------------
	// --------------------------------------------------------------------------------------------------------------------------------------------

	Section
	{
		id: 										planningPhase
		text: 										planningPhase.expanded ? qsTr("<b>1. Planning</b>") : qsTr("1. Planning")
		expanded: 									!samplingChecked.checked
		columns: 									2

		Group
		{
			title: 									qsTr("Sampling Objectives")
			columns:								2
			enabled:								!pasteVariables.checked

			CheckBox
			{
				id: 								materiality_test
				text: 								qsTr("Performance materiality")
				name: 								"materiality_test"

				RadioButtonGroup
				{
					id: 							materiality_type
					name: 							"materiality_type"

					Row
					{
						visible: 					materiality_test.checked

						RadioButton
						{
							id: 					materiality_rel
							name: 					"materiality_rel"
							text: 					qsTr("Relative")
							checked:				true
							childrenOnSameRow: 		true

							PercentField
							{
								id: 				materiality_rel_val
								visible: 			materiality_rel.checked
								decimals: 			2
								defaultValue: 		0
								min:				0
								max:				99
								name: 				"materiality_rel_val"
							}
						}
					}

					Row
					{
						visible: 					materiality_test.checked

						RadioButton
						{
							id: 					materiality_abs
							name: 					"materiality_abs"
							text: 					qsTr("Absolute")
							childrenOnSameRow: 		true

							DoubleField
							{
								id: 				materiality_abs_val
								visible: 			materiality_abs.checked
								name: 				"materiality_abs_val"
								defaultValue: 		0
								min: 				0
								fieldWidth: 		90 * preferencesModel.uiScale
								decimals: 			2
							}
						}
					}
				}
			}

			HelpButton
			{
				toolTip: 							qsTr("Click to learn more about performance materiality.")
				helpPage:							"Audit/performanceMateriality"
			}

			CheckBox
			{
				id: 								min_precision_test
				text: 								qsTr("Minimum precision")
				name: 								"min_precision_test"

				PercentField
				{
					id: 							min_precision_rel_val
					name: 							"min_precision_rel_val"
					decimals: 						2
					defaultValue: 					2
					min:							0.1
					max:							99.9
					label: 							qsTr("Relative")
					visible: 						min_precision_test.checked
				}
			}

			HelpButton
			{
				toolTip: 							qsTr("Click to learn more about the precision.")
				helpPage:							"Audit/minimumPrecision"
			}
		}

		CIField
		{
			name: 									"conf_level"
			label: 									qsTr("Confidence")
			enabled:								!pasteVariables.checked
		}

		Divider { }

		VariablesForm
		{
			id: 									variablesFormPlanning
			preferredHeight: 						jaspTheme.smallDefaultVariablesFormHeight
			enabled:								!pasteVariables.checked

			AvailableVariablesList
			{
				name: 								"variablesFormPlanning"
			}

			AssignedVariablesList
			{
				id: 								id
				name: 								"id"
				title: 								qsTr("Item ID")
				singleVariable:						true
				allowedColumns:						["nominal", "nominalText", "ordinal", "scale"]
				allowAnalysisOwnComputedColumns: 	false
				onCountChanged:						if(lik_hypergeometric.checked && id.count == 0) lik_binomial.click()
			}

			AssignedVariablesList
			{
				id: 								values
				name: 								"values"
				title: 								qsTr("Book Value")
				singleVariable: 					true
				allowedColumns: 					["scale"]
				allowAnalysisOwnComputedColumns: 	false
				onCountChanged:
				{
					if (initialized)
					{
						values.count > 0 ? values_sampling.click() : rows_sampling.click()
						values.count > 0 ? continuous.click() : binary.click()
					}
				}
			}
		}

		RadioButtonGroup
		{
			id: 									expected
			name: 									"expected_type"
			title: 									qsTr("Expected Errors in Sample")
			enabled:								!pasteVariables.checked

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
			enabled:								!pasteVariables.checked

			RadioButton
			{
				id: 								lik_hypergeometric
				text: 								qsTr("Hypergeometric")
				name: 								"hypergeometric"
				enabled:							id.count > 0
			}

			RadioButton
			{
				id: 								lik_binomial
				text: 								qsTr("Binomial")
				name: 								"binomial"
				checked: 							true
			}

			RadioButton
			{
				id: 								lik_poisson
				text: 								qsTr("Poisson")
				name: 								"poisson"
			}
		}

		Group
		{
			title: 									qsTr("Tables")

			CheckBox
			{
				text: 								qsTr("Descriptive statistics")
				name: 								"tableBookDist"
				enabled:							values.count > 0
			}
		}

		Group
		{
			title: 									qsTr("Audit Risk Model")
			enabled:								materiality_test.checked && !pasteVariables.checked

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
			title: 									qsTr("Plots")

			CheckBox
			{
				name: 								"plotBookDist"
				text: 								qsTr("Distribution of book values")
				enabled: 							values.count > 0
			}

			CheckBox
			{
				text: 								qsTr("Compare sample sizes")
				name: 								"plotSampleSizes"
				enabled:							materiality_test.checked
			}

			CheckBox
			{
				text: 								qsTr("Assumed error distribution")
				name: 								"plotErrorDist"
			}
		}

		Section
		{
			title:									qsTr("Advanced Options")
			columns:								3

			Group
			{
				name:								"critical_items"
				title:								qsTr("Critical Items")
				enabled:							data.checked && values.count > 0 && !pasteVariables.checked

				CheckBox
				{
					id: 							critical_negative
					name:							"critical_negative"
					text:							qsTr("Negative book values")
					enabled:						values.count > 0
					checked:						true

					ComputedColumnField
					{
						id: 						critical_name
						name: 						"critical_name"
						text: 						qsTr("Column name")
						fieldWidth: 				120 * preferencesModel.uiScale
						value: 						qsTr("critical")
					}

					RadioButtonGroup
					{
						name: 						"critical_action"

						RadioButton
						{
							id:						inspect
							text: 					qsTr("Keep")
							name: 					"inspect"
							checked: 				true
						}

						RadioButton
						{
							text: 					qsTr("Remove")
							name: 					"remove"
						}
					}
				}
			}

			Group
			{
				title:								qsTr("Iterations")
				enabled:							!pasteVariables.checked

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

				RadioButton
				{
					text: 							qsTr("Monetary values")
					name: 							"amount"
					enabled:						values.count > 0
				}
			}
		}

		Item
		{
			Layout.preferredHeight: 				toSampling.height
			Layout.fillWidth: 						true
			enabled:								!pasteVariables.checked
			Layout.columnSpan: 						2

			Button
			{
				anchors.right:						toSampling.left
				anchors.rightMargin:				jaspTheme.generalAnchorMargin
				text:								qsTr("<b>Download Report</b>")
				onClicked:							form.exportResults()
			}

			CheckBox
			{
				id: 								samplingChecked
				name: 								"samplingChecked"
				anchors.right:						toSampling.left
				width:								0
				visible: 							false
				checked: 							false
			}

			Button
			{
				id: 								toSampling
				anchors.right: 						parent.right
				text: 								qsTr("<b>To Selection</b>")
				enabled: 							!samplingChecked.checked && ((materiality_rel.checked ?
																					  materiality_rel_val.value > 0 && id.count > 0 :
																					  materiality_abs_val.value > 0 && id.count > 0 && values.count > 0) ||
																				 (min_precision_test.checked && min_precision_rel_val.value > 0 && id.count > 0))
				onClicked:							samplingChecked.checked	= true
			}
		}
	}

	// --------------------------------------------------------------------------------------------------------------------------------------------
	// ---------------------------------------------------  SELECTION  ----------------------------------------------------------------------------
	// --------------------------------------------------------------------------------------------------------------------------------------------

	Section
	{
		id: 										samplingPhase
		text: 										samplingPhase.expanded ? qsTr("<b>2. Selection</b>") : qsTr("2. Selection")
		enabled: 									samplingChecked.checked
		expanded: 									samplingChecked.checked && !executionChecked.checked
		columns: 									2

		VariablesForm
		{
			id: 									variablesFormSampling
			preferredHeight: 						jaspTheme.smallDefaultVariablesFormHeight
			enabled: 								!pasteVariables.checked

			AvailableVariablesList
			{
				name: 								"variablesFormSampling"
			}

			AssignedVariablesList
			{
				id:									rank
				name: 								"rank"
				title: 								qsTr("Ranking Variable")
				singleVariable:						true
				allowedColumns:						["scale"]
				allowAnalysisOwnComputedColumns: 	false
			}

			AssignedVariablesList
			{
				name:								"variables"
				title: 								qsTr("Additional Variables")
				Layout.preferredHeight: 			140 * preferencesModel.uiScale
				allowedColumns: 					["scale", "ordinal", "nominal"]
				allowAnalysisOwnComputedColumns: 	false
			}
		}

		Group
		{
			IntegerField
			{
				id: 								seed
				text: 								qsTr("Seed")
				name: 								"seed"
				defaultValue: 						1
				min: 								1
				max: 								99999
				enabled:							randomize.checked || method.value != "interval"
			}

			CheckBox
			{
				id:									randomize
				name:								"randomize"
				text:								qsTr("Randomize item order")
				enabled:							!pasteVariables.checked && rank.count == 0
			}
		}

		Group
		{
			title: 									qsTr("Tables")

			CheckBox
			{
				text: 								qsTr("Descriptive statistics")
				name: 								"tableDescriptives"
			}

			CheckBox
			{
				text: 								qsTr("Selected items")
				name: 								"tableSample"
			}
		}

		Group
		{
			rowSpacing: 							15 * preferencesModel.uiScale

			RadioButtonGroup
			{
				id: 								units
				title:								qsTr("Sampling Units")
				name: 								"units"
				columns:							2
				enabled:							!pasteVariables.checked

				RadioButton
				{
					id: 							rows_sampling
					text: 							qsTr("Items")
					name: 							"items"
					checked: 						true
				}

				HelpButton
				{
					toolTip: 						qsTr("Click to learn more about record sampling.")
					helpPage:						"Audit/recordSampling"
				}

				RadioButton
				{
					id: 							values_sampling
					text: 							qsTr("Monetary units")
					name: 							"values"
					enabled: 						values.count > 0
				}

				HelpButton
				{
					helpPage:						"Audit/monetaryUnitSampling"
					toolTip: 						qsTr("Click to learn more about monetary unit sampling.")
				}
			}

			RadioButtonGroup
			{
				id: 								method
				title:								qsTr("Method")
				name: 								"sampling_method"
				enabled:							!pasteVariables.checked
				columns:							2

				RadioButton
				{
					id: 							interval
					text: 							qsTr("Fixed interval sampling")
					name: 							"interval"
					checked: 						true

					IntegerField
					{
						id: 						start
						text: 						qsTr("Starting point")
						name: 						"start"
						defaultValue: 				1
						min: 						1
						visible:					interval.checked
					}
				}

				HelpButton
				{
					toolTip: 						qsTr("Click to learn more about fixed interval sampling.")
					helpPage:						"Audit/fixedIntervalSampling"
				}

				RadioButton
				{
					id: 							cell
					text: 							qsTr("Cell sampling")
					name: 							"cell"
				}

				HelpButton
				{
					toolTip: 						qsTr("Click to learn more about cell sampling.")
					helpPage:						"Audit/cellSampling"
				}

				RadioButton
				{
					id: 							random
					text: 							qsTr("Random sampling")
					name: 							"random"
				}

				HelpButton
				{
					toolTip: 						qsTr("Click to learn more about random sampling.")
					helpPage:						"Audit/randomSampling"
				}
			}
		}

		Item
		{
			Layout.preferredHeight: 				toExecution.height
			Layout.fillWidth: 						true
			enabled:								!pasteVariables.checked
			Layout.columnSpan:						2

			Button
			{
				anchors.left: 						parent.left
				text: 								qsTr("<b>Reset Workflow</b>")
				onClicked: 							form.reset()
			}

			Button
			{
				enabled:							((materiality_rel.checked ?
														materiality_rel_val.value != "0" && id.count > 0 :
														materiality_abs_val.value != "0" && id.count > 0 && values.count > 0) ||
													 (min_precision_test.checked && min_precision_rel_val.value != "0" && id.count > 0))
				anchors.right:						toExecution.left
				anchors.rightMargin:				jaspTheme.generalAnchorMargin
				text:								qsTr("<b>Download Report</b>")
				onClicked:							form.exportResults()
			}

			CheckBox
			{
				id: 								executionChecked
				anchors.right: 						toExecution.left
				width: 								0
				visible: 							false
				name: 								"executionChecked"
				checked: 							false
			}

			Button
			{
				id: 								toExecution
				anchors.right: 						parent.right
				text: 								qsTr("<b>To Execution</b>")
				enabled:							!executionChecked.checked
				onClicked:							executionChecked.checked = true
			}
		}
	}

	// --------------------------------------------------------------------------------------------------------------------------------------------
	// ---------------------------------------------------  EXECUTION  ----------------------------------------------------------------------------
	// --------------------------------------------------------------------------------------------------------------------------------------------

	Section
	{
		id: 										executionPhase
		text: 										executionPhase.expanded ? qsTr("<b>3. Execution</b>") : qsTr("3. Execution")
		expanded: 									executionChecked.checked && !evaluationChecked.checked
		enabled: 									executionChecked.checked
		columns: 									2

		RadioButtonGroup
		{
			id: 									annotation
			name: 									"annotation"
			title: 									qsTr("Annotation")
			enabled:								!pasteVariables.checked
			columns:								2

			RadioButton
			{
				id: 								continuous
				text: 								qsTr("Audit value")
				name: 								"continuous"
				enabled: 							values.count > 0
			}

			HelpButton
			{
				toolTip: 							qsTr("Adds a column to specify the audit values of the items.")
				helpPage: 							"?"
			}

			RadioButton
			{
				id: 								binary
				text: 								qsTr("Correct / Incorrect")
				name: 								"binary"
				checked: 							true
				enabled: 							true
			}

			HelpButton
			{
				toolTip:							qsTr("Adds a column to specify the items as correct (0) or misstated (1).")
				helpPage: 							"?"
			}
		}

		Group
		{
			id: 									names
			enabled:								!pasteVariables.checked

			ComputedColumnField
			{
				id: 								indicator_col
				name: 								"indicator_col"
				text: 								qsTr("Column name selection result")
				fieldWidth: 						120 * preferencesModel.uiScale
				value:								qsTr("selected")
			}

			ComputedColumnField
			{
				id: 								variable_col
				name: 								"variable_col"
				text: 								qsTr("Column name audit result")
				fieldWidth: 						120 * preferencesModel.uiScale
				value: 								qsTr("auditResult")
			}
		}

		Item
		{
			Layout.preferredHeight:					names.height
			Layout.columnSpan:						2
			Layout.fillWidth:						true

			CheckBox
			{
				id: 								pasteVariables
				anchors.right: 						pasteButton.left
				width: 								height
				visible: 							false
				name: 								"pasteVariables"
				checked: 							false
			}

			Button
			{
				id: 								pasteButton
				text: 								qsTr("<b>Fill Variables</b>")
				enabled: 							indicator_col.value != "" && variable_col.value != "" && !pasteVariables.checked
				anchors.right:						parent.right
				onClicked:
				{
					pasteVariables.checked 		= true
					performAuditTable.colName   = variable_col.value
					performAuditTable.extraCol	= indicator_col.value
					critical_negative.checked && inspect.checked ? performAuditTable.filter = indicator_col.value + " > 0" + " | " + critical_name.value + " > 0" : performAuditTable.filter = indicator_col.value + " > 0"
					performAuditTable.initialValuesSource = continuous.checked ? "values" : ""
				}
			}
		}

		Section
		{
			id:										executeAuditSection
			title:									qsTr("Data Entry")
			expanded:								pasteVariables.checked
			enabled:								pasteVariables.checked
			columns:								1

			Label
			{
				id: 								performAuditText
				Layout.alignment: 					Qt.AlignHCenter
				text: 								continuous.checked ? qsTr("<b>Annotate your selected items with their audit (true) values.</b>") : qsTr("<b>Annotate your selected items as correct (0) or incorrect (1).</b>")
				visible: 							pasteVariables.checked
			}

			TableView
			{
				id:									performAuditTable
				name:								"performAudit"
				Layout.fillWidth: 					true
				modelType:							JASP.FilteredDataEntryModel
				source:								["id", "values", "variables"]
				colName:							"Filter"
				defaultValue:						0
				decimals:							10
			}
		}

		Item
		{
			Layout.preferredHeight: 				toEvaluation.height
			Layout.fillWidth: 						true
			enabled:								!evaluationChecked.checked
			Layout.columnSpan:						2

			Button
			{
				anchors.left: 						parent.left
				text: 								qsTr("<b>Reset Workflow</b>");
				onClicked: 							form.reset()
			}

			CheckBox
			{
				id: 								evaluationChecked
				anchors.right:						toEvaluation.left
				width: 								height
				visible: 							false
				name: 								"evaluationChecked"
				checked: 							false
			}

			Button
			{
				id: 								toEvaluation
				enabled: 							pasteVariables.checked
				anchors.right: 						parent.right
				text: 								qsTr("<b>To Evaluation</b>")

				onClicked:
				{
					executionPhase.expanded 		= false
					executeAuditSection.expanded	= false
					evaluationChecked.checked 		= true
					if (values_sampling.checked && continuous.checked)
						stringer.click()
					if (rows_sampling.checked && continuous.checked)
						regression.click()
					if (binary.checked)
					{
						if (lik_poisson.checked) 				poisson.click()
						if (lik_binomial.checked) 				binomial.click()
						if (lik_hypergeometric.checked) 		hypergeometric.click()
					}
				}
			}
		}
	}

	// --------------------------------------------------------------------------------------------------------------------------------------------
	// ---------------------------------------------------  EVALUATION  ---------------------------------------------------------------------------
	// --------------------------------------------------------------------------------------------------------------------------------------------

	Section
	{
		id: 										evaluationPhase
		text: 										evaluationPhase.expanded ? qsTr("<b>4. Evaluation</b>") : qsTr("4. Evaluation")
		expanded: 									evaluationChecked.checked
		enabled: 									evaluationChecked.checked
		columns: 									2

		VariablesForm
		{
			preferredHeight: 						jaspTheme.smallDefaultVariablesFormHeight

			AvailableVariablesList
			{
				name: 								"evaluationVariables"
				source: 							"variablesFormPlanning"
			}

			AssignedVariablesList
			{
				id: 								auditResult
				name: 								"values.audit"
				title: 								continuous.checked ? qsTr("Audit Value") : qsTr("Audit Result")
				singleVariable: 					true
				allowedColumns: 					["nominal" ,"scale"]
			}
		}

		RadioButtonGroup
		{
			title: 									qsTr("Method")
			name: 									"method"

			RadioButton
			{
				id:									hypergeometric
				name: 								"hypergeometric"
				text: 								qsTr("Hypergeometric")
				enabled:							id.count > 0
			}

			RadioButton
			{
				id:									binomial
				name: 								"binomial"
				text: 								qsTr("Binomial")
				checked:							true
			}

			RadioButton
			{
				id:									poisson
				name: 								"poisson"
				text: 								qsTr("Poisson")
			}

			RadioButton
			{
				id: 								stringer
				name: 								"stringer"
				text: 								qsTr("Stringer")
				enabled: 							values.count > 0 && continuous.checked

				CheckBox
				{
					name: 							"lta"
					text: 							qsTr("LTA adjustment")
					checked: 						true
				}
			}

			RadioButton
			{
				id:									mpu
				name: 								"mpu"
				text: 								qsTr("Mean-per-unit estimator")
				enabled: 							values.count > 0 && continuous.checked
			}

			RadioButton
			{
				id:									direct
				name: 								"direct"
				text: 								qsTr("Direct estimator")
				enabled: 							values.count > 0 && continuous.checked
			}

			RadioButton
			{
				id:									difference
				name: 								"difference"
				text: 								qsTr("Difference estimator")
				enabled: 							values.count > 0 && continuous.checked
			}

			RadioButton
			{
				id:									quotient
				name: 								"quotient"
				text: 								qsTr("Ratio estimator")
				enabled: 							values.count > 0 && continuous.checked
			}

			RadioButton
			{
				id:									regression
				name: 								"regression"
				text: 								qsTr("Regression estimator")
				enabled: 							values.count > 0 && continuous.checked
			}
		}

		Group
		{

			Group
			{
				title: 								qsTr("Tables")

				CheckBox
				{
					text: 							qsTr("Corrections to population")
					name: 							"tableCorrections"
					enabled:						values.count > 0
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
					enabled: 						continuous.checked

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

		}

		Item
		{
			Layout.preferredHeight: 				toInterpretation.height
			Layout.preferredWidth:					parent.width
			Layout.columnSpan:						2

			Button
			{
				id: 								toInterpretation
				anchors.right:						parent.right
				text:								qsTr("<b>Download Report</b>")
				onClicked:
				{
					evaluationPhase.expanded = false
					form.exportResults()
				}
			}
		}
	}
}
