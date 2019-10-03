const std = @import("std");
const mkv = @import("../mkv.zig");

const Id = mkv.id.Id;



pub const ElementBegins = struct {
    id: Id,
    size: ?u32,
    write_true_to_skip_it: *bool,
};

pub const ElementEnds = struct {
    id: Id,
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
    
}

fn fortest(q: void, e:Event)anyerror!void {}

test "l2" {
    const e = Event { .number = 0 };
    var p : Self = new();

    try p.push_bytes("", {}, fortest);
}
