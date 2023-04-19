
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
import JASP.Module

Upgrades
{
	Upgrade
	{
		functionName:	"auditBayesianPlanning"
		fromVersion:	"0.17.1"
		toVersion:		"0.17.2"

		ChangeJS
		{
			name:		"area"

			jsFunction:	function(options)
			{
				switch(options["area"])
				{
					case "area_bound":		return "less";
					case "area_interval":	return "two.sided";
				}
			}
		}
	}

	Upgrade
	{
		functionName:	"auditBayesianEvaluation"
		fromVersion:	"0.17.1"
		toVersion:		"0.17.2"

		ChangeJS
		{
			name:		"area"

			jsFunction:	function(options)
			{
				switch(options["area"])
				{
					case "area_bound":		return "less";
					case "area_interval":	return "two.sided";
				}
			}
		}
	}

	Upgrade
	{
		functionName:	"auditBayesianWorkflow"
		fromVersion:	"0.17.1"
		toVersion:		"0.17.2"

		ChangeJS
		{
			name:		"area"

			jsFunction:	function(options)
			{
				switch(options["area"])
				{
					case "area_bound":		return "less";
					case "area_interval":	return "two.sided";
				}
			}
		}
	}
}
