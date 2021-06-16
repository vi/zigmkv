# zigmkv
A work in progress Matroska/webm (mkv) parser in Zig.
For now it contains elements database, can decode mkv files to element tree, but it does not yet handle parse frame content and calculate proper timecodes.
Main idea was to evaluate Zig as a general purpose programming language.

```
$ zig build
$ zig-out/bin/zigmkv l2dump < some_file.mkv
open 0x1a45dfa3 (EBML) type=Type.master size=35
  open 0x4286 (EBMLVersion) type=Type.uinteger size=1
    number 1
    close 0x4286 (EBMLVersion) type=Type.uinteger
  open 0x42f7 (EBMLReadVersion) type=Type.uinteger size=1
    number 1
    close 0x42f7 (EBMLReadVersion) type=Type.uinteger
  open 0x42f2 (EBMLMaxIDLength) type=Type.uinteger size=1
    number 4
    close 0x42f2 (EBMLMaxIDLength) type=Type.uinteger
...
```
