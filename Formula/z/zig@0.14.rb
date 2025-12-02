class ZigAT014 < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.14.1/zig-0.14.1.tar.xz"
  sha256 "237f8abcc8c3fd68c70c66cdbf63dce4fb5ad4a2e6225ac925e3d5b4c388f203"
  license "MIT"

  livecheck do
    url "https://ziglang.org/download/"
    regex(/href=.*?zig[._-]v?(0\.14(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed459b4f22e43748e723704ba25ed2019707082ecc27fffb9b2772c7ec8a6d56"
    sha256 cellar: :any,                 arm64_sequoia: "03851d2d9118608f887d97b3674d5a8929699855c73fa7bcf6f6dc7c72fdf70b"
    sha256 cellar: :any,                 arm64_sonoma:  "01f5813d555a56abab6d5076bfc93048b7c792336d9839513df1ccef355644d9"
    sha256 cellar: :any,                 arm64_ventura: "bf2bb8d09f1eb6c311609f6d5699206199e06d4d60924e1d19c9e72ba0537b6a"
    sha256 cellar: :any,                 sonoma:        "2e77847e273785c7db555a9f563eaeb2cfe65c0d2310862ef404933c28ee6828"
    sha256 cellar: :any,                 ventura:       "c7ac8f1ea8b09c4c9706597da2eef4317c56f46801be7fb699b11fde357dfb1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8c0ee0e04b687903f8ee93cf9d2c294dd41b872edbb0ff6938db0a888cad051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f53b11bf84acc90c55d583801bd50470ac2532bffbb977d8e47401bf38a5679"
  end

  keg_only :versioned_formula

  # Unsupported since Zig 0.15 was released on 2025-08-19, but we are
  # giving an extra 6 months for dependents to migrate to newer Zig
  deprecate! date: "2026-02-19", because: :unsupported
  # disable! date: "2026-08-19", because: :unsupported

  depends_on "cmake" => :build
  depends_on "lld@19"
  depends_on "llvm@19"
  depends_on macos: :big_sur # https://github.com/ziglang/zig/issues/13313

  on_macos do
    depends_on "zstd"
  end

  # https://github.com/Homebrew/homebrew-core/issues/209483
  skip_clean "lib/zig/libc/darwin/libSystem.tbd"

  # Fix linkage with libc++.
  # https://github.com/ziglang/zig/pull/23264
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
+                    const sdk = std.zig.system.darwin.getSdk(b.allocator, b.graph.host.result) orelse return error.SdkDetectFailed;
+                    const @"libc++" = b.pathJoin(&.{ sdk, "usr/lib/libc++.tbd" });
+                    exe.root_module.addObjectFile(.{ .cwd_relative = @"libc++" });
+                }
             },
             .windows => {
                 if (target.abi != .msvc) mod.link_libcpp = true;
