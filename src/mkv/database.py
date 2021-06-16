#!/usr/bin/env python3
# https://raw.githubusercontent.com/cellar-wg/matroska-specification/master/ebml_matroska.xml

import sys
from xml.etree import ElementTree as ET

header="""// This file is codegenerated. Run `./database.py --help` for info.
const mkv = @import("../mkv.zig");
const IdInfo = mkv.id.IdInfo;
const Id = mkv.id.Id;

pub const database = [_]IdInfo {
"""

footer="""
};
"""

hot_elements="""
    Cluster
    SimpleBlock
    Timestamp
""".split()

important_elements="""
    Segment
    Info
    TimestampScale
    Cluster
    Timestamp
    SimpleBlock
    BlockGroup
    Block
    BlockDuration
    Tracks
    TrackEntry
    TrackNumber
    TrackType
    CodecID
    CodecPrivate
    Video
    PixelWidth
    PixelHeight
    Audio
    SamplingFrequency
    Channels
    ContentCompression
""".split()

def codegen(elids):
    print(header)
    for x in elids:
        i=x.get("id")
        t=x.get("type")
        n=x.get("name")
        p=x.get("imp")
        
        print("    IdInfo { .id=%-10s, .typ=.%-8s, .name=%-30s,.importance=.%-10s}," % (i, t, '"'+n+'"', p))
    print(footer)

    for x in elids:
        i=x.get("id")
        n=x.get("name")
        
        print("pub const ID_%-30s = Id.wrap(%-10s);" % (n,i) )

        
    pass

def codegen_database_zig():
    r=ET.fromstring(sys.stdin.buffer.read())
    elids = [
        { 'id':"0x1A45DFA3", 'type':"master"  , "name": "EBML"                        ,"imp":"important" },
        { 'id':"0x4286"    , 'type':"uinteger", "name": "EBMLVersion"                 ,"imp":"default"   },
        { 'id':"0x42F7"    , 'type':"uinteger", "name": "EBMLReadVersion"             ,"imp":"important" },
        { 'id':"0x42F2"    , 'type':"uinteger", "name": "EBMLMaxIDLength"             ,"imp":"default"   },
        { 'id':"0x42F3"    , 'type':"uinteger", "name": "EBMLMaxSizeLength"           ,"imp":"default"   },
        { 'id':"0x4282"    , 'type':"string"  , "name": "DocType"                     ,"imp":"important" },
        { 'id':"0x4287"    , 'type':"uinteger", "name": "DocTypeVersion"              ,"imp":"default"   },
        { 'id':"0x4285"    , 'type':"uinteger", "name": "DocTypeReadVersion"          ,"imp":"important" },
        { 'id':"0x4281"    , 'type':"master"  , "name": "DocTypeExtension"            ,"imp":"default"   },
        { 'id':"0x4283"    , 'type':"string"  , "name": "DocTypeExtensionName"        ,"imp":"default"   },
        { 'id':"0x4284"    , 'type':"uinteger", "name": "DocTypeExtensionVersion"     ,"imp":"default"   },
        { 'id':"0xEC"      , 'type':"binary"  , "name": "Void"                        ,"imp":"default"   },
        { 'id':"0xBF"      , 'type':"binary"  , "name": "CRC32"                       ,"imp":"default"   },
    ];
    for x in r.findall("q:element",namespaces={"q":"urn:ietf:rfc:8794"}):
        i=x.get("id")
        t=x.get("type")
        n=x.get("name")

        impo=n in important_elements;
        hoto=n in hot_elements;

        if t == "utf-8": t="utf8"
        if n.startswith("EBML"): continue

        imp = "important" if impo else "default"
        if hoto: imp = "hot"

        elids.append({
            'name': n,
            'id': i,
            'type': t,
            'imp': imp,
        });
    codegen(elids)


if __name__ == "__main__":
    if len(sys.argv) != 1:
        print("Usage: curl -s https://raw.githubusercontent.com/cellar-wg/matroska-specification/master/ebml_matroska.xml | python3 src/mkv/database.py > src/mkv/database.zig\n")
        sys.exit(1)
    codegen_database_zig()

