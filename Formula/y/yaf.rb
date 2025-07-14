class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.16.4.tar.gz"
  sha256 "b328d44e5f0fdf5fdf63acbb724cfa569b87f428dde6051958e404b689cf6e16"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab15b3b5a0bcd4e25d4cdeaad2b0d3c7cd17d646e8842c5b06169820ee9853c2"
    sha256 cellar: :any,                 arm64_sonoma:  "f54d3a9ca4d925a43c011a19f509d5e4f526f54baf3397dc3eacdb98958947ee"
    sha256 cellar: :any,                 arm64_ventura: "c48b63196eaf4bfef4d0663ccb48ee207dc205559d803d095178b9a90ce09626"
    sha256 cellar: :any,                 sonoma:        "86d6e4d206e2324d57b48418d21004990972bab688dda408ed2cea063518723b"
    sha256 cellar: :any,                 ventura:       "1cd24687f78ed78ccec68da83a694edb4faee4285947ef9376b027caf66cd25f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa909c4ec0a920fdf01a66589f67f8cd7e5b22f6f6b72b15c1039b0f395f724e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddb56ac424e91945dc7d36c16776523d9dfe3309e6a93f98580f5a4e2fdf1661"
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
    output = pipe_output(bin/"yafscii", shell_output("#{bin}/yaf --in #{input}"))
    expected = "2014-10-02 10:29:06.168 - 10:29:06.169 (0.001 sec) tcp " \
               "192.168.1.115:51613 => 192.168.1.118:80 71487608:98fc8ced " \
               "S/APF:AS/APF (7/453 <-> 5/578) rtt 0 ms"
    assert_equal expected, output.strip
  end
end
