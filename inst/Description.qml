import QtQuick 			2.12
import JASP.Module 		1.0

Description
{
	name				: "jaspAudit"
	title				: qsTr("Audit")
	description			: qsTr("Statistical methods for auditing")
	version				: "0.17.1"
	author				: "Koen Derks, Jacques de Swart, Eric-Jan Wagenmakers, Jan Wille & Ruud Wetzels"
	maintainer			: "Koen Derks <k.derks@nyenrode.nl>"
	website				: "www.github.com/koenderks/jfa"
	license				: "GPL (>= 3)"
	icon				: "audit-module.svg"

	GroupTitle
	{
		title:			qsTr("Workflow")
		icon:			"audit-workflow.svg"
	}
	Analysis
	{
		title:			qsTr("Sampling Workflow")
		func:			"auditClassicalWorkflow"
	}
	Analysis
	{
		title:			qsTr("Bayesian Sampling Workflow")
		func:			"auditBayesianWorkflow"
	}

	GroupTitle
	{
		title:			qsTr("Planning")
		icon:			"audit-planning.svg"
	}
	Analysis
	{
		title:			qsTr("Planning")
		func:			"auditClassicalPlanning"
		requiresData:	false
	}
	Analysis
	{
		title:			qsTr("Bayesian Planning")
		func:			"auditBayesianPlanning"
		requiresData:	false
	}

	GroupTitle
	{
		title:			qsTr("Selection")
		icon:			"audit-selection.svg"
	}
	Analysis
	{
		title:			qsTr("Selection")
		func:			"auditSelection"
	}

	GroupTitle
	{
		title:			qsTr("Evaluation")
		icon:			"audit-evaluation.svg"
	}
	Analysis
	{
		title:			qsTr("Evaluation")
		func:			"auditClassicalEvaluation"
		requiresData:	false
	}
	Analysis
	{
		title:			qsTr("Bayesian Evaluation")
		func:			"auditBayesianEvaluation"
		requiresData:	false
	}

	GroupTitle
	{
		title:			qsTr("Digit Analysis")
		icon:			"audit-number-analysis.svg"
	}
	Analysis
	{
		title:			qsTr("Benford's Law")
		func:			"auditClassicalBenfordsLaw"
	}
	Analysis
	{
		menu:			qsTr("Repeated Values")
		title:			qsTr("Repeated Values Analysis")
		func:			"auditClassicalNumberBunching"
	}

	GroupTitle
	{
		title:			qsTr("Other")
		icon:			"audit-other.svg"
	}
	Analysis
	{
		title:			qsTr("True Value Estimation")
		func:			"auditClassicalEstimation"
	}
}
