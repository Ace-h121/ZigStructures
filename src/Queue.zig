const std = @import("std");
const DoublyLinkedList = @import("DoubleLinkedList.zig");

pub fn FIFOQueue(comptime T: type) type {
    return struct {
        list: *DoublyLinkedList.makeDoublelyLinkedList(T),
        allocator: std.mem.Allocator,
        const Self = @This();

        pub fn init(allocator: std.mem.Allocator) !*Self {
            const queue = try allocator.create(Self);
            const D = DoublyLinkedList.makeDoublelyLinkedList(u32);

            const list = try allocator.create(D);
            list.* = D{};

            queue.* = Self{ .allocator = allocator, .list = list };
            return queue;
        }
    };
}

test "FIFOQueue" {
    const fifoQueue = FIFOQueue(u32);

    const allocator = std.heap.page_allocator;

    const queue = try fifoQueue.init(allocator);
    _ = queue;
}
