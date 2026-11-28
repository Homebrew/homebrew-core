class Wireshark < Formula
  desc "Network analyzer and capture tool - without graphical user interface"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-4.6.10.tar.xz"
  mirror "https://1.eu.dl.wireshark.org/src/all-versions/wireshark-4.6.10.tar.xz"
  sha256 "268f41bdf8acee561b670217cf6ea74cf9e779477543e59f92f1cd00294a03dd"
  license "GPL-2.0-or-later"
  compatibility_version 1
  head "https://gitlab.com/wireshark/wireshark.git", branch: "master"

  # Upstream indicates stable releases with an even-numbered minor (see:
  # https://wiki.wireshark.org/Development/ReleaseNumbers).
  livecheck do
    url "https://www.wireshark.org/download.html"
    regex(/href=.*?wireshark[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    manifest_sha256 "2d20c7a487163ea1f4fba1f458b72a262ad5d54f96755489ef27686503b65319"
    sha256               arm64_golden_gate: "62eb1e7f449d42c23cde3e21648419ed2a8692aa4e01b2f95edce4982a99382f"
    sha256               arm64_tahoe:       "c3264739cd1f8b05c944d7f0e45e79693be1d231e8035c3871427a6900d8e910"
    sha256               arm64_sequoia:     "3482dfbfb587c637dc9ff170f08815f037a0e31e473ac847ef3777da839ded87"
    sha256               arm64_linux:       "5418842e1e2e26bfef4b0ffa81697e222bf793754d8d9c5e110aac667460356b"
    sha256 cellar: :any, x86_64_linux:      "698b23407766a4d8bb72e49ff55d783c5840f52daa4dfb4aa66b0f539f38e701"
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

  deny_network_access!

  def install
    lua = dep("lua")
    plugindir = lib/"wireshark/plugins/#{version.major}-#{version.minor}"
    extcap_rpath = rpath(source: libexec/"wireshark/extcap")
    codecs_rpath = rpath(source: plugindir/"codecs")
    args = %W[
      -DENABLE_BROTLI=OFF
      -DENABLE_SNAPPY=OFF
      -DLUA_INCLUDE_DIR=#{lua.opt_include}/lua
      -DLUA_LIBRARY=#{lua.opt_lib}/#{shared_library("liblua")}
      -DCARES_INCLUDE_DIR=#{formula_opt_include("c-ares")}
      -DGCRYPT_INCLUDE_DIR=#{formula_opt_include("libgcrypt")}
      -DGNUTLS_INCLUDE_DIR=#{formula_opt_include("gnutls")}
      -DMAXMINDDB_INCLUDE_DIR=#{formula_opt_include("libmaxminddb")}
      -DBUILD_wireshark=OFF
      -DBUILD_logray=OFF
      -DENABLE_APPLICATION_BUNDLE=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath};#{extcap_rpath}
      -DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,#{codecs_rpath}
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
