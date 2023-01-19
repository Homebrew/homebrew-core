class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.10.1/zig-0.10.1.tar.xz"
  sha256 "69459bc804333df077d441ef052ffa143d53012b655a51f04cfef1414c04168c"
  license "MIT"
  head "https://github.com/ziglang/zig.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a3908bf383d7754fbc4875440c9b8392e9c4bc5bb9a0f4e62f80d2ea0044414b"
    sha256 cellar: :any,                 arm64_monterey: "c9c484c3a6161663eda02c97a2898629e2c82576105e47f32cd9e4e741545f66"
    sha256 cellar: :any,                 arm64_big_sur:  "5ec09008b3393fc4fb4793a39c9938776f69695ea51b509ad3c68a6d6be00e5e"
    sha256 cellar: :any,                 ventura:        "d52517dc0a1e61ab460bc4453e616c3e18f3b088b6d66e16eda12a70815aead5"
    sha256 cellar: :any,                 monterey:       "fc156c0ddf4bb31e6258c905acc3121fda3ecb7930385d7baa245099cb7d90ef"
    sha256 cellar: :any,                 big_sur:        "42647236a8dee891946d8e399cf06d07c3f16e46eaf83db460f1443e8013c52b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "900d27fc1b3a98e1be76db86621b76d195336712a409e5088223e230dd12d76d"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on macos: :big_sur # https://github.com/ziglang/zig/issues/13313
  depends_on "z3"
  depends_on "zstd"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    system "cmake", "-S", ".", "-B", "build", "-DZIG_STATIC_LLVM=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
