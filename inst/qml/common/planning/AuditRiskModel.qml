
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

	columns:					2
	title:						show_title ? qsTr("Audit Risk Model") : ""
	enabled:					enable
	visible:					!hide
	info:						qsTr("When the auditor has information that indicates a low-risk profile on the population, they can use this information to reduce their required sample size via the Audit Risk Model (ARM) provided that there are no errors in the population. According to the ARM, the audit risk (AR) is a function of the inherent risk (IR), the internal control risk (CR), and the detection risk (DR).\n\n*AR = IR x CR x DR*\n\nThe auditor assesses inherent risk and internal control risk generally on a 3-point scale to determine the appropriate detection risk. Using the ARM and zero errors the sample size depends on the risk factor *R* and the performance materiality. The risk factor *R* is a function of the detection risk (Stewart 2012).\n\n*R = -ln(DR)*\n\nThe following table presents values of *R* as a function of the detection risk, provided that there are zero errors (Touw and Hoogduin 2012).\n\n| Detection risk (%) | 1 | 4 | 5 | 10 | 14 |\n| :---: | :---: | :---: | :---: | :---: | :---: |\n| R | 4.6 | 3.2 | 3 | 2.3 | 2 |\n\nThe risk factor *R* can be adjusted using the assessments of the inherent risk and the internal control risk. By default, the standard method of setting the probabilities of IR and CR is by following the table below for a detection risk of 5%:\n\n|  | High | Medium | Low | \n| :---: | :---: | :---: |\n| R | 3 | 2 | 1 |\n\nThese values of *R* are used to set default percentages for IR and CR. The Audit module handles the following default values for IR and CR:\n- High: 100%\n- Medium: 60%\n- Low: 36%\n\nYou can manually adjust the value of IR and CR by selecting the Custom option under the corresponding risk assessment, thus adjusting the risk factor *R*.")

	DropDown
	{
		id: 					ir
		name: 					"ir"
		indexDefaultValue: 	 	0
		startValue:				"high"
		label: 					qsTr("Inherent risk")
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
		defaultValue: 			ir.value == "high" ? 100 : (ir.value == 'medium' ? 63 : (ir.value == "low" ? 40 : 100))
		min: 					1
		enabled: 				ir.value == "custom"
		info:					qsTr("The percentage that corresponds with the inherent risk probability.")
	}

	DropDown
	{
		id: 					cr
		name: 					"cr"
		indexDefaultValue:		0
		startValue:				"high"
		label: 					qsTr("Control risk")
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
		defaultValue:			cr.value == "high" ? 100 : (cr.value == 'medium' ? 52 : (cr.value == "low" ? 34 : 100))
		min: 					1
		enabled: 				cr.value == "custom"
		info:					qsTr("The percentage that corresponds with the control risk probability.")
	}
}
