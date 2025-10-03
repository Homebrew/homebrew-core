class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.17.1.tar.gz"
  sha256 "2d361f602d04ff16cb4c6ffca31f0ba32a55ee4bf87e30a2d2d64fc13b81442e"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4543484b45766bfcb44645966b556e12a1baa0faa4f1e347a0252af7ea964f45"
    sha256 cellar: :any,                 arm64_sequoia: "fc69d836a75aece50ed5b5f719d6f289d6c1c34966d1ea10fa9d126ade80b37d"
    sha256 cellar: :any,                 arm64_sonoma:  "18f3dcb2267a39b9a3919d4432b06305ca5e6011b19982bfda9026cbf71b277f"
    sha256 cellar: :any,                 arm64_ventura: "a6e1377b16dcaf787188bc6e6a3a19602ab6eca18be77a864d43f0d73191d75f"
    sha256 cellar: :any,                 sonoma:        "e8121e901e9a9851e0b44bf6f88572896b91303fb1a161a634052cc884348e2c"
    sha256 cellar: :any,                 ventura:       "8eeb39210480ed56eeef7c6f2cd1427dc49356f813653c348678e263f853b7d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b1980c07ee8762cb0432079dd2cb9ffaf4effd11129257b40b812c6213a2b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc484b56a155b04d2633aac0ed45fa8e164c2b9696a31ab6b286bed5b19611a1"
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
