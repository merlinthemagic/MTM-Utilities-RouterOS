:local cPath "MTM/Utilities/Facts/Tools/FS.rsc";
:local s [:toarray ""];

:set ($s->"getFiles") do={
	:global MtmUtilFS;
	:if ([:typeof ($MtmUtilFS->"files")] = "nothing") do={
		:global MtmAuto;
		:local mVal ([($MtmAuto->"getEnv") "mtm.utils.root.path"]."/Tools/FS/Files.rsc");
		:set mVal [($MtmAuto->"importFile") $mVal];
	}
	:return ($MtmUtilFS->"files");
}
:set ($s->"getConcatenate") do={
	:global MtmUtilFS;
	:if ([:typeof ($MtmUtilFS->"concat")] = "nothing") do={
		:global MtmAuto;
		:local mVal ([($MtmAuto->"getEnv") "mtm.utils.root.path"]."/Tools/FS/Concatenate.rsc");
		:set mVal [($MtmAuto->"importFile") $mVal];
	}
	:return ($MtmUtilFS->"concat");
}


:global MtmUtilFS;
:set MtmUtilFS [:toarray ""];

:global MtmUtilTools;
:set ($MtmUtilTools->"fs") $s;
