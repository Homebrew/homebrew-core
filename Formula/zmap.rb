class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/v2.1.1.tar.gz"
  sha256 "29627520c81101de01b0213434adb218a9f1210bfd3f2dcfdfc1f975dbce6399"
  license "Apache-2.0"
  revision 2
  head "https://github.com/zmap/zmap.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "4f6a24cc441b2c1591370d13cd9f9b58b391780e4aee353976dd9698b1a85c2c"
    sha256 arm64_big_sur:  "c1ee5777fb69a3df8b0b0107404effdbaa3a6d73138fda9a93f279efd9c0bb8d"
    sha256 monterey:       "f68c0305b46be402d4b41bb709960228e76f4c17b7b39f42cdd5b11460dea905"
    sha256 big_sur:        "edcf5c3a608c25386b8b5719ffba9ee6f18a140593c4dc941b43a768d1d14084"
    sha256 catalina:       "7e94d9738a92dff6de1e76d69ab0e38ca7c6488d06c34d5bb40c3aa8cb08c8f4"
    sha256 x86_64_linux:   "bf4676cca925307267ddc7fae14da7c3d4857a4636088a2c3361ec193ebc2137"
  end

  depends_on "byacc" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "json-c"
  depends_on "libdnet"

  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"

  # fix json-c 0.14 compat
  # ref PR, https://github.com/zmap/zmap/pull/609
  patch :DATA

  def install
    inreplace ["conf/zmap.conf", "src/zmap.c", "src/zopt.ggo.in"], "/etc", etc

    system "cmake", ".", *std_cmake_args, "-DENABLE_DEVELOPMENT=OFF",
                         "-DRESPECT_INSTALL_PREFIX_CONFIG=ON"
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/zmap", "--version"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 8bd825f..c70b651 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -72,6 +72,7 @@
     endif()

     add_definitions("-DJSON")
+    string(REPLACE ";" " " JSON_CFLAGS "${JSON_CFLAGS}")
     set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${JSON_CFLAGS}")
 endif()
