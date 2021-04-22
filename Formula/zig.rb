class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  revision 1

  stable do
    url "https://ziglang.org/download/0.7.1/zig-0.7.1.tar.xz"
    sha256 "2db3b944ab368d955b48743d9f7c963b8f96de1a441ba5a35e197237cc6dae44"
    depends_on "llvm@11"
  end

  bottle do
    sha256 cellar: :any, big_sur:  "36024d6e9270699221abc2fe0d49b9f16e9bfc62636b33750f94d89a07e0e308"
    sha256 cellar: :any, catalina: "167c21243552b1b309c4cf83bfb8e678a14b5a3e3adf66e7f2501b36d027d693"
    sha256 cellar: :any, mojave:   "63643cea7d45ce511f4cd0a4e7089a64e2dedecc9cd900eaff805c011b299cda"
  end

  head do
    url "https://github.com/ziglang/zig.git"
    depends_on "llvm"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"hello.zig").write <<~EOS
      const std = @import("std");
      pub fn main() !void {
          var stdout_file: std.fs.File = std.io.getStdOut();
          _ = try stdout_file.write("Hello, world!");
      }
    EOS
    system "#{bin}/zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output("./hello")
  end
end
