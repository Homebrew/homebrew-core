class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  license "MIT"
  head "https://github.com/ziglang/zig.git", branch: "master"

  stable do
    url "https://ziglang.org/download/0.10.0/zig-0.10.0.tar.xz"
    sha256 "d8409f7aafc624770dcd050c8fa7e62578be8e6a10956bca3c86e8531c64c136"

    on_macos do
      # We need to make sure there is enough space in the MachO header when we rewrite install names.
      # https://github.com/ziglang/zig/issues/13388
      patch :DATA
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "01af7e89a24e093d0a9237fd46cac44adf68a9abf43cbeab2d19f375c587728d"
    sha256 cellar: :any,                 arm64_monterey: "7bd6777182b5b0d39aa73c0840b5d9619c76e0328cf48909648ef134ab0c8c2f"
    sha256 cellar: :any,                 arm64_big_sur:  "c501006d75235e835705010031188f1e840f5e977c4022981bee7d95d9dd5e35"
    sha256 cellar: :any,                 ventura:        "55c9562de04c6bc2f14e2a0d78e04bcfca087c567222b0f273ca828c2bd11910"
    sha256 cellar: :any,                 monterey:       "f1df3f7f4fc4d266d5af55a7adacd17d38d47385f863a92902beecd434af1086"
    sha256 cellar: :any,                 big_sur:        "8e9858adbecf1870e59028794a70e0e37c26ffe513301fb4d88e92819c3c160a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cf9a390995748c4450c9b748cae48f333371a97d4f4fbe5c373ed64a2ca9166"
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

__END__
diff --git a/build.zig b/build.zig
index e5e80b4..1da6892 100644
--- a/build.zig
+++ b/build.zig
@@ -154,6 +154,7 @@ pub fn build(b: *Builder) !void {
 
     exe.stack_size = stack_size;
     exe.strip = strip;
+    exe.headerpad_max_install_names = true;
     exe.sanitize_thread = sanitize_thread;
     exe.build_id = b.option(bool, "build-id", "Include a build id note") orelse false;
     exe.install();
