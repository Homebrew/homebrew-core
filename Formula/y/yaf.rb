class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.19.1.tar.gz"
  sha256 "d2bab3eab2a227eaeedc8624c69dfb77a7ba314d02c3f050cbb829e7ccf66271"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56f4ea440bca04278fdf50b593f09635f3d7891ae9ac15ccda90869ea51656e4"
    sha256 cellar: :any,                 arm64_sequoia: "f837ebb2dd639231481cbce06f1ec41655be39c2c1f7ac35de0b77810e9a4377"
    sha256 cellar: :any,                 arm64_sonoma:  "1619cea677b13c42f8f7141a643d4d75ab6a9a08d98477070bbde7b3caa8f9de"
    sha256 cellar: :any,                 sonoma:        "da8bf37261b856a80f336bac36015205d3d57fcc389ce1485dd657946cac0e98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2f39712dc5237abf10883d2c4ebae68793fa8e378e57460f0a936c571959989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91cde7336e0c16efa7188fe16570ed567bf0735caa2ad1fbba42f7550e7f4603"
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
