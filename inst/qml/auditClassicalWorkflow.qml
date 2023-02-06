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

// --------------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------  BEGIN WORKFLOW  -------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------------------

Form
{
	columns: 										2
	info:											qsTr("The task of an auditor is to make a judgment regarding the fairness of the presented transactions in a population. When the auditor has access to the raw population data, they can use the *audit workflow* to calculate how many samples need to be evaluated in order to meet a certain confidence in their judgment. The user can then sample these items from the population, inspect and audit these items, and perform statistical inference about the misstatement in the population. The sampling workflow guides the auditor through the audit process, making the correct choices of calculations along the way.\n\nPlease see the manual of the Audit module (download [here](https://github.com/jasp-stats/jaspAudit/raw/master/man/manual.pdf)) for more detailed information about this analysis.\n\n### Workflow\n---\n- Planning: Calculate the minimum sample size to achieve your sampling objectives with the specified confidence.\n- Selection: Select the required sampling units from the population.\n- Execution: Annotate the selection with your assessment of the fairness of the selected items.\n- Evaluation: Make a population statement based on your annotated selection.\n\n<img src='%HELP_FOLDER%/img/workflow.png'/>"")

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

															 AssignedVariablesList
															 {
																 id: 								id
																 name: 								"id"
																 title: 								qsTr("Item ID")
																 singleVariable:						true
																 allowedColumns:						["nominal", "nominalText", "ordinal", "scale"]
																 allowAnalysisOwnComputedColumns: 	false
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

														 GridLayout
														 {
															 columns: 1
															 Common.SamplingObjectives { id: objectives; enabled: !pasteVariables.checked }
															 Common.ExpectedErrors { enabled: !pasteVariables.checked }
															 Common.AuditRiskModel { enable: objectives.use_materiality }
															 Common.ExplanatoryText { }
														 }

														 Section
														 {
															 title:									qsTr("Report")
															 columns:								2
															 Common.PlanningOutput { bayesian: false; workflow: true; enable_values: values.count > 0 }
															 Common.Display { show_monetary: true; enable_monetary: values.count > 0 }
														 }

														 Section
														 {
															 title:									qsTr("Advanced")
															 columns:								3
															 Common.Likelihood { id:likelihood; bayesian: false; evaluation: false; enable_hypergeometric: id.count > 0 && values.count > 0  }
															 Common.Iterations { enable: !pasteVariables.checked }
															 Common.CriticalItems { id: critical; enable: !data.use_stats && values.count > 0 && !pasteVariables.checked }
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
																		 enabled:							randomize.checked || !method.use_interval || method.use_random_start
																	 }

																	 CheckBox
																	 {
																		 id:									randomize
																		 name:								"randomize"
																		 text:								qsTr("Randomize item order")
																		 enabled:							!pasteVariables.checked && rank.count == 0
																	 }

																	 CheckBox
																	 {
																		 id:									add_selection_variables
																		 name:								"add_sel_vars"
																		 text:								qsTr("Add variables to sample")
																		 enabled:							!pasteVariables.checked
																	 }
																 }

																 Common.SamplingUnits { id: units; enable: !pasteVariables.checked; enable_mus: values.count > 0 }
																 Common.SelectionMethod { id: method; enable: !pasteVariables.checked; enable_sieve: values.count > 0 && units.use_mus }
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
																		 critical.use_negative && critical.use_inspect ? performAuditTable.filter = indicator_col.value + " > 0" + " | " + critical.use_name + " > 0" : performAuditTable.filter = indicator_col.value + " > 0"
																		 performAuditTable.initialValuesSource = continuous.checked ? "values" : ""
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

															 Section
															 {
																 title:						qsTr("Report")
																 Group
																 {
																	 columns:				1
																	 Common.EvaluationOutput
																	 {
																		 bayesian: false
																		 enable_taints: values.count > 0 && !data.use_stats
																		 enable_corrections: values.count > 0
																		 enable_objectives: objectives.use_materiality || objectives.use_precision
																		 enable_scatter: continuous.checked
																		 enable_estimates: true
																	 }
																 }
															 }

															 Section
															 {
																 title:									qsTr("Advanced")

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

																 Common.IntervalType { bayesian: false }
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
