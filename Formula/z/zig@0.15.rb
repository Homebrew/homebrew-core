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

  on_macos do
    depends_on macos: :big_sur # https://github.com/ziglang/zig/issues/13313
    depends_on "zstd"
  end

  # https://github.com/Homebrew/homebrew-core/issues/209483
  skip_clean "lib/zig/libc/darwin/libSystem.tbd"

  # Fix linkage with libc++.
  #   https://github.com/ziglang/zig/pull/23264
  # Fix max_rss
  #   https://github.com/Homebrew/homebrew-core/issues/252365
  patch do
    file "Patches/zig/0.15.patch"
    type :unofficial
  end

  def install
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
