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
    typ: Type,
    name: []const u8,
    /// Required for obtaining content from files, disregarding metadata, seeking, etc.
    important: bool,
};



const database2 = @import("database.zig");

/// Is not expected to be included in compiled code unless explicitly references
pub const database = database2.database;

/// Wrapper type for Matroska element ID.
pub const Id = struct {
    id : u32,

    const Self = @This();

    fn wrap(x:u32)Self {
        return Self { .id = x };
    }
    fn get_type(self:Self)?Type {
        @setEvalBranchQuota(2000);
        inline for (database) |x| {
            if (x.important) {
                if (self.id == x.id) return x.typ;
            }
        }
        inline for (database) |x| {
            if (!x.important) {
                if (self.id == x.id) return x.typ;
            }
        }
        return null;
    }
    fn get_name(self:Self)?[]const u8 {
        inline for (database) |x| {
            if (self.id == x.id) return x.name;
        }
        return null;
    }
};

test "basic" {
    const expectEqual = @import("std").testing.expectEqual;
    expectEqual((?Type)(Type.master), Id.wrap(0x18538067).get_type());
    expectEqual((?[]const u8)("Segment"), Id.wrap(0x18538067).get_name());
}


