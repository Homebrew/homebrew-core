class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.9.1/zig-0.9.1.tar.xz"
  sha256 "38cf4e84481f5facc766ba72783e7462e08d6d29a5d47e3b75c8ee3142485210"
  license "MIT"
  head "https://github.com/ziglang/zig.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "61d958015313e75d98c407902e6aba1b4f359e392eda0c090199eec76d20534a"
    sha256 cellar: :any,                 arm64_big_sur:  "accea97f675c8fb0c6049225ccaba3b9ce4a0d7f778ed47b4b2d2f34c8bccdf5"
    sha256 cellar: :any,                 monterey:       "da8c2def2c9d0d09a84dd745a52b9d4acd136014b4fc1c383f06df05d99e6cb3"
    sha256 cellar: :any,                 big_sur:        "ce7fefb8d1e9de6374a0daf605ae5ec7756377a6f60fa6b34bb11dfadf57e7c4"
    sha256 cellar: :any,                 catalina:       "f53b3254181523c12e382404fec21583b408390ce2668b1c97d94b8af343acd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d8cb3768434244333ab7164ba5806a924db341a1f86c9471009fc1f6177fcfe"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

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
