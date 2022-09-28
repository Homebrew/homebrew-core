class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  revision 2

  stable do
    url "https://ziglang.org/download/0.9.1/zig-0.9.1.tar.xz"
    sha256 "38cf4e84481f5facc766ba72783e7462e08d6d29a5d47e3b75c8ee3142485210"
    depends_on "llvm@13" => :build
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "68753cc80a085df9c1a37c33b9ce0dc1a52a54ee4d30b08ceb34adcd38c4187e"
    sha256 cellar: :any,                 arm64_big_sur:  "cb634dd3f4056a6af9fb473bb4df0ef9d43f72d87770013c90d1cfed917a3d65"
    sha256 cellar: :any,                 monterey:       "fb571c678a0b09b8121bf22beb0b5b7590c570126d996bd2453d0dc63556a79a"
    sha256 cellar: :any,                 big_sur:        "a68db737a48c93265857facdf97584eaa2db5557ddfddfa193f753ad8cf33bfd"
    sha256 cellar: :any,                 catalina:       "57ac5fe27bf9390bee7631c0b72e7f219bb07ef30a77ecbc45e38b7d1cbb5134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16147ff8975e5e77003c1c933d1bbcd5cc57b4250eb838503a6dfea96d68206f"
  end

  head do
    url "https://github.com/ziglang/zig.git", branch: "master"
    depends_on "llvm" => :build
  end

  depends_on "cmake" => :build

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    odie "HEAD installs of `zig` are broken until ziglang/zig#12923 is resolved!" if build.head?
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
