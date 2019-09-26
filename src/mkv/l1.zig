const std = @import("std");
const BUFL = 8;

state: State,

pub const TagOpenInfo = struct {
    id: u32,
    size: ?u64,
};
pub const TagCloseInfo = struct {
    id: u32,
    size: u64,
};

pub const Event = union(enum) {
    TagOpened: TagOpenInfo,
    RawData: []const u8,
    TagClosed: TagCloseInfo,
};

pub const HandlerReply = enum {
    GiveRawData,
    GoDeeper,
};

const ReadingEbmlVln = struct {
    buf: [BUFL]u8,
    bytes_already_in_buffer: u8,

    const Self2 = @This();

    pub fn new() Self2 {
        return Self2 {
            .bytes_already_in_buffer = 0,
            .buf = [1]u8{0} ** BUFL,
        };
    }
    pub fn push_bytes(self: *Self2, b: *[]const u8, with_tag: bool)!?u64 {
        const bb = b.*;
        const bytes_available = @intCast(usize,self.bytes_already_in_buffer) + bb.len;
        const first_byte : u8 = if (self.bytes_already_in_buffer  > 0) self.buf[0] else bb[0];
        const required_bytes : usize = try ebml_num_size(first_byte);
        if (required_bytes > bytes_available) {
            // Remember those bytes
            var can_copy = BUFL - @intCast(usize, self.bytes_already_in_buffer);
            if (can_copy > b.len) can_copy = bb.len;
            std.mem.copy(u8, self.buf[self.bytes_already_in_buffer..(self.bytes_already_in_buffer+can_copy)], bb[0..can_copy]);
            self.bytes_already_in_buffer+=@intCast(u8,can_copy);
            b.* = bb[can_copy..0];
            return error._NotReadyYet;
        }
        var vnb : []const u8 = undefined;
        if (self.bytes_already_in_buffer == 0) {
            // fast&happy path
            vnb = bb[0..required_bytes];
            b.* = bb[required_bytes..];
        } else {
            std.mem.copy(u8, self.buf[self.bytes_already_in_buffer..required_bytes], bb[0..(required_bytes-self.bytes_already_in_buffer)]);
            b.* = bb[(required_bytes-self.bytes_already_in_buffer)..];
            vnb = self.buf[0..required_bytes];
        }
        return ebml_get_unsigned(vnb, with_tag);
    }
};

const WaitingForId = struct {
    reading_num : ReadingEbmlVln,
};
const WaitingForSize = struct {
    reading_num : ReadingEbmlVln,
    element_id: u32,
};

const StreamingData = struct {
    element_id: u32,
    element_inner_size: ?u32,
    bytes_remaining: u32,
};

const State = union(enum) {
    /// Waiting until we get full element ID
    waiting_for_id: WaitingForId,
    /// Waiting until we get full EBML element size
    waiting_for_size : WaitingForSize,
    /// Inside non-Master EBML element
    streaming_data : StreamingData,
};




const Self = @This();

pub fn new() Self {
    var p = Self { 
        .state = State { 
            .waiting_for_id = WaitingForId {
                .reading_num = ReadingEbmlVln.new(),
            }
        },
    };
    return p;
}

fn ebml_num_size(first_byte:u8) !usize {
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

fn ebml_get_unsigned(b:[]const u8, with_tag: bool) ?u64 {
    std.debug.assert(b.len > 1);
    const s = ebml_num_size(b[0]) catch @panic("Invalid EMBL variable-length number");
    std.debug.assert(b.len == s);
    
    const mask : u8 = if (with_tag)
        u8(0xFF)
    else switch(s) {
        1 => u8(0x7F),
        2 => 0x3F,
        3 => 0x1F,
        4 => 0x0F,
        5 => 0x07,
        6 => 0x03,
        7 => 0x01,
        8 => 0x00,
        else => unreachable,
    };
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

/// Make L1Parser interpret specified bytes, calling `callback` if some event is ready to go.
/// The data is only minimally cached. Short pushes result in short `RawData` events.
pub fn push_bytes(
                    self: *Self, 
                    b: []const u8, 
                    usrdata: var,
                    callback: fn(usrdata: @typeOf(usrdata), event: Event)anyerror!HandlerReply,
                )anyerror!void {
    var bb = b;
    while(bb.len != 0) {
        switch (self.state) {
            .waiting_for_id => |*ss| {
                const ret : anyerror!?u64 = ss.reading_num.push_bytes(&bb, true);
                _ = ret catch |x| if (x == error._NotReadyYet) continue;
                const id = (try ret) orelse return error.MkvInvalidElementId;
                if (id > 0xFFFFFFFE) return error.MkvElementIdTooLarge;
                self.state = State { 
                    .waiting_for_size = WaitingForSize { 
                        .reading_num = ReadingEbmlVln.new(),
                        .element_id = @intCast(u32,id),
                    },
                };
                continue;
            },
            .waiting_for_size => |ss| {
                @panic("unimplemented");
            },
            .streaming_data => |ss| {
                _ = try callback(usrdata, Event{.RawData=bb});
                bb=bb[0..0];
                continue;
            },
        }
    }
}
