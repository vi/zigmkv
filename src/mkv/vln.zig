const assert = @import("std").debug.assert;

/// Returns length of EBML VLN based on first byte, including the first byte
/// Returns error if it is 0.
pub fn len(first_byte:u8) !usize {
    return switch(first_byte) {
        0x80...0xFF => 1,
        0x40...0x7F => 2,
        0x20...0x3F => 3,
        0x10...0x1F => 4,
        0x08...0x0F => 5,
        0x04...0x07 => 6,
        0x02...0x03 => 7,
        0x01...0x01 => 8,
        0x00...0x00 => error.MkvWrongByteInEbmlVarnum,
    };
}

/// Returns parsed VLN, with or without the size tag, or null of VLN's data part is all 1-s.
/// Panics if the number is invalid.
pub fn parse_unsigned(b:[]const u8, with_tag: bool) ?u64 {
    assert(b.len > 0);
    const s = len(b[0]) catch @panic("Invalid EMBL variable-length number");
    assert(b.len == s);
    
    var mask : u8 = switch(s) {
        1 => u8(0xFF),
        2 => 0x7F,
        3 => 0x3F,
        4 => 0x1F,
        5 => 0x0F,
        6 => 0x07,
        7 => 0x03,
        8 => 0x01,
        else => unreachable,
    };
    if (!with_tag) mask >>= 1;
    var x           = @intCast(u64, mask & b[0]);
    var maxpossible = @intCast(u64, mask);

    for(b[1..]) |v| {
        x <<= 8;
        x |= @intCast(u64, v);
        maxpossible <<= 8;
        maxpossible |= 0xFF;
    }

    if (x == maxpossible) return null;
    return x;
}
test "ebml_get_unsigned" {
    const expectEqual = @import("std").testing.expectEqual;
    expectEqual((?u64)(0x1A45DFA3), parse_unsigned("\x1a\x45\xdf\xa3", true));
    expectEqual((?u64)(0x0A45DFA3), parse_unsigned("\x1a\x45\xdf\xa3", false));
    expectEqual((?u64)(null), parse_unsigned("\x1f\xff\xff\xff", false));
    expectEqual((?u64)(null), parse_unsigned("\x3f\xff\xff", false));
    expectEqual((?u64)(null), parse_unsigned("\x7f\xff", false));
    expectEqual((?u64)(null), parse_unsigned("\xff", false));
    expectEqual((?u64)(null), parse_unsigned("\x1f\xff\xff\xff", true));
    expectEqual((?u64)(null), parse_unsigned("\x3f\xff\xff", true));
    expectEqual((?u64)(null), parse_unsigned("\x7f\xff", true));
    expectEqual((?u64)(null), parse_unsigned("\xff", true));
    expectEqual((?u64)(0), parse_unsigned("\x80", false));
    expectEqual((?u64)(0), parse_unsigned("\x40\x00", false));
    expectEqual((?u64)(0), parse_unsigned("\x20\x00\x00", false));
    expectEqual((?u64)(0), parse_unsigned("\x10\x00\x00\x00", false));
    expectEqual((?u64)(0), parse_unsigned("\x08\x00\x00\x00\x00", false));
    expectEqual((?u64)(0), parse_unsigned("\x04\x00\x00\x00\x00\x00", false));
    expectEqual((?u64)(0), parse_unsigned("\x02\x00\x00\x00\x00\x00\x00", false));
    expectEqual((?u64)(0), parse_unsigned("\x01\x00\x00\x00\x00\x00\x00\x00", false));
    expectEqual((?u64)(0xFE), parse_unsigned("\xfe", true));
    expectEqual((?u64)(0x7FFE), parse_unsigned("\x7f\xfe", true));
    expectEqual((?u64)(0x3FFFFE), parse_unsigned("\x3f\xff\xfe", true));
    expectEqual((?u64)(0x1FFFFFFE), parse_unsigned("\x1f\xff\xff\xfe", true));
    expectEqual((?u64)(0x7E), parse_unsigned("\xfe", false));
    expectEqual((?u64)(0x3FFE), parse_unsigned("\x7f\xfe", false));
    expectEqual((?u64)(0x1FFFFE), parse_unsigned("\x3f\xff\xfe", false));
    expectEqual((?u64)(0x0FFFFFFE), parse_unsigned("\x1f\xff\xff\xfe", false));
    expectEqual((?u64)(0x07FFFFFFFE), parse_unsigned("\x0f\xff\xff\xff\xfe", false));
    expectEqual((?u64)(0x03FFFFFFFFFE), parse_unsigned("\x07\xff\xff\xff\xff\xfe", false));
    expectEqual((?u64)(0x01FFFFFFFFFFFE), parse_unsigned("\x03\xff\xff\xff\xff\xff\xfe", false));
    expectEqual((?u64)(0x00FFFFFFFFFFFFFE), parse_unsigned("\x01\xff\xff\xff\xff\xff\xff\xfe", false));
}
