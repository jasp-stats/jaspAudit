
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

Group
{
	property bool	show_title:	true
	property bool	enable:		true
	property bool	hide:		false

	columns:					3
	title:						show_title ? qsTr("Audit Risk Model") : ""
	enabled:					enable
	visible:					!hide
	info:						qsTr("When the auditor has information that indicates a low-risk profile on the population, they can use this information to reduce their required sample size via the Audit Risk Model (ARM) provided that there are no errors in the population. According to the ARM, the audit risk (AR) is a function of the inherent risk (IR), the internal control risk (CR), the analytical risk (CAR) and the detection risk (DR).\n\n*AR = IR x CR x CAR x DR*\n\nThe auditor assesses inherent risk, internal control risk and analytical risk generally on a 3-point scale consisting of high, medium and low to determine the appropriate detection risk. To use the ARM, these categorical risk assessments must be mapped to probabilities. By default, the Audit module uses the percentages shown in the table below, which are inspired by the <i>Handboek Auditing Rijksoverheid</i>. You can manually adjust the percentages associated with one or all of the risks by selecting the Custom option in the drop-down list under the corresponding risk assessment.\n\n|  | Inherent risk (IR) | Control risk (CR) | Analytical risk (CAR) |\n| ---: | :---: | :---: | :---: |\n| High | 100% | 100% | 100% |\n| Medium | 63% | 52% | 50% |\n| Low | 40% | 34% | 25% |")

	Label 
	{
		text: 					qsTr("Inherent risk")
	}

	DropDown
	{
		id: 					ir
		name: 					"ir"
		indexDefaultValue: 		0
		startValue:				"high"
		values: [
			{ label: qsTr("High"),		value: "high"},
			{ label: qsTr("Medium"), 	value: "medium"},
			{ label: qsTr("Low"), 		value: "low"},
			{ label: qsTr("Custom"), 	value: "custom"}
		]
		info:					qsTr("A category or probability for the inherent risk. Inherent risk is defined as the risk of material misstatement posed by an error or omission in a financial statement due to a factor other than a failure of internal control.")
	}

	PercentField
	{
		name: 					"irCustom"
		defaultValue: 			ir.value === "high" ? 100 : (ir.value === 'medium' ? 63 : (ir.value === "low" ? 40 : 100))
		min: 					1
		enabled: 				ir.value === "custom"
		info:					qsTr("The percentage that corresponds with the inherent risk probability.")
	}

	Label 
	{
		text: 					qsTr("Control risk")
	}

	DropDown
	{
		id: 					cr
		name: 					"cr"
		indexDefaultValue:		0
		startValue:				"high"
		values: [
			{ label: qsTr("High"),		value: "high"},
			{ label: qsTr("Medium"), 	value: "medium"},
			{ label: qsTr("Low"), 		value: "low"},
			{ label: qsTr("Custom"), 	value: "custom"}
		]
		info:					qsTr("A category or probability for the internal control risk. Control risk is defined as the risk of a material misstatement in the financial statements arising due to absence or failure in the operation of relevant controls of the auditee.")
	}

	PercentField
	{
		name: 					"crCustom"
		defaultValue:			cr.value === "high" ? 100 : (cr.value === 'medium' ? 52 : (cr.value === "low" ? 34 : 100))
		min: 					1
		enabled: 				cr.value === "custom"
		info:					qsTr("The percentage that corresponds with the control risk probability.")
	}

	Label 
	{
		text: 					qsTr("Analytical risk")
	}

	DropDown
	{
		id: 					car
		name: 					"car"
		indexDefaultValue:		0
		startValue:				"high"
		values: [
			{ label: qsTr("High"),		value: "high"},
			{ label: qsTr("Medium"), 	value: "medium"},
			{ label: qsTr("Low"), 		value: "low"},
			{ label: qsTr("Custom"), 	value: "custom"}
		]
		info:					qsTr("A category or probability for the analytical risk. Analytical risk is defined as the the risk that a material misstatement will not be discovered by the auditor through analytical procedures.")
	}

	PercentField
	{
		name: 					"carCustom"
		defaultValue:			car.value === "high" ? 100 : (car.value == 'medium' ? 50 : (car.value === "low" ? 25 : 100))
		min: 					1
		enabled: 				car.value === "custom"
		info:					qsTr("The percentage that corresponds with the analytical risk probability.")
	}
}
