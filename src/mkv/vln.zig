const std = @import("std");
const assert = std.debug.assert;

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
        1 => 0xFF,
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

const BUFL = 8;
pub const EbmlVlnReader = struct {
    buf: [BUFL]u8,
    bytes_already_in_buffer: u8,

    const Self2 = @This();

    pub fn new() Self2 {
        return Self2 {
            .bytes_already_in_buffer = 0,
            .buf = [1]u8{0} ** BUFL,
        };
    }
    const PushBytesRet = struct {
        /// four outcomes: 1. ready number, 2. null, 3. not enough bytes, keep feeding, 3. error happened
        result: anyerror!?u64,
        /// Bytes can be consumed even if null returned in `result`
        consumed_bytes: usize,
    };
    pub fn push_bytes(self: *Self2, bb: []const u8, with_tag: bool) PushBytesRet {
        if (bb.len == 0) return PushBytesRet { .result = error._NotReadyYet, .consumed_bytes = 0 };
        const bytes_available = @intCast(usize,self.bytes_already_in_buffer) + bb.len;
        const first_byte : u8 = if (self.bytes_already_in_buffer  > 0) self.buf[0] else bb[0];
        const required_bytes : usize = len(first_byte) catch |e| return PushBytesRet { .result = e, .consumed_bytes = 0};
        if (required_bytes > bytes_available) {
            // Remember those bytes
            var can_copy = BUFL - @intCast(usize, self.bytes_already_in_buffer);
            if (can_copy > bb.len) can_copy = bb.len;
            std.mem.copy(u8, self.buf[self.bytes_already_in_buffer..(self.bytes_already_in_buffer+can_copy)], bb[0..can_copy]);
            self.bytes_already_in_buffer+=@intCast(u8,can_copy);
            return PushBytesRet { .result = error._NotReadyYet, .consumed_bytes = can_copy };
        }
        var vnb : []const u8 = undefined;
        var consumed_bytes : usize = undefined;
        if (self.bytes_already_in_buffer == 0) {
            // fast&happy path
            vnb = bb[0..required_bytes];
            consumed_bytes = required_bytes;
        } else {
            const to_copy = required_bytes-self.bytes_already_in_buffer;
            std.mem.copy(u8, self.buf[self.bytes_already_in_buffer..required_bytes], bb[0..to_copy]);
            vnb = self.buf[0..required_bytes];
            consumed_bytes = to_copy;
        }
        return PushBytesRet { .result = parse_unsigned(vnb, with_tag), .consumed_bytes = consumed_bytes };
    }
};
