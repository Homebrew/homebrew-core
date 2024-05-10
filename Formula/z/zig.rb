class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://ziglang.org/download/0.12.0/zig-0.12.0.tar.xz"
  sha256 "a6744ef84b6716f976dad923075b2f54dc4f785f200ae6c8ea07997bd9d9bd9a"
  license "MIT"

  livecheck do
    url "https://ziglang.org/download/"
    regex(/href=.*?zig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b29fd206a2901a98bc54965e635ceeda49b888eb19d232102bd9325e44ea7f56"
    sha256 cellar: :any,                 arm64_ventura:  "d62fd01d62ff70335248de047a393e02198a64538cc571eb22b732eba1ddcce5"
    sha256 cellar: :any,                 arm64_monterey: "b236a97dd7e99560f0163bf125d4de32dba12e8128d8721c9e885a4fd396dc9d"
    sha256 cellar: :any,                 sonoma:         "280268416169c9380803c9a4f09946c19effd120eaf9789432a66a437a41a7fc"
    sha256 cellar: :any,                 ventura:        "8cb59f37d582014e5d44bed5bfc6bd01bdd26e29266bc5aff202cb4264fd8da7"
    sha256 cellar: :any,                 monterey:       "6130fb2b4b92efc04f3fc306be13ac72054f51ac0805020a9e54dc01f9a26220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33292b8bb48bc913b72630876cdc1b7e9839a0e99f750a1b2c2f4c8835a64b9a"
  end

  depends_on "cmake" => :build
  # Check: https://github.com/ziglang/zig/blob/#{version}/CMakeLists.txt
  # for supported LLVM version.
  depends_on "llvm@17" => :build
  depends_on macos: :big_sur # https://github.com/ziglang/zig/issues/13313
  depends_on "zstd"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Workaround for https://github.com/Homebrew/homebrew-core/pull/141453#discussion_r1320821081.
    # This will likely be fixed upstream by https://github.com/ziglang/zig/pull/16062.
    if OS.linux?
      ENV["NIX_LDFLAGS"] = ENV["HOMEBREW_RPATH_PATHS"].split(":")
                                                      .map { |p| "-rpath #{p}" }
                                                      .join(" ")
    end

    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = ["-DZIG_STATIC_LLVM=ON"]
    args << "-DZIG_TARGET_MCPU=#{cpu}" if build.bottle?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.zig").write <<~EOS
      const std = @import("std");
      pub fn main() !void {
          const stdout = std.io.getStdOut().writer();
          try stdout.print("Hello, world!", .{});
      }
    EOS
    system "#{bin}/zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output("./hello")

    # error: 'TARGET_OS_IPHONE' is not defined, evaluates to 0
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        fprintf(stdout, "Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/zig", "cc", "hello.c", "-o", "hello"
    assert_equal "Hello, world!", shell_output("./hello")
  end
end
