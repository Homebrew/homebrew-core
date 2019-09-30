class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.5.0/zig-0.5.0.tar.xz"
  sha256 "55ae16960f152bcb9cf98b4f8570902d0e559a141abf927f0d3555b7cc838a31"
  head "https://github.com/ziglang/zig.git"

  bottle do
    sha256 "d905ba1d1f5e0e48e5e1dc1b60ef69741c2a4f939229c542e86ac818695ee1f2" => :mojave
    sha256 "ad0d81d938b6012330f1ee53d7479d7a3e6c8e6180081094d043ba2bd5094163" => :high_sierra
    sha256 "5fda9647ef7f6e13d9e5bc2215de96be3c69d6e79cc158870411553b1d0ad5da" => :sierra
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
