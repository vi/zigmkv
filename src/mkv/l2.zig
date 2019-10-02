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
    /// Required for obtaining content from files, disregarding metadata, seeking, etc.
    important: bool,
};

const database2 = @import("database.zig");
pub const database = database2.database;

test "basic" {
    const d = database;
}


