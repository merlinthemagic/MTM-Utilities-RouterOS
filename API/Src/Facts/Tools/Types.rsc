:local cPath "MTM/Utilities/Facts/Tools/Types.rsc";
:local s [:toarray ""];

:set ($s->"getGuids") do={
	:global MtmUtilTypes;
	:if ([:typeof ($MtmUtilTypes->"guids")] = "nothing") do={
		:global MtmAuto;
		:local mVal ([($MtmAuto->"getEnv") "mtm.utils.root.path"]."/Tools/Types/Guids.rsc");
		:set mVal [($MtmAuto->"importFile") $mVal];
	}
	:return ($MtmUtilTypes->"guids");
}
:set ($s->"getStrings") do={
	:global MtmUtilTypes;
	:if ([:typeof ($MtmUtilTypes->"strings")] = "nothing") do={
		:global MtmAuto;
		:local mVal ([($MtmAuto->"getEnv") "mtm.utils.root.path"]."/Tools/Types/Strings.rsc");
		:set mVal [($MtmAuto->"importFile") $mVal];
	}
	:return ($MtmUtilTypes->"strings");
}
:global MtmUtilTypes;
:set MtmUtilTypes [:toarray ""];

:global MtmUtilTools;
:set ($MtmUtilTools->"types") $s;