class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  revision 1
  head "https://github.com/ziglang/zig.git"

  stable do
    url "https://ziglang.org/download/0.8.0/zig-0.8.0.tar.xz"
    sha256 "03a828d00c06b2e3bb8b7ff706997fd76bf32503b08d759756155b6e8c981e77"

    # Fix compilation of C code on Mojave. Remove at version bump.
    # https://github.com/ziglang/zig/pull/9427
    patch do
      url "https://github.com/ziglang/zig/commit/24bfd7bdddbf045c5568c1bb67a3f754c24eb8c4.patch?full_index=1"
      sha256 "feda7d03502c073bd9874996453da6961dcf16f5a3e08b86d6df1d4cbc1475a7"
    end
  end

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
