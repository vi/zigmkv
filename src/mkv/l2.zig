const std = @import("std");
const mkv = @import("../mkv.zig");

const Id = mkv.id.Id;
const Type = mkv.id.Type;


const BUFL = 8; // to fit any float or number as element

pub const ElementBegins = struct {
    id: Id,
    typ: Type,
    size: ?u64,
    /// Allows quick-skipping unneeded elements. Contect will be delibered as unknown_or_void chunks.
    write_true_to_decode_as_binary: *bool,
};

pub const ElementEnds = struct {
    id: Id,
    typ: Type,
};


pub const Event = union(enum) {
    element_begins: ElementBegins,
    number: u64,
    signed_number: i64,
    binary_chunk: []const u8,
    string_chunk: []const u8,
    utf8_chunk: []const u8,
    unknown_or_void_chunk: []const u8,
    float: f64,
    element_ends: ElementEnds,
};


const BEUnsignedReader = struct {
    x: u64,
    filled: u8,
    size: u8,

    const Self2 = @This();
    pub fn new(sz: u64) Self2 {
        return Self2 {
            .x = 0,
            .filled = 0,
            .size = @intCast(u8, sz),
        };
    }
    pub fn push_bytes(self: *Self2, bb: []const u8) ?u64 {
        for (bb) |b| {
            if (self.size == self.filled) break;
            self.x <<= 8;
            self.x |= @intCast(u64, b);
            self.filled += 1;
        }
        if (self.size == self.filled) return self.x;
        return null;
    }
};
const BESignedReader = struct {
    x: i64,
    filled: u8,
    size: u8,

    const Self2 = @This();
    pub fn new(sz: u64) Self2 {
        return Self2 {
            .x = 0,
            .filled = 0,
            .size = @intCast(u8, sz),
        };
    }
    pub fn push_bytes(self: *Self2, bb: []const u8) ?i64 {
        for (bb) |b| {
            if (self.size == self.filled) break;
            if (self.filled == 0 and b >= 0x80) {
                self.x = @intCast(i64, b) - 256;
            } else {
                self.x <<= 8;
                self.x |= @intCast(i64, b);
            }
            self.filled += 1;
        }
        if (self.size == self.filled) return self.x;
        return null;
    }
};

test "numreaders" {
    const expectEqual = @import("std").testing.expectEqual;
    expectEqual((?u64)(0x12          ),  (BEUnsignedReader.new(1).push_bytes("\x12")));
    expectEqual((?u64)(0x1234        ),  (BEUnsignedReader.new(2).push_bytes("\x12\x34")));
    expectEqual((?u64)(null          ),  (BEUnsignedReader.new(2).push_bytes("\x12")));
    expectEqual((?u64)(0x1234567812345678),  (BEUnsignedReader.new(8).push_bytes("\x12\x34\x56\x78\x12\x34\x56\x78")));

    expectEqual((?i64)(0x12          ),  (BESignedReader.new(1).push_bytes("\x12")));
    expectEqual((?i64)(0x1234        ),  (BESignedReader.new(2).push_bytes("\x12\x34")));
    expectEqual((?i64)(null          ),  (BESignedReader.new(2).push_bytes("\x12")));
    expectEqual((?i64)(0x1234567812345678),  (BESignedReader.new(8).push_bytes("\x12\x34\x56\x78\x12\x34\x56\x78")));

    expectEqual((?i64)(-1            ),  (BESignedReader.new(1).push_bytes("\xFF")));
    expectEqual((?i64)(-1            ),  (BESignedReader.new(2).push_bytes("\xFF\xFF")));
    expectEqual((?i64)(null          ),  (BESignedReader.new(2).push_bytes("\xFF")));
    expectEqual((?i64)(-1            ),  (BESignedReader.new(8).push_bytes("\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF")));
}

/// Read exactly `required_len` bytes, emitting a buffer of exactly BUFL bytes, prepended with zero bytes
const AccumulateZeroPrependedBuffer = struct {
    buf: [BUFL]u8,
    filled: u8,

    const Self2 = @This();

    pub fn new(sz: u64) Self2 {
        return Self2 {
            .buf = [_]u8{0} ** BUFL,
            .filled = BUFL - @intCast(u8, sz),
        };
    }

    /// XXX: ignores trailing bytes
    pub fn push_bytes(self: *Self2, b: []const u8) ?[BUFL]u8 {
        var to_copy = b.len;
        if (to_copy > (BUFL - self.filled)) {
            to_copy = (BUFL - self.filled);
        }

        std.mem.copy(u8, self.buf[self.filled..(self.filled+to_copy)], b[0..to_copy]);
        self.filled += @intCast(u8,to_copy);

        if (self.filled == BUFL) {
            return self.buf;
        } else {
            return null;
        }
    }
};


const RawDataChunkMode = union(enum) {
    /// Pass-though RawDataChunks to Event.unknown_or_void_chunk
    unknown,
    /// Pass-though RawDataChunks to Event.binary_chunk
    binary,
    /// Pass-though RawDataChunks to Event.string_chunk
    string,
    /// Pass-though RawDataChunks to Event.utf8_chunk
    utf8,

    number: BEUnsignedReader,
    signed_number: BESignedReader,
    float32: BEUnsignedReader,
    float64: BEUnsignedReader,
};


const Self = @This();

pub fn new() Self {
    return Self {
        .l1 = mkv.L1Parser.new(),
        .state = RawDataChunkMode { .unknown={} },
    };
}

l1: mkv.L1Parser,
state: RawDataChunkMode,

pub fn push_bytes(
                    self: *Self,
                    b: []const u8,
                    usrdata: anytype,
                    callback: fn(usrdata: @TypeOf(usrdata), event: Event)anyerror!void,
                )anyerror!void {
    const H = L1Handler(@TypeOf(usrdata));
    const h = H { .self = self,  .usrdata = usrdata, .callback = callback };
    try self.l1.push_bytes(b, h, H.handler);
}

fn L1Handler(comptime T:type) type {
    return struct {
        self: *Self,
        usrdata: T,
        callback: fn(usrdata: T, event: Event)anyerror!void,

        fn handler(self: @This(), e: mkv.L1Parser.Event) anyerror!void {
            return self.self.l1handler(e, self.usrdata, self.callback);
        }
    };
}
fn l1handler(
                    self: *Self,
                    event: mkv.L1Parser.Event,
                    usrdata: anytype,
                    callback: fn(usrdata: @TypeOf(usrdata), event: Event)anyerror!void,
                )anyerror!void {
    switch(event) {
        .TagOpened    => |x| {
            const id = Id.wrap(x.id);
            const typ = id.get_type();
            var skip = false;
            const ev = Event {
                .element_begins = ElementBegins {
                    .id = id,
                    .typ = typ,
                    .size = x.size,
                    .write_true_to_decode_as_binary = &skip,
                }
            };
            try callback(usrdata, ev);
            self.state = switch(typ) {
                .unknown => .unknown,
                .string => .string,
                .binary => .binary,
                .utf8 => .utf8,
                .master => .unknown,

                .uinteger,
                .integer,
                .float,
                .date,
                => blk: {
                    if (x.size) |sz| {
                        if (sz > 8 or sz == 0) {
                            return error.MkvWrongSizeForNumericElement;
                        }
                        if (typ == .date and sz != 8) { return error.MkvWrongSizeForNumericElement; }
                        if (typ == .float and (sz != 8 and sz != 4)) { return error.MkvWrongSizeForNumericElement; }
                        break :blk switch (typ) {
                            .uinteger => RawDataChunkMode { .number = BEUnsignedReader.new(sz) },
                            .integer  => RawDataChunkMode { .signed_number = BESignedReader.new(sz) },
                            // TODO: proper date handling?
                            .date => RawDataChunkMode { .signed_number = BESignedReader.new(sz) },
                            .float =>   if (sz == 4)
                                            RawDataChunkMode { .float32 = BEUnsignedReader.new(4) }
                                        else
                                            RawDataChunkMode { .float32 = BEUnsignedReader.new(8) }
                                        ,
                            else => unreachable,
                        };
                    }
                    return error.MkvNoSizeForNumericElement;
                },
            };

            if (typ == .master and !skip) {
                x.write_true_here_if_master_element = true;
            }

            if (id.eql(mkv.id.ID_Void)) {
                self.state = .unknown;
            }
        },
        .RawDataChunk => |x| {
            switch (self.state) {
                .unknown => try callback(usrdata, Event { .unknown_or_void_chunk = x }),
                .binary  => try callback(usrdata, Event { .binary_chunk = x }),
                .string  => try callback(usrdata, Event { .string_chunk = x }),
                .utf8    => try callback(usrdata, Event { .utf8_chunk = x }),

                .number,
                .float32,
                .float64
                => |*y| {
                    if (y.push_bytes(x)) |xx| {
                        switch (self.state) {
                            .number => {
                                try callback(usrdata, Event { .number = xx });
                            },
                            .float64 => {
                                const f = @bitCast(f64, xx);
                                try callback(usrdata, Event { .float = f });
                            },
                            .float32 => {
                                const f = @floatCast(f64, @bitCast(f32, @intCast(u32, xx)));
                                try callback(usrdata, Event { .float = f });
                            },
                            else => unreachable,
                        }
                    } else {
                        // number is not ready yet. Awaiting for more RawDataChunks
                    }
                },
                .signed_number => |*y| {
                    if (y.push_bytes(x)) |xx| {
                        try callback(usrdata, Event { .signed_number = xx });
                    }
                },
            }
        },
        .TagClosed    => |x| {
            const id = Id.wrap(x.id);
            const typ = id.get_type();
            const ev = Event {
                .element_ends = ElementEnds {
                    .id = id,
                    .typ = typ,
                }
            };
            try callback(usrdata, ev);
        },
    }
}

fn fortest(q: void, e:Event)anyerror!void {_ = e;_=q;}

test "l2" {
    const e = Event { .number = 0 };
    _ = e;
    var p : Self = new();

    try p.push_bytes("", {}, fortest);
}
