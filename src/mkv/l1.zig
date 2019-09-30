const std = @import("std");
const BUFL = 8; // to fit any VLN
const MAXDEPTH = 8; // max depth of nested EBML elements

const vln = @import("../mkv.zig").vln;


pub const TagOpenInfo = struct {
    id: u32,
    size: ?u64,
    /// To be set by event handler. If size is null and this is a master element then no tag closed event may be not delivered.
    write_true_here_if_master_element: bool,
};
pub const TagCloseInfo = struct {
    id: u32,
};

pub const Event = union(enum) {
    /// Do not squirrel away the pointer
    TagOpened: *TagOpenInfo,
    RawDataChunk: []const u8,
    TagClosed: TagCloseInfo,
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
        const required_bytes : usize = vln.len(first_byte) catch |e| return PushBytesRet { .result = e, .consumed_bytes = 0};
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
        return PushBytesRet { .result = vln.parse_unsigned(vnb, with_tag), .consumed_bytes = consumed_bytes };
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

const ParentElement = struct {
    element_id: u32,
    bytes_remaining: u32, // shall it handle super-large segments that fail to fit in u32?
};

const Self = @This();

state: State,
parent_elements: [MAXDEPTH]ParentElement,
parent_element_count: u8,

pub fn new() Self {
    var p = Self { 
        .state = State { 
            .waiting_for_id = WaitingForId {
                .reading_num = ReadingEbmlVln.new(),
            }
        },
        .parent_elements = undefined,
        .parent_element_count = 0,
    };
    return p;
}

/// Make L1Parser interpret specified bytes, calling `callback` if some event is ready to go.
/// The data is only minimally cached. Short pushes result in short `RawData` events.
pub fn push_bytes(
                    self: *Self, 
                    b: []const u8, 
                    usrdata: var,
                    callback: fn(usrdata: @typeOf(usrdata), event: Event)anyerror!void,
                )anyerror!void {
    var bb = b;
    var loop_again = false; // for some final cleanup events even when all data is processed
    while(bb.len != 0 or loop_again) 
        //: ({@import("std").debug.warn("L {} {}\n", bb.len, loop_again);}) 
    {
        loop_again=false;
        const immediate_parent_element : ?*ParentElement = if (self.parent_element_count > 0) &self.parent_elements[self.parent_element_count-1] else null;

        if (immediate_parent_element) |par| {
            //@import("std").debug.warn("P rem={} id={x}\n", par.bytes_remaining, par.element_id);
            if (par.bytes_remaining == 0) {
                try callback(usrdata, Event{.TagClosed=TagCloseInfo { .id = par.element_id} });
                self.parent_element_count -= 1;
                // TODO: check if state is not this one and maybe report error
                self.state = State {
                    .waiting_for_id = WaitingForId {
                        .reading_num = ReadingEbmlVln.new(),
                    },
                };
                loop_again = true;
                continue;
            }
        }

        switch (self.state) {
            .waiting_for_id => |*ss| {
                var allowed_bytes = bb.len;
                if (immediate_parent_element) |par| {
                    if (allowed_bytes > par.bytes_remaining) {
                        allowed_bytes = par.bytes_remaining;
                    }
                }
                const reti = ss.reading_num.push_bytes(bb[0..allowed_bytes], true);
                bb = bb[reti.consumed_bytes..];
                if (immediate_parent_element) |par| {
                    par.bytes_remaining -= @intCast(u32, reti.consumed_bytes);
                }

                const ret : anyerror!?u64 = reti.result;
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
                var allowed_bytes = bb.len;
                if (immediate_parent_element) |par| {
                    if (allowed_bytes > par.bytes_remaining) {
                        allowed_bytes = par.bytes_remaining;
                    }
                }
                const reti = ss.reading_num.push_bytes(bb[0..allowed_bytes], false);
                bb = bb[reti.consumed_bytes..];
                if (immediate_parent_element) |par| {
                    par.bytes_remaining -= @intCast(u32, reti.consumed_bytes);
                }
                
                const ret : anyerror!?u64 = reti.result;
                _ = ret catch |x| if (x == error._NotReadyYet) continue;
                var size = try ret;

                var ti = TagOpenInfo { 
                    .id = ss.element_id,
                    .size = size,
                    .write_true_here_if_master_element = false,
                };
                try callback(usrdata, Event{.TagOpened=&ti});
                if (size) |x| if (x > 0xFFFFFFFF) {
                    // Considering that large elements infinite
                    size = null;
                };
                var size32 = if(size)|x|@intCast(u32, x) else null;

                if (immediate_parent_element) |par| {
                    // Fill in size even if child element's size is null
                    // Or trim too large size, prefering parent element's size over child's
                    if (size32) |sz| {
                        if (sz > par.bytes_remaining) {
                            size32 = par.bytes_remaining;
                        }
                    } else {
                        size32 = par.bytes_remaining;
                    }
                }

                if (!ti.write_true_here_if_master_element) {
                    // non-master element
                    self.state = State {
                        .streaming_data = StreamingData {
                            .element_id = ss.element_id,
                            .bytes_remaining = size32,
                        },
                    };
                    continue;
                } else {
                    // master element

                    if (self.parent_element_count >= MAXDEPTH) {
                        return error.MkvElementsNestTooDeep;
                    }
                    if (size32) |sz| {
                        // There is some size, so can add parent element to the stack
                        const new_parent_element = &self.parent_elements[self.parent_element_count];
                        new_parent_element.*.element_id = ss.element_id;
                        new_parent_element.*.bytes_remaining = sz;
                        self.parent_element_count += 1;

                        if (immediate_parent_element) |par| {
                            par.bytes_remaining -= sz;
                        }
                    }
                    self.state = State {
                        .waiting_for_id = WaitingForId {
                            .reading_num = ReadingEbmlVln.new(),
                        },
                    };
                    continue;
                }
            },
            .streaming_data => |*ss| {
                var bytes_to_haul_this_time = bb.len;
                if (ss.bytes_remaining)|x|{
                    if (bytes_to_haul_this_time > x) bytes_to_haul_this_time = x;
                }
                try callback(usrdata, Event{.RawDataChunk=bb[0..bytes_to_haul_this_time]});
                bb=bb[bytes_to_haul_this_time..];
                if (immediate_parent_element) |par| {
                    par.bytes_remaining -= @intCast(u32, bytes_to_haul_this_time);
                }
                if (ss.bytes_remaining)|*x|{
                    x.* -= @intCast(u32,bytes_to_haul_this_time);
                    if (x.* == 0) {
                        // finished streaming
                        try callback(usrdata, Event{.TagClosed=TagCloseInfo { .id = ss.element_id} });
                        self.state = State {
                            .waiting_for_id = WaitingForId {
                                .reading_num = ReadingEbmlVln.new(),
                            },
                        };
                        loop_again = true;
                    }
                }
                continue;
            },
        }
    }
}
