class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"

  stable do
    url "https://ziglang.org/download/0.9.0/zig-0.9.0.tar.xz"
    sha256 "cd1be83b12f8269cc5965e59877b49fdd8fa638efb6995ac61eb4cea36a2e381"

    depends_on "llvm"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "018b275bd4e61525d19dc95f065622cac2deeb83a562d6d779414b056db989ce"
    sha256 cellar: :any,                 arm64_big_sur:  "4b06b5abf72a311162138a852dcadb863974d4c69573dfa13d9857b312010165"
    sha256 cellar: :any,                 monterey:       "d882ab923be5da7adf934d5ad34f3b6c90907411c896ad78f87841f513afcbfc"
    sha256 cellar: :any,                 big_sur:        "18e6b29f749642d8a01ce2d9657e206c9b7d3f130264f39f7afde9b9b072e03b"
    sha256 cellar: :any,                 catalina:       "80fa8f4df5ccc5e0f8b190a8ec86eabd223ec56c756fa5e1821ef8d75d93934f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "effb69c4ee99ffa28c7a927c786565c03f56f99da437026f3788218d962c3ab8"
  end

  head do
    url "https://github.com/ziglang/zig.git", branch: "master"
    depends_on "llvm"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    system "cmake", ".", *std_cmake_args, "-DZIG_STATIC_LLVM=ON"
    system "make", "install"
  end

  test do
    (testpath/"hello.zig").write <<~EOS
      const std = @import("std");
      pub fn main() !void {
          const stdout = std.io.getStdOut().writer();
          try stdout.print("Hello, world!", .{});
      }
    EOS
    system "#{bin}/zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output("./hello")

    # error: 'TARGET_OS_IPHONE' is not defined, evaluates to 0
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        fprintf(stdout, "Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/zig", "cc", "hello.c", "-o", "hello"
    assert_equal "Hello, world!", shell_output("./hello")
  end
end
