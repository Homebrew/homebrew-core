class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.19.2.tar.gz"
  sha256 "dbe9413ce366c0ea2a104d45d86b21f5518f0d3b5c210c9a5c0d109642fea6a7"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "857af8c365b6df50253cbaa33a171163d75b65f7288135b7feca78046668ea1c"
    sha256 cellar: :any,                 arm64_sequoia: "8213e61b11aac042a590f406aa078d79e1be1812762d1fc9b8c8d76590b9afac"
    sha256 cellar: :any,                 arm64_sonoma:  "9f87db599efaa28d5fbda5713dabf77f927b50ddd0470e7b1f644cd4f922ff9c"
    sha256 cellar: :any,                 sonoma:        "9f5415b6a828e01373aa6adf935b74bf58896b4c30cfe34af7761202436ac695"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd6664df5db554d69483be286dda7e839a9739ec81c8b2c3fc5e81deb4fb3044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc7e1a17a370433768ebc8ae49d815b9be288e6cae36bfa5722ed91ad87c29ed"
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
