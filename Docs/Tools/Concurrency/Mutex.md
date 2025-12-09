#initialize

```
/import file-name=flash/storage/MTM/Utilities/Enable.rsc;
:global MtmUtils;
:local toolObj [($MtmUtils->"get") "getTools()->getConcurrency()->getMutex()"];
```

## Methods:

### lock:

```
:local lockName "myProc"; ##name of the lock
:local lockHold 300; ##how long the lock is valid for maximum, default: 5
:local lockWait 2; ##if lock exists, how long will we wait to try and obtain it, default: 0

:local key [($toolObj->"lock") $lockName $lockHold $lockWait]; ##error if the lock is already held else the key for the lock


```
