class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/v2.1.1.tar.gz"
  sha256 "29627520c81101de01b0213434adb218a9f1210bfd3f2dcfdfc1f975dbce6399"
  license "Apache-2.0"
  revision 2
  head "https://github.com/zmap/zmap.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "3ea3dd65e8b77906443e60b1fecbaca531493c6b073c0b821116be968d65502e"
    sha256 arm64_big_sur:  "142f0a0643a81aa7c4cd350d60c0879406524e867b8d6891265a2260e22d6ccb"
    sha256 monterey:       "dc5f4713ce9f3a9df3e6a4008c88dbfcf5e7732cde0ee3fd7e16b8006cbbab62"
    sha256 big_sur:        "4fbcf0453c48feae254c0799fdb38dc489ab435a9fd8f71f4f40490cb61a7272"
    sha256 catalina:       "7f3dce955fb01597407317a81e6d1e0b60d66756e64358f11106adf5335b820a"
    sha256 mojave:         "3014cc393e0d9b5e6705392a10da8588f26d668daa5660aebe252ed514bf176e"
    sha256 high_sierra:    "99c0f7e06b2789fb57bd465a5a1fe35628b6d5e624ebba32d7f1199abc78d8bf"
    sha256 x86_64_linux:   "31a5211efb8b10ea9fadbc9f6720fd6aef62ee5bf8df6689c391b2ac66677c86"
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
@@ -71,7 +71,7 @@ if(WITH_JSON)
         message(FATAL_ERROR "Did not find libjson")
     endif()

-    add_definitions("-DJSON")
+    string(REPLACE ";" " " JSON_CFLAGS "${JSON_CFLAGS}")
     set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${JSON_CFLAGS}")
 endif()
