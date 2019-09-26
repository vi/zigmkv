const std = @import("std");
const warn = std.debug.warn;


const mkv = struct {

    const TagOpenInfo = struct {
        id: u32,
        size: ?u64,
    };
    const TagCloseInfo = struct {
        id: u32,
        size: u64,
    };

    const L1Event = union(enum) {
        TagOpened: TagOpenInfo,
        RawData: []u8,
        TagClosed: TagCloseInfo,
    };

    const L1HandlerReply = enum {
        GiveRawData,
        GoDeeper,
    };

    pub const L1Parser = struct {
        buf: [8]u8,
        level: u8, // number of actual bytes in `buf`

        pub fn new() L1Parser {
            var p = L1Parser { 
                .buf = [1]u8{0} ** 8,
                .level = 0,
            };
            return p;
        }

        pub fn push_bytes(
                            self: L1Parser, 
                            b: []u8, 
                            usrdata: var,
                            cb: fn(usrdata: @typeOf(usrdata), event: L1Event)anyerror!L1HandlerReply,
                        )anyerror!void {
            _ = try cb(usrdata, L1Event{.RawData=b});
        }
    };
    
};

fn handler(q : void, ev: mkv.L1Event) anyerror!mkv.L1HandlerReply {
    switch(ev) {
        .TagOpened => warn("open\n"),
        .RawData => warn("data\n"),
        .TagClosed => warn("close\n"),
    }
    return mkv.L1HandlerReply.GiveRawData;
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
