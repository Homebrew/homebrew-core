class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.13.0.tar.gz"
  sha256 "a4c0a7cec4b3e78cde7a9bcd051e3e6bcb88c671494745ac506f1843756a61a3"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fe970fd0b918ee604656eb3e6c121f5a6a8041fdbe56ac36fb71610aa2b435fd"
    sha256 cellar: :any,                 arm64_monterey: "e5bd952fc40d1bd243db30722a7d93ac5d97b394449419bc406eb68dc77adf0f"
    sha256 cellar: :any,                 arm64_big_sur:  "596b2b06e571cd7ecc9ec566e18d50a46c5dc65603bfe9527c3d50e69c19580a"
    sha256 cellar: :any,                 ventura:        "75e22fb43347b2f438946ec664c1ef76c89928c4f86eac387c79aeefb1bc7da5"
    sha256 cellar: :any,                 monterey:       "1059dcb272df222467b31ee108fec323d8fe07a1668e6e912e73f3543f609022"
    sha256 cellar: :any,                 big_sur:        "994824437848fe9311cf91f18654d4c6b48208322ac3cda67bf7be1d1de9d6ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d4ac7fad775c930524cdfde619c9ff43d63000d6e7fda4a00ee6f44c2935eab"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "libtool"
  depends_on "pcre"

  uses_from_macos "libpcap"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
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
