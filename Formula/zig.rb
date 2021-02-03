class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.7.1/zig-0.7.1.tar.xz"
  sha256 "2db3b944ab368d955b48743d9f7c963b8f96de1a441ba5a35e197237cc6dae44"
  license "MIT"
  head "https://github.com/ziglang/zig.git"

  bottle do
    sha256 cellar: :any, big_sur:  "f088607533abf8e77c38ad57b5c068b7c975d31d3558eda5ff9ef23221278650"
    sha256 cellar: :any, catalina: "f1168c13a73d6677a8d6eb04ecd0d67e93038bd33218bafadd9aac9a23045e7d"
    sha256 cellar: :any, mojave:   "eb2e0de16f666b740fb67529910712c517fed8ae3fd6e14d27acbbf19a41018a"
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
