:local cPath "MTM/Utilities/Models/File/V1/Read.rsc";
:local mVal "";

:global MtmUtilFileM;
:local s ($MtmUtilFileM->"t");
:local v ($s->"v");
:local guid [($s->"getGuid")];

:set ($v->"_offset") 0;

:set mVal " \
:global MtmUtilFileM; \
:set (\$MtmUtilFileM->\"c\"->\"$guid\"->\"v\"->\"_offset\") ((\$MtmUtilFileM->\"c\"->\"$guid\"->\"v\"->\"_offset\") + \$0); \
:return true; \
";
:set ($s->"addOffset") [:parse $mVal];

:set mVal " \
:global MtmUtilFileM; :set (\$MtmUtilFileM->\"c\"->\"$guid\"->\"v\"->\"_offset\") \$0; \
:return true; \
";
:set ($s->"setOffset") [:parse $mVal];

:set mVal " \
:global MtmUtilFileM; \
:return (\$MtmUtilFileM->\"c\"->\"$guid\"->\"v\"->\"_offset\"); \
";
:set ($s->"getOffset") [:parse $mVal];

:set mVal " \
:global MtmUtilFileM; \
:local this (\$MtmUtilFileM->\"c\"->\"$guid\"); \
:local size \$0; \
:if (\$size > 32768) do={ :error (\"$cPath: Max chunk size is 32768 bytes\"); }; \
:local addOffset \$1; \
:local d ([/file/read file=([(\$this->\"getPathAsString\")]) offset=([(\$this->\"getOffset\")]) chunk=\$size as-value]); \
:if (\$addOffset = true) do={ :local dVal ([(\$this->\"addOffset\") \$size]); }; \
:return (\$d->\"data\"); \
";
:set ($s->"readChunk") [:parse $mVal];

:set ($s->"v") $v;
:set ($MtmUtilFileM->"t") $s;
