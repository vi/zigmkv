/// Mid-level Matroska parser. Returns event stream for tag opening, closure and interpreted data.
/// Does not bother with extracting frames from SimpleBlocks.
pub const L2Parser = @import("mkv/l2.zig");


/// Wrapper for Matroska element ID. Allows getting type and name from ID.
/// Contains Matroska EBML elements database inside.
pub const id = @import("mkv/id.zig");

/// Lowest-level EBML parser. Contains no ID database. 
/// Handler decides whether to interpret a thing as a master element
pub const L1Parser = @import("mkv/l1.zig");

/// Functions for working with EBML's VLN (Variable Length Numbers)
pub const vln = @import("mkv/vln.zig");


