:local cPath "MTM/Utilities/Models/File/V1/Zulu.rsc";
:local mVal "";

:global MtmUtilFileM;
:local s ($MtmUtilFileM->"t");
:local v ($s->"v");
:local guid [($s->"getGuid")];

:set mVal " \
:global MtmUtilFileM; \
:set (\$MtmUtilFileM->\"c\"->\"$guid\"); \
:return true \
";
:set ($s->"terminate") [:parse $mVal];


:set ($s->"v") $v;
:set ($MtmUtilFileM->"t") $s;
