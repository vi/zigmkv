const std = @import("std");
const warn = std.debug.warn;

var pool : [4096]u8 = undefined;

pub fn main() anyerror!void {
    var alloc = std.heap.FixedBufferAllocator.init(&pool);
    const argv = try std.process.argsAlloc(&alloc.allocator);
    defer std.process.argsFree(&alloc.allocator, argv);
    
    if (argv.len<2) {
        warn("Usage: zigmkv {{help|<subtool_name>}} ...\n");
        std.process.exit(1);
    }

    if (std.mem.eql(u8, argv[1], "help")) {
        warn("Tools:\n");
        warn("  zigmkv l2dump\n");
        warn("Use --help option after tool name for further help.\n");
    }
    else if (std.mem.eql(u8, argv[1], "l2dump")) {
        try @import("tool_l2dump.zig").tool(argv[2..]);
    } else {
        warn("Unknown tool name `{}`\n", argv[1]);
        std.process.exit(1);
    }
}
