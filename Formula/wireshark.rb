class Wireshark < Formula
  desc "Graphical network analyzer and capture tool"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-4.0.1.tar.xz"
  mirror "https://1.eu.dl.wireshark.org/src/all-versions/wireshark-4.0.1.tar.xz"
  sha256 "b3b002f99d13bbf47f9ed3be7eb372cb0c2454bd0faea29a756819ce019ffdc2"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/wireshark/wireshark.git", branch: "master"

  livecheck do
    url "https://www.wireshark.org/download.html"
    regex(/Stable Release \((\d+(?:\.\d+)*)/i)
  end

  bottle do
    sha256 arm64_ventura:  "de7c25233ad9a993dfb56ffb5ad03c2aa4c3aaaba224959f5c9a1cb17a172beb"
    sha256 arm64_monterey: "ae77fc53c5c561de9dd9e2bfad2f7e44d22208808363808c824e26ec3cd229ab"
    sha256 arm64_big_sur:  "c53abfe4e20e32f373caa9fe7ef85b105451c8b4657c46b77e46a8118b75153b"
    sha256 ventura:        "e099a04650db7e9dbb348e21bf157685973b48f19adc5c07b8090851412fd28e"
    sha256 monterey:       "459152ef6495b5c962a904d291089af617df4193f92f86b29e1065f0a83ee98a"
    sha256 big_sur:        "d66559ed91b1546c6eb4cecabb2f8e5fed32daef2201addd2b40d540974d21b4"
    sha256 catalina:       "ee3b0ba0c35d0d456bdc818639319356176eb7b59be75e8d48251aa1dbe72744"
    sha256 x86_64_linux:   "d0f60fc3c648d4f41677cab1e0b23f43c61d35d37e1cbd1a1641cbf527d87b1f"
  end

  depends_on "cmake" => :build
  depends_on "c-ares"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libmaxminddb"
  depends_on "libnghttp2"
  depends_on "libsmi"
  depends_on "libssh"
  depends_on "lua"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build
  uses_from_macos "libpcap"

  def install
    args = std_cmake_args + %W[
      -DENABLE_CARES=ON
      -DENABLE_GNUTLS=ON
      -DENABLE_MAXMINDDB=ON
      -DBUILD_wireshark_gtk=OFF
      -DENABLE_PORTAUDIO=OFF
      -DENABLE_LUA=ON
      -DLUA_INCLUDE_DIR=#{Formula["lua"].opt_include}/lua
      -DLUA_LIBRARY=#{Formula["lua"].opt_lib/shared_library("liblua")}
      -DCARES_INCLUDE_DIR=#{Formula["c-ares"].opt_include}
      -DGCRYPT_INCLUDE_DIR=#{Formula["libgcrypt"].opt_include}
      -DGNUTLS_INCLUDE_DIR=#{Formula["gnutls"].opt_include}
      -DMAXMINDDB_INCLUDE_DIR=#{Formula["libmaxminddb"].opt_include}
      -DENABLE_SMI=ON
      -DBUILD_sshdump=ON
      -DBUILD_ciscodump=ON
      -DENABLE_NGHTTP2=ON
      -DBUILD_wireshark=OFF
      -DENABLE_APPLICATION_BUNDLE=OFF
      -DENABLE_QT5=OFF
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
    ]

    system "cmake", *args, "."
    system "make", "install"

    # Install headers
    (include/"wireshark").install Dir["*.h"]
    (include/"wireshark/epan").install Dir["epan/*.h"]
    (include/"wireshark/epan/crypt").install Dir["epan/crypt/*.h"]
    (include/"wireshark/epan/dfilter").install Dir["epan/dfilter/*.h"]
    (include/"wireshark/epan/dissectors").install Dir["epan/dissectors/*.h"]
    (include/"wireshark/epan/ftypes").install Dir["epan/ftypes/*.h"]
    (include/"wireshark/epan/wmem").install Dir["epan/wmem/*.h"]
    (include/"wireshark/wiretap").install Dir["wiretap/*.h"]
    (include/"wireshark/wsutil").install Dir["wsutil/*.h"]
  end

  def caveats
    <<~EOS
      This formula only installs the command-line utilities by default.

      Install Wireshark.app with Homebrew Cask:
        brew install --cask wireshark

      If your list of available capture interfaces is empty
      (default macOS behavior), install ChmodBPF:
        brew install --cask wireshark-chmodbpf
    EOS
  end

  test do
    system bin/"randpkt", "-b", "100", "-c", "2", "capture.pcap"
    output = shell_output("#{bin}/capinfos -Tmc capture.pcap")
    assert_equal "File name,Number of packets\ncapture.pcap,2\n", output
  end
end
