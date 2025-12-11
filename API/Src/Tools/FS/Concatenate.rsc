
:local cPath "MTM/Utilities/Tools/FS/Concatenate.rsc";
:local s [:toarray ""];

:set ($s->"fromPaths") do={

	:local cPath "MTM/Utilities/Tools/FS/Concatenate.rsc/fromPaths";
	:if ([:typeof $0] != "array") do={
		:error ($cPath.": File paths input has invalid type '".[:typeof $0]."'");
	}
	:if ([:typeof $1] != "str") do={
		:error ($cPath.": Output file has invalid type '".[:typeof $1]."'");
	}
	
	:global MtmUtils;
	:local fileTool ([($MtmUtils->"get") "getTools()->getFS()->getFiles()"]);
	:foreach mPath in=$0 do={
		:if ([($fileTool->"getExists") $mPath] = true) do={
			:if ([($fileTool->"getSize") $mPath] > 4095) do={
				:error ($cPath.": File is too large '".$mPath."', max is 4095bytes");
			}
		} else={
			:error ($cPath.": File path does not exist '".$mPath."'");
		}
	}
	:local ls [:toarray ""];
	:set ($ls->([:len $ls])) (":local ps [:toarray \"\"];");
	
	:foreach mPath in=$0 do={
		:set ($ls->([:len $ls])) (":set (\$ps->([:len \$ps])) (\"".$mPath."\");");
	}
	:set ($ls->([:len $ls])) (":foreach c in=\$ps do={ :put ([/file/get [find where name=\$c] content]); };");
	:local scr "";
	:foreach line in=$ls do={
		:set scr ($scr.$line."\r\n");
	}

	:local mVal "";
	:local lockTool [($MtmUtils->"get") "getTools()->getConcurrency()->getMutex()"];
	:local mKey "mtmConcatFile";
	:local lKey [($lockTool->"lock") $mKey (10) (3)];
	
	##create output file, it might be in a dir
	:set mVal [($fileTool->"create") $1];
	
	:do {
		:set mVal [:execute script=$scr file=$1];
		:return true;
	} on-error={
		:set mVal [($lockTool->"unlock") $mKey $lKey];
		:error ($cPath.": Failed to concatenate");
	}
}

:global MtmUtilFS;
:set ($MtmUtilFS->"concat") $s;
