class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.19.4.tar.gz"
  sha256 "300394f7ea7989e75db803d688e9396102b263734ebc12805ff1107526080d67"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "59a79ed1d8e559c6fcb9b3702479465fbda6a36ab4101329c80a7d82067b818f"
    sha256 cellar: :any, arm64_sequoia: "c454c3c16c82a1d57b4722269c78191d09e17602276256bdc8895dfd1dc3d458"
    sha256 cellar: :any, arm64_sonoma:  "91978aac0faa4e0cdedb3d617f6def448a0d675c83c4a89083a45ac20031b46b"
    sha256 cellar: :any, sonoma:        "f9503c2a37d0c6f0f01839c3098de22131326a585211c409323fa54f5c61f0aa"
    sha256 cellar: :any, arm64_linux:   "1dd91d342cfe9b0b5d5aa459238fa08a05a8fac4376f560b0bc16d367fd128a5"
    sha256 cellar: :any, x86_64_linux:  "4f048c5bacd3051d3f5e3b5aed95963ac09ae28c804353101e0a34f1386a70c2"
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
