const std = @import("std");
const expect = std.testing.expect;
pub fn makeTree(comptime T: type) type {
    return struct {
        const Self = @This();
        pub const Node = struct {
            left: ?*Node = null,
            right: ?*Node = null,
            data: T = undefined,
        };

        pub fn makeTreeNode(list: *Self, value: T) *Node {
            _ = list;
            var newNode = Node{ .data = value };
            return &newNode;
        }
    };
}

test "basicTree" {
    const treeStruct = makeTree(u8);
    var tree = treeStruct{};
    var parentNode = tree.makeTreeNode(1);
    parentNode.left = tree.makeTreeNode(2);
    try expect(parentNode.left.?.data == 2);
}
