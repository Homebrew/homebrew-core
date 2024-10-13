class Ssldump < Formula
  desc "SSLv3/TLS network protocol analyzer"
  homepage "https://adulau.github.io/ssldump/"
  url "https://github.com/adulau/ssldump/archive/refs/tags/v1.8.tar.gz"
  sha256 "fa1bb14034385487cc639fb32c12a5da0f8fbfee4603f4e101221848e46e72b3"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e03414b1accfe6900e7ca54b236c583dceced96e8d93ab5d06733240cd8b5961"
    sha256 cellar: :any,                 arm64_sonoma:   "5a04f758e392c85c23e64281e62e56355494e8c17cc2916d4b5b3496e13337c6"
    sha256 cellar: :any,                 arm64_ventura:  "48bec7a09eb15f3b58e960495016638e6a8b8c2e041f00f20d2ef7d7b7197917"
    sha256 cellar: :any,                 arm64_monterey: "bf61f7bbad2f9c944136b9338cc2ad2ae7a7d501f72762ee03969bb8f95e7290"
    sha256 cellar: :any,                 sonoma:         "ec039ce32c6879ccc9febdfd3cc80aefbf434fdd53191046ceecacf74625470d"
    sha256 cellar: :any,                 ventura:        "af9a81b16fc912ffd160db362c9e78512e9d06452d028045dea42491a23afc5d"
    sha256 cellar: :any,                 monterey:       "97a5488ee177f7e6fa0dd65ec4f06dfb61a94719577c44ee44cf231111be2b91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2431676c289f4b0000dbff8a7c131803dc06385d18f9445affbbe1f83b1c1810"
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "libnet"
  depends_on "libpcap"
  depends_on "openssl@3"

  # Temporarily apply patch to not ignore our preferred destination directories
  # Remove for >=1.9
  patch :DATA

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"ssldump", "-v"
  end
end

__END__
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -8,6 +7,9 @@ project(
     LANGUAGES C
 )
 
+include(CheckSymbolExists)
+include(GNUInstallDirs)
+
 configure_file(base/pcap-snoop.c.in base/pcap-snoop.c)
 
 set(SOURCES
@@ -110,8 +112,5 @@ target_link_libraries(ssldump
         ${JSONC_LIBRARIES}
 )
 
-set(CMAKE_INSTALL_PREFIX "/usr/local")
-install(TARGETS ssldump DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
-
-set(CMAKE_INSTALL_MANDIR "/usr/local/share/man")
+install(TARGETS ssldump DESTINATION ${CMAKE_INSTALL_BINDIR})
 install(FILES ssldump.1 DESTINATION ${CMAKE_INSTALL_MANDIR}/man1)
