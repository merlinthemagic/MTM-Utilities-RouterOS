:local cPath "MTM/Utilities/Enable.rsc";
:local mVal "";

:global MtmUtilsLoaded;
:if ($MtmUtilsLoaded != true) do={
	:global MtmUtilsLoaded false;
	
	##Load Dependencies
	:local hintFiles [:toarray "mtmAutoRoot.hint"];
	:foreach hintFile in=$hintFiles do={
		:set mVal [/file/find name~$hintFile];
		:if ([:len $mVal] != 1) do={
			:set mVal [/system/script/environment/remove [find where name="MtmUtilsLoaded"]];
			:error ($cPath.": Hint file: '".$hintFile."' is invalid");
		}
		:set mVal [/file/get $mVal name];
		:set mVal [/import file-name=([:pick $mVal 0 ([:len $mVal] - (([:len $hintFile]) + 1))]."/Enable.rsc") verbose=no];
	}
	:global MtmAuto;
	

	##Load this APP
	:local hintFile "mtmUtilitiesRoot.hint";
	:set mVal [/file/find name~$hintFile];
	:if ([:len $mVal] != 1) do={
		:set mVal [/system/script/environment/remove [find where name="MtmUtilsLoaded"]];
		:error ($cPath.": Hint file: '".$hintFile."' is invalid");
	}
	:set mVal [/file/get $mVal name];
	:local rootPath [:pick $mVal 0 ([:len $mVal] - (([:len $hintFile]) + 1))];
	:set mVal [($MtmAuto->"importFile") ($rootPath."/Facts.rsc")];

	:global MtmUtils;
	:if ([:typeof $MtmUtils] = "nothing") do={
		:set mVal [/system/script/environment/remove [find where name="MtmUtilsLoaded"]];
		:error ($cPath.": Loading MtmUtils failed");
	}

	##load the environment
	:set mVal [($MtmAuto->"setEnv") "mtm.utils.root.path" $rootPath];
	:foreach id in=[/file/find where name~("^".$rootPath."/Envs/")] do={
		:set mVal [($MtmAuto->"loadEnvFile") ([/file/get $id name]) (true)];
	}

	:global MtmUtilsLoaded true;
	
} else={
	#MTM Utilities is already loaded
}