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

import QtQuick									2.8
import QtQuick.Layouts							1.3
import JASP.Controls							1.0
import JASP.Widgets								1.0
import JASP										1.0

import "./common"	as Common


Form {
	columns:							2
  Section{
  title: qsTr("Pick Variables")
	VariablesForm
	{
		id: 							variablesFormBenfordsLaw
		preferredHeight:				jaspTheme.smallDefaultVariablesFormHeight

		AvailableVariablesList
		{
			name: 						"variablesFormBenfordsLaw"
		}

		AssignedVariablesList
		{
			id: 						group
			name: 						"group"
			title: 						qsTr("Group")
			singleVariable:				true
			allowedColumns:				["nominal", "nominalText"]
		}
				AssignedVariablesList
		{
			id: 						predicted
			name: 						"predicted"
			title: 						qsTr("Predicted")
			singleVariable:				true
			allowedColumns:				["nominal", "nominalText"]
		}
				AssignedVariablesList
		{
			id: 						actual
			name: 						"actual"
			title: 						qsTr("Actual")
			singleVariable:				true
			allowedColumns:				["nominal", "nominalText"]
		}

	}

	Group
	{
		Label	{ text : qsTr("Choose a Level")	}
		TableView
		{

			property int designDataColumns : 1


			id					: selectedDesign2
			implicitWidth		: (form.implicitWidth) /2
			implicitHeight		: 150 * preferencesModel.uiScale
			source: [{name: "group", use: "levels"}]

			modelType			: JASP.Simple
			name				: "selectedDesign2"

			columnNames			: qsTr("Counts")
			cornerText			: qsTr("Level")
			initialColumnCount	: 1// -1 because the first "column" is not a column but the row header
			columnCount			: 1

			itemType			: JASP.Double
			rowCount			: 0
			initialRowCount		: 0

			itemDelegate: Item
			{

				Rectangle
				{

					id: backgroundRect
					color: rowIndex === tableView.rowSelected ? jaspTheme.grayLighter : jaspTheme.white
					anchors
					{
						fill:			parent
						topMargin:		-selectedDesign2.view.itemVerticalPadding
						bottomMargin:	-selectedDesign2.view.itemVerticalPadding
					}

					MouseArea
					{
						anchors.fill: parent
						onClicked:
						{
							tableView.colSelected = columnIndex
							tableView.rowSelected = rowIndex
						}
					}
				}

				Label
				{
					text						: tableView.getDefaultValue(columnIndex, rowIndex)
					anchors.verticalCenter		: parent.verticalCenter
					anchors.horizontalCenter	: parent.horizontalCenter
					onTextChanged:
					{
						selectedDesign2.itemChanged(columnIndex, rowIndex, value, inputType)
					}
				}
			}

			rowNumberDelegate: Rectangle
			{
				// identical to default but with changed colors
				color: rowIndex === tableView.rowSelected ? jaspTheme.grayLighter : jaspTheme.white// : jaspTheme.analysisBackgroundColor
				Text
				{
					text:					tableView.getRowHeaderText(headerText, rowIndex);
					color:					jaspTheme.textEnabled
					anchors.centerIn:		parent;
					horizontalAlignment:	Text.AlignHCenter
					verticalAlignment:		Text.AlignVCenter
					leftPadding:			3 * preferencesModel.uiScale
					elide:					Text.ElideRight;
					width:					parent.width
					height:					parent.width
					font:					jaspTheme.font
				}

				MouseArea
				{
					anchors.fill: parent
					onClicked:
					{
						if (tableView.rowSelected === rowIndex)
							rowIndex = -1
						tableView.rowSelected = rowIndex;
					}
				}
			}

			columnHeaderDelegate : Rectangle
			{
				// identical to the default definition in TableView, but this does not change color when the column is selected
				color: jaspTheme.analysisBackgroundColor
				Text { text: tableView.getColHeaderText(headerText, columnIndex); anchors.centerIn: parent; font: jaspTheme.font; color:	jaspTheme.textEnabled }
				MouseArea
				{
					anchors.fill: parent
					onClicked:
					{
						if (tableView.colSelected === columnIndex)
							columnIndex = -1
						tableView.colSelected = columnIndex;
					}
				}
			}


		}
		IntegerField { name: "selectedRow"; label: qsTr("debug selected row"); defaultValue: selectedDesign2.rowSelected; negativeValues: true; visible: false }
	}


	Item
	{
		Layout.preferredHeight:			download.height
		Layout.preferredWidth: 			parent.width
		Layout.columnSpan:				2

		Button
		{
			id:							download
			enabled: 					values.count > 0
			anchors.right:				parent.right
			text:						qsTr("<b>Download Report</b>")
			onClicked:					form.exportResults()
		}
	}
 }

 Section
 {
  title: qsTr("Fairness Measures")

  Group
  {
  columns:			2
	Layout.columnSpan:	2

    HelpButton
  	{
  		toolTip:			qsTr("Manor we shall merit by chief wound no or would. Oh towards between subject passage sending mention or it. Sight happy do burst fruit to woody begin at. Assurance perpetual he in oh determine as. The year paid met him does eyes same. Own marianne improved sociable not out. Thing do sight blush mr an. Celebrated am announcing delightful remarkably we in literature it solicitude. Design use say piqued any gay supply. Front sex match vexed her those great.

Demesne far hearted suppose venture excited see had has. Dependent on so extremely delivered by. Yet .no jokes worse her why. Bed one supposing breakfast day fulfilled off depending questions. Whatever boy her exertion his extended. Ecstatic followed handsome drawings entirely mrs one yet outweigh. Of acceptance insipidity remarkably is invitation.
")
  		helpPage:			"auditFairnessQuestionHelp/auditQ1Helper"
  		Layout.columnSpan:	2
  	}

    Group
    {
      RadioButtonGroup
      {
      name: "q1"
      id: "q1"
      title: qsTr("Do you want to be fair based on disparate representation or based on disparate errors of your system?")

      RadioButton{
      id:"q1option1"; label: qsTr("Representation"); name:"q1option1"; value:"rep";  checked: true; onClicked:
       {
        groupQ2.visible = true
        q2.title= qsTr("Do you need to select equal # of people from each group or proportional to their percentage in the \n overall population?")
        q2option1.label =qsTr("Equal Numbers")
        q2option2.label =qsTr("Proportional")
       }
      }

      RadioButton{
      id:"q1option2"; label: qsTr("Errors"); value:"err"; onClicked:
        {
        groupQ2.visible = true
        q2.title= qsTr("Are your interventions punitive or assistive")
        q2option1.label =qsTr("Punitive")
        q2option2.label =qsTr("Assistive")
        }
      }
      }
     }
    }

	Group
	{
	  id : groupQ2
	  visible: false
  	columns:			2
		Layout.columnSpan:	2

    HelpButton
  	{
  		toolTip:			qsTr("Click to learn more about stuff from Q2.")
  		helpPage:			"auditQ2Helper"
  		Layout.columnSpan:	2
  	}

    Group
    {
      RadioButtonGroup
      {
      name: "q2"
      id: "q2"
      title: qsTr("")

      RadioButton{
      id:"q2option1"; checked: true; value:"a"; onClicked:
       {
       if(q1option1.clicked)
        {
        groupQ3.visible = false
        }
       if(q1option2.clicked)
        {
        groupQ3.visible = true
        q3.title= qsTr("Are you intervening with a very small % of the population?")
        q3option1.label =qsTr("Yes")
        q3option2.label =qsTr("No")
        }
       }
      }

      RadioButton{
      id:"q2option2";  value:"b"; onClicked:
        {
        if(q1option1.clicked)
        {
        groupQ3.visible = false
        }
        if(q1option2.clicked)
        {
        groupQ3.visible = true
        q3.title= qsTr("Are you intervening with a very small % of the population?")
        q3option1.label =qsTr("Yes")
        q3option2.label =qsTr("No")
        }
        }
      }
      }
     }
		}

	Group{
	  id: groupQ3
	  visible: false
  	columns:			2
		Layout.columnSpan:	2

    HelpButton
  	{
  		toolTip:			qsTr("Click to learn more about stuff from Q2.")
  		helpPage:			"auditQ2Helper"
  		Layout.columnSpan:	2
  	}

    Group{
      RadioButtonGroup
      {
      name: "q3"
      id: "q3"
      title: qsTr("")

      RadioButton{
      id:"q3option1"; label: qsTr("Representation"); value:"c"; onClicked:
       {
        groupQ4.visible = true
        q4.title= qsTr("Do you need to select equal # of people from each group or proportional to their percentage in the \n overall population?")
        q4option1.label =qsTr("Equal Numbers")
        q4option2.label =qsTr("Proportional")
       }
      }

      RadioButton{
      id:"q3option2";label: qsTr("Errors"); value:"d"; onClicked:
        {
        groupQ4.visible = true
        q4.title= qsTr("Are your interventions punitive or assistive")
        q4option1.label =qsTr("Punitive")
        q4option2.label =qsTr("Assistive")
        }
      }
      }
      }
      }


  }

  Section {
  title: qsTr("Performance Measures")

  		CheckBox
		{
			text:									qsTr("Enable Performance Metrics Group")
			name:									"performanceMeasuresGroup"
		}

		CheckBox
		{
			text:									qsTr("Enable Performance Metrics All")
			name:									"performanceMeasuresAll"
		}

  }
}


//verbinden met R moet makkelijker zijn, anders hardcoden
//mss dictionary



