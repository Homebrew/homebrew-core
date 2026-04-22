class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.18.3.tar.gz"
  sha256 "4cee46b11371fc5b7b76044c7efadb1e30043e699eb0d8d1aa4f1ca6436e8cdd"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3b7251cb48fe4163d5ceaf8c494d08f515f36969cbd11b663111828f9f9bb726"
    sha256 cellar: :any,                 arm64_sequoia: "7cad8b87c9095aa1109b7a9d2aef1959d4f8a22212bd06935f81354e0b0e6257"
    sha256 cellar: :any,                 arm64_sonoma:  "e918c459b53d43fe9c5e81fd34cce202a2837c0b9965dceab37dd80c78dd5ff1"
    sha256 cellar: :any,                 sonoma:        "42791e849b3a3d5b6fef29e72eb312d002a522795d75ab10f1eb1a343f9cff61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a94b4b5ad8a62f6cb5303609324034aebc094f1b33c05a10013197a90104cdc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9df057a2865d4c4752a5f54c7d6b86bc91e92cc0343998821ed7dd6cbd47ba7e"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "libtool"

  uses_from_macos "libpcap"

  on_macos do
    depends_on "gettext"
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
    input = test_fixtures("test.pcap")
    output = pipe_output("#{bin}/yafscii", shell_output("#{bin}/yaf --in #{input}"), 0)
    expected = "2014-10-02 10:29:06.168497 - 10:29:06.169875 (0.001378 sec) tcp " \
               "192.168.1.115:51613 => 192.168.1.118:80 71487608:98fc8ced " \
               "S/APF:AS/APF (7/453 <-> 5/578) rtt 451 us"
    assert_equal expected, output.strip
  end
end
