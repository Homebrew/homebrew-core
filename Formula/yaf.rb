class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.12.2.tar.gz"
  sha256 "0f3634887b68c695c80472ed17f3a2ebfbf86f841d23a2d48534afc8b637afcb"
  license "GPL-2.0-only"

  livecheck do
    url "https://tools.netsa.cert.org/yaf/download.html"
    regex(/".*?yaf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2102db37f2a17f95fd62c210db3893148a723a887754fa6bba131c3e3a6c30fc"
    sha256 cellar: :any,                 arm64_big_sur:  "554d7265d1648b6aeb930e7d70ea7a9c8e67bf259049bc17c8a2b4c493534ef1"
    sha256 cellar: :any,                 monterey:       "a36c6eb87bda36da6ff74ec2b993eb964eb767f67cfc97b66e430d94df386249"
    sha256 cellar: :any,                 big_sur:        "e9a598eb315228ca4e968cbf074f2fb819311e4666559acc382c784f87720faf"
    sha256 cellar: :any,                 catalina:       "26ce51e3201562138d3ec6f04ccaca48799766196b04e390ac2989552b507c64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a28bfd8a9a02046495ff8ac90f3487de50adf772672d183e5670bd3f5cb4d6b4"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "libtool"
  depends_on "pcre"

  uses_from_macos "libpcap"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
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
