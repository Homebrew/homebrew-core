class Wireshark < Formula
  desc "Network analyzer and capture tool - without graphical user interface"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-4.4.9.tar.xz"
  mirror "https://1.eu.dl.wireshark.org/src/all-versions/wireshark-4.4.9.tar.xz"
  sha256 "60551dc787f41e87aeaa1e9c33304f9008037e3baf9fa11aef9c2d584cc0b54b"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/wireshark/wireshark.git", branch: "master"

  # Upstream indicates stable releases with an even-numbered minor (see:
  # https://wiki.wireshark.org/Development/ReleaseNumbers).
  livecheck do
    url "https://www.wireshark.org/download.html"
    regex(/href=.*?wireshark[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "c039be942f3c8cc97f07111ce62cb8085764552d53833235340a47963d1b917b"
    sha256                               arm64_sequoia: "75c17ac368b370f7393a39db6e533539c855b73be9292c2f47d89eb897c9c439"
    sha256                               arm64_sonoma:  "e1169a1bb7af40cca14b8e2b141369c5a62cca5640eba098ba06c1241578025b"
    sha256                               arm64_ventura: "5a49ba751f8952f96e7335f5719489c14017f1584879952445dd07563cbb762a"
    sha256                               sonoma:        "14829ba5a1935a484f4fa58d815af9b45b96ca773bfb936dedcbdf8eaa250c47"
    sha256                               ventura:       "cf1294643ad99f105eb5767a11c68b695f165c0767443ed219a98f209fd053fd"
    sha256                               arm64_linux:   "d7cd0d349cb68a59daa9f9a2b80e5031ae219c408ccffa7830c99e03017a25f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0362a0f74ff0a78d82c78782116aa93ce89dc68249c7b1e4d52a2db04a7abd0"
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
