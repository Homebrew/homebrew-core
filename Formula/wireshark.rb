class Wireshark < Formula
  desc "Graphical network analyzer and capture tool"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-3.4.9.tar.xz"
  mirror "https://1.eu.dl.wireshark.org/src/all-versions/wireshark-3.4.9.tar.xz"
  sha256 "c6525e829bd24525ee699aa207ecd27c50646d64263a669671badfb71cd99620"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/wireshark/wireshark.git", branch: "master"

  livecheck do
    url "https://www.wireshark.org/download.html"
    regex(/Stable Release \((\d+(?:\.\d+)*)/i)
  end

  bottle do
    sha256 arm64_big_sur: "1ea892a48ea622868e01f59f5c31862e80785d4d1c276fedc17465512dce9dfd"
    sha256 big_sur:       "6885514683558139b01f9cb8820cf42d1474fb0b72b381996327ae64d7cb694c"
    sha256 catalina:      "c9e2893065d4b33debbb40453093c72781c6835a3df502713786aa9de69136cd"
    sha256 mojave:        "b0acdf1efbb775f4e9de3057ed00dcc73c438c532099d3b43e1dba20517fe0e4"
    sha256 x86_64_linux:  "518874dd9f83f422b433fd8211387db4d1385e6ce890cc4024aa651b4e1e0ee7"
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

  def install
    args = std_cmake_args + %W[
      -DENABLE_CARES=ON
      -DENABLE_GNUTLS=ON
      -DENABLE_MAXMINDDB=ON
      -DBUILD_wireshark_gtk=OFF
      -DENABLE_PORTAUDIO=OFF
      -DENABLE_LUA=ON
      -DLUA_INCLUDE_DIR=#{Formula["lua"].opt_include}/lua
      -DLUA_LIBRARY=#{Formula["lua"].opt_lib}/liblua.dylib
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
