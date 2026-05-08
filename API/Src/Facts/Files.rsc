:local cPath "MTM/Utilities/Facts/Files.rsc";
:local s [:toarray ""];

:set ($s->"getFile") do={

	##New instance each time
	
	:global MtmAuto;
	:global MtmUtils;
	:global MtmUtilFileM;

	:local cPath "MTM/Utilities/Facts/Files.rsc/getFile";
	:local mVal "";
	
	:local cacheFile ([($MtmUtils->"getCachePath")]."utilFileV1.txt");
	:local fileTool [($MtmUtils->"get") "getTools()->getFS()->getFiles()"];
	:if ([($fileTool->"getExists") $cacheFile] = false) do={
		
		##create a concatninated version of the file for faster loading
		##loading each file seperately each time takes 4 sec per file
		##concatinated the load takes > 0.5 sec per file
		:local rootPath [($MtmAuto->"getEnv") "mtm.utils.root.path"];
		:local mPaths [:toarray ""];
		:set ($mPaths->0) ($rootPath."/Models/File/V1/Alpha.rsc");
		:set ($mPaths->1) ($rootPath."/Models/File/V1/Read.rsc");
		:set ($mPaths->2) ($rootPath."/Models/File/V1/Zulu.rsc");

		:local concatTool ([($MtmUtils->"get") "getTools()->getFS()->getConcatenate()"]);
		:set mVal [($concatTool->"fromPaths") $mPaths $cacheFile];
	}

	:local lockTool [($MtmUtils->"get") "getTools()->getConcurrency()->getMutex()"];
	:local mKey "AddMtmUtilFile";
	:local lKey [($lockTool->"lock") $mKey (5) (3)];
	
	:do {

		:set mVal [($MtmAuto->"importFile") $cacheFile];

		:local fileObj ($MtmUtilFileM->"t");
		:set ($MtmUtilFileM->"t") [:toarray ""];
		
		:local guid [($fileObj->"getGuid")];
		:set ($MtmUtilFileM->"c"->$guid) $fileObj;
		:set mVal [($lockTool->"unlock") $mKey $lKey];
		:return $fileObj;
		
	} on-error={
		:do {
			:set mVal [($lockTool->"unlock") $mKey $lKey];
		} on-error={
		}
		:log/error ($cPath.": Failed to create file object");
		:error ($cPath.": Failed to get file");
	}
}

:global MtmUtilFileM;
:set MtmUtilFileM [:toarray ""];
:set ($MtmUtilFileM->"t") [:toarray ""]; ##temp store for building file objects
:set ($MtmUtilFileM->"c") [:toarray ""]; ##Cache

:global MtmUtilFacts;
:set ($MtmUtilFacts->"files") $s;
