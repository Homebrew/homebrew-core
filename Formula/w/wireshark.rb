class Wireshark < Formula
  desc "Network analyzer and capture tool - without graphical user interface"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-4.6.7.tar.xz"
  mirror "https://1.eu.dl.wireshark.org/src/all-versions/wireshark-4.6.7.tar.xz"
  sha256 "242929b8c10ba89a8d3bcad7ff2eba8effb648d30f48e270d2e5e6ff94d88613"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/wireshark/wireshark.git", branch: "master"

  # Upstream indicates stable releases with an even-numbered minor (see:
  # https://wiki.wireshark.org/Development/ReleaseNumbers).
  livecheck do
    url "https://www.wireshark.org/download.html"
    regex(/href=.*?wireshark[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256               arm64_tahoe:   "c46e6a684ed35855f5eacf43dffee7030ee542ddb771b703268dbae81e7183c2"
    sha256               arm64_sequoia: "7d83df9266676038a4de052174d4d62686e6fd49275bccf97f61cd913ab046cf"
    sha256               arm64_sonoma:  "1a188ada18ffdca93ad92df9449807cb831f24cc9450a431c14aa65b40def1f2"
    sha256               sonoma:        "3ed6decb7b6c0d1a1884b92ffdd765faf728cd513a91960d5878549f9f28b38b"
    sha256               arm64_linux:   "1065611e4f391a1270e0a69a543321a0066251d6f70b1c2aa95baf3a86df90cc"
    sha256 cellar: :any, x86_64_linux:  "d11cf6f0afe4cb21a94f5cb9ecd312dc1e3ef8f19e69da80bad5879fb90a3756"
  end

  depends_on "cmake" => :build
  depends_on "c-ares"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libmaxminddb"
  depends_on "libnghttp2"
  depends_on "libnghttp3"
  depends_on "libsmi"
  depends_on "libssh"
  depends_on "lua"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "speexdsp"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build
  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "libgpg-error"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with cask: "wireshark-app"

  def install
    lua = Formula["lua"]
    plugindir = lib/"wireshark/plugins/#{version.major}-#{version.minor}"
    args = %W[
      -DENABLE_BROTLI=OFF
      -DENABLE_SNAPPY=OFF
      -DLUA_INCLUDE_DIR=#{lua.opt_include}/lua
      -DLUA_LIBRARY=#{lua.opt_lib/shared_library("liblua")}
      -DCARES_INCLUDE_DIR=#{formula_opt_include("c-ares")}
      -DGCRYPT_INCLUDE_DIR=#{formula_opt_include("libgcrypt")}
      -DGNUTLS_INCLUDE_DIR=#{formula_opt_include("gnutls")}
      -DMAXMINDDB_INCLUDE_DIR=#{formula_opt_include("libmaxminddb")}
      -DBUILD_wireshark=OFF
      -DBUILD_logray=OFF
      -DENABLE_APPLICATION_BUNDLE=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: libexec/"wireshark/extcap")}
      -DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,#{rpath(source: plugindir/"codecs")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "--install", "build", "--component", "Development"
  end

  def caveats
    <<~EOS
      This formula only installs the command-line utilities by default.

      Install Wireshark.app with Homebrew Cask:
        brew install wireshark-app

      If your list of available capture interfaces is empty
      (default macOS behavior), install ChmodBPF:
        brew install --cask wireshark-chmodbpf
    EOS
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <stdio.h>
      #include <ws_version.h>

      int main() {
        printf("%d.%d.%d", WIRESHARK_VERSION_MAJOR, WIRESHARK_VERSION_MINOR,
               WIRESHARK_VERSION_MICRO);
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}/wireshark", "-o", "test"
    output = shell_output("./test")
    assert_equal version.to_s, output
    system bin/"randpkt", "-b", "100", "-c", "2", "capture.pcap"
    output = shell_output("#{bin}/capinfos -Tmc capture.pcap")
    assert_equal "File name,Number of packets\ncapture.pcap,2\n", output
  end
end
