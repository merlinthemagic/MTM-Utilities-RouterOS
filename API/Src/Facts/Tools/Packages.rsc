:local cPath "MTM/Utilities/Facts/Tools/Packages.rsc";
:local s [:toarray ""];

:set ($s->"getRouteros") do={

	:global MtmUtilPacks;
	:if ([:typeof ($MtmUtilPacks->"routeros")] = "nothing") do={
		:global MtmAuto;
		:local mVal ([($MtmAuto->"getEnv") "mtm.utils.root.path"]."/Tools/Packages/Routeros.rsc");
		:set mVal [($MtmAuto->"importFile") $mVal];
	}
	:return ($MtmUtilPacks->"routeros");
}

:global MtmUtilPacks;
:set MtmUtilPacks [:toarray ""];

:global MtmUtilTools;
:set ($MtmUtilTools->"packs") $s;