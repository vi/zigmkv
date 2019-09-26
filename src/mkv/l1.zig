buf: [8]u8,
level: u8, // number of actual bytes in `buf`

pub const TagOpenInfo = struct {
    id: u32,
    size: ?u64,
};
pub const TagCloseInfo = struct {
    id: u32,
    size: u64,
};

pub const Event = union(enum) {
    TagOpened: TagOpenInfo,
    RawData: []u8,
    TagClosed: TagCloseInfo,
};

pub const HandlerReply = enum {
    GiveRawData,
    GoDeeper,
};

const Self = @This();

pub fn new() Self {
    var p = Self { 
        .buf = [1]u8{0} ** 8,
        .level = 0,
    };
    return p;
}

pub fn push_bytes(
                    self: Self, 
                    b: []u8, 
                    usrdata: var,
                    callback: fn(usrdata: @typeOf(usrdata), event: Event)anyerror!HandlerReply,
                )anyerror!void {
    _ = try callback(usrdata, Event{.RawData=b});
}
