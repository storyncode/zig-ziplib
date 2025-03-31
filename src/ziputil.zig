const std = @import("std");
const File = std.fs.File;

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
    std.testing.refAllDecls(@This());
}
