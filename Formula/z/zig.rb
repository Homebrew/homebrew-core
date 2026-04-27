class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.16.0/zig-0.16.0.tar.xz"
  sha256 "43186959edc87d5c7a1be7b7d2a25efffd22ce5807c7af99067f86f99641bfdf"
  license "MIT"
  revision 1
  compatibility_version 1

  livecheck do
    url "https://ziglang.org/download/"
    regex(/href=.*?zig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "522ec6fc3cd13d1c731b4677234054a4f9207d1f7e208f0a1313fd21835bd16b"
    sha256 cellar: :any,                 arm64_sequoia: "12b55d2efffbc6fc65f471ff989703934fee7f55e60887e400c8c18abd1b3baf"
    sha256 cellar: :any,                 arm64_sonoma:  "90f1fb24a01715a36a48878969a16e29b341039a1c97a82fc134db09a00cd888"
    sha256 cellar: :any,                 sonoma:        "22035d0f3aa03f82192326b77dad535ea14acd5689a04a2c18df9b077b2d53e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dec0d9355b49eea00ae882bd407bbceb48b27c206a6f0e823ac63635b74d5c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9657f0322225292cb4a9c158d2305f62520524467b5b57daf545a327c492cd37"
  end

  depends_on "cmake" => :build
  depends_on "lld@21"
  depends_on "llvm@21"
  depends_on macos: :big_sur # https://github.com/ziglang/zig/issues/13313

  # NOTE: `z3` should be macOS-only dependency whenever we need to re-add
  on_macos do
    depends_on "zstd"
  end

  conflicts_with "anyzig", because: "both install `zig` binaries"

  # https://github.com/Homebrew/homebrew-core/issues/209483
  skip_clean "lib/zig/libc/darwin/libSystem.tbd"

  # Force Zig to use the system libc++ on Darwin. Without this, the vendored
  # libc++ gives `zig` a private std::error_code category that disagrees with
  # libLLVM.dylib's, breaking comparisons across the boundary — e.g. `zig ar`
  # can't create new archives with ZIG_SHARED_LLVM=ON.
  # https://github.com/Homebrew/homebrew-core/issues/278849
  patch :DATA

  def install
    # Reduce max_rss to build on CI with less than 8GB memory available
    inreplace "build.zig", ".max_rss = 8_000_000_000,", ".max_rss = 6_900_000_000,"

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
    when :arm_vortex_tempest then "apple_m1"
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
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
      pub fn main(init: std.process.Init) !void {
          try std.Io.File.stdout().writeStreamingAll(init.io, "Hello, world!");
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

    # Regression test for `zig ar` creating a new archive.
    # https://github.com/Homebrew/homebrew-core/issues/278849
    system bin/"zig", "cc", "-c", "hello.c", "-o", "hello.o"
    system bin/"zig", "ar", "rcs", "test.a", "hello.o"
    assert_path_exists testpath/"test.a"

    return unless OS.mac?

    # Guards against `zig` vendoring its own libc++. Before removing,
    # confirm the binary has no private libc++ of its own.
    # https://github.com/Homebrew/homebrew-core/issues/278849
    require "utils/linkage"
    library = "/usr/lib/libc++.1.dylib"
    assert Utils.binary_linked_to_library?(bin/"zig", library), "No linkage with #{library}!"
  end
end

__END__
diff --git a/build.zig b/build.zig
--- a/build.zig
+++ b/build.zig
@@ -859,7 +859,15 @@
                 mod.linkSystemLibrary("unwind", .{});
             },
             .driverkit, .ios, .maccatalyst, .macos, .tvos, .visionos, .watchos => {
-                mod.link_libcpp = true;
+                const io = b.graph.io;
+                if (static or !std.zig.system.darwin.isSdkInstalled(b.allocator, io)) {
+                    mod.link_libcpp = true;
+                } else {
+                    const sdk = std.zig.system.darwin.getSdk(b.allocator, io, target) orelse
+                        return error.SdkDetectFailed;
+                    const libcpp_tbd = b.pathJoin(&.{ sdk, "usr/lib/libc++.tbd" });
+                    mod.addObjectFile(.{ .cwd_relative = libcpp_tbd });
+                }
             },
             .windows => {
                 if (target.abi != .msvc) mod.link_libcpp = true;
