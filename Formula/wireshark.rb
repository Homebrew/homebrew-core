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
    sha256 arm64_ventura:  "ed981aeab980341210869eebe5c4bdef8ab52e4309087d65c2d30cac64f989df"
    sha256 arm64_monterey: "f088621c27caec85b4183c6fdf6b153767db17cc632093da55abb348416209fa"
    sha256 arm64_big_sur:  "9468c9ac26dcabc6ab915aae8b65c955995702456c0cdaa199bc5c41386e206d"
    sha256 ventura:        "0f8a37c382c7aa0e38069e62314facc2ba29cd24a23fc8a679fac73ff8a0873b"
    sha256 monterey:       "fcb648f3da10afe95ad67755fa519e7430ee5063d08e460cfd2fbe1dca6fa888"
    sha256 big_sur:        "a15cbb5b88689312cc419a7ed92f0321c61fa2c3733a64e1d75df90ed6dcb38b"
    sha256 x86_64_linux:   "aa61d106a0d3975f51adfa64a3b8de1c3c7e0eb29e6deff07389debe2408175c"
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
