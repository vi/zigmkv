const std = @import("std");
const warn = std.debug.print;

var pool : [4096]u8 = undefined;

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    const argv = try std.process.argsAlloc(alloc);
    defer std.process.argsFree(alloc, argv);
    
    if (argv.len<2) {
        warn("Usage: zigmkv {{help|<subtool_name>}} ...\n", .{});
        std.process.exit(1);
    }

    if (std.mem.eql(u8, argv[1], "help")) {
        warn("Tools:\n", .{});
        warn("  zigmkv l2dump\n" , .{});
        warn("Use --help option after tool name for further help.\n", .{});
    }
    else if (std.mem.eql(u8, argv[1], "l2dump")) {
        try @import("tool_l2dump.zig").tool(argv[2..]);
    } else {
        warn("Unknown tool name `{s}`\n", .{argv[1]});
        std.process.exit(1);
    }
}
