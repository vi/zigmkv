const std = @import("std");
const BUFL = 8;

const vln = @import("../mkv.zig").vln;

state: State,

pub const TagOpenInfo = struct {
    id: u32,
    size: ?u64,
};
pub const TagCloseInfo = struct {
    id: u32,
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
        const required_bytes : usize = try vln.len(first_byte);
        if (required_bytes > bytes_available) {
            // Remember those bytes
            var can_copy = BUFL - @intCast(usize, self.bytes_already_in_buffer);
            if (can_copy > b.len) can_copy = bb.len;
            std.mem.copy(u8, self.buf[self.bytes_already_in_buffer..(self.bytes_already_in_buffer+can_copy)], bb[0..can_copy]);
            self.bytes_already_in_buffer+=@intCast(u8,can_copy);
            @import("std").debug.warn("b.len={} bb.len={} can_copy={}\n", b.*.len, bb.len, can_copy);
            b.* = bb[can_copy..];
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
        return vln.parse_unsigned(vnb, with_tag);
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
    bytes_remaining: ?u32,
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

/// Make L1Parser interpret specified bytes, calling `callback` if some event is ready to go.
/// The data is only minimally cached. Short pushes result in short `RawData` events.
pub fn push_bytes(
                    self: *Self, 
                    b: []const u8, 
                    usrdata: var,
                    callback: fn(usrdata: @typeOf(usrdata), event: Event)anyerror!HandlerReply,
                )anyerror!void {
    var bb = b;
    var loop_again = false; // for some final cleanup events even when all data is processed
    while(bb.len != 0 and !loop_again) {
        loop_again=false;
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
            .waiting_for_size => |*ss| {
                const ret : anyerror!?u64 = ss.reading_num.push_bytes(&bb, false);
                _ = ret catch |x| if (x == error._NotReadyYet) continue;
                var size = try ret;

                _ = try callback(usrdata, Event{.TagOpened=TagOpenInfo { .id = ss.element_id, .size = size} });
                if (size) |x| if (x > 0xFFFFFFFF) {
                    // Considering that large elements infinite
                    size = null;
                };

                self.state = State {
                    .streaming_data = StreamingData {
                        .element_id = ss.element_id,
                        .bytes_remaining = if(size)|x|@intCast(u32, x) else null,
                    },
                };
                continue;
            },
            .streaming_data => |*ss| {
                var bytes_to_haul_this_time = bb.len;
                if (ss.bytes_remaining)|x|{
                    if (bytes_to_haul_this_time > x) bytes_to_haul_this_time = x;
                }
                _ = try callback(usrdata, Event{.RawData=bb[0..bytes_to_haul_this_time]});
                bb=bb[bytes_to_haul_this_time..];
                if (ss.bytes_remaining)|*x|{
                    x.* -= @intCast(u32,bytes_to_haul_this_time);
                    if (x.* == 0) {
                        // finished streaming
                        _ = try callback(usrdata, Event{.TagClosed=TagCloseInfo { .id = ss.element_id} });
                        self.state = State {
                            .waiting_for_id = WaitingForId {
                                .reading_num = ReadingEbmlVln.new(),
                            },
                        };
                    }
                }
                continue;
            },
        }
    }
}
