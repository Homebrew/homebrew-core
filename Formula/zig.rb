class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.10.1/zig-0.10.1.tar.xz"
  sha256 "69459bc804333df077d441ef052ffa143d53012b655a51f04cfef1414c04168c"
  license "MIT"
  head "https://github.com/ziglang/zig.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "8a4d9ff9954cc5653d7ee911bdb1763d391782ec9a238045ff56ba5f86bf2e1a"
    sha256 cellar: :any,                 arm64_monterey: "39edbad109f049325e58dbc101a748c02c175be1f0a40174b2e896e4bef3ccdc"
    sha256 cellar: :any,                 arm64_big_sur:  "0b51293590c234eeb6719160a14e4b613bf72881485e5d0e232cf780db76d3b9"
    sha256 cellar: :any,                 ventura:        "b4ae05a9335758b47c4d9bb9c71ce455aff7449bb975f4996f4d92c32e407701"
    sha256 cellar: :any,                 monterey:       "03372943e1f2b037452fef537f19114af3953f945eb30c5f8cb04b9335fe34c1"
    sha256 cellar: :any,                 big_sur:        "237021c926ad9b3ae44112d1e34d7ba615d940ff28c29170915cd68af84b2b87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f17973e872f1ea8de838d540cb1b8092a6a4091e41f2d08822a0431bbd970080"
  end

  depends_on "cmake" => :build
  depends_on "llvm@15" => :build
  depends_on macos: :big_sur # ziglang/zig#13313
  depends_on "zstd"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = ["-DZIG_STATIC_LLVM=ON"]
    args << "-DZIG_TARGET_MCPU=#{cpu}" if build.bottle?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
    # ziglang/zig#10377
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
