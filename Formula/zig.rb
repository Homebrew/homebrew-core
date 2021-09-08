class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.8.1/zig-0.8.1.tar.xz"
  sha256 "8c428e14a0a89cb7a15a6768424a37442292858cdb695e2eb503fa3c7bf47f1a"
  license "MIT"
  head "https://github.com/ziglang/zig.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "509462e2ab9377e1a1464e0204bad486e18c32908aca8ae3684d12f5a46039f7"
    sha256 cellar: :any,                 big_sur:       "8b2243d6f8b4e25848592238ee8134af62d3db2eb855f73796066b96f4d4101e"
    sha256 cellar: :any,                 catalina:      "c129c5da03f133d5d8ac1b0cf9f21e411778856152f94a488e0dbe2b7c8aafc9"
    sha256 cellar: :any,                 mojave:        "f5986270bfca4ac26802df56f58c7d836d019bf133b6c885449fa6f088840ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65514fee3818165516c30de75546f33e3beb632d401fa5de756b190940fd385a"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

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
