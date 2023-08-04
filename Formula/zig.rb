class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.11.0/zig-0.11.0.tar.xz"
  sha256 "ead029cfe474d9bf0413332d0e9d3bdfb5990cadce238f44f35ba32d92169295"
  license "MIT"

  livecheck do
    url "https://ziglang.org/download/"
    regex(/href=.*?zig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "f9fba5a3f6ce5a3005d6f5c91f06a2630237747eb98bbf7be39b885856f7a064"
    sha256 cellar: :any,                 arm64_monterey: "5bb3325fbf88ed5d129b289bb53d7d56184bd89708398521bf5ae5275ba4fde8"
    sha256 cellar: :any,                 arm64_big_sur:  "e148c22748a77f420327bdc267ad8dcc1fcaa4cdd307fba435693ce02d9242f9"
    sha256 cellar: :any,                 ventura:        "1e7f133b829d858de19d5bc60a581ebccae19fcb2cf4b7dfbef36cae27705aa6"
    sha256 cellar: :any,                 monterey:       "d89854a3bdc7bfefaa695c6369ee708151fe3f0ec70dc38b30c92c981b6f58c0"
    sha256 cellar: :any,                 big_sur:        "eb4a6e0dd5714db1d682ac049eed6e92993badc9d5a9e9d593248820c5ca0070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eefd8e8b1a71b27ce3b5a9c9c3ea8bcb4cf0f74221035d5da84b11d31fa33569"
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
