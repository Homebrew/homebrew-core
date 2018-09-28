class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://github.com/ziglang/zig/archive/0.3.0.tar.gz"
  sha256 "23ebb962823b2c78fd7bb16dd033b189c3050eee9991070debbd79c9b8648772"
  head "https://github.com/ziglang/zig.git"

  bottle do
    sha256 "93c95a500ebf3a57025a980aabeb47a9ffd93606ef7f67461b457a29f80663cb" => :mojave
    sha256 "2debc5e9a4d567b8412aa38645f2bfe485eac79c4e953710d5c05e006b56ff4d" => :high_sierra
    sha256 "2d57cb9516cc3d2d5f4c83c33beece104166c348808751d6195054f05858fcb2" => :sierra
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
          var stdout_file = try std.io.getStdOut();
          try stdout_file.write("Hello, world!");
      }
    EOS
    system "#{bin}/zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output("./hello")
  end
end
