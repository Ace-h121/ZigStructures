const std = @import("std");

const expect = std.testing.expect;

pub fn makeDoublelyLinkedList(comptime T: type) type {
    return struct {
        const Self = @This();

        const Node = struct {
            next: ?*Node = null,
            prev: ?*Node = null,
            data: T,

            pub fn insertAhead(head: *Node, newNode: *Node) void {
                newNode.next = head.next;
                head.next = newNode;
                newNode.prev = head;
            }

            pub fn insertBehind(head: *Node, newNode: *Node) void {
                newNode.prev = head.prev;
                head.prev = newNode;
                newNode.next = head;
            }

            pub fn removeNext(head: *Node) ?*Node {
                const nextNode = head.next orelse return null;
                head.next = nextNode.next;
                if (nextNode.next != null) {
                    nextNode.next.?.prev = head;
                }
                nextNode.prev = null;
                nextNode.next = null;
                return nextNode;
            }

            pub fn removePrev(head: *Node) ?*Node {
                const prevNode = head.prev orelse return null;
                head.prev = prevNode.prev;
                if (prevNode.prev != null) {
                    prevNode.prev.?.next = head;
                }
                prevNode.prev = null;
                prevNode.next = null;
                return prevNode;
            }

            pub fn findLast(head: *Node) *Node {
                var it = head;
                while (true) {
                    it = it.next orelse return it;
                }
            }

            pub fn findFirst(head: *Node) *Node {
                var it = head;
                while (true) {
                    it = it.prev orelse return it;
                }
            }

            pub fn findChildren(head: *Node) usize {
                var it = head;
                var i: usize = 0;
                while (it.next != null) {
                    it = it.next.?;
                    i = i + 1;
                }
                return i;
            }
        };

        head: ?*Node = null,

        pub fn getHeadNode(list: *Self) ?*Node {
            return list.head;
        }

        pub fn prepend(list: *Self, head: *Node) void {
            if (list.head != null) {
                list.head.?.prev = head;
            }
            head.next = list.head;
            list.head = head;
        }

        pub fn append(list: *Self, node: *Node) void {
            if (list.head == null) {
                list.head = node;
            }
            var tempNode = list.head.?;
            while (tempNode.next != null) {
                tempNode = tempNode.next.?;
            }
            tempNode.insertAhead(node);
        }

        pub fn len(list: *Self) usize {
            if (list.head) |n| {
                return 1 + n.findChildren();
            } else {
                return 0;
            }
        }

        pub fn removeNode(list: *Self, node: *Node) ?*Node {
            if (list.head == null) {
                return null;
            }

            if (list.head == node) {
                const tempNode = list.head;
                list.head = list.head.?.next;
                if (list.head) |n| {
                    n.prev = null;
                }
                return tempNode;
            }

            var tempNode = list.head.?;
            while (tempNode.next != node and tempNode.next != null) {
                tempNode = tempNode.next.?;
            }

            if (tempNode.next == null) {
                return null;
            }
            return tempNode.removeNext();
        }
    };
}

test "insert Ahead" {
    const L = makeDoublelyLinkedList(u32);
    var headNode = L.Node{ .data = 1 };
    var newNode = L.Node{ .data = 2 };
    headNode.insertAhead(&newNode);
    try expect(headNode.next == &newNode);
    try expect(newNode.prev == &headNode);
    try expect(headNode.prev == null);
    try expect(newNode.next == null);
}

test "insert Behind" {
    const L = makeDoublelyLinkedList(u32);
    var headNode = L.Node{ .data = 1 };
    var newNode = L.Node{ .data = 2 };
    headNode.insertBehind(&newNode);
    try expect(headNode.prev == &newNode);
    try expect(newNode.next == &headNode);
    try expect(headNode.next == null);
    try expect(newNode.prev == null);
}

test "Remove Next" {
    const L = makeDoublelyLinkedList(u32);
    var headNode = L.Node{ .data = 1 };
    var newNode = L.Node{ .data = 2 };
    var newestNode = L.Node{ .data = 3 };
    headNode.insertAhead(&newNode);
    newNode.insertAhead(&newestNode);
    try expect(headNode.removeNext().? == &newNode);
    try expect(headNode.next == &newestNode);
    try expect(newestNode.prev == &headNode);
    try expect(newNode.next == null);
    try expect(newNode.prev == null);
}

test "Remove Prev" {
    const L = makeDoublelyLinkedList(u32);
    var headNode = L.Node{ .data = 1 };
    var newNode = L.Node{ .data = 2 };
    var newestNode = L.Node{ .data = 3 };
    headNode.insertAhead(&newNode);
    newNode.insertAhead(&newestNode);
    try expect(newestNode.removePrev().? == &newNode);
    try expect(headNode.next == &newestNode);
    try expect(newestNode.prev == &headNode);
    try expect(newNode.next == null);
    try expect(newNode.prev == null);
}

test "Head and Tail" {
    const L = makeDoublelyLinkedList(u32);
    var headNode = L.Node{ .data = 1 };
    var newNode = L.Node{ .data = 2 };
    var newestNode = L.Node{ .data = 3 };
    headNode.insertAhead(&newNode);
    newNode.insertAhead(&newestNode);
    try expect(headNode.findFirst() == &headNode);
    try expect(headNode.findLast() == &newestNode);
}

test "Prepend" {
    const L = makeDoublelyLinkedList(u32);
    var headNode = L.Node{ .data = 1 };
    var newNode = L.Node{ .data = 2 };
    var list = L{ .head = &headNode };
    list.prepend(&newNode);
    try expect(list.head.? == &newNode);
    try expect(list.head.?.next == &headNode);
}

test "RemoveNode" {
    const L = makeDoublelyLinkedList(u32);
    var headNode = L.Node{ .data = 1 };
    var newNode = L.Node{ .data = 2 };
    var newestNode = L.Node{ .data = 3 };
    headNode.insertAhead(&newNode);
    newNode.insertAhead(&newestNode);
    var list = L{ .head = &headNode };

    try expect(list.removeNode(&newNode) == &newNode);
    try expect(headNode.next.? == &newestNode);
    try expect(newestNode.prev.? == &headNode);
}

test "Append" {
    const L = makeDoublelyLinkedList(u32);
    var headNode = L.Node{ .data = 1 };
    var newNode = L.Node{ .data = 2 };
    var newestNode = L.Node{ .data = 3 };
    headNode.insertAhead(&newNode);
    var list = L{ .head = &headNode };

    list.append(&newestNode);
    try expect(newNode.next.? == &newestNode);
}
