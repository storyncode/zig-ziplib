const std = @import("std");

pub fn main() u8 {
    return 0;
}

test {
    std.testing.refAllDecls(@This());
}
