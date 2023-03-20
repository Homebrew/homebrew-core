class Wireshark < Formula
  desc "Graphical network analyzer and capture tool"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-4.0.4.tar.xz"
  mirror "https://1.eu.dl.wireshark.org/src/all-versions/wireshark-4.0.4.tar.xz"
  sha256 "a4a09f6564f00639036ffe5064ac4dc2176adfa3e484c539c9c73f835436e74b"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/wireshark/wireshark.git", branch: "master"

  livecheck do
    url "https://www.wireshark.org/download.html"
    regex(/href=.*?wireshark[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "40ff9c2bf1f2e88ce4e08c2f4ec1e4402eeee3ecc3a605cd03ab8cd58c35d42b"
    sha256 arm64_monterey: "529c4be5b86deb78b886d450b1d4374a011e925bf82fd9933243c4cf9e38f20b"
    sha256 arm64_big_sur:  "db35a1acfc71d429db258e1108b6a42b2a265fa3486f090becab608d01d62607"
    sha256 ventura:        "bdf6ee39d2607dbb4d64d9a1c4e4e3665640d8a2e68356cc0f005d15ea76c73a"
    sha256 monterey:       "00f8fcbcd0d77094a022115052a075afe6329fd0c352e61dd965b0779456ae0c"
    sha256 big_sur:        "1909bb2787d8fffdb0140c0c72baf61beb464c28f39aa1bb13b96f9e54eddf9d"
    sha256 x86_64_linux:   "8b831cb4b63c8b5176d62f96ae424fcb58408b657b02ffd36547fa4330bd7bee"
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
  uses_from_macos "libxml2"

  def install
    args = %W[
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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
