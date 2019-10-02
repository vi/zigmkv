#!/usr/bin/env python3
# https://raw.githubusercontent.com/cellar-wg/matroska-specification/master/ebml_matroska.xml

import sys
from xml.etree import ElementTree as ET

header="""// This file is codegenerated. Run `./database.py --help` for info.
const mkv = @import("../mkv.zig");
const IdInfo = mkv.L2Parser.IdInfo;

pub const database = [_]IdInfo {
    IdInfo { .id=0x1A45DFA3, .type=.master  , .name="EBML"                        },
    IdInfo { .id=0x4286    , .type=.uinteger, .name="EBMLVersion"                 },
    IdInfo { .id=0x42F7    , .type=.uinteger, .name="EBMLReadVersion"             },
    IdInfo { .id=0x42F2    , .type=.string  , .name="EBMLMaxIDLength"             },
    IdInfo { .id=0x42F3    , .type=.uinteger, .name="EBMLMaxSizeLength"           },
    IdInfo { .id=0x4282    , .type=.string  , .name="DocType"                     },
    IdInfo { .id=0x4287    , .type=.uinteger, .name="DocTypeVersion"              },
    IdInfo { .id=0x4285    , .type=.uinteger, .name="DocTypeReadVersion"          },
    IdInfo { .id=0x4281    , .type=.master  , .name="DocTypeExtension"            },
    IdInfo { .id=0x4283    , .type=.string  , .name="DocTypeExtensionName"        },
    IdInfo { .id=0x4284    , .type=.uinteger, .name="DocTypeExtensionVersion"     },
    IdInfo { .id=0xEC      , .type=.binary  , .name="Void"                        },
    IdInfo { .id=0xBF      , .type=.binary  , .name="CRC32"                       },

"""

footer="""
};
"""

def codegen_database_zig():
    r=ET.fromstring(sys.stdin.buffer.read())
    print(header)
    for x in r.findall("q:element",namespaces={"q":"https://ietf.org/cellar/ebml"}):
        i=x.get("id")
        t=x.get("type")
        n=x.get("name")

        if t == "utf-8": t="utf8"
        if n.startswith("EBML"): continue

        print("    IdInfo { .id=%-10s, .type=.%-8s, .name=%-30s}," % (i, t, '"'+n+'"'))
    print(footer)


if __name__ == "__main__":
    if len(sys.argv) != 1:
        print("Usage: curl -s https://raw.githubusercontent.com/cellar-wg/matroska-specification/master/ebml_matroska.xml | python3 src/mkv/database.py > src/mkv/database.zig\n")
        sys.exit(1)
    codegen_database_zig()

