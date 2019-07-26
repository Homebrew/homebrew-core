class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.11.0.tar.gz"
  sha256 "5e2523eeeaa5ac7e08f73b38c599f321ba93f239011efec9c39cfcbc30489dca"
  revision 1

  bottle do
    cellar :any
    sha256 "45d3e8977a0fa168a7b6aff0111be670b21fe587f9f36141a9868513c5d8fb64" => :mojave
    sha256 "b414c3c8f71e4add024f22adc69ea30b2fb0ff67c6c4c7a7e89715f2c80cabe0" => :high_sierra
    sha256 "416ffc51d3f526210e3843d3d7f79557900ebe345b2cf099edbb6e77353da8e0" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libfixbuf"
  depends_on "libtool"
  depends_on "pcre"

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
