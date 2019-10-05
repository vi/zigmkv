const std = @import("std");
const mkv = @import("../mkv.zig");

const Id = mkv.id.Id;
const Type = mkv.id.Type;



pub const ElementBegins = struct {
    id: Id,
    typ: Type,
    size: ?u64,
    /// Allows quick-skipping unneeded elements. Contect will be delibered as binary chunks.
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
    float: f64,
    element_ends: ElementEnds,
};


const Self = @This();

pub fn new() Self {
    return Self {
        .l1 = mkv.L1Parser.new(),
    };
}

l1: mkv.L1Parser,

pub fn push_bytes(
                    self: *Self,
                    b: []const u8,
                    usrdata: var,
                    callback: fn(usrdata: @typeOf(usrdata), event: Event)anyerror!void,
                )anyerror!void {
    const H = L1Handler(@typeOf(usrdata));
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
                    usrdata: var,
                    callback: fn(usrdata: @typeOf(usrdata), event: Event)anyerror!void,
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
            if (typ == .master and !skip) {
                x.write_true_here_if_master_element = true;
            }
        },
        .RawDataChunk => |x| {
            const ev = Event {
                .binary_chunk = x,
            };
            try callback(usrdata, ev);
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

fn fortest(q: void, e:Event)anyerror!void {}

test "l2" {
    const e = Event { .number = 0 };
    var p : Self = new();

    try p.push_bytes("", {}, fortest);
}
