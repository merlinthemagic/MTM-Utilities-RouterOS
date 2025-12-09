:local cPath "MTM/Utilities/Facts/Tools.rsc";
:local s [:toarray ""];

:set ($s->"getConcurrency") do={
	:global MtmUtilTools;
	:if ([:typeof ($MtmUtilTools->"concurrency")] = "nothing") do={
		:global MtmAuto;
		:local mVal ([($MtmAuto->"getEnv") "mtm.utils.root.path"]."/Facts/Tools/Concurrency.rsc");
		:set mVal [($MtmAuto->"importFile") $mVal];
	}
	:return ($MtmUtilTools->"concurrency");
}
:set ($s->"getTime") do={
	:global MtmUtilTools;
	:if ([:typeof ($MtmUtilTools->"time")] = "nothing") do={
		:global MtmAuto;
		:local mVal ([($MtmAuto->"getEnv") "mtm.utils.root.path"]."/Facts/Tools/Time.rsc");
		:set mVal [($MtmAuto->"importFile") $mVal];
	}
	:return ($MtmUtilTools->"time");
}
:set ($s->"getPackages") do={
	:global MtmUtilTools;
	:if ([:typeof ($MtmUtilTools->"packs")] = "nothing") do={
		:global MtmAuto;
		:local mVal ([($MtmAuto->"getEnv") "mtm.utils.root.path"]."/Facts/Tools/Packages.rsc");
		:set mVal [($MtmAuto->"importFile") $mVal];
	}
	:return ($MtmUtilTools->"packs");
}
:set ($s->"getTypes") do={
	:global MtmUtilTools;
	:if ([:typeof ($MtmUtilTools->"types")] = "nothing") do={
		:global MtmAuto;
		:local mVal ([($MtmAuto->"getEnv") "mtm.utils.root.path"]."/Facts/Tools/Types.rsc");
		:set mVal [($MtmAuto->"importFile") $mVal];
	}
	:return ($MtmUtilTools->"types");
}
:global MtmUtilTools;
:set MtmUtilTools [:toarray ""];

:global MtmUtilFacts;
:set ($MtmUtilFacts->"tools") $s;