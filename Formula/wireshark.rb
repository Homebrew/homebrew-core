class Wireshark < Formula
  desc "Graphical network analyzer and capture tool"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-2.6.2.tar.xz"
  mirror "https://1.eu.dl.wireshark.org/src/wireshark-2.6.2.tar.xz"
  sha256 "49b2895ee3ba17ef9ef0aebfdc4d32a778e0f36ccadde184516557d5f3357094"
  head "https://code.wireshark.org/review/wireshark", :using => :git

  bottle do
    sha256 "a0e08a86c763b6d102b09a4bcef154b4959e13e38f978132fd5f0d28b0c1282c" => :high_sierra
    sha256 "28ed5d2ad2b272d17dd104f0a58dbfb63b37a91438b70f631a9cec398d3f1626" => :sierra
    sha256 "1b2cea3e894914ee3b853eb9d082720d988182c862c0c9b6514b7fc8685e7dda" => :el_capitan
  end

  deprecated_option "with-qt5" => "with-qt"

  option "with-qt", "Build the wireshark command with Qt"
  option "with-headers", "Install Wireshark library headers for plug-in development"
  option "with-nghttp2", "Enable HTTP/2 header dissection"

  depends_on "cmake" => :build
  depends_on "c-ares"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libmaxminddb"
  depends_on "lua@5.1"
  depends_on "libsmi" => :optional
  depends_on "libssh" => :optional
  depends_on "nghttp2" => :optional
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

    if build.with? "libsmi"
      args << "-DENABLE_SMI=ON"
    else
      args << "-DENABLE_SMI=OFF"
    end

    if build.with? "libssh"
      args << "-DBUILD_sshdump=ON" << "-DBUILD_ciscodump=ON"
    else
      args << "-DBUILD_sshdump=OFF" << "-DBUILD_ciscodump=OFF"
    end

    if build.with? "nghttp2"
      args << "-DENABLE_NGHTTP2=ON"
    else
      args << "-DENABLE_NGHTTP2=OFF"
    end

    system "cmake", *args
    system "make", "install"

    if build.with? "qt"
      prefix.install bin/"Wireshark.app"
      bin.install_symlink prefix/"Wireshark.app/Contents/MacOS/Wireshark" => "wireshark"
    end

    if build.with? "headers"
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
  end

  def caveats; <<~EOS
    This formula only installs the command-line utilities by default.

    Wireshark.app can be downloaded directly from the website:
      https://www.wireshark.org/

    Alternatively, install with Homebrew-Cask:
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
