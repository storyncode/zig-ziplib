const std = @import("std");
const testing = std.testing;
const assert = std.debug.assert;

pub const HeaderError = error{
    InvalidSystemNameReference,
};

pub const Signature = u32;
pub const SystemName = enum(u8) {
    MSDOS = 0,
    Amiga = 1,
    OpenVMS = 2,
    Unix = 3,
    VMCMS = 4,
    AtariST = 5,
    OS2 = 6,
    Macintosh = 7,
    Z_System = 8,
    CPM = 9,
    NTFS = 10,
    MVS = 11,
    VSE = 12,
    AcornRisc = 13,
    VFAT = 14,
    AlternateMVS = 15,
    BeOS = 16,
    Tandem = 17,
    OS400 = 18,
    OSX = 19,

    pub fn fromByte(value: u8) HeaderError!SystemName {
        return switch (value) {
            0 => SystemName.MSDOS,
            1 => SystemName.Amiga,
            2 => SystemName.OpenVMS,
            3 => SystemName.Unix,
            4 => SystemName.VMCMS,
            5 => SystemName.AtariST,
            6 => SystemName.OS2,
            7 => SystemName.Macintosh,
            8 => SystemName.Z_System,
            9 => SystemName.CPM,
            10 => SystemName.NTFS,
            11 => SystemName.MVS,
            12 => SystemName.VSE,
            13 => SystemName.AcornRisc,
            14 => SystemName.VFAT,
            15 => SystemName.AlternateMVS,
            16 => SystemName.BeOS,
            17 => SystemName.Tandem,
            18 => SystemName.OS400,
            19 => SystemName.OSX,
            else => HeaderError.InvalidSystemNameReference,
        };
    }
};

test "SystemName parses as expected" {
    var systemName: SystemName = undefined;

    for (0..20) |value| {
        const u8Value: u8 = @intCast(value);
        systemName = try SystemName.fromByte(u8Value);

        try testing.expect(@intFromEnum(systemName) == value);
    }
}

test "SystemName returns error union if invalid value passed" {
    try testing.expectError(HeaderError.InvalidSystemNameReference, SystemName.fromByte(20));
}

pub const LocalFileHeader = struct {
    signature: Signature,
    system: SystemName,
    version: u8,
};

pub const CentralDirectoryFileHeader = struct {
    signature: Signature,
    version: SystemName,
};
