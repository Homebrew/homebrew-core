class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.8.1/zig-0.8.1.tar.xz"
  sha256 "8c428e14a0a89cb7a15a6768424a37442292858cdb695e2eb503fa3c7bf47f1a"
  license "MIT"
  head "https://github.com/ziglang/zig.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "6c1d8057521dcb3f8f46374a33b10b8cd650b3e72d082781fb6f89d86ee42f6e"
    sha256 cellar: :any,                 big_sur:       "e1be8baf52c6146c23701345969e40f580ffbf4c14273bce206c4be26989f82d"
    sha256 cellar: :any,                 catalina:      "91244d050c13d67518e0311dfc1e2d2233f42102b2fca5be06a9f5dbba8e6970"
    sha256 cellar: :any,                 mojave:        "acd62f790db0e7d1a8379185c36394f9c97c96022e37cd8dbf46a56995543a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93cf0e20f945e484fa7681053aba4af7eca1492cd7ef58d10ccd6f979a552db1"
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
