class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.10.1/zig-0.10.1.tar.xz"
  sha256 "69459bc804333df077d441ef052ffa143d53012b655a51f04cfef1414c04168c"
  license "MIT"
  head "https://github.com/ziglang/zig.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "df936652f951eae31e4faf5c878d613e4ced6028a1fa555047ffec9fc7f02cd7"
    sha256 cellar: :any,                 arm64_monterey: "0db450570200f124aed4d3750f6472491424a47dbcff91418ca84a649201819a"
    sha256 cellar: :any,                 arm64_big_sur:  "1c3190b58e7c36c3ebe5f00c5423d65a502eedd422992b8e28b223cae17c67d3"
    sha256 cellar: :any,                 ventura:        "2deaff1dfc54e41f92adf130167a644d57d38cca7c074f5c1054a9c628b71a30"
    sha256 cellar: :any,                 monterey:       "e7c66e2a7d7d94af2844132e20913810d821fdb0f901f2336aa8ee88b39c93f0"
    sha256 cellar: :any,                 big_sur:        "171497e2e4e8cd729c3bdd332bb26c3ae820cbfabff1d0876e7c6101c47a0703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99a414e113877e3348717d54b4fe4b6e4e78db2b179a1ddce5bdf3be48af04f7"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on macos: :big_sur # https://github.com/ziglang/zig/issues/13313
  depends_on "z3"
  depends_on "zstd"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  fails_with gcc: "5" # LLVM is built with GCC

  def install
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
