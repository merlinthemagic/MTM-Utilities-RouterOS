:local cPath "MTM/Utilities/Facts.rsc";
:local mVal "";

:global MtmUtilsLoaded;
:if ([:typeof $MtmUtilsLoaded] = "nothing") do={
	##Load the Enable.rsc file before using Facts
	:error ($cPath.": Please load Enable.rsc before using the factory");
}

:global MtmUtils;
:if ([:typeof $MtmUtils] = "nothing") do={

	#static "objects"
	:global MtmUtilFacts;
	:set MtmUtilFacts [:toarray ""];
	
	##Setup function
	:local s [:toarray ""];
	
	:set ($s->"get") do={
		:global MtmAuto;
		:global MtmUtils;
		:return [($MtmAuto->"get") $0 ($MtmUtils)];
	}
	:set ($s->"getCachePath") do={
		##ram based dir for temp items
		:return "mtmCache/";
	}
	##factories
	:set ($s->"getTools") do={
		:global MtmUtilFacts;
		:if ([:typeof ($MtmUtilFacts->"tools")] = "nothing") do={
			:global MtmAuto;
			:local mVal ([($MtmAuto->"getEnv") "mtm.utils.root.path"]."/Facts/Tools.rsc");
			:set mVal [($MtmAuto->"importFile") $mVal];
		}
		:return ($MtmUtilFacts->"tools");
	}
	
	:set MtmUtils $s;
}
