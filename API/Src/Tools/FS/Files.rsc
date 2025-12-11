
:local cPath "MTM/Utilities/Tools/FS/Files.rsc";
:local s [:toarray ""];

:set ($s->"getExists") do={

	:global MtmFacts;
	:local cPath "MTM/Utilities/Tools/FS/Files.rsc/getExists";
	:if ([:typeof $0] != "str") do={
		:error ($cPath.": Input has invalid type '".[:typeof $0]."'");
	}
	:if ([:typeof $1] = "num") do={
		##wait $1 miliseconds. Allow the file to be created. RouterOS file I/O can be quite slow
		:local tTime $1;
		:while ($tTime > 0) do={
			:if ([:len [/file/find where name=$0]] > 0) do={
				:set tTime 0;
			} else={
				:set tTime ($tTime - 100);
				:delay 0.1s;
			}
		}
	}
	:if ([:len [/file/find where name=$0]] > 0) do={
		:return true;
	} else={
		:return false;
	}
}
:set ($s->"getTemp") do={

	:local cPath "MTM/Utilities/Tools/FS/Files.rsc/getTemp";
	
	:global MtmUtils;
	:local strTool [($MtmUtils->"get") "getTools()->getTypes()->getStrings()"];
	
	:global MtmUtilFS;
	:local self ($MtmUtilFS->"files");
	
	:local isDone false;
	:local max 50;
	:local cur 0;
	:local fileName "";
	:local mVal "";
	
	:local lockTool [($MtmUtils->"get") "getTools()->getConcurrency()->getMutex()"];
	:local mKey "makeTmpFile";
	:local lKey [($lockTool->"lock") $mKey (5) (3)];
	
	:while ($isDone = false) do={
		
		:set fileName ([($strTool->"getRandom") (12)].".txt");
		:if ([($self->"getExists") $fileName] = false) do={
			:do {
				:set mVal [($self->"create") $fileName];
			} on-error={
				:set mVal [($lockTool->"unlock") $mKey $lKey];
				:error ($cPath.": Failed to create unique new temp file. Create returned error");
			}
			:set isDone true;
		}
		:set cur ($cur + 1);
		:if ($cur > $max) do={
			:set mVal [($lockTool->"unlock") $mKey $lKey];
			:error ($cPath.": Failed to create unique new temp file. Too many attempts");
		}
	}
	:set mVal [($lockTool->"unlock") $mKey $lKey];
	:return $fileName;
}
:set ($s->"create") do={

	:local cPath "MTM/Utilities/Tools/FS/Files.rsc/create";
	:if ([:typeof $0] != "str") do={
		:error ($cPath.": Input has invalid type '".[:typeof $0]."'");
	}
	:local mVal "";
	
	:global MtmUtilFS;
	:local self ($MtmUtilFS->"files");
	
	:if ([($self->"getExists") $0] = false) do={
		:set mVal [/file/print file=$0];
		##wait for the file to be created
		:if ([($self->"getExists") $0 (1500)] = false) do={
			:error ($cPath.": Failed to create file: '".$0."'");
		}
		##empty the new file
		:set mVal [($self->"setContent") $0 ""];
	} else={
		:error ($cPath.": Cannot create, file exists '".$0."'");
	}
	:return true;
}
:set ($s->"delete") do={

	:local cPath "MTM/Utilities/Tools/FS/Files.rsc/delete";
	:if ([:typeof $0] != "str") do={
		:error ($cPath.": Input has invalid type '".[:typeof $0]."'");
	}
	:local mVal "";
	
	:global MtmUtilFS;
	:local self ($MtmUtilFS->"files");
	
	:if ([($self->"getExists") $0] = true) do={
		:set mVal [/file/remove $0];
		:local tTime 1500;
		:while ($tTime > 0) do={
			:if ([($self->"getExists") $0] = false) do={
				:set tTime 0;
			} else={
				:set tTime ($tTime - 100);
				:if ($tTime > 0) do={
					:delay 0.1s;
				} else={
					:error ($cPath.": Failed to delete file '".$0."'");
				}
			}
		}
	
	} else={
		:error ($cPath.": Cannot delete, file does not exists '".$0."'");
	}
	:return true;
}
:set ($s->"setContent") do={

	:local cPath "MTM/Utilities/Tools/FS/Files.rsc/setContent";
	:if ([:typeof $0] != "str") do={
		:error ($cPath.": Input file name has invalid type '".[:typeof $0]."'");
	}
	:if ([:typeof $1] != "str") do={
		:error ($cPath.": Input content has invalid type '".[:typeof $1]."'");
	}
	
	:local newSize [:len $1];
	:if ($newSize > 4095) do={
		:error ($cPath.": Content length for '".$0."' cannot exceed 4095 bytes");
	}
	
	:local mVal "";
	:global MtmUtilFS;
	:local self ($MtmUtilFS->"files");

	:if ([($self->"getExists") $0] = false) do={
		:set mVal [($self->"create") $0];
	}
	:set mVal [/file/set [find where name=$0] content=$1];
	:if ([($self->"isSize") $0 $newSize (1500)] = false) do={
		:error ($cPath.": Failed to set content. Size mismatch for file '".$0."'");
	}
	:return true;
}
:set ($s->"getContent") do={

	:local cPath "MTM/Utilities/Tools/FS/Files.rsc/getContent";
	:if ([:typeof $0] != "str") do={
		:error ($cPath.": Input file name has invalid type '".[:typeof $0]."'");
	}

	:local mVal "";
	:global MtmUtilFS;
	:local self ($MtmUtilFS->"files");

	:if ([($self->"getExists") $0] = false) do={
		:error ($cPath.": Cannot get content, file does not exists '".$0."'");
	}
	:if ([($self->"getSize") $0] < 4096) do={
		:return [/file/get [find where name=$0] content];
	} else={
		:error ($cPath.": Cannot get content, file is too large '".$0."'");
	}
}
:set ($s->"getSize") do={

	:local cPath "MTM/Utilities/Tools/FS/Files.rsc/getSize";
	:if ([:typeof $0] != "str") do={
		:error ($cPath.": Input file name has invalid type '".[:typeof $0]."'");
	}
	:local mVal "";
	:global MtmUtilFS;
	:local self ($MtmUtilFS->"files");
	
	:if ([($self->"getExists") $0] = false) do={
		:error ($cPath.": Cannot get size file does not exist: '".$0."'");
	}
	:return [:tonum [/file/get [find where name=$0] size]];
}
:set ($s->"isSize") do={

	:local cPath "MTM/Utilities/Tools/FS/Files.rsc/isSize";
	:if ([:typeof $0] != "str") do={
		:error ($cPath.": Input file name has invalid type '".[:typeof $0]."'");
	}
	:if ([:typeof $1] != "num") do={
		:error ($cPath.": Input file size has invalid type '".[:typeof $1]."'");
	}
	
	:local mVal "";
	:global MtmUtilFS;
	:local self ($MtmUtilFS->"files");
	
	:if ([:typeof $2] = "num") do={
		##wait $2 miliseconds. Allow the file to reach the right size. Mikrotik I/O can be quite slow
		:local tTime $2;
		:while ($tTime > 0) do={
			:if ([($self->"getSize") $0] = $1) do={
				:set tTime 0;
			} else={
				:set tTime ($tTime - 100);
				:delay 0.1s;
			}
		}
	}
	:if ([($self->"getSize") $0] = $1) do={
		:return true;
	} else={
		:return false;
	}
}

:global MtmUtilFS;
:set ($MtmUtilFS->"files") $s;
