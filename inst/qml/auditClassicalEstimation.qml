
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

import QtQuick 								2.8
import QtQuick.Layouts 						1.3
import JASP.Controls 						1.0
import JASP.Widgets 						1.0

Form {

    columns:								2

    VariablesForm
    {
        id: 								variablesFormEstimation
        preferredHeight: 					jaspTheme.smallDefaultVariablesFormHeight

        AvailableVariablesList
        {
            name: 							"variablesFormEstimation"
        }

        AssignedVariablesList
        {
            id: 							bookValues
            name: 							"bookValues"
            title: 							qsTr("Book Values")
            singleVariable:					true
            allowedColumns:					["scale"]
            enabled: 						!mpu.checked
        }

        AssignedVariablesList
        {
            id: 							auditValues
            name: 							"auditValues"
            title: 							qsTr("Audit Values")
            singleVariable: 				true
            allowedColumns: 				["scale"]
        }
    }

    CIField
    {
        name: 								"confidence"
        label: 								qsTr("Confidence")
    }

    Group
    {
        title: 								qsTr("Display")
        columns: 							2

        CheckBox
        {
            id: 							explanatoryText
            text: 							qsTr("Explanatory text")
            name: 							"explanatoryText"
            checked: 						true
        }

        HelpButton
        {
            helpPage:						"Audit/explanatoryText"
            toolTip: 						qsTr("Show explanatory text at each step of the analysis")
        }
    }

    Group
    {
        title: 								qsTr("Population")

        IntegerField
        {
            id: 							populationSize
            name: 							"populationSize"
            text: 							qsTr("No. items")
            fieldWidth: 					100 * preferencesModel.uiScale
            defaultValue: 					0
            min: 							0
        }

        DoubleField
        {
            id: 							populationValue
            name: 							"populationValue"
            text: 							qsTr("No. units")
            defaultValue: 					0
            fieldWidth: 					100 * preferencesModel.uiScale
            min: 							0
            decimals: 						2
            enabled:						!mpu.checked
        }
    }

    Group
    {
        title: 								qsTr("Tables")

        CheckBox
        {
            id: 							requiredSampleSize
            text:	 						qsTr("Required sample size")
            name: 							"requiredSampleSizeTable"

            DoubleField
            {
                name: 						"requiredUncertainty"
                visible: 					requiredSampleSize.checked
                text: 						qsTr("for an uncertainty of:")
                defaultValue: 				100000
                fieldWidth: 				100 * preferencesModel.uiScale
                min: 						0
                decimals: 					2
            }
        }
    }

    RadioButtonGroup
    {
        name:								"estimator"
        title: 								qsTr("Method")

        RadioButton
        {
            id:								mpu
            name:							"mpu"
            text:							qsTr("Direct estimator")
        }

        RadioButton
        {
            name:							"difference"
            text:							qsTr("Difference estimator")
        }

        RadioButton
        {
            name:							"ratio"
            text:							qsTr("Ratio estimator")
        }

        RadioButton
        {
            name:							"regression"
            text:							qsTr("Regression estimator")
            checked:						true
        }
    }

    Group
    {
        title: 								qsTr("Plots")

        CheckBox
        {
            text: 							qsTr("Scatter plot")
            name: 							"correlationPlot"
            enabled: 						!mpu.checked
        }
    }

    Item
    {
        Layout.preferredHeight: 			download.height
        Layout.fillWidth: 					true
        Layout.columnSpan:					2

        Button
        {
            id: 							download
            enabled: 						populationSize.value != 0 && populationValue.value != 0 && auditValues.count > 0 && bookValues.count > 0
            anchors.right: 					parent.right
            anchors.bottom: 				parent.bottom
            text: 							qsTr("<b>Download Report</b>")
            onClicked:						form.exportResults()
        }
    }
}
