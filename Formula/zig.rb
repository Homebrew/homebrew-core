class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "http://ziglang.org/"
  url "https://github.com/zig-lang/zig/archive/0.1.1.tar.gz"
  sha256 "fabbfcb0bdb08539d9d8e8e1801d20f25cb0025af75ac996f626bb5e528e71f1"

  bottle do
    sha256 "2184016574a84b2c0a8cdedd95727a265bb6459d580348200722e4cf36b82ed7" => :high_sierra
    sha256 "78b8bac1021aa558183c8f9d46a918c89378b6473a688f20713d9b9c85879562" => :sierra
    sha256 "2862e1ca07f7150b31a034cb486351b7499f6c6ba9c8dd46015b5517a876c6aa" => :el_capitan
  end

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
