class Wireshark < Formula
  desc "Graphical network analyzer and capture tool"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-4.1.0.tar.xz"
  mirror "https://1.eu.dl.wireshark.org/src/all-versions/wireshark-4.1.0.tar.xz"
  sha256 "9a32ae59f0a843aefd8856c0d208fc464b93ce9415fb8da8723c550c840ab1d5"
  license "GPL-2.0-or-later"
  revision 1
  head "https://gitlab.com/wireshark/wireshark.git", branch: "master"

  # Upstream indicates stable releases with an even-numbered minor (see:
  # https://wiki.wireshark.org/Development/ReleaseNumbers).
  livecheck do
    url "https://www.wireshark.org/download.html"
    regex(/href=.*?wireshark[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "cb8e10b484c692bc280a5beb61530e7289ae7729ed5225d734d876b35e0911d8"
    sha256                               arm64_ventura:  "6db5381e512659b8320d83fc752d25080fbbde6d7db529113d9bc0e653ceeee8"
    sha256                               arm64_monterey: "328a6e3e2669f0fc6773db0ae03d24d24d30cde3d4fc153c282885e752130cd1"
    sha256                               arm64_big_sur:  "f152097880272bd8295ffe86037f582026cc8717183f389e682a4e66ddaf7468"
    sha256                               sonoma:         "0148a22305e2a1924433aa4cf355e420f216b16d1456a411589cdd1989a0dd3b"
    sha256                               ventura:        "48c07ebec0010af5f97efd18a38900e2ed88c999ab7364ec7666ee2903bda31c"
    sha256                               monterey:       "3db805ae9444acfd8fe58b42a1d30e245b3fd62a8f7e155ff1df9fdf2c5e38c6"
    sha256                               big_sur:        "95dce7c79103a61049e7750be7665f6de877181753a827abf83f92c94f767b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "757e56afe26f46ad893658d93a57d92eca3bd759c19f5fe42d45f4dfde21f20a"
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
  depends_on "speexdsp"

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
    system "cmake", "--install", "build", "--component", "Development"
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
    (testpath/"test.cpp").write <<~EOS
      #include <stdio.h>
      #include <ws_version.h>

      int main() {
        printf("%d.%d.%d", WIRESHARK_VERSION_MAJOR, WIRESHARK_VERSION_MINOR,
               WIRESHARK_VERSION_MICRO);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}/wireshark", "-o", "test"
    output = shell_output("./test")
    assert_equal version.to_s, output
    system bin/"randpkt", "-b", "100", "-c", "2", "capture.pcap"
    output = shell_output("#{bin}/capinfos -Tmc capture.pcap")
    assert_equal "File name,Number of packets\ncapture.pcap,2\n", output
  end
end
