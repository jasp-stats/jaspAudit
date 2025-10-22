import QtQuick
import JASP.Module

Description
{
	title				: qsTr("Audit")
	description			: qsTr("Statistical methods for auditing")
	preloadData			: false
	icon				: "audit-module.svg"
	hasWrappers			: false
	
	GroupTitle
	{
		title:			qsTr("Audit Sampling")
		icon:			"audit-sampling.svg"
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
	Analysis
	{
		title:			qsTr("Selection")
		func:			"auditSelection"
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
	Analysis
	{
		title:			qsTr("True Value Estimation")
		func:			"auditClassicalEstimation"
		preloadData:	true
	}
	
	GroupTitle
	{
		title:			qsTr("Data Auditing")
		icon:			"audit-data.svg"
	}
	Analysis
	{
		title:			qsTr("Benford's Law")
		func:			"auditClassicalBenfordsLaw"
		preloadData:	true
	}
	Analysis
	{
		menu:			qsTr("Repeated Values")
		title:			qsTr("Repeated Values Analysis")
		func:			"auditClassicalNumberBunching"
		preloadData:	true
	}

	GroupTitle
	 {
	 	title:			qsTr("Algorithm Auditing")
		icon:			"audit-algorithms.svg"
	 }
	   Analysis
	 {
	 	title:			qsTr("Fairness Workflow")
		func:			"auditClassicalFairnessWorkflow"
		preloadData:	true
	 }
	 Analysis
	 {
	 	menu:			qsTr("Evaluation")
		title:			qsTr("Fairness Evaluation")
		func:			"auditClassicalFairness"
		preloadData:	true
	 }
}
