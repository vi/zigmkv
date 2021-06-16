const std = @import("std");
const warn = std.debug.warn;

const mkv = @import("mkv.zig");

const L2Dump = struct {
    indent: usize,
    f: std.fs.File,

    const Self = @This();

    fn print(self: *Self, comptime format: []const u8, args: anytype) anyerror!void {
        try self.f.writer().print(format, args);
    }

    fn handler(self : *Self, ev: mkv.L2Parser.Event) anyerror!void {
        if (ev == .unknown_or_void_chunk) {
            return;
        }
        var ugly_counter = self.indent; // Zig should have better syntax for repeating
        while(ugly_counter>0):(ugly_counter-=1) {
            try self.print("  ", .{});
        }
        switch(ev) {
            .element_begins => |x| {
                try self.print("open 0x{x} ({s}) type={} size={}\n", .{x.id.id, x.id.get_name(), x.typ, x.size});
                self.indent += 1;
            },
            .number => |x|{
                try self.print("number {}\n", .{x});
            },
            .signed_number => |x|{
                try self.print("signed_number {}\n", .{x});
            },
            .binary_chunk => |x|{
                try self.print("binary chunk len={}\n", .{x.len});
            },
            .unknown_or_void_chunk => unreachable,
            .string_chunk => |x|{
                try self.print("string {s}\n", .{x});
            },
            .utf8_chunk => |x|{
                try self.print("utf8 {s}\n", .{x});
            },
            .float => |x| {
                try self.print("float {}\n", .{x});
            },
            .element_ends => |x| {
                try self.print("close 0x{x} ({s}) type={}\n", .{x.id.id, x.id.get_name(), x.typ});
                self.indent -= 1;
            },
        }
    }
};



var pool : [4096]u8 = undefined;

pub fn tool(argv:[][]const u8) anyerror!void {

    if (argv.len > 0) {
        warn("Usage: zigmkv l2dump < input_file.mkv\n", .{});
        std.process.exit(1);
    }

    var si = std.io.getStdIn();

    var buf : [256]u8 = undefined;

    var m = mkv.L2Parser.new();


    var l2dump = L2Dump {
        .indent = 0,
        .f = std.io.getStdOut(),
    };

    while(true) {
        var ret = si.read(buf[0..]) catch |e| {
            if (e == error.WouldBlock) {
                //std.time.sleep(50*1000*1000); // fails on WASI
                continue;
            }
            return e;
        };
        if (ret == 0) break;
        const b = buf[0..ret];
        try m.push_bytes(b, &l2dump, L2Dump.handler);
    }
    try l2dump.print("OK\n", .{});
}
