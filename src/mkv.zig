/// Lowest-level EBML parser. Contains no ID database. 
/// Handler decides whether to interpret a thing as a master element
pub const L1Parser = @import("mkv/l1.zig");

/// Functions for working with EBML's VLN (Variable Length Numbers)
pub const vln = @import("mkv/vln.zig");
