class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.6.0/zig-0.6.0.tar.xz"
  sha256 "5d167dc19354282dd35dd17b38e99e1763713b9be8a4ba9e9e69284e059e7204"
  license "MIT"
  revision 1
  head "https://github.com/ziglang/zig.git"

  bottle do
    cellar :any
    sha256 "56d061f373c70fe00ae0d38f1aace3d719123219d211ff50d613aa7d7d34c7f9" => :catalina
    sha256 "dd0354fc2c222ca360577701e554fe2acc6c6a6884906ec721c6602b98e9d2bf" => :mojave
    sha256 "10bca4e34e31a22c30ba447ecf999b32fd7b186e8083051458ee5694ffd493f8" => :high_sierra
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
