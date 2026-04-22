class ZigAT015 < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.15.2/zig-0.15.2.tar.xz"
  sha256 "d9b30c7aa983fcff5eed2084d54ae83eaafe7ff3a84d8fb754d854165a6e521c"
  license "MIT"

  livecheck do
    url "https://ziglang.org/download/"
    regex(/href=.*?zig[._-]v?(0\.15(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3376720c6c088ddce7219a4dca4f50d790bcc97087c9a44f66a427d6a6718515"
    sha256 cellar: :any,                 arm64_sequoia: "6984547a314038f1c7123bb3be4a127e82dd0200c12101e7f388adb8ebad03ed"
    sha256 cellar: :any,                 arm64_sonoma:  "50e79a382a4310c562a5afbdc15435018a5e4d9ff9149729261670e6eaced4b6"
    sha256 cellar: :any,                 sonoma:        "fbf88162ef3557bbf834f9d2ca329e12ca3d0d383f52e073f48a61a63b650961"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df1dbd800df23e6abbe082fb4dd6ab3decb6a428c7b8919f25f815ff204fa2bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a63a3ccb03202319d56571238da8f5bb23dbbd2446217c3724b8b934c24e832"
  end

  keg_only :versioned_formula

  # Unsupported since Zig 0.16 was released on 2026-04-13, but we are
  # giving an extra 1 year for dependents to migrate to newer Zig
  deprecate! date: "2027-04-15", because: :unsupported
  disable! date: "2028-04-15", because: :unsupported

  depends_on "cmake" => :build
  depends_on "lld@20"
  depends_on "llvm@20"
  depends_on macos: :big_sur # https://github.com/ziglang/zig/issues/13313

  on_macos do
    depends_on "zstd"
  end

  # https://github.com/Homebrew/homebrew-core/issues/209483
  skip_clean "lib/zig/libc/darwin/libSystem.tbd"

  # Fix linkage with libc++.
  #   https://github.com/ziglang/zig/pull/23264
  # Fix max_rss
  #   https://github.com/Homebrew/homebrew-core/issues/252365
  patch :DATA

  def install
    # Workaround for https://github.com/Homebrew/homebrew-core/pull/141453#discussion_r1320821081.
    # This will likely be fixed upstream by https://github.com/ziglang/zig/pull/16062.
    if OS.linux?
      ENV["NIX_LDFLAGS"] = ENV["HOMEBREW_RPATH_PATHS"].split(":")
                                                      .map { |p| "-rpath #{p}" }
                                                      .join(" ")
    end

    cpu = case ENV.effective_arch # See `zig targets`.
    when :arm_vortex_tempest then "apple_m1"
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = ["-DZIG_SHARED_LLVM=ON"]
    args << "-DZIG_TARGET_MCPU=#{cpu}" if build.bottle?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.zig").write <<~ZIG
      const std = @import("std");
      pub fn main() !void {
          try std.fs.File.stdout().writeAll("Hello, world!");
      }
    ZIG
    system bin/"zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output("./hello")

    arches = ["aarch64", "x86_64"]
    systems = ["macos", "linux"]
    arches.each do |arch|
      systems.each do |os|
        system bin/"zig", "build-exe", "hello.zig", "-target", "#{arch}-#{os}", "--name", "hello-#{arch}-#{os}"
        assert_path_exists testpath/"hello-#{arch}-#{os}"
        file_output = shell_output("file --brief hello-#{arch}-#{os}").strip
        if os == "linux"
          assert_match(/\bELF\b/, file_output)
          assert_match(/\b#{arch.tr("_", "-")}\b/, file_output)
        else
          assert_match(/\bMach-O\b/, file_output)
          expected_arch = (arch == "aarch64") ? "arm64" : arch
          assert_match(/\b#{expected_arch}\b/, file_output)
        end
      end
    end

    native_os = OS.mac? ? "macos" : OS.kernel_name.downcase
    native_arch = Hardware::CPU.arm? ? "aarch64" : Hardware::CPU.arch
    assert_equal "Hello, world!", shell_output("./hello-#{native_arch}-#{native_os}")

    # error: 'TARGET_OS_IPHONE' is not defined, evaluates to 0
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main() {
        fprintf(stdout, "Hello, world!");
        return 0;
      }
    C
    system bin/"zig", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c")

    return unless OS.mac?

    # See https://github.com/Homebrew/homebrew-core/pull/211129
    require "utils/linkage"
    library = "/usr/lib/libc++.1.dylib"
    assert Utils.binary_linked_to_library?(bin/"zig", library), "No linkage with #{library}!"
  end
end

__END__
From 8f9216e7d10970c21fcda9e8fe6af91a7e0f7db9 Mon Sep 17 00:00:00 2001
From: Michael Dusan <michael.dusan@gmail.com>
Date: Mon, 10 Mar 2025 17:32:00 -0400
Subject: [PATCH] macos stage3: add link support for system libc++

- activates when -DZIG_SHARED_LLVM=ON
- activates when llvm_config is used and --shared-mode is shared
- otherwise vendored libc++ is used

closes #23189
---
 build.zig | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/build.zig b/build.zig
index 15762f0ae881..ea729f408f74 100644
--- a/build.zig
+++ b/build.zig
@@ -782,7 +782,13 @@ fn addCmakeCfgOptionsToExe(
                 mod.linkSystemLibrary("unwind", .{});
             },
             .ios, .macos, .watchos, .tvos, .visionos => {
-                mod.link_libcpp = true;
+                if (static or !std.zig.system.darwin.isSdkInstalled(b.allocator)) {
+                    mod.link_libcpp = true;
+                } else {
+                    const sdk = std.zig.system.darwin.getSdk(b.allocator, &b.graph.host.result) orelse return error.SdkDetectFailed;
+                    const @"libc++" = b.pathJoin(&.{ sdk, "usr/lib/libc++.tbd" });
+                    exe.root_module.addObjectFile(.{ .cwd_relative = @"libc++" });
+                }
             },
             .windows => {
                 if (target.abi != .msvc) mod.link_libcpp = true;

--------------------------------------------------------------------------------
diff --git a/build.zig b/build.zig
index 9e672a4ca7..77959757f7 100644
--- a/build.zig
+++ b/build.zig
@@ -738,7 +738,7 @@ fn addCompilerMod(b: *std.Build, options: AddCompilerModOptions) *std.Build.Modu
 fn addCompilerStep(b: *std.Build, options: AddCompilerModOptions) *std.Build.Step.Compile {
     const exe = b.addExecutable(.{
         .name = "zig",
-        .max_rss = 7_800_000_000,
+        .max_rss = 6_900_000_000,
         .root_module = addCompilerMod(b, options),
     });
     exe.stack_size = stack_size;

--------------------------------------------------------------------------------
--- a/src/link/MachO/Dylib.zig	2025-10-10 20:53:18
+++ b/src/link/MachO/Dylib.zig	2026-03-25 21:28:19
@@ -730,29 +730,35 @@ pub const TargetMatcher = struct {
             .cpu_arch = cpu_arch,
             .platform = platform,
         };
-        const apple_string = try targetToAppleString(allocator, cpu_arch, platform);
-        try self.target_strings.append(allocator, apple_string);
+        try self.addTargetStrings(cpuArchToAppleString(cpu_arch));
+        // In Xcode 26.4, Apple unified their TBD files from having separate `arm64-macos` and `arm64e-macos`
+        // entries to having just the latter, presumably because the symbol lists are identical anyway. It
+        // sure would have been nice if they settled on the former as the unified name so as not to break the
+        // world, but evidently we can't have nice things.
+        if (cpu_arch == .aarch64) try self.addTargetStrings("arm64e");
 
-        switch (platform) {
-            .IOSSIMULATOR, .TVOSSIMULATOR, .WATCHOSSIMULATOR, .VISIONOSSIMULATOR => {
-                // For Apple simulator targets, linking gets tricky as we need to link against the simulator
-                // hosts dylibs too.
-                const host_target = try targetToAppleString(allocator, cpu_arch, .MACOS);
-                try self.target_strings.append(allocator, host_target);
-            },
-            .MACOS => {
-                // Turns out that around 10.13/10.14 macOS release version, Apple changed the target tags in
-                // tbd files from `macosx` to `macos`. In order to be compliant and therefore actually support
-                // linking on older platforms against `libSystem.tbd`, we add `<cpu_arch>-macosx` to target_strings.
-                const fallback_target = try std.fmt.allocPrint(allocator, "{s}-macosx", .{
-                    cpuArchToAppleString(cpu_arch),
-                });
-                try self.target_strings.append(allocator, fallback_target);
-            },
+        return self;
+    }
+
+    fn addTargetStrings(self: *TargetMatcher, arch: []const u8) !void {
+        try self.target_strings.append(self.allocator, try std.fmt.allocPrint(
+            self.allocator,
+            "{s}-{s}",
+            .{ arch, platformToAppleString(self.platform) },
+        ));
+
+        switch (self.platform) {
+            .MACCATALYST => {
+                // Mac Catalyst is allowed to link macOS libraries in a TBD because Apple were apparently too lazy
+                // to add the proper target strings despite doing so in other places in the format???
+                try self.target_strings.append(self.allocator, try std.fmt.allocPrint(self.allocator, "{s}-macos", .{arch}));
+            },
+            .IOSSIMULATOR, .TVOSSIMULATOR, .WATCHOSSIMULATOR, .VISIONOSSIMULATOR => {
+                // For Apple simulator targets, we need to link against the simulator host's libraries too.
+                try self.target_strings.append(self.allocator, try std.fmt.allocPrint(self.allocator, "{s}-macos", .{arch}));
+            },
             else => {},
         }
-
-        return self;
     }
 
     pub fn deinit(self: *TargetMatcher) void {
@@ -762,7 +767,7 @@ pub const TargetMatcher = struct {
         self.target_strings.deinit(self.allocator);
     }
 
-    inline fn cpuArchToAppleString(cpu_arch: std.Target.Cpu.Arch) []const u8 {
+    fn cpuArchToAppleString(cpu_arch: std.Target.Cpu.Arch) []const u8 {
         return switch (cpu_arch) {
             .aarch64 => "arm64",
             .x86_64 => "x86_64",
@@ -770,9 +775,8 @@ pub const TargetMatcher = struct {
         };
     }
 
-    pub fn targetToAppleString(allocator: Allocator, cpu_arch: std.Target.Cpu.Arch, platform: macho.PLATFORM) ![]const u8 {
-        const arch = cpuArchToAppleString(cpu_arch);
-        const plat = switch (platform) {
+    fn platformToAppleString(platform: macho.PLATFORM) []const u8 {
+        return switch (platform) {
             .MACOS => "macos",
             .IOS => "ios",
             .TVOS => "tvos",
@@ -787,7 +791,6 @@ pub const TargetMatcher = struct {
             .DRIVERKIT => "driverkit",
             else => unreachable,
         };
-        return std.fmt.allocPrint(allocator, "{s}-{s}", .{ arch, plat });
     }
 
     fn hasValue(stack: []const []const u8, needle: []const u8) bool {
