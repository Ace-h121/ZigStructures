const std = @import("std");
const expect = std.testing.expect;
const DoublyLinkedList = @import("DoubleLinkedList.zig");

pub fn FIFOQueue(comptime T: type) type {
    return struct {
        list: *DoublyLinkedList.makeDoublelyLinkedList(T),
        allocator: std.mem.Allocator,
        length: usize = 0,
        const Self = @This();
        const D = DoublyLinkedList.makeDoublelyLinkedList(u32);

        pub fn init(allocator: std.mem.Allocator) !*Self {
            const queue = try allocator.create(Self);

            const list = try allocator.create(D);
            list.* = D{};

            queue.* = Self{ .allocator = allocator, .list = list };
            return queue;
        }

        pub fn enqueue(self: *Self, data: T) !void {
            self.length = self.length + 1;
            const node = try D.makeNode(data, self.allocator);
            return self.list.prepend(node);
        }

        pub fn dequeue(self: *Self) !?*D.Node {
            if (self.length != 0) {
                self.length = self.length - 1;
            }
            return self.list.removeLast();
        }

        //0(1) as the queue keeps track of all items added and subtracted;
        pub fn len(self: *Self) usize {
            return self.list.len();
        }
    };
}

pub fn FILOQueue(comptime T: type) type {
    return struct {
        list: *DoublyLinkedList.makeDoublelyLinkedList(T),
        allocator: std.mem.Allocator,
        length: usize = 0,
        const Self = @This();
        const D = DoublyLinkedList.makeDoublelyLinkedList(u32);

        pub fn init(allocator: std.mem.Allocator) !*Self {
            const queue = try allocator.create(Self);

            const list = try allocator.create(D);
            list.* = D{};

            queue.* = Self{ .allocator = allocator, .list = list };
            return queue;
        }

        pub fn enqueue(self: *Self, data: T) !void {
            self.length = self.length + 1;
            const node = try D.makeNode(data, self.allocator);
            return self.list.append(node);
        }

        pub fn dequeue(self: *Self) !?*D.Node {
            if (self.length != 0) {
                self.length = self.length - 1;
            }
            return self.list.removeLast();
        }

        //0(1) as the queue keeps track of all items added and subtracted;
        pub fn len(self: *Self) usize {
            return self.list.len();
        }
    };
}

test "FIFOQueue" {
    const fifoQueue = FIFOQueue(u32);

    const allocator = std.heap.page_allocator;
    const queue = try fifoQueue.init(allocator);
    defer allocator.destroy(queue);
    try queue.enqueue(5);
    try queue.enqueue(2);
    try expect(queue.len() == 2);
    const removedNode = try queue.dequeue();
    try expect(removedNode.?.data == 5);
    queue.allocator.destroy(removedNode.?);
    try expect(queue.len() == 1);
}

test "FILOQueue" {
    const filoQueue = FILOQueue(u32);

    const allocator = std.heap.page_allocator;
    const queue = try filoQueue.init(allocator);
    defer allocator.destroy(queue);
    try queue.enqueue(5);
    try queue.enqueue(2);
    try expect(queue.len() == 2);
    const removedNode = try queue.dequeue();
    try expect(removedNode.?.data == 2);
    queue.allocator.destroy(removedNode.?);
    try expect(queue.len() == 1);
}
