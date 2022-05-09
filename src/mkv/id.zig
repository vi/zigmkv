/// Include database of all possible Matroska elements, not just ones that are used in this parser
const know_all_elements = true;

pub const Importance = enum {
    /// get_type should be optimized to handle those quickly
    hot,
    /// handled somehow by this library
    important,
    /// the rest of elements
    default,
};

pub const Type = enum(u4) {
    unknown,
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
    importance: Importance,
};



const database2 = @import("database.zig");

/// `database` is not expected to be included in compiled code unless explicitly references
/// Type of it is `[_]IdInfo`
///
/// There are also a lot of ID_SomeElementName constants typed `Id`.
usingnamespace database2;

/// Wrapper type for Matroska element ID.
pub const Id = struct {
    id : u32,

    const Self = @This();

    pub fn wrap(x:u32)Self {
        return Self { .id = x };
    }

    fn entry(self:Self)?IdInfo {
        @setEvalBranchQuota(2000);
        inline for (database2.database) |x| {
            if (x.importance == .hot) {
                if (self.id == x.id) return x;
            }
        }
        inline for (database2.database) |x| {
            if (x.importance == .important or (know_all_elements and x.importance != .hot) ) {
                if (self.id == x.id) return x;
            }
        }
        return null;
    }

    pub fn get_type(self:Self) Type {
        return if (@call(.{.modifier = .always_inline}, entry, .{self})) |x|x.typ else Type.unknown;
    }
    pub fn get_name(self:Self)?[]const u8 {
        return if (@call(.{.modifier = .always_inline}, entry, .{self})) |x|x.name else null;
    }

    pub fn eql(self:Self, other:Self)bool {
        return self.id == other.id;
    }
};

test "basic" {
    const expectEqual = @import("std").testing.expectEqual;
    expectEqual((?Type)(Type.master), Id.wrap(0x18538067).get_type());
    expectEqual((?[]const u8)("Segment"), Id.wrap(0x18538067).get_name());
    @import("std").debug.assert(Id.wrap(0x18538067).eql(database2.ID_Segment));
}


