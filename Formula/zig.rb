class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  # Re-enable C compilation test at 0.8.1
  url "https://ziglang.org/download/0.8.0/zig-0.8.0.tar.xz"
  sha256 "03a828d00c06b2e3bb8b7ff706997fd76bf32503b08d759756155b6e8c981e77"
  license "MIT"
  head "https://github.com/ziglang/zig.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "cbfe30a9fc41655c96d04c98a00d4dd451823ee8f55afaa9387c9cf367f66c62"
    sha256 cellar: :any, big_sur:       "740bcf88640b02fa8b21a6719c62c21afe3dd59ea60bb2a8d5efd4a3826fd5c7"
    sha256 cellar: :any, catalina:      "be1c5cab5438eede09322ff1e896202f0cbfaafb0641a596fdd04f0f4f6c6d48"
    sha256 cellar: :any, mojave:        "207446cc593dd0b1c63716d26bbb552a2242bc94fe19033df177186f610872df"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build

  def install
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
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

    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        fprintf(stdout, "Hello, world!");
        return 0;
      }
    EOS
    # Compiling C is broken on Mojave. Re-enable at 0.8.1.
    # https://github.com/ziglang/zig/issues/8999
    if MacOS.version > :mojave
      system "#{bin}/zig", "cc", "hello.c", "-o", "hello"
      assert_equal "Hello, world!", shell_output("./hello")
    end
  end
end
