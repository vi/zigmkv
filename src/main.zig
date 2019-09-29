const std = @import("std");
const warn = std.debug.warn;

const mkv = @import("mkv.zig");

fn handler(q : void, ev: mkv.L1Parser.Event) anyerror!void {
    switch(ev) {
        .TagOpened    => |x| warn("open 0x{x} size={}\n", x.id, x.size),
        .RawDataChunk => |x| warn("data len={}\n", x.len),
        .TagClosed    => |x| warn("close 0x{x}\n", x.id),
    }
}

pub fn main() anyerror!void {
    var si = try std.io.getStdIn();

    var buf : [256]u8 = undefined;

    var m = mkv.L1Parser.new();

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
        try m.push_bytes(b, {}, handler);
    }

}
