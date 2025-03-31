const std = @import("std");
const File = std.fs.File;
const headers = @import("headers");

pub const Zipfile = struct {
    input_file: File,
    file_size: u64,

    pub fn init(
        self: *Zipfile,
        input_file: File,
    ) !void {
        self.input_file = input_file;
        self.file_size = try self.input_file.getEndPos();

        if (self.file_size > 0x7fffffffffffffff) return error.FileToBig;
    }
};

test {
    _ = @import("headers/header.zig"); // indicates that tests from headers/headers.zig should be run
}
