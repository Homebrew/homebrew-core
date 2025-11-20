class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.17.2.tar.gz"
  sha256 "e40f343b58fdf878e5983307f81f45953e77eec229855021b8e4658936012537"
  license "GPL-2.0-only"

  # NOTE: This should be updated to check the main `/yaf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/yaf2/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2369538a7a48770175aa01e27663584c777f72f0c9bdd5c9439eeece21cfc6ef"
    sha256 cellar: :any,                 arm64_sequoia: "9aae4348f07a1dc3ec9b404fb8c23e22d1a879175c1e90d8cf98ce6c37220e27"
    sha256 cellar: :any,                 arm64_sonoma:  "deb0663a9658250d1cb65fb3e234571441d5f57df31e7c2af3c9993a43388f7c"
    sha256 cellar: :any,                 sonoma:        "ffd8611568408d7f1cd1ff3879dc7385d1b792a83a86f112a8c2f374b30ce80c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47736eb26d5a8b3d036b28efcefa3aeabc8f3a8fc856436cdbd85b5af2a4965b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9016679a4bd98e886d30504389f8dbf2a23a1f521558d3a6c2d153814217b7a8"
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
