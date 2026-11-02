class ZigAT016 < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.16.0/zig-0.16.0.tar.xz"
  sha256 "43186959edc87d5c7a1be7b7d2a25efffd22ce5807c7af99067f86f99641bfdf"
  license "MIT"

  livecheck do
    skip "No longer developed or maintained"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "903da9c678fe088d1385a1f5d58d547cbf6ed786ad4d1d398f06927f06be9379"
    sha256 cellar: :any, arm64_tahoe:       "298f134e117990b66d111149c857440701c1960be92adc74198b114206d9a211"
    sha256 cellar: :any, arm64_sequoia:     "836e667257f5a7c83b040697de094f5689a44be20eeff4140765ef01df66b0fb"
    sha256 cellar: :any, arm64_linux:       "54b58a3a847afaef55cf6b3b406d63c5a3f2f9128ea57775478ea39909806342"
    sha256 cellar: :any, x86_64_linux:      "dec64f9cbe7ce40ceceddb61efa9032869b8c7091014c2663066ef5ba8a4550a"
  end

  keg_only :versioned_formula

  # Unsupported since Zig 0.17 was released on 2026-10-01, but we are
  # giving an extra 1 year for dependents to migrate to newer Zig
  deprecate! date: "2027-10-01", because: :unsupported
  disable! date: "2028-10-01", because: :unsupported

  depends_on "cmake" => :build
  depends_on "lld@21"
  depends_on "llvm@21"

  on_macos do
    depends_on "zstd"
  end

  # https://github.com/Homebrew/homebrew-core/issues/209483
  skip_clean "lib/zig/libc/darwin/libSystem.tbd"

  # Backport fix for zig to fetch zip files to cache
  patch do
    url "https://codeberg.org/ziglang/zig/commit/cfde9303ff75322525746aa325026f0e12fb402c.diff"
    sha256 "9e9aa27db65d5b66eb82df7eae13baff57656de2088c0ee15eccbda404e690fa"
    type :backport
  end

  # Force Zig to use the system libc++ on Darwin. Without this, the vendored
  # libc++ gives `zig` a private std::error_code category that disagrees with
  # libLLVM.dylib's, breaking comparisons across the boundary — e.g. `zig ar`
  # can't create new archives with ZIG_SHARED_LLVM=ON.
  # https://github.com/Homebrew/homebrew-core/issues/278849
  patch do
    file "Patches/zig/0.16.patch"
    type :unofficial
  end

  deny_network_access!

  def install
    # Reduce max_rss to build on CI with less than 8GB memory available
    inreplace "build.zig", ".max_rss = 8_000_000_000,", ".max_rss = 6_900_000_000,"

    # Workaround for https://github.com/Homebrew/homebrew-core/pull/141453#discussion_r1320821081.
    # This will likely be fixed upstream by https://github.com/ziglang/zig/pull/16062.
    if OS.linux?
      ENV["NIX_LDFLAGS"] = ENV["HOMEBREW_RPATH_PATHS"].split(":")
                                                      .map { |p| "-rpath #{p}" }
                                                      .join(" ")
    end

    args = ["-DZIG_SHARED_LLVM=ON"]
    args << "-DZIG_TARGET_MCPU=#{Hardware.zig_cpu(ENV.effective_arch)}" if build.bottle?

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
