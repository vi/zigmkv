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


test "l2" {
    const e = Event { .number = 0 };
}
