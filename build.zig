const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const util_lib_mod = b.createModule(.{
        .root_source_file = b.path("src/ziputil.zig"),
        .target = target,
        .optimize = optimize,
    });

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe_mod.addImport("libziputil", util_lib_mod);

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "libziputil",
        .root_module = util_lib_mod,
    });

    // This declares intent for the executable to be installed into the
    // standard location when the user invokes the "install" step
    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .name = "ziputil",
        .root_module = exe_mod,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // Creates a step for running the executable with arguments
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const lib_unit_tests = b.addTest(.{
        .root_module = util_lib_mod,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    // Creates a step for unit testing.
    const exe_unit_tests = b.addTest(.{
        .root_module = exe_mod,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    // Creates a step for running unit tests
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}
