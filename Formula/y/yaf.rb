class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.19.3.tar.gz"
  sha256 "6b03bc3d25495c01d8d8020b00a908ef1ed28b6edf78f631618208d81e809b30"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bfcf711422adfa54260c067643bd0a96a2d8bf60fdd2fbd0e06ff8384e0c211e"
    sha256 cellar: :any, arm64_sequoia: "ad18f1702c4d74ffae5b3170389e99bb411dcfe8c7ee64e1b4dad41a9bf1a7d2"
    sha256 cellar: :any, arm64_sonoma:  "1ca0f942ce85a4deab36ef21685a17fec1c6496d854708241a18d7a530a1372d"
    sha256 cellar: :any, sonoma:        "6e81d4d8d6963f765d965caa3d3a9cbb3b9e59babe0f62291c71fedd24868b79"
    sha256 cellar: :any, arm64_linux:   "7fa6ce4dd4b0306e9b408d534a98a1c9edac323910b8bd49e22ccf90c1ec4a3f"
    sha256 cellar: :any, x86_64_linux:  "88e2d6f2587e00c40ae787e8ac7e855a9816b7929f5afecd113da23c8e83332b"
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
