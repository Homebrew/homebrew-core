class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"

  stable do
    url "https://ziglang.org/download/0.9.1/zig-0.9.1.tar.xz"
    sha256 "38cf4e84481f5facc766ba72783e7462e08d6d29a5d47e3b75c8ee3142485210"

    depends_on "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3d388804326dc5475ce377832327cbae7c32d3468255c462394feb89d3ed743d"
    sha256 cellar: :any,                 arm64_big_sur:  "894049ce2d60bba662770aa28bc8c52347f039840172c291f848ab5a7e11776c"
    sha256 cellar: :any,                 monterey:       "5825b4b6610cad3d73eac8ff5915c01609a82a58bde9cf9309c6dc1fa32c9feb"
    sha256 cellar: :any,                 big_sur:        "937d9e3adbfddfa2f7cb2902d9410b5636bd33f4cf47341b935bb68e87893d88"
    sha256 cellar: :any,                 catalina:       "1b0c7260cfcd87901ad399f1082d59c0a8e8f87da521807eb8e6641c7e12c890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fd87d8186cb47914cdc179cb28e789cb59999f6e1b11d79f2ca9e701ac43e23"
  end

  head do
    url "https://github.com/ziglang/zig.git", branch: "master"
    depends_on "llvm"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    system "cmake", ".", *std_cmake_args, "-DZIG_STATIC_LLVM=ON"
    system "make", "install"
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
