class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "http://ziglang.org/"
  url "https://github.com/zig-lang/zig/archive/0.1.1.tar.gz"
  sha256 "fabbfcb0bdb08539d9d8e8e1801d20f25cb0025af75ac996f626bb5e528e71f1"

  depends_on "cmake" => :build
  depends_on "llvm"

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
