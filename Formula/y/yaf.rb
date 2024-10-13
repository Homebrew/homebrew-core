class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.16.1.tar.gz"
  sha256 "6005b8165831039e616cbcd7a450ac3e6daae051b4421d6294ad9c00688a14a2"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "741606b6161f1b09dfd4f897570961ae624c88176cd97dbd3a41130b47b530a1"
    sha256 cellar: :any,                 arm64_sonoma:  "1d52b1b512e7cb6007fa22894a859a02e660505290cf0bc99bff38487a2e447c"
    sha256 cellar: :any,                 arm64_ventura: "0bc3213396cc078555b6d6059effef5946d06eb87406a70961f47150a8cd0de7"
    sha256 cellar: :any,                 sonoma:        "1399ebb7bf5d482c87f119c588fa350c378d626c378ea1afa803aed0d51fd2ea"
    sha256 cellar: :any,                 ventura:       "47690d5e3d016b95501e23eb80b8bc18b79bbcf1ffd513fa367546d2b4a3a9ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0b09048f7e10ddaa4c419542f5ec672437103d257712a6ea6b43444670db950"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "libtool"
  depends_on "pcre"

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    input = test_fixtures("test.pcap")
    output = `#{bin}/yaf --in #{input} | #{bin}/yafscii`
    expected = "2014-10-02 10:29:06.168 - 10:29:06.169 (0.001 sec) tcp " \
               "192.168.1.115:51613 => 192.168.1.118:80 71487608:98fc8ced " \
               "S/APF:AS/APF (7/453 <-> 5/578) rtt 0 ms"
    assert_equal expected, output.strip
  end
end
