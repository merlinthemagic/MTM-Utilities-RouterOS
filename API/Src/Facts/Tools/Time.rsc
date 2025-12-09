:local cPath "MTM/Utilities/Facts/Tools/Time.rsc";
:local s [:toarray ""];

:set ($s->"getEpoch") do={
	:global MtmUtilTime;
	:if ([:typeof ($MtmUtilTime->"epoch")] = "nothing") do={
		:global MtmAuto;
		:local mVal ([($MtmAuto->"getEnv") "mtm.utils.root.path"]."/Tools/Time/Epoch.rsc");
		:set mVal [($MtmAuto->"importFile") $mVal];
	}
	:return ($MtmUtilTime->"epoch");
}
:set ($s->"getRouteros") do={
	:global MtmUtilTime;
	:if ([:typeof ($MtmUtilTime->"routeros")] = "nothing") do={
		:global MtmAuto;
		:local mVal ([($MtmAuto->"getEnv") "mtm.utils.root.path"]."/Tools/Time/Routeros.rsc");
		:set mVal [($MtmAuto->"importFile") $mVal];
	}
	:return ($MtmUtilTime->"routeros");
}
:global MtmUtilTime;
:set MtmUtilTime [:toarray ""];

:global MtmUtilTools;
:set ($MtmUtilTools->"time") $s;