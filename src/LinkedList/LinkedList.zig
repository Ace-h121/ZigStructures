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

            pub fn findChildren(node: *Node) usize {
                var it = node;
                var i: usize = 0;
                while (it.next != null) {
                    it = it.next.?;
                    i = i + 1;
                }
                return i;
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

        pub fn pop(list: *Self) ?*Node {
            var poppedNode: ?*Node = null;
            if (list.first == null) {
                return null;
            }

            if (list.first.?.next == null) {
                poppedNode = list.first;
                list.first = null;
                return poppedNode;
            }

            var prevNode: *Node = undefined;
            poppedNode = list.first;
            while (poppedNode.?.next != null) {
                prevNode = poppedNode.?;
                poppedNode = poppedNode.?.next;
            }
            prevNode.next = null;
            list.first = prevNode;
            return poppedNode;
        }

        pub fn len(list: *Self) usize {
            if (list.first) |n| {
                return 1 + n.findChildren();
            } else {
                return 0;
            }
        }

        pub fn removeNode(list: *Self, node: *Node) *Node {
            if (list.first == node) {
                const tempNode = list.first.?;
                list.first = node.next;
                return tempNode;
            } else {
                var currentNode = list.first.?;
                while (currentNode.next != node) {
                    currentNode = currentNode.next.?;
                }
                currentNode.next = node.next;
                return node;
            }
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

test "removeNext" {
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

test "countNode" {
    const L = makeLinkedList(u32);
    var list = L{};
    var headNode = L.Node{ .data = 1 };
    var newNode = L.Node{ .data = 2 };
    var newestNode = L.Node{ .data = 3 };
    list.prepend(&headNode);
    headNode.insertNode(&newNode);
    try expect(list.getFirstNode().?.next == &newNode);
    try expect(headNode.findChildren() == 1);
    newNode.insertNode(&newestNode);
    try expect(headNode.findChildren() == 2);
}

test "popNode" {
    const L = makeLinkedList(u32);
    var list = L{};
    var headNode = L.Node{ .data = 1 };
    var newNode = L.Node{ .data = 2 };
    var newestNode = L.Node{ .data = 3 };
    list.prepend(&headNode);
    headNode.insertNode(&newNode);
    try expect(list.getFirstNode().?.next == &newNode);
    try expect(headNode.findChildren() == 1);
    newNode.insertNode(&newestNode);
    try expect(headNode.findChildren() == 2);
    const poppedNode = list.pop();
    try expect(poppedNode.? == &newestNode);
    try expect(headNode.findChildren() == 1);
}

test "LenList" {
    const L = makeLinkedList(u32);
    var list = L{};
    var headNode = L.Node{ .data = 1 };
    var newNode = L.Node{ .data = 2 };
    list.prepend(&headNode);
    headNode.insertNode(&newNode);
    try expect(list.getFirstNode().?.next == &newNode);
    try expect(list.len() == 2);
}

test "removeNode" {
    const L = makeLinkedList(u32);
    var list = L{};
    var headNode = L.Node{ .data = 1 };
    var newNode = L.Node{ .data = 2 };
    var newestNode = L.Node{ .data = 3 };
    list.prepend(&headNode);
    headNode.insertNode(&newNode);
    try expect(list.getFirstNode().?.next == &newNode);
    try expect(headNode.findChildren() == 1);
    newNode.insertNode(&newestNode);
    const removedNode = list.removeNode(&newestNode);
    try expect(removedNode == &newestNode);
    try expect(list.len() == 2);
}
