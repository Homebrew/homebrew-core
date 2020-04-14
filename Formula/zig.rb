class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.6.0/zig-0.6.0.tar.xz"
  sha256 "5d167dc19354282dd35dd17b38e99e1763713b9be8a4ba9e9e69284e059e7204"
  head "https://github.com/ziglang/zig.git"

  bottle do
    sha256 "3b5659dac004dcdf68e57bed34f9b7f097524aebecd7cf263ff74d643fcc7d22" => :catalina
    sha256 "3142c933d0a51bd29119cb242e4241cb012f22d9aa65380f1541bd16876206ae" => :mojave
    sha256 "db30263fb131a6dce56904b5232dbba1165d58c58545b84a9958102f779fe13b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def install
    system "cmake", ".", *std_cmake_args, "-DZIG_PREFER_CLANG_CPP_DYLIB=ON"
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
