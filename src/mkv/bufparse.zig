/// Maximum number of laced frames
const MAXLACE = 64;


const std = @import("std");
const mkv = @import("../mkv.zig");

pub const Flags = struct {
    keyframe: bool,
    invisible: bool,
    discardable: bool,
};

pub const Event = union(enum) {
    track_number: u64,
    /// Relative to recent `Timestamp` element content
    relative_timecode: i16,
    flags : Flags,
    frame_start,
    frame_chunk: []const u8,
    frame_end,
    buffer_end,
};

const LacingMode = enum {
    none,
    xiph,
    ebml,
    fixed,
};

const Lace = [MAXLACE]u32;

const StreamingFrames = struct {
    lace: Lace,
    current_frame: u8,
    position_inside_current_frame: u32,
};

const State = union(enum) {
    reading_track_number: mkv.vln.EbmlVlnReader,
    reading_timecode,
    reading_flags,
    reading_lacing,
    streaming_frames : StreamingFrames,
};

const Self = @This();

state: State,


pub fn new() Self {
    return Self {
        .state = State {
            .reading_track_number = mkv.vln.EbmlVlnReader.new(),
        },
    };
}

test "basic" {
    const q = Self.new();
    const e = Event { .track_number = 3 };
}
