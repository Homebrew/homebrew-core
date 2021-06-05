class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  # Re-enable C compilation test at 0.8.1
  url "https://ziglang.org/download/0.8.0/zig-0.8.0.tar.xz"
  sha256 "03a828d00c06b2e3bb8b7ff706997fd76bf32503b08d759756155b6e8c981e77"
  license "MIT"
  head "https://github.com/ziglang/zig.git"

  bottle do
    sha256 cellar: :any, big_sur:  "36024d6e9270699221abc2fe0d49b9f16e9bfc62636b33750f94d89a07e0e308"
    sha256 cellar: :any, catalina: "167c21243552b1b309c4cf83bfb8e678a14b5a3e3adf66e7f2501b36d027d693"
    sha256 cellar: :any, mojave:   "63643cea7d45ce511f4cd0a4e7089a64e2dedecc9cd900eaff805c011b299cda"
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
    # Compiling C is broken on Mojave. Re-enable at 0.8.1.
    # https://github.com/ziglang/zig/issues/8999
    if MacOS.version > :mojave
      system "#{bin}/zig", "cc", "hello.c", "-o", "hello"
      assert_equal "Hello, world!", shell_output("./hello")
    end
  end
end
