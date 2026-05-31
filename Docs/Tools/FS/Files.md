#initialize

```
/import file-name=flash/storage/MTM/Utilities/Enable.rsc;
:global MtmUtils;
:local toolObj [($MtmUtils->"get") "getTools()->getFS()->getFiles()"];
```

## Methods:

### getExists:

```
:local filePath "flash/my/dir/example.txt"
:local wait 0; ##default: 0, allow a little time if file does not exist, helpful if you just created a file and its not yet showing

:local bool [($toolObj->"getExists") $filePath $wait]; ##boolean

```

### getTemp:

```
:local fileName [($toolObj->"getTemp")]; ##filename as string e.g. mtmTmpFiles/73c7f7d1a724.txt

```

### create:

```
:local filePath "flash/my/dir/example.txt"
:local throw 0; ##default: true, throw error if we fail, else false is returned

:local bool [($toolObj->"create") $filePath $wait]; ##boolean

```

### delete:

```
:local filePath "flash/my/dir/example.txt"
:local bool [($toolObj->"create") $filePath $wait]; ##boolean or error

```


##TODO: add more documentation for all the methods