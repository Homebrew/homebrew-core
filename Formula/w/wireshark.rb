class Wireshark < Formula
  desc "Network analyzer and capture tool - without graphical user interface"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-4.6.0.tar.xz"
  mirror "https://1.eu.dl.wireshark.org/src/all-versions/wireshark-4.6.0.tar.xz"
  sha256 "ab016463062bb635285b9678dd45ddd84c65938911fd40b3cca9a903a08ad8d9"
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
    sha256                               arm64_tahoe:   "0be567a2410a1943f6aa48f6d7ebd41785b8742b9a2a7e52263e7404fe0d21ae"
    sha256                               arm64_sequoia: "cd775354ae62c51a2d70c1778fc2478632ab51309b71a25dcd0404e1ee6cfbd0"
    sha256                               arm64_sonoma:  "0b5b2f45a6513bcabea5a638d8fc0eb21fee00bfa8ffd17a29c6999267687b6c"
    sha256                               sonoma:        "ac57ba34a566fa522e22c8a0693ce6d780e0a6a91034883462bf694dd62c2d5c"
    sha256                               arm64_linux:   "093f5cfb0f3d7512c9a85956e971e8660ac3d88aaf9d4dcb0b8463154340a3c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cad6a7c06dca4c74ddc501e432d1d1ccf7d905d51d5da70e292edc5f6ef6ef9"
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
  depends_on "pcre2"
  depends_on "speexdsp"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build
  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libgpg-error"
  end

  conflicts_with cask: "wireshark-app"

  def install
    args = %W[
      -DLUA_INCLUDE_DIR=#{Formula["lua"].opt_include}/lua
      -DLUA_LIBRARY=#{Formula["lua"].opt_lib/shared_library("liblua")}
      -DCARES_INCLUDE_DIR=#{Formula["c-ares"].opt_include}
      -DGCRYPT_INCLUDE_DIR=#{Formula["libgcrypt"].opt_include}
      -DGNUTLS_INCLUDE_DIR=#{Formula["gnutls"].opt_include}
      -DMAXMINDDB_INCLUDE_DIR=#{Formula["libmaxminddb"].opt_include}
      -DBUILD_wireshark=OFF
      -DBUILD_logray=OFF
      -DENABLE_APPLICATION_BUNDLE=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
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
