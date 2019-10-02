#!/usr/bin/env python3
# https://raw.githubusercontent.com/cellar-wg/matroska-specification/master/ebml_matroska.xml

import sys
from xml.etree import ElementTree as ET

header="""// This file is codegenerated. Run `./database.py --help` for info.
const mkv = @import("../mkv.zig");
const IdInfo = mkv.L2Parser.IdInfo;

pub const database = [_]IdInfo {
    IdInfo { .id=0x1A45DFA3, .type=.master  , .name="EBML"                        ,.important=true },
    IdInfo { .id=0x4286    , .type=.uinteger, .name="EBMLVersion"                 ,.important=false},
    IdInfo { .id=0x42F7    , .type=.uinteger, .name="EBMLReadVersion"             ,.important=true },
    IdInfo { .id=0x42F2    , .type=.string  , .name="EBMLMaxIDLength"             ,.important=false},
    IdInfo { .id=0x42F3    , .type=.uinteger, .name="EBMLMaxSizeLength"           ,.important=false},
    IdInfo { .id=0x4282    , .type=.string  , .name="DocType"                     ,.important=true },
    IdInfo { .id=0x4287    , .type=.uinteger, .name="DocTypeVersion"              ,.important=false},
    IdInfo { .id=0x4285    , .type=.uinteger, .name="DocTypeReadVersion"          ,.important=true },
    IdInfo { .id=0x4281    , .type=.master  , .name="DocTypeExtension"            ,.important=false},
    IdInfo { .id=0x4283    , .type=.string  , .name="DocTypeExtensionName"        ,.important=false},
    IdInfo { .id=0x4284    , .type=.uinteger, .name="DocTypeExtensionVersion"     ,.important=false},
    IdInfo { .id=0xEC      , .type=.binary  , .name="Void"                        ,.important=false},
    IdInfo { .id=0xBF      , .type=.binary  , .name="CRC32"                       ,.important=false},

"""

footer="""
};
"""


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

def codegen_database_zig():
    r=ET.fromstring(sys.stdin.buffer.read())
    print(header)
    for x in r.findall("q:element",namespaces={"q":"https://ietf.org/cellar/ebml"}):
        i=x.get("id")
        t=x.get("type")
        n=x.get("name")

        impo=n in important_elements;

        if t == "utf-8": t="utf8"
        if n.startswith("EBML"): continue

        print("    IdInfo { .id=%-10s, .type=.%-8s, .name=%-30s,.important=%s}," % (i, t, '"'+n+'"', "true " if impo else "false"))
    print(footer)


if __name__ == "__main__":
    if len(sys.argv) != 1:
        print("Usage: curl -s https://raw.githubusercontent.com/cellar-wg/matroska-specification/master/ebml_matroska.xml | python3 src/mkv/database.py > src/mkv/database.zig\n")
        sys.exit(1)
    codegen_database_zig()

