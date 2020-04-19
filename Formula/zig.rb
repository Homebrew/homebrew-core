class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.6.0/zig-0.6.0.tar.xz"
  sha256 "5d167dc19354282dd35dd17b38e99e1763713b9be8a4ba9e9e69284e059e7204"
  revision 1
  head "https://github.com/ziglang/zig.git"

  bottle do
    cellar :any
    sha256 "0520a4469bb408ad4300e4711f7c50fcd970bb37d7f2343a02c5be964fbbeb6a" => :catalina
    sha256 "8a537f9c6091dcf2817201a4bd7dc09f718ded5f88431f7823d301e4eedd0139" => :mojave
    sha256 "0ab8d31b6563b943b54758a3f4d5292db5dc1340e1854fe27c8c4f85941d1e68" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  # Fix linking issues
  # https://github.com/Homebrew/homebrew-core/issues/53198
  patch :DATA

  def install
    system "cmake", ".", *std_cmake_args
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

__END__
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -384,6 +384,9 @@ target_link_libraries(zig_cpp LINK_PUBLIC
     ${CLANG_LIBRARIES}
     ${LLD_LIBRARIES}
     ${LLVM_LIBRARIES}
+    "-Wl,/usr/local/opt/llvm/lib/libPolly.a"
+    "-Wl,/usr/local/opt/llvm/lib/libPollyPPCG.a"
+    "-Wl,/usr/local/opt/llvm/lib/libPollyISL.a"
 )
