class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.16.2.tar.gz"
  sha256 "4155794364a1a705841718919a7ef64514a8cb3b13d44211d36dff7ba8c35546"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4beb4eaf87c7a5b45b77c97efe277f2059d5b74cfefeefed34b80a9ca7188e58"
    sha256 cellar: :any,                 arm64_sonoma:  "8faecf15789d73010ca49458a33cd257f940d36a23d4d4f21486bbe7a034ba96"
    sha256 cellar: :any,                 arm64_ventura: "a751d045582697fff1c862a3cfd3769d2b3a8bfe649dce507235666a5b9ecfce"
    sha256 cellar: :any,                 sonoma:        "d9467f85042105d34e511bab134a4891e601bbb05f9d87875078a790019b1bb1"
    sha256 cellar: :any,                 ventura:       "301f74f55f414a56226694796136df4ad3c2d20148bdd6ac5fdaa0e705820ce1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c76480d475c395589adc5a943682fd9b6a0c9ce05aac31c13c255c4e4df8e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b1513aec6289640e5edcd930116b75aaf2906910cbdc5e3467ab47de0babfd6"
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
