class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://github.com/zig-lang/zig/archive/0.1.1.tar.gz"
  sha256 "fabbfcb0bdb08539d9d8e8e1801d20f25cb0025af75ac996f626bb5e528e71f1"
  revision 1

  bottle do
    sha256 "3c2e3f738f28287a1fc68ac80d6bf4b0b047a51cc54d0239cd0e4c8a65b47714" => :high_sierra
    sha256 "17bb8fa63298c108fc67839c80116ecad69c2d0b3f7ec5f19ea4a88eb09b52fe" => :sierra
    sha256 "920c60bf1e853505349414aa7f24c95ae65ccc432b1db27211ddb7707a6a11de" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "llvm@5"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"hello.zig").write <<~EOS
      const io = @import("std").io;
      pub fn main() -> %void {
          %%io.stdout.printf("Hello, world!");
      }
    EOS
    system "#{bin}/zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output("./hello")
  end
end
