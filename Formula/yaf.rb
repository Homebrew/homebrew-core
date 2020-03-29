class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.11.0.tar.gz"
  sha256 "5e2523eeeaa5ac7e08f73b38c599f321ba93f239011efec9c39cfcbc30489dca"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "62355ef76633be429f5a281b1a357fa74d12e33ffaf5c2e38b0291442cb1f9fd" => :catalina
    sha256 "7395026369a9b4b30f6614ab98baa1d810de2af29511b635b3ba2ad5a3d82289" => :mojave
    sha256 "3e4ba45a90c4a47bcb4edc7dd9d9bf227d8b70af3989368bbf6cc4b006d2a9f7" => :high_sierra
    sha256 "f9f45a164b81d2b4d4ef3b45664faa81d8317039cee93b69a1f4dc2d55786068" => :sierra
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
