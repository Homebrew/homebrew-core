class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.14.0.tar.gz"
  sha256 "cf9e40428690387de7db78e27981c47b72664e4129a6b348ed19ea831f2ee019"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f8e5cf2ae79c6980e61e89844418c6877b5e2a48d1ddea6a70c1e83965c9cca9"
    sha256 cellar: :any,                 arm64_monterey: "26d046bf80b87c66a59515c66ccadd69c12e1852fad7923ae658e865d05bdedb"
    sha256 cellar: :any,                 arm64_big_sur:  "f4481baef958c27b898d2bd139ac1f1dcf27be85dd76345e800f37e73a9f6b91"
    sha256 cellar: :any,                 ventura:        "68217cf50e582cbf0f1dd02dbe383b8aedbbdab185dfeebae85c28c6afec17d8"
    sha256 cellar: :any,                 monterey:       "ffcb9bd872071d72353b7ed1e901e1750fc862e36d9e06efa6138f08ffafeaa2"
    sha256 cellar: :any,                 big_sur:        "0c952e1ff5d8dc8e78e142d365ad91b4564b8eb5db1522128e27c631418beedc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6683dff5df2b4aab7de61ff8c1f8e789a54f441939b86cc9c20a2d066b00f3a2"
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
