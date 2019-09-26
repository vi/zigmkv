const std = @import("std");
const warn = std.debug.warn;

const mkv = struct {
    /// Lowest-level EBML parser. Contains no ID database. 
    /// Handler decides whether to interpret a thing as a master element
    pub const L1Parser = @import("mkv/l1.zig");
};

fn handler(q : void, ev: mkv.L1Parser.Event) anyerror!mkv.L1Parser.HandlerReply {
    switch(ev) {
        .TagOpened => warn("open\n"),
        .RawData => warn("data\n"),
        .TagClosed => warn("close\n"),
    }
    return mkv.L1Parser.HandlerReply.GiveRawData;
}

pub fn main() anyerror!void {
    var si = try std.io.getStdIn();

    var buf : [64]u8 = undefined;

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
