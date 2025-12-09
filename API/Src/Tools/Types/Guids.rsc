:local cPath "MTM/Utilities/Tools/Types/Guids.rsc";

:local s [:toarray ""];

:set ($s->"getV4") do={
	## generate guids in format: 11B8AA12-E644-0399-71D6-B2AA561233EB
	:local cPath "MTM/Utilities/Tools/Types/Guids.rsc/getV4";
	
	:global MtmUtils;
	:local strTool [($MtmUtils->"get") "getTools()->getTypes()->getStrings()"];
	:local randStr [($strTool->"getRandom") (36)];
	:set randStr [($strTool->"toUpper") $randStr];
	:local rData "";
	:for x from=0 to=35 do={
		:if ($x = 8 || $x = 13 || $x = 18 || $x = 23) do={
			:set rData ($rData."-");
		} else={
			:set rData ($rData.[:pick $randStr $x]);
		}
	}
	:return $rData;
}

:global MtmUtilTypes;
:set ($MtmUtilTypes->"guids") $s;
