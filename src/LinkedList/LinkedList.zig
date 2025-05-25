const std = @import("std");
const expect = std.testing.expect;

pub fn makeLinkedList(comptime T: type) type {
    return struct {
        const Self = @This();

        pub const Node = struct {
            next: ?*Node = null,
            data: T,

            pub fn insertNode(headNode: *Node, newNode: *Node) void {
                newNode.next = headNode.next;
                headNode.next = newNode;
            }

            pub fn removeNext(node: *Node) ?*Node {
                const next_node = node.next orelse return null;
                node.next = next_node.next;
                return next_node;
            }

            pub fn findLast(node: *Node) *Node {
                var it = node;
                while (true) {
                    it = it.next orelse return it;
                }
            }
        };

        first: ?*Node = null,

        pub fn setHeadNode(list: *Self, headNode: *Node) void {
            list.first = headNode;
        }

        pub fn getFirstNode(list: *Self) ?*Node {
            return list.first;
        }

        pub fn prepend(list: *Self, headNode: *Node) void {
            headNode.next = list.first;
            list.first = headNode;
        }
    };
}

test "insertNode" {
    const L = makeLinkedList(u32);
    var list = L{};
    var headNode = L.Node{ .data = 1 };
    var newNode = L.Node{ .data = 2 };
    list.prepend(&headNode);
    headNode.insertNode(&newNode);
    try expect(list.getFirstNode().?.next == &newNode);
}

test "removeNode" {
    const L = makeLinkedList(u32);
    var list = L{};
    var headNode = L.Node{ .data = 1 };
    var newNode = L.Node{ .data = 2 };
    list.prepend(&headNode);
    headNode.insertNode(&newNode);
    try expect(list.getFirstNode().?.next == &newNode);
    const removedNode = headNode.removeNext();
    try expect(list.getFirstNode().? == &headNode);
    try expect(removedNode == &newNode);
}

test "lastNode" {
    const L = makeLinkedList(u32);
    var list = L{};
    var headNode = L.Node{ .data = 1 };
    var newNode = L.Node{ .data = 2 };
    list.prepend(&headNode);
    headNode.insertNode(&newNode);
    try expect(list.getFirstNode().?.next == &newNode);
    try expect(headNode.findLast() == &newNode);
}
