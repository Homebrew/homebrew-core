class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.5.0/zig-0.5.0.tar.xz"
  sha256 "55ae16960f152bcb9cf98b4f8570902d0e559a141abf927f0d3555b7cc838a31"
  head "https://github.com/ziglang/zig.git"

  bottle do
    sha256 "3b5659dac004dcdf68e57bed34f9b7f097524aebecd7cf263ff74d643fcc7d22" => :catalina
    sha256 "3142c933d0a51bd29119cb242e4241cb012f22d9aa65380f1541bd16876206ae" => :mojave
    sha256 "db30263fb131a6dce56904b5232dbba1165d58c58545b84a9958102f779fe13b" => :high_sierra
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
