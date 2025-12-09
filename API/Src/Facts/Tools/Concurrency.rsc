:local cPath "MTM/Utilities/Facts/Tools/Concurrency.rsc";
:local s [:toarray ""];

:set ($s->"getMutex") do={

	:global MtmUtilConcurrency;
	:if ([:typeof ($MtmUtilConcurrency->"mutex")] = "nothing") do={
		:global MtmAuto;
		:local mVal ([($MtmAuto->"getEnv") "mtm.utils.root.path"]."/Tools/Concurrency/Mutex.rsc");
		:set mVal [($MtmAuto->"importFile") $mVal];
	}
	:return ($MtmUtilConcurrency->"mutex");
}

:global MtmUtilConcurrency;
:set MtmUtilConcurrency [:toarray ""];

:global MtmUtilTools;
:set ($MtmUtilTools->"concurrency") $s;