class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.18.2.tar.gz"
  sha256 "b2324e6c5468e4748e59d9f33312decc8e72cc9ee51e927cd7e77b3d3584d909"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7201b08b55d9bce81c4f67e08eae208fdb9f5f65e638b59d129a52747b3bd0d1"
    sha256 cellar: :any,                 arm64_sequoia: "3edc90e7654f43e5e6825a43cf264b5551b0e32c06e3b2bc92674822204d6a6b"
    sha256 cellar: :any,                 arm64_sonoma:  "54b00a860afdff9c4cc7cd27822bfb6c7a7e16ec78637b6a811b430074ebac3e"
    sha256 cellar: :any,                 sonoma:        "cb777e8ff186f4f52d9da9becefea457f54890f6445a4b1ba6762144d6793e10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b5973aac45d6f926fefcb8326fcfe8b7aaecebb66f0ec19d5725ed12b6844e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9502982332be786abd5420bca28a7e70d3d2180cc81b74f40844aceadabf5a76"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "libtool"

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
    output = pipe_output("#{bin}/yafscii", shell_output("#{bin}/yaf --in #{input}"), 0)
    expected = "2014-10-02 10:29:06.168497 - 10:29:06.169875 (0.001378 sec) tcp " \
               "192.168.1.115:51613 => 192.168.1.118:80 71487608:98fc8ced " \
               "S/APF:AS/APF (7/453 <-> 5/578) rtt 451 us"
    assert_equal expected, output.strip
  end
end
