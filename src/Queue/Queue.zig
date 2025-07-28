const std = @import("std");
const List = @import("../DoubleLinkedList/DoubleLinkedList.zig");

pub fn FIFOQueue(comptime T: type) type {
    return struct {
        const L = List.makeDoublelyLinkedList(T);

        list: L = L{ .head = null },
    };
}
