:local cPath "MTM/Utilities/Tools/Concurrency/Mutex.rsc";

:local s [:toarray ""];

:set ($s->"lock") do={
	
	:local cPath "MTM/Utilities/Tools/Concurrency/Mutex.rsc/lock";
	:if ([:typeof $0] != "str"  || [:len $0] < 1) do={
		:error ($cPath.": Input lock name invalid type '".[:typeof $0]."'");
	}
	:local lName $0;
	
	:local hold 5;
	:if ([:typeof $1] = "num") do={
		:if ($1 < 2) do={
			:error ($cPath.": Input lock duration for lock name '".$lName."' too short, must be at least 2s");
		} else={
			:set hold $1;
		}
	} else={
		:if ([:typeof $1] != nil) do={
			:error ($cPath.": Input lock hold time invalid type '".[:typeof $1]."'");
		}
	}

	:local wait 0;
	:if ([:typeof $2] = "num") do={
		:set wait $2;
		:if ($wait < 0) do={
			:error ($cPath.": Input lock wait for lock name '".$lName."' too short, must be at least 0s");
		}
		
	} else={
		:if ([:typeof $2] != nil) do={
			:error ($cPath.": Input lock wait time invalid type '".[:typeof $2]."'");
		}
	}

	:global MtmUtils;
	:local key ([/certificate/scep-server/otp/generate minutes-valid=0 as-value]->"password");
	:local timeTool [($MtmUtils->"get") "getTools()->getTime()->getEpoch()"];
	:local cTime [($timeTool->"getCurrent")];
	:local tTime ($cTime + $wait);
	:local lock [:toarray ""];
	:local isDone false;
	
	:while ($isDone = false) do={
		:global MtmUtilMutex;
		:set lock ($MtmUtilMutex->$lName);
		:if ([:typeof $lock] = "nothing") do={
			:set ($MtmUtilMutex->$lName) {expire=($cTime + $hold);key=$key};
			:set isDone true;
		} else={
			:if (($lock->"expire") < $cTime) do={
				:set ($MtmUtilMutex->$lName);
			} else={
				:if ($tTime > $cTime) do={
					:delay 0.2s;
					:set cTime [($timeTool->"getCurrent")];
				} else={
					:set isDone true;
				}
			}
		}
	}
	:global MtmUtilMutex;
	:set lock ($MtmUtilMutex->$lName);
	:if ($key = ($lock->"key")) do={
		:return ($lock->"key");
	} else={
		:error ($cPath.": Failed to obtain lock name '".$0."', lock taken");
	}
}
:set ($s->"extendlock") do={
	
	:local cPath "MTM/Utilities/Tools/Concurrency/Mutex.rsc/extendlock";
	:if ([:typeof $0] != "str"  || [:len $0] < 1) do={
		:error ($cPath.": Input lock name invalid type '".[:typeof $0]."'");
	}
	:if ([:typeof $1] != "str"  || [:len $1] < 1) do={
		:error ($cPath.": Input lock key invalid for lock name '".$0."'");
	}
	:local hold 0;
	:if ([:typeof $2] = "num") do={
		:set hold $2;
	} else={
		:if ([:typeof $2] = "str" && [:len $2] > 0) do={
			:set hold [:tonum $2];
		}
	}
	:if ($hold < 2) do={
		:error ($cPath.": Input lock duration for lock name '".$0."' too short");
	}

	:global MtmUtilMutex;
	:global MtmUtils;

	:local lock ($MtmUtilMutex->$0);
	:if ([:typeof $lock] != "nothing") do={
		
		:local timeTool [($MtmUtils->"get") "getTools()->getTime()->getEpoch()"];
		:local cTime [($timeTool->"getCurrent")];
	
		:if ($1 != ($lock->"key")) do={
			:error ($cPath.": Failed to extend lock name '".$0."' key does not match");
		}
		:if ((($lock->"expire") - 2) < $cTime) do={
			:error ($cPath.": Failed to extend lock name '".$0."' expires in less than 2 seconds");
		}
		:set ($MtmUtilMutex->$0) {expire=($cTime + $hold);key=$1};
		
	} else={
		:error ($cPath.": Failed to extend lock name '".$0."', lock does not exist");
	}
	:return true;
}
:set ($s->"lockremain") do={
	
	:local cPath "MTM/Utilities/Tools/Concurrency/Mutex.rsc/lockremain";
	:if ([:typeof $0] != "str"  || [:len $0] < 1) do={
		:error ($cPath.": Input lock name invalid type '".[:typeof $0]."'");
	}
	
	:local remain 0;
	:global MtmUtilMutex;
	:local lock ($MtmUtilMutex->$0);
	:if ([:typeof $lock] != "nothing") do={
		:global MtmUtils;
		:local timeTool [($MtmUtils->"get") "getTools()->getTime()->getEpoch()"];
		:set remain (($lock->"expire") - [($timeTool->"getCurrent")]);
	}
	:return $remain;
}
:set ($s->"unlock") do={
	:local cPath "MTM/Utilities/Tools/Concurrency/Mutex.rsc/unlock";
	:if ([:typeof $0] != "str"  || [:len $0] < 1) do={
		:error ($cPath.": Input lock name invalid type '".[:typeof $0]."'");
	}
	:if ([:typeof $1] != "str"  || [:len $1] < 1) do={
		:error ($cPath.": Input lock key invalid for lock name '".$0."'");
	}
	:global MtmUtilMutex;
	:local lock ($MtmUtilMutex->$0);
	:if ([:typeof $lock] != "nothing") do={
		:if ($1 != ($lock->"key")) do={
			:error ($cPath.": Failed to unlock name '".$0."' key does not match");
		}
		:set ($MtmUtilMutex->$0);
	}
	:return true;
}

:global MtmUtilMutex;
:set MtmUtilMutex [:toarray ""];

:global MtmUtilConcurrency;
:set ($MtmUtilConcurrency->"mutex") $s;

