const std = @import("std");
const warn = std.debug.warn;

const mkv = @import("mkv.zig");

fn handler(indent : *usize, ev: mkv.L1Parser.Event) anyerror!void {
    var ugly_counter = indent.*; // Zig should have better syntax for repeating
    while(ugly_counter>0):(ugly_counter-=1) {
        warn("  ");
    }
    switch(ev) {
        .TagOpened    => |x| {
            warn("open 0x{x} size={}\n", x.id, x.size);
            x.write_true_here_if_master_element = switch (x.id) {
                0x1a45dfa3 => true,
                0x18538067 => true,
                0x114d9b74 => true,
                0x1549a966 => true,
                else => false,
            };
            indent.* += 1;
        },
        .RawDataChunk => |x| warn("data len={}\n", x.len),
        .TagClosed    => |x| {
            warn("close 0x{x}\n", x.id);
            indent.* -= 1;
        },
    }
}

pub fn main() anyerror!void {
    var si = try std.io.getStdIn();

    var buf : [256]u8 = undefined;

    var m = mkv.L1Parser.new();

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
