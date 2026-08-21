class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.20.3.tar.gz"
  sha256 "fb581317124a2a5064c17e211cc2a0226a41f606c2135a5a5c6f672ecf6e4c9f"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7d58b6b29ef0bdac04e40a4f9dbe5cdefec4681d2d164790fd6b1eb77468335f"
    sha256 cellar: :any, arm64_sequoia: "44f5446df10c09d8c593272f90eb1f601c42d450c97b052a543a7c9cd2876a53"
    sha256 cellar: :any, arm64_sonoma:  "1a555454646cdab533b4eb2f39c55157797e99857f9137a00a470085c87d5609"
    sha256 cellar: :any, sonoma:        "4cbac92c29d1eb92dd2ff4212594c833b4268ff0b6889b1f273045d9d60c142b"
    sha256 cellar: :any, arm64_linux:   "cb70792aba44640ff604d804dd3867537337276e73236cc94800e802c2705357"
    sha256 cellar: :any, x86_64_linux:  "1fa7b2898c187ae91606eba4d35aaba3bcca74a3120483a73e2c39c88ccc2406"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "libtool"

  uses_from_macos "libpcap"

  on_macos do
    depends_on "gettext"
    depends_on "pcre2"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # OpenSSL is disabled as Apache-2.0 is not compatible with GPL-2.0-only
    # Ref: https://www.gnu.org/licenses/license-list.html#apache2
    system "./configure", "--without-openssl", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    # FIXME: yafscii 2.19.1 segfaults when reading stdin or writing stdout
    system bin/"yaf", "--in", test_fixtures("test.pcap"), "--out", testpath/"flow.ipfix"
    system bin/"yafscii", "--in", testpath/"flow.ipfix", "--out", testpath/"flow.txt"
    expected = "2014-10-02 10:29:06.168497 - 10:29:06.169875 (0.001378 sec) tcp " \
               "192.168.1.115:51613 => 192.168.1.118:80 71487608:98fc8ced " \
               "S/APF:AS/APF (7/453 <-> 5/578) rtt 451 us"
    assert_equal expected, (testpath/"flow.txt").read.strip
  end
end
