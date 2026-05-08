:local cPath "MTM/Utilities/Models/File/V1/Alpha.rsc";
:local mVal "";

:global MtmUtilFileM;
:set ($MtmUtilFileM->"t") [:toarray ""];

:global MtmUtils;
:local guid [($MtmUtils->"get") "getTools()->getTypes()->getGuids()->getV4()"];

#class variables
:local s [:toarray ""];

:local v [:toarray ""];
:set ($v->"_guid") $guid;
:set ($v->"_initTime") ([($MtmUtils->"get") "getTools()->getTime()->getEpoch()->getCurrent()"].".000001");
:set ($v->"_version") 1;
:set ($v->"_path") "";


#functions

:set mVal " \
:return \"$guid\"; \
";
:set ($s->"getGuid") ([:parse $mVal]);


:set mVal " \
:global MtmUtilFileM; \
:return (\$MtmUtilFileM->\"c\"->\"$guid\"->\"v\"->\"_version\"); \
";
:set ($s->"getVersion") [:parse $mVal];


:set mVal " \
:global MtmUtilFileM; \
:return (\$MtmUtilFileM->\"c\"->\"$guid\"->\"v\"->\"_initTime\"); \
";
:set ($s->"getInitTime") [:parse $mVal];


:set mVal " \
:global MtmUtilFileM; :set (\$MtmUtilFileM->\"c\"->\"$guid\"->\"v\"->\"_path\") \$0; \
:return true; \
";
:set ($s->"setPathAsString") [:parse $mVal];

:set mVal " \
:global MtmUtilFileM; \
:return (\$MtmUtilFileM->\"c\"->\"$guid\"->\"v\"->\"_path\"); \
";
:set ($s->"getPathAsString") [:parse $mVal];

:set ($s->"v") $v;
:set ($MtmUtilFileM->"t") $s;
