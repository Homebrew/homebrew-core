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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "ebda0bd6d057bef6348214f2aa784ef4800f59645561eb10d6eced1a7999d905"
    sha256 cellar: :any, arm64_tahoe:       "1e3cc31b59bdac9883f04d975ce5da65aac6141fd05e259646a566b0a83ccb25"
    sha256 cellar: :any, arm64_sequoia:     "44dd9125a5e849a2623b61a98aa48e382859cf942599d0b003fc32597b93a5f3"
    sha256 cellar: :any, arm64_sonoma:      "25d0484f1dc6caf78fda4497eb68f0103002eca1e2ae414c62459b9a3cebe569"
    sha256 cellar: :any, arm64_linux:       "d37d996c260f2f6602d4aa7d6d0695bb6a7da657b89f901a51d8270c799c3e0c"
    sha256 cellar: :any, x86_64_linux:      "451386463068f96031bab7c650a3945e7f1a3e555f7f8d516e9ee558b3342146"
  end

  depends_on "cmake" => :build
  depends_on "lld@21"
  depends_on "llvm@21"

  # NOTE: `z3` should be macOS-only dependency whenever we need to re-add
  on_macos do
    depends_on "zstd"
  end

  conflicts_with "anyzig", because: "both install `zig` binaries"

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
