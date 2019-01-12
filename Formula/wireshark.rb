class Wireshark < Formula
  desc "Graphical network analyzer and capture tool"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-2.6.6.tar.xz"
  mirror "https://1.eu.dl.wireshark.org/src/wireshark-2.6.6.tar.xz"
  sha256 "487933ea075bdbb25d8df06017d9c4f49fc20eb7f6ec80af086718ed5550e863"
  head "https://code.wireshark.org/review/wireshark", :using => :git

  bottle do
    sha256 "14930696b3d8b186abb0d76fcc8ce2e77a81bce1974f977cb7fe72a2d57dcfb5" => :mojave
    sha256 "f67946bde540a9373dc8cd5f5dc92cc294c7085f27815e6994470c248d39884d" => :high_sierra
    sha256 "b8eb1a5cfa08703cd2389f3f74e3dadd6ede6c9f9fd80476c8b06f46d3a27ef0" => :sierra
  end

  option "with-qt", "Build the wireshark command with Qt"

  deprecated_option "with-qt5" => "with-qt"

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
  depends_on "qt" => :optional

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
    ]

    if build.with? "qt"
      args << "-DBUILD_wireshark=ON"
      args << "-DENABLE_APPLICATION_BUNDLE=ON"
      args << "-DENABLE_QT5=ON"
    else
      args << "-DBUILD_wireshark=OFF"
      args << "-DENABLE_APPLICATION_BUNDLE=OFF"
      args << "-DENABLE_QT5=OFF"
    end

    system "cmake", *args
    system "make", "install"

    if build.with? "qt"
      prefix.install bin/"Wireshark.app"
      bin.install_symlink prefix/"Wireshark.app/Contents/MacOS/Wireshark" => "wireshark"
    end

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

    Wireshark.app can be downloaded directly from the website:
      https://www.wireshark.org/

    Alternatively, install with Homebrew Cask:
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
