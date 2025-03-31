const std = @import("std");
const allocator = std.heap.page_allocator;

fn usage(program_name: []const u8) u8 {
    std.debug.print("Usage:{s} <zip_file_path>\n", .{program_name});
    return 1;
}

pub fn main() !u8 {
    var args = std.process.args();
    const program_name = args.next() orelse {
        unreachable;
    }; // program name should always be present in args

    const file_path = args.next() orelse {
        // prompt with usage and exit
        return usage(program_name);
    };

    std.fs.accessAbsolute(file_path, .{ .mode = .read_only }) catch |err| {
        std.log.err("Error encountered when testing access for file {s}.\nError: {any}.", .{ file_path, err });
        return 1;
    };

    const file = try std.fs.openFileAbsolute(file_path, .{ .mode = .read_only });
    defer file.close();

    return 0;
}
