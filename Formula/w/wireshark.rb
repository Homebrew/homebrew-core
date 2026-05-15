class Wireshark < Formula
  desc "Network analyzer and capture tool - without graphical user interface"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-4.6.5.tar.xz"
  mirror "https://1.eu.dl.wireshark.org/src/all-versions/wireshark-4.6.5.tar.xz"
  sha256 "b5322538b20fa3e0bf004be83c534a42937d442be3f960d01b4e1f0db6c50386"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/wireshark/wireshark.git", branch: "master"

  # Upstream indicates stable releases with an even-numbered minor (see:
  # https://wiki.wireshark.org/Development/ReleaseNumbers).
  livecheck do
    url "https://www.wireshark.org/download.html"
    regex(/href=.*?wireshark[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "1e34f03cf9795aecd7947bb58ff3910408abc3bb63efd3c1a4a23bb34b2383ed"
    sha256                               arm64_sequoia: "0f6c690807d0af39d0bf94d50a7656f4615b9156a165a36aae13db76d031c757"
    sha256                               arm64_sonoma:  "c615c035c78537029d08eeaec64fbe6bc2bbc63254fedc248a62aa1948ced623"
    sha256                               sonoma:        "94a555a70d028d3507ada4b48e648968e3a0dba055c0eec4bee32996fa4986cc"
    sha256                               arm64_linux:   "c2a70492fb6e10258083db140679464628c5f3ac2f2ac3e6a8be784614e8eb97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc9acf8ce2a250f6b711d27b610fea3f62b0ae9bffb24e00a62b3a2cd6bcdf86"
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
      -DCARES_INCLUDE_DIR=#{Formula["c-ares"].opt_include}
      -DGCRYPT_INCLUDE_DIR=#{Formula["libgcrypt"].opt_include}
      -DGNUTLS_INCLUDE_DIR=#{Formula["gnutls"].opt_include}
      -DMAXMINDDB_INCLUDE_DIR=#{Formula["libmaxminddb"].opt_include}
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
