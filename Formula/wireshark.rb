class Wireshark < Formula
  desc "Graphical network analyzer and capture tool"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-3.2.2.tar.xz"
  mirror "https://1.eu.dl.wireshark.org/src/all-versions/wireshark-3.2.2.tar.xz"
  sha256 "5f5923ef4c3fee370ed0ca1bb324f37c246015eba4a7e74ab95d9208feeded79"
  head "https://code.wireshark.org/review/wireshark", :using => :git

  bottle do
    sha256 "c0509d8a6fe03675bea1a9f3d2f8db62790000a02e2363202ff384d646feb4ab" => :catalina
    sha256 "e55d0fe730ec7c96ccfa16d3c1b2bc5ba5638e496543c8b0fb332bfef5f39c85" => :mojave
    sha256 "cddabe5267aa896a8c6b22adad6f6f9b6754bfcc0b9a4fee25ebfedd801275a2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "c-ares"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libmaxminddb"
  depends_on "libsmi"
  depends_on "libssh"
  depends_on "lua@5.1"
  depends_on "nghttp2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    args = std_cmake_args + %W[
      -DENABLE_CARES=ON
      -DENABLE_GNUTLS=ON
      -DENABLE_MAXMINDDB=ON
      -DBUILD_wireshark_gtk=OFF
      -DENABLE_PORTAUDIO=OFF
      -DENABLE_LUA=ON
      -DLUA_INCLUDE_DIR=#{Formula["lua@5.1"].opt_include}/lua-5.1
      -DLUA_LIBRARY=#{Formula["lua@5.1"].opt_lib}/liblua5.1.dylib
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

  def caveats; <<~EOS
    This formula only installs the command-line utilities by default.

    Install Wireshark.app with Homebrew Cask:
      brew cask install wireshark

    If your list of available capture interfaces is empty
    (default macOS behavior), install ChmodBPF:
      brew cask install wireshark-chmodbpf
  EOS
  end

  test do
    system bin/"randpkt", "-b", "100", "-c", "2", "capture.pcap"
    output = shell_output("#{bin}/capinfos -Tmc capture.pcap")
    assert_equal "File name,Number of packets\ncapture.pcap,2\n", output
  end
end
