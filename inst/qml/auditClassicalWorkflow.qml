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

import QtQuick
import QtQuick.Layouts
import JASP
import JASP.Controls
import JASP.Widgets

import "./common" as Common
import "./common/selection" as Selection
import "./common/planning" as Planning
import "./common/evaluation" as Evaluation

// --------------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------  BEGIN WORKFLOW  -------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------------------

Form
{
	columns: 										2
	info:											qsTr("The task of an auditor is to make a judgment regarding the fairness of the presented transactions in a population. When the auditor has access to the raw population data, they can use the *audit workflow* to calculate how many samples need to be evaluated in order to meet a certain confidence in their judgment. The user can then sample these items from the population, inspect and audit these items, and perform statistical inference about the misstatement in the population. The sampling workflow guides the auditor through the audit process, making the correct choices of calculations along the way.\n\nPlease see the manual of the Audit module (download [here](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) for more detailed information about this analysis.\n\n### Workflow\n---\n- Planning: Calculate the minimum sample size to achieve your sampling objectives with the specified confidence.\n- Selection: Select the required sampling units from the population.\n- Execution: Annotate the selection with your assessment of the fairness of the selected items.\n- Evaluation: Make a population statement based on your annotated selection.\n\n![Audit sampling workflow](%HELP_FOLDER%/img/workflow.png)")

	// Hidden option(s)
	CheckBox { name: "workflow"; checked: true; visible: false }
	CheckBox { name: "bayesian"; checked: false; visible: false }
	CheckBox { name: "separateMisstatement"; checked: false; visible: false }
	RadioButtonGroup { name: "dataType"; visible: false; RadioButton { name: "data"; checked: true } }
	RadioButtonGroup { name: "prior_method"; visible: false; RadioButton { name: "arm"; checked: true } }

	// --------------------------------------------------------------------------------------------------------------------------------------------
	// ---------------------------------------------------  PLANNING  -----------------------------------------------------------------------------
	// --------------------------------------------------------------------------------------------------------------------------------------------

	Section
	{
		id: 										planningPhase
		text: 										planningPhase.expanded ? qsTr("<b>1. Planning</b>") : qsTr("1. Planning")
		expanded: 									!samplingChecked.checked
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
			Selection.IdVariable { id: id }
			Selection.BookVariable { id: values }
		}

		GridLayout
		{
			columns: 1
			Planning.SamplingObjectives { id: objectives; enable: !pasteVariables.checked }
			Planning.ExpectedErrors { enable: !pasteVariables.checked }
			Planning.AuditRiskModel { enable: objectives.use_materiality && !pasteVariables.checked }
			Common.ExplanatoryText { }
		}

		Section
		{
			title:									qsTr("Report")
			columns:								2
			Planning.PlanningOutput { bayesian: false; workflow: true; enable_values: values.use_book }
			Common.Display { show_monetary: true; enable_monetary: values.use_book }
		}

		Section
		{
			title:									qsTr("Advanced")
			columns:								3
			Planning.Likelihood { id:likelihood; bayesian: false; evaluation: false; enable: !pasteVariables.checked; enable_hypergeometric: id.use_id || (id.use_id && values.use_book) }
			Planning.Iterations { enable: !pasteVariables.checked }
			Planning.CriticalItems { id: critical; enable: values.use_book && !pasteVariables.checked }
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
				enabled: 							!samplingChecked.checked && ((objectives.use_materiality && (objectives.absolute_materiality ?
																													 objectives.absolute_value > 0 && id.use_id && values.use_book :
																													 objectives.relative_value > 0 && id.use_id)) ||
																				 (objectives.use_precision && objectives.precision_value > 0 && id.use_id))
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
			visible:								add_selection_variables.checked

			AvailableVariablesList
			{
				name: 								"variablesFormSampling"
			}

			Selection.RankVariable { id: rank }
			Selection.AdditionalVariables { }
		}

		GridLayout
		{
			columns:								1

			Group
			{
				Selection.Seed { enable: (randomize.use_randomize || !method.use_interval || method.use_random_start) && !pasteVariables.checked }
				Selection.Randomize { id: randomize; enable: !pasteVariables.checked && !rank.use_rank }
				CheckBox
				{
					id:								add_selection_variables
					name:							"add_sel_vars"
					text:							qsTr("Add variables to sample")
					enabled:						!pasteVariables.checked
					debug:							true
				}
			}

			Selection.SamplingUnits { id: units; enable: !pasteVariables.checked; enable_mus: values.use_book }
			Selection.SelectionMethod { id: method; enable: !pasteVariables.checked; enable_sieve: values.use_book && units.use_mus }
		}

		Section
		{
			title:									qsTr("Report")
			Selection.SelectionOutput { }
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

		Evaluation.Annotation { id: annotation; enable: !pasteVariables.checked; enable_values: values.use_book }
		Evaluation.AddVariables { id: names; enable: !pasteVariables.checked }

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
				text: 								qsTr("<b>Continue</b>")
				enabled: 							names.indicator_name != "" && names.variable_name != "" && !pasteVariables.checked
				anchors.right:						parent.right
				onClicked:
				{
					pasteVariables.checked 		= true
					performAuditTable.colName   = names.variable_name
					performAuditTable.extraCol	= names.indicator_name

					if(values.count > 0 && critical.use_negative && critical.use_inspect)
						performAuditTable.filter = names.indicator_name + " > 0" + " | " + critical.use_name + " > 0" 
					else
						performAuditTable.filter = names.indicator_name + " > 0"

					performAuditTable.initialValuesSource = annotation.use_values ? "values" : ""
				}
			}
		}

		Section
		{
			id:										executeAuditSection
			title:									qsTr("Sample List")
			expanded:								pasteVariables.checked
			enabled:								pasteVariables.checked
			columns:								1

			Label
			{
				id: 								performAuditText
				Layout.alignment: 					Qt.AlignHCenter
				text: 								annotation.use_values ? qsTr("<b>Annotate your selected items with their audit (true) values.</b>") : qsTr("<b>Annotate your selected items as correct (0) or incorrect (1).</b>")
				visible: 							pasteVariables.checked
			}

			TableView
			{
				id:									performAuditTable
				name:								"performAudit"
				Layout.fillWidth: 					true
				modelType:							JASP.FilteredDataEntryModel
				source:								["id", "values", "variables"]
				defaultValue:						0
				decimals:							10
				Layout.preferredHeight:				500 * preferencesModel.uiScale
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
			Evaluation.AuditVariable { binary: annotation.use_values }
		}

		Section
		{
			title:									qsTr("Report")
			Group
			{
				columns:				1
				Evaluation.EvaluationOutput
				{
					bayesian: false
					enable_taints: values.use_book
					enable_corrections: values.use_book
					enable_objectives: objectives.use_materiality || objectives.use_precision
					enable_scatter: annotation.use_values
					enable_estimates: true
				}
			}
		}

		Section
		{
			title:									qsTr("Advanced")

			RadioButtonGroup
			{
				title: 								qsTr("Method")
				name: 								"method"

				RadioButton
				{
					id:								hypergeometric
					name: 							"hypergeometric"
					text: 							qsTr("Hypergeometric")
					enabled:						id.use_id
					checked:						likelihood.use_hypergeometric
				}

				RadioButton
				{
					id:								binomial
					name: 							"binomial"
					text: 							qsTr("Binomial")
					checked:						likelihood.use_binomial
				}

				RadioButton
				{
					id:								poisson
					name: 							"poisson"
					text: 							qsTr("Poisson")
					checked:						likelihood.use_poisson
				}

				RadioButton
				{
					id: 							stringer
					name: 							"stringer.binomial"
					text: 							qsTr("Stringer")
					enabled: 						values.use_book && annotation.use_values && interval.use_right

					CheckBox
					{
						name: 						"lta"
						text: 						qsTr("LTA adjustment")
						checked: 					true
					}
				}

				RadioButton
				{
					id:								mpu
					name: 							"mpu"
					text: 							qsTr("Mean-per-unit estimator")
					enabled: 						values.use_book && annotation.use_values
				}

				RadioButton
				{
					id:								direct
					name: 							"direct"
					text: 							qsTr("Direct estimator")
					enabled: 						values.use_book && annotation.use_values
				}

				RadioButton
				{
					id:								difference
					name: 							"difference"
					text: 							qsTr("Difference estimator")
					enabled: 						values.use_book && annotation.use_values
				}

				RadioButton
				{
					id:								quotient
					name: 							"quotient"
					text: 							qsTr("Ratio estimator")
					enabled: 						values.use_book && annotation.use_values
				}

				RadioButton
				{
					id:								regression
					name: 							"regression"
					text: 							qsTr("Regression estimator")
					enabled: 						values.use_book && annotation.use_values
				}
			}

			Evaluation.IntervalType { id: interval; bayesian: false; enable: !stringer.checked; test: objectives.use_materiality }
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
