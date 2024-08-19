class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.15.0.tar.gz"
  sha256 "3743d2f7b9bac3ac2ee2017dc26f6d7c5775dfdf95062ef7fa29c8c793e9472f"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f4c454dd111e81d96fe4b7a96ffd9e5206a81d4b43f7eb5d587ac790414db79a"
    sha256 cellar: :any,                 arm64_ventura:  "2a412f316dad9f799eb94a6ace746fcea6de0a76f1283235470820f8d7d48dff"
    sha256 cellar: :any,                 arm64_monterey: "fe779f22669ae77e31393122ff3f286d76d832361b05fcfc749610ae99a7112f"
    sha256 cellar: :any,                 sonoma:         "ab2ba75307eab5e71027153bbc9cedcf6a40a6700f570e8b22690a6b1f18d0be"
    sha256 cellar: :any,                 ventura:        "6a68fde3aab87006a0e9b77db3e54489bee1c9d50db666ab7873d4e40027296d"
    sha256 cellar: :any,                 monterey:       "e1a127564d3362b3f95ffed00d2661c1ee21ecc5e85f89547de996d3959c2af0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95a12e2afcaa5a2746a4a56dd489b04905e60a5bd716ad6774a120928a4331d7"
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
