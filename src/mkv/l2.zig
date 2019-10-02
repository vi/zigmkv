pub const Type = enum {
    master,
    uinteger,
    string,
    binary,
    utf8,
    float,
    date,
    integer,
};


pub const IdInfo = struct {
    id: u32,
    type: Type,
    name: []const u8,
};

const database2 = @import("database.zig");
pub const database = database2.database;

test "basic" {
    const d = database;
}


