class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.7.1/zig-0.7.1.tar.xz"
  sha256 "2db3b944ab368d955b48743d9f7c963b8f96de1a441ba5a35e197237cc6dae44"
  license "MIT"
  head "https://github.com/ziglang/zig.git"

  bottle do
    cellar :any
    sha256 "49ed801fbd9d811765e6154805bcb259c4efa831d729c65e2d8d97edc1e770da" => :big_sur
    sha256 "e1961b8c92810f085db84f43d4a20e3f14efdfe4d8d816cbd4620e412761edc7" => :catalina
    sha256 "fe8d287d02eaea270f69a51455f4aa27dda3bc4984231e592e9f56eaafba194a" => :mojave
    sha256 "e1cf0c30406fc5b9b0cbc00c56879674118b89cb40e2b1b840cac04996df29b4" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "llvm"

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
