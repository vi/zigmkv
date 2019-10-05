const std = @import("std");
const warn = std.debug.warn;

const mkv = @import("mkv.zig");

fn handler(indent : *usize, ev: mkv.L2Parser.Event) anyerror!void {
    if (ev == .unknown_or_void_chunk) {
        return;
    }
    var ugly_counter = indent.*; // Zig should have better syntax for repeating
    while(ugly_counter>0):(ugly_counter-=1) {
        warn("  ");
    }
    switch(ev) {
        .element_begins => |x| {
            warn("open 0x{x} ({}) type={} size={}\n", x.id.id, x.id.get_name(), x.typ, x.size);
            indent.* += 1;
        },
        .number => |x|{
            warn("number {}\n", x);
        },
        .signed_number => |x|{
            warn("signed_number {}\n", x);
        },
        .binary_chunk => |x|{
            warn("binary chunk len={}\n", x.len);
        },
        .unknown_or_void_chunk => unreachable,
        .string_chunk => |x|{
            warn("string {}\n", x);
        },
        .utf8_chunk => |x|{
            warn("utf8 {}\n", x);
        },
        .float => |x| {
            warn("float {}\n", x);
        },
        .element_ends => |x| {
            warn("close 0x{x} ({}) type={}\n", x.id.id, x.id.get_name(), x.typ);
            indent.* -= 1;
        },
    }
}

pub fn main() anyerror!void {
    var si = try std.io.getStdIn();

    var buf : [256]u8 = undefined;

    var m = mkv.L2Parser.new();

    var indent : usize = 0;

    while(true) {
        var ret = si.read(buf[0..]) catch |e| {
            if (e == error.WouldBlock) {
                std.time.sleep(50*1000*1000);
                continue;
            }
            return e;
        };
        if (ret == 0) break;
        const b = buf[0..ret];
        try m.push_bytes(b, &indent, handler);
    }
    warn("OK\n");

}
