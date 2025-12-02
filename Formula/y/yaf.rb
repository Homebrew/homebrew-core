class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.18.1.tar.gz"
  sha256 "eebab530828deed9628c0d25e3ef663ec36a5dd992603f50fdf5824e19a30dea"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f2f5971533f3b725ed2f537a9004607869a73a1141afb9cbad853a39abe77240"
    sha256 cellar: :any,                 arm64_sequoia: "0b109a6ef2591b62c7df1cafb0c845b44449d0e20cc3cecf895ceb696c8c1745"
    sha256 cellar: :any,                 arm64_sonoma:  "282f3cba6b7f1564c39dbcd27162e476bfc82f0d567597f40e4a92d6eeb2def4"
    sha256 cellar: :any,                 sonoma:        "c95234ba360895c2239b7e8a85d544585972f44629d531f22409c21746f293e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23f7c28c6c571e3cc9058850532f2541a514ea34cb30183839d64e194303dabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d2e85a66482d0ef51a4932ef9b4fdc263474943054bff79e03de90e8abae04b"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "libtool"
  depends_on "pcre"

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "openssl@3"
  end

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    input = test_fixtures("test.pcap")
    output = pipe_output("#{bin}/yafscii", shell_output("#{bin}/yaf --in #{input}"))
    expected = "2014-10-02 10:29:06.168497 - 10:29:06.169875 (0.001378 sec) tcp " \
               "192.168.1.115:51613 => 192.168.1.118:80 71487608:98fc8ced " \
               "S/APF:AS/APF (7/453 <-> 5/578) rtt 451 us"
    assert_equal expected, output.strip
  end
end
