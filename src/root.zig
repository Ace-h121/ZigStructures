//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const LinkedList = @import("LinkedList/LinkedList.zig").makeLinkedList(u32);
const testing = std.testing;
