class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.14.1/zig-0.14.1.tar.xz"
  sha256 "237f8abcc8c3fd68c70c66cdbf63dce4fb5ad4a2e6225ac925e3d5b4c388f203"
  license "MIT"

  livecheck do
    url "https://ziglang.org/download/"
    regex(/href=.*?zig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3fffc57a94634f42df4156f3d1c4c2377e3c84772c5b49b95c0fecdc54dea092"
    sha256 cellar: :any,                 arm64_sonoma:  "4ef618c7685f323025c86403c58e3bae87c7ad47871f709eb935de8798581c6f"
    sha256 cellar: :any,                 arm64_ventura: "8edc35ba83083e73684c765e06e996a13ee59233c49e091c6495c9c604e29ef6"
    sha256 cellar: :any,                 sonoma:        "d72ea1ebdae41308ce7145ebe3319736509d25b600683309ec890ac0edfff6ef"
    sha256 cellar: :any,                 ventura:       "324fbfd949a1648b6abda1ac560d53dc707aedb613570260281581e804564a69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ff8fc4310dff376fb6c02827f01dce82e0468223ea56996c026795aeba85ec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "422b4295434e2c8b052379581e8fbcad8b650591e58cdf17fa3df4f7721b1663"
  end

  depends_on "cmake" => :build
  depends_on "lld@19"
  depends_on "llvm@19"
  depends_on macos: :big_sur # https://github.com/ziglang/zig/issues/13313

  # NOTE: `z3` should be macOS-only dependency whenever we need to re-add
  on_macos do
    depends_on "zstd"
  end

  # https://github.com/Homebrew/homebrew-core/issues/209483
  skip_clean "lib/zig/libc/darwin/libSystem.tbd"

  # Fix linkage with libc++.
  # https://github.com/ziglang/zig/pull/23264
  patch :DATA

  def install
    llvm = deps.find { |dep| dep.name.match?(/^llvm(@\d+)?$/) }
               .to_formula
    if llvm.versioned_formula? && deps.any? { |dep| dep.name == "z3" }
      # Don't remove this check even if we're using a versioned LLVM
      # to avoid accidentally keeping it when not needed in the future.
      odie "`z3` dependency should be removed!"
    end

    # Workaround for https://github.com/Homebrew/homebrew-core/pull/141453#discussion_r1320821081.
    # This will likely be fixed upstream by https://github.com/ziglang/zig/pull/16062.
    if OS.linux?
      ENV["NIX_LDFLAGS"] = ENV["HOMEBREW_RPATH_PATHS"].split(":")
                                                      .map { |p| "-rpath #{p}" }
                                                      .join(" ")
    end

    cpu = case Hardware.oldest_cpu # See `zig targets`.
    # Cortex A-53 seems to be the oldest available ARMv8-A processor.
    # https://en.wikipedia.org/wiki/ARM_Cortex-A53
    when :armv8 then "cortex_a53"
    when :arm_vortex_tempest then "apple_m1"
    else Hardware.oldest_cpu
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
          const stdout = std.io.getStdOut().writer();
          try stdout.print("Hello, world!", .{});
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
    assert_includes (bin/"zig").dynamically_linked_libraries, "/usr/lib/libc++.1.dylib"
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
+                    const sdk = std.zig.system.darwin.getSdk(b.allocator, b.graph.host.result) orelse return error.SdkDetectFailed;
+                    const @"libc++" = b.pathJoin(&.{ sdk, "usr/lib/libc++.tbd" });
+                    exe.root_module.addObjectFile(.{ .cwd_relative = @"libc++" });
+                }
             },
             .windows => {
                 if (target.abi != .msvc) mod.link_libcpp = true;
