//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const LinkedList = @import("LinkedList/LinkedList.zig").makeLinkedList(u32);
const Tree = @import("Tree/Tree.zig").makeTree(u32);
const expect = std.testing.expect;

test "System Check" {
    var allocator = std.heap.page_allocator;

    var memory = try allocator.create(LinkedList);
    const headNode = try allocator.create(LinkedList.Node);
    const newNode = try LinkedList.makeNode(5, allocator);
    newNode.* = LinkedList.Node{ .data = 2 };
    memory.prepend(headNode);
    memory.prepend(newNode);
    try expect(memory.getFirstNode().? == newNode);
    allocator.destroy(memory);

    var tree = try allocator.create(Tree);
    const parentNode = tree.makeTreeNode(1);
    parentNode.*.left = tree.makeTreeNode(2);
    try expect(parentNode.*.left.?.data == 2);
    allocator.destroy(tree);
}
