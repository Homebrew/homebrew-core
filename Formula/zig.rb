class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://github.com/ziglang/zig/archive/0.3.0.tar.gz"
  sha256 "23ebb962823b2c78fd7bb16dd033b189c3050eee9991070debbd79c9b8648772"
  head "https://github.com/ziglang/zig.git"

  bottle do
    sha256 "17b028751975abeda9ad81a7509020d1691ce0b85c0653cb2ec3b5814cd794a0" => :mojave
    sha256 "9985f61a3ad0913ff7ef4595b64ed940532720f2e6e07e0e535cdb660a758c1a" => :high_sierra
    sha256 "4c2b272a5229f0b0d67759a075cc647e09860b29b0325d0feb38a9abbb58830f" => :sierra
    sha256 "4244c50ca567e20e6a98a783b7cdc97455d5114ae0f9d754d6c72a21b5a45c1f" => :el_capitan
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
