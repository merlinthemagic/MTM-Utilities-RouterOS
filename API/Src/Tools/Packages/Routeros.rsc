:local cPath "MTM/Utilities/Tools/Packages/Routeros.rsc";

:local s [:toarray ""];

:set ($s->"getMajor") do={

	:global MtmAuto;
	:local mVal [($MtmAuto->"getAvp") "mtm.utils.pack.ros.major" (false)];
	:if ([:typeof $mVal] != "num") do={
		:global MtmUtils;
		:local self [($MtmUtils->"get") "getTools()->getPackages()->getRouteros()"];
		:local rVal [($self->"parse") ([/system/resource/get version])];
		:set mVal [($MtmAuto->"setAvp") "mtm.utils.pack.ros.major" ($rVal->"major")];
		:set mVal ($rVal->"major");
	}
	:return $mVal;
}
:set ($s->"getMinor") do={

	:global MtmAuto;
	:local mVal [($MtmAuto->"getAvp") "mtm.utils.pack.ros.minor" (false)];
	:if ([:typeof $mVal] != "num") do={
		:global MtmUtils;
		:local self [($MtmUtils->"get") "getTools()->getPackages()->getRouteros()"];
		:local rVal [($self->"parse") ([/system/resource/get version])];
		:set mVal [($MtmAuto->"setAvp") "mtm.utils.pack.ros.minor" ($rVal->"minor")];
		:set mVal ($rVal->"minor");
	}
	:return $mVal;
}
:set ($s->"getPatch") do={

	:global MtmAuto;
	:local mVal [($MtmAuto->"getAvp") "mtm.utils.pack.ros.patch" (false)];
	:if ([:typeof $mVal] != "num") do={
		:global MtmUtils;
		:local self [($MtmUtils->"get") "getTools()->getPackages()->getRouteros()"];
		:local rVal [($self->"parse") ([/system/resource/get version])];
		:set mVal [($MtmAuto->"setAvp") "mtm.utils.pack.ros.patch" ($rVal->"patch")];
		:set mVal ($rVal->"patch");
	}
	:return $mVal;
}
:set ($s->"getTrain") do={

	:global MtmAuto;
	:local mVal [($MtmAuto->"getAvp") "mtm.utils.pack.ros.train" (false)];
	:if ([:typeof $mVal] != "num") do={
		:global MtmUtils;
		:local self [($MtmUtils->"get") "getTools()->getPackages()->getRouteros()"];
		:local rVal [($self->"parse") ([/system/resource/get version])];
		:set mVal [($MtmAuto->"setAvp") "mtm.utils.pack.ros.train" ($rVal->"train")];
		:set mVal ($rVal->"train");
	}
	:return $mVal;
}
:set ($s->"getChannel") do={

	:global MtmAuto;
	:local mVal [($MtmAuto->"getAvp") "mtm.utils.pack.ros.channel" (false)];
	:if ([:typeof $mVal] != "num") do={
		:global MtmUtils;
		:local self [($MtmUtils->"get") "getTools()->getPackages()->getRouteros()"];
		:local rVal [($self->"parse") ([/system/resource/get version])];
		:set mVal [($MtmAuto->"setAvp") "mtm.utils.pack.ros.channel" ($rVal->"channel")];
		:set mVal ($rVal->"channel");
	}
	:return $mVal;
}
:set ($s->"parse") do={

	:local channel "";
	:local train "";
	:local major 0;
	:local minor 0;
	:local patch 0;
	
	:local mVer $0;
	:local mPos 0;
	
	##find channel
	:set mPos [:find $mVer "("];
	:if ([:typeof $mPos] = "num") do={
		:set channel ([:pick $mVer ($mPos + 1) ([:len $mVer] - 1)]);
		:set mVer [:pick $mVer 0 ($mPos - 1)]; #-1 to get rid of the space
	}
	
	##find pre release type
	:local found 0;
	:if ($found = 0) do={
		:set mPos [:find $mVer "rc"];
		:if ([:typeof $mPos] = "num") do={
			:set train ([:pick $mVer $mPos ([:len $mVer])]);
			:set mVer [:pick $mVer 0 $mPos];
			:set found 1;
		}
	}
	:if ($found = 0) do={
		:set mPos [:find $mVer "beta"];
		:if ([:typeof $mPos] = "num") do={
			:set train ([:pick $mVer $mPos ([:len $mVer])]);
			:set mVer [:pick $mVer 0 $mPos];
			:set found 1;
		}
	}
	:if ($found = 0) do={
		:set mPos [:find $mVer "alpha"];
		:if ([:typeof $mPos] = "num") do={
			:set train ([:pick $mVer $mPos ([:len $mVer])]);
			:set mVer [:pick $mVer 0 $mPos];
			:set found 1;
		}
	}
	
	:set mPos [:find $mVer "."];
	:if ([:typeof $mPos] = "num") do={
		:set major ([:tonum [:pick $mVer 0 $mPos]]);
		:set mVer [:pick $mVer ($mPos + 1) [:len $mVer]];
		:set mPos [:find $mVer "."];
		:if ([:typeof $mPos] = "num") do={
			:set minor ([:tonum [:pick $mVer 0 $mPos]]);
			:set mVer [:pick $mVer ($mPos + 1) [:len $mVer]];
			:if ([:len $mVer] > 0) do={
				:set patch ([:tonum $mVer]);
			}
		} else={
			:if ([:len $mVer] > 0) do={
				:set minor ([:tonum $mVer]);
			}
		}
	}
	
	:local rObj [:toarray ""];
	:set ($rObj->"major") $major;
	:set ($rObj->"minor") $minor;
	:set ($rObj->"patch") $patch;
	:set ($rObj->"train") $train;
	:set ($rObj->"channel") $channel;
	:return $rObj;
}

:global MtmUtilPacks;
:set ($MtmUtilPacks->"routeros") $s;
