
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

// --------------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------  BEGIN WORKFLOW  -------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------------------

Form
{
	columns: 										2

	// Hidden option(s)
	CheckBox { name: "workflow"; checked: true; visible: false }
	CheckBox { name: "bayesian"; checked: true; visible: false }
	RadioButtonGroup { name: "dataType"; visible: false; RadioButton { name: "data"; checked: true } }

	// --------------------------------------------------------------------------------------------------------------------------------------------
	// ---------------------------------------------------  PLANNING  -----------------------------------------------------------------------------
	// --------------------------------------------------------------------------------------------------------------------------------------------

	Section
	{
		id: 										planningPhase
		text: 										planningPhase.expanded ? qsTr("<b>1. Planning</b>") : qsTr("1. Planning")
		expanded:									!samplingChecked.checked
		columns: 									2

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
				title: 								qsTr("Item ID (required)")
				singleVariable:						true
				allowedColumns:						["nominal", "nominalText", "ordinal", "scale"]
				allowAnalysisOwnComputedColumns: 	false
				// onCountChanged:						if(likelihood.use_hypergeometric && id.count == 0) lik_binomial.click()
			}

			AssignedVariablesList
			{
				id: 								values
				name: 								"values"
				title: 								qsTr("Book Value (optional)")
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

		GridLayout
		{
			columns: 1

			Common.SamplingObjectives { id: objectives; enabled: !pasteVariables.checked }
			Common.ExpectedErrors { enabled: !pasteVariables.checked }
			Common.ExplanatoryText { }
		}

		Section
		{
			title: 									qsTr("Prior")
			columns:								2

			Common.Likelihood { id:likelihood; bayesian: true; evaluation: false; enable_hypergeometric: id.count > 0 && values.count > 0 }
			Common.PriorMethod { use_materiality: objectives.use_materiality }
		}

		Section
		{
			title:				qsTr("Report")
			columns:			2

			Common.PlanningOutput { bayesian: true; workflow: true; enable_values: values.count > 0; disable_predictive: likelihood.use_hypergeometric }
			Common.Display { show_monetary: true; enable_monetary: values.count > 0 }
		}

		Section
		{
			title:									qsTr("Advanced")
			columns:								3

			Common.Iterations { enable: !pasteVariables.checked }
			Common.CriticalItems { id: critical; enable: !data.use_stats && values.count > 0 && !pasteVariables.checked }
			Common.Algorithm
			{
				id: 								algorithm
				enable:								!pasteVariables.checked
				enable_algorithm2: 					id.count > 0 && values.count > 0 && likelihood.use_binomial
			}
		}

		Item
		{
			Layout.preferredHeight: 				toSampling.height
			Layout.fillWidth: 						true
			enabled:								!pasteVariables.checked
			Layout.columnSpan:						2

			Button
			{
				anchors.right:	 					toSampling.left
				anchors.rightMargin:				jaspTheme.generalAnchorMargin
				text:								qsTr("<b>Download Report</b>")
				onClicked: 							form.exportResults()
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
				enabled: 							!samplingChecked.checked && ((objectives.use_materiality && (objectives.absolute_materiality ?
																													 objectives.absolute_value > 0 && id.count > 0 && values.count > 0 :
																													 objectives.relative_value > 0 && id.count > 0)) ||
																				 (objectives.use_precision && objectives.precision_value > 0 && id.count > 0))
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

		GridLayout
		{
			columns:								1

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
					enabled:							(randomize.checked || !method.use_interval) && !algorithm.use_algorithm2
				}

				CheckBox
				{
					id:									randomize
					name:								"randomize"
					text:								qsTr("Randomize item order")
					enabled:							!pasteVariables.checked && !separate.checked && rank.count == 0
				}

				CheckBox
				{
					id:									add_selection_variables
					name:								"add_sel_vars"
					text:								qsTr("Add variables to sample")
					enabled:							!pasteVariables.checked
				}
			}

			Common.SamplingUnits { enable: !pasteVariables.checked; enable_mus: values.count > 0; force_mus: separate.checked }
			Common.SelectionMethod { id: method; enable: !pasteVariables.checked; force_interval: separate.checked}
		}

		VariablesForm
		{
			id: 									variablesFormSampling
			preferredHeight: 						jaspTheme.smallDefaultVariablesFormHeight
			enabled: 								!pasteVariables.checked
			visible:								add_selection_variables.checked

			AvailableVariablesList
			{
				name: 								"variablesFormSampling"
			}

			AssignedVariablesList
			{
				id:									rank
				name: 								"rank"
				title: 								qsTr("Ranking Variable (optional)")
				singleVariable:						true
				allowedColumns:						["scale"]
				allowAnalysisOwnComputedColumns: 	false
				enabled:							!separate.checked
			}

			AssignedVariablesList
			{
				name:								"variables"
				title: 								qsTr("Additional Variables (optional)")
				Layout.preferredHeight: 			140 * preferencesModel.uiScale
				allowedColumns: 					["scale", "ordinal", "nominal", "nominalText"]
				allowAnalysisOwnComputedColumns: 	false
			}
		}

		Section
		{
			title:			qsTr("Report")
			Group
			{
				Common.SelectionOutput { }
			}
		}

		Item
		{
			Layout.preferredHeight: 				toExecution.height
			Layout.fillWidth: 						true
			Layout.columnSpan:						2
			enabled:								!pasteVariables.checked

			Button
			{
				anchors.left: 						parent.left
				text: 								qsTr("<b>Reset Workflow</b>")
				onClicked: 							form.reset()
			}

			Button
			{
				anchors.right:						toExecution.left
				anchors.rightMargin:				jaspTheme.generalAnchorMargin
				text:								qsTr("<b>Download Report</b>")
				onClicked:							form.exportResults()
			}

			CheckBox
			{
				id: 								executionChecked
				anchors.right: 						toExecution.left
				width: 								height
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
				enabled: 							!separate.checked
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
					critical.use_negative && critical.use_inspect ? performAuditTable.filter = indicator_col.value + " > 0" + " | " + critical.use_name + " > 0" : performAuditTable.filter = indicator_col.value + " > 0"
					performAuditTable.initialValuesSource = continuous.checked ? "values" : ""
				}
			}
		}

		Section
		{
			id: 									executeAuditSection
			title:									qsTr("Sample List")
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
				source:     						["id", "values", "variables"]
				colName:    						"Filter"
				defaultValue:						0
				decimals:							10
			}
		}

		Item
		{
			Layout.preferredHeight: 				toEvaluation.height
			Layout.fillWidth: 						true
			Layout.columnSpan:						2
			enabled:								!evaluationChecked.checked

			Button
			{
				anchors.left: 						parent.left
				text: 								qsTr("<b>Reset Workflow</b>");
				onClicked: 							form.reset()
			}

			CheckBox
			{
				id: 								evaluationChecked
				anchors.right: 						toEvaluation.left
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
					executionPhase.expanded = false
					executeAuditSection.expanded = false
					evaluationChecked.checked = true
					if (lik_binomial.checked) 						binomial.click()
					if (lik_hypergeometric.checked) 				hypergeometric.click()
					if (lik_poisson.checked) 						poisson.click()
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
				allowedColumns: 					["nominal", "scale"]
			}
		}

		Section
		{
			title:						qsTr("Report")

			Group
			{
				columns:				1

				Common.EvaluationOutput
				{
					bayesian: true
					enable_taints: values.count > 0 && !data.use_stats
					enable_corrections: values.count > 0
					enable_assumptions: algorithm.use_algorithm2
					enable_objectives: objectives.use_materiality || objectives.use_precision
					enable_predictive: !likelihood.use_hypergeometric
					enable_scatter: continuous.checked
				}
			}
		}

		Section
		{
			title:									qsTr("Advanced")
			columns:								2

			RadioButtonGroup
			{
				title: 									qsTr("Distribution")
				name: 									"method"
				debug:									true

				RadioButton
				{
					id: 								hypergeometric
					name: 								"hypergeometric"
					text: 								qsTr("Beta-binomial")
					enabled: 							lik_hypergeometric.checked
				}

				RadioButton
				{
					id: 								binomial
					name: 								"binomial"
					text: 								qsTr("Beta")
					enabled: 							lik_binomial.checked
				}

				RadioButton
				{
					id: 								poisson
					name: 								"poisson"
					text: 								qsTr("Gamma")
					enabled: 							lik_poisson.checked
				}
			}

			Common.IntervalType { }
		}

		Item
		{
			Layout.preferredHeight: 				toInterpretation.height
			Layout.preferredWidth: 					parent.width
			Layout.columnSpan:						2

			Button
			{
				id: 								toInterpretation
				anchors.right: 						parent.right
				text: 								qsTr("<b>Download Report</b>")
				onClicked:
				{
					evaluationPhase.expanded = false
					form.exportResults()
				}
			}
		}
	}
}
// --------------------------------------------------------------------------------------------------------------------------------------------
// ---------------------------------------------------  END WORKFLOW  -------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------------------
